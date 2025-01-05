import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:june/june.dart';
import '../state/address.dart';
import '../types/address.dart';

class AddressManagementScreen extends StatefulWidget {
  const AddressManagementScreen({super.key});

  @override
  State<AddressManagementScreen> createState() => _AddressListScreenState();
}

class _AddressListScreenState extends State<AddressManagementScreen> {
  late List<Address> addresses;
  int secondsRemaining = 4;
  Timer? timer;
  bool error = false;
  String errorMsg = '';
  bool isLoading = false;


  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      var state = June.getState(() => AddressState());
      _getAddresses(state);
    });
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      if (secondsRemaining == 0) {
        setState(() {
          timer.cancel();
          error = false;
          errorMsg = "";
        });
      } else {
        setState(() {
          secondsRemaining--;
        });
      }
    });
  }

  void _getAddresses(AddressState state) async {
    await state.fetchAddresses();
    if (state.isError) {
     setState(() {
        error = true;
        errorMsg = state.errorMessage ?? "";
      });
    } else if (state.isLoaded) {
      setState(() {
        addresses = state.addresses;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor:
            !error ? Theme.of(context).colorScheme.surface : Colors.red,
        title: Text(
          error ? errorMsg : "Addresses",
          style: TextStyle(
            fontSize: 18,
            color: Theme.of(context).colorScheme.primary,
            fontWeight: FontWeight.normal,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_rounded, size: 32,),
            onPressed: () {
              context.go("/address/add/");
            },
          ),
        ],
      ),
      body: JuneBuilder(() => AddressState(),
        builder: (state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state.isError) {
            return Center(child: Text(state.errorMessage ?? "Error loading addresses"));
          } else if (state.isLoaded) {
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: state.addresses.length,
              itemBuilder: (context, index) {
                return AddressCard(address: state.addresses[index]);
              },
            );
          } else {
            return const Center(child: Text("No addresses found"));
          }
        }
      ),
    );
  }
}

class AddressCard extends StatefulWidget {
  final Address address;

  const AddressCard({
    super.key,
    required this.address,
  });

  @override
  State<AddressCard> createState() => _AddressCardState();
}

class _AddressCardState extends State<AddressCard> {
  GoogleMapController? mapController;
  Set<Marker> markers = {};



  @override
  void initState() {
    super.initState();
    markers.add(
      Marker(
        markerId: MarkerId(widget.address.id.toString()),
        position: LatLng(
          widget.address.latitude,
          widget.address.longitude,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.go("/address/view-address", extra: widget.address);
      },
      child: Card(
        margin: const EdgeInsets.only(bottom: 16),
        elevation: 6,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(16)),
              child: Stack(
                children: [
                  SizedBox(
                    height: 150,
                    child: GoogleMap(
                      initialCameraPosition: CameraPosition(
                        target: LatLng(
                          widget.address.latitude,
                          widget.address.longitude,
                        ),
                        zoom: 15,
                      ),
                      onMapCreated: (controller) {
                        mapController = controller;
                      },
                      markers: markers,
                      zoomControlsEnabled: false,
                      mapToolbarEnabled: false,
                      myLocationButtonEnabled: false,
                    ),
                  ),
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.5),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        widget.address.type.toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            Text(
                              widget.address.name,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.blue.shade50,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                'Default',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.blue.shade600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.more_vert),
                        onPressed: () {
                          _showOptions(context);
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.address.city,
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.address.fullAddress,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.edit),
                title: const Text('Edit'),
                onTap: () {
                  Navigator.pop(context);
                  // Handle edit action
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete),
                title: const Text('Delete'),
                onTap: () {
                  Navigator.pop(context);
                  // Handle delete action
                },
              ),
              ListTile(
                leading: const Icon(Icons.star),
                title: const Text('Make Default'),
                onTap: () {
                  Navigator.pop(context);
                  // Handle make default action
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    mapController?.dispose();
    super.dispose();
  }
}