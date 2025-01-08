import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:june/june.dart';
import '../state/address.dart';
import '../types/address.dart';

class ViewAddressScreen extends StatefulWidget {
  final EditAddressconfirmation editAddressconfirmation;

  const ViewAddressScreen({super.key, required this.editAddressconfirmation});

  @override
  State<ViewAddressScreen> createState() => _ViewAddressScreenState();
}

class _ViewAddressScreenState extends State<ViewAddressScreen> {
  GoogleMapController? mapController;
  Set<Marker> markers = {};

  @override
  void initState() {
    super.initState();
    markers.add(
      Marker(
        markerId: MarkerId(widget.editAddressconfirmation.address.id.toString() ),
        position: LatLng(
         widget.editAddressconfirmation.address.latitude,
         widget.editAddressconfirmation.address.longitude,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.editAddressconfirmation.address.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(bottom: Radius.circular(16)),
              child: Stack(
                children: [
                  SizedBox(
                    height: 250,
                    child: GoogleMap(
                      initialCameraPosition: CameraPosition(
                        target: LatLng(
                          widget.editAddressconfirmation.address.latitude,
                          widget.editAddressconfirmation.address.longitude,
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
                        widget.editAddressconfirmation.address.type.toUpperCase(),
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
                        child: Text(
                          widget.editAddressconfirmation.address.name,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      // if (widget.address.isDefault == true)
                         JuneBuilder(() => AddressState(), builder: (state) {
                              if (state.isLoading) {
                                return const Center(
                                    child: CircularProgressIndicator());
                              } else if (state.isError) {
                                return Center(
                                    child: Text(state.errorMessage ??
                                        "Error loading addresses"));
                              } else if (state.defaultAddress?.id == widget.editAddressconfirmation.address.id) {
                                return Container(
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
                                );
                              } else {
                                return const SizedBox();
                              }
                            }),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    widget.editAddressconfirmation.address.city,
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w500,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.editAddressconfirmation.address.fullAddress,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),

                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListTile(
                        leading: const Icon(Icons.edit),
                        title: const Text('Edit'),
                        onTap: () {
                          EditAddressconfirmation data = EditAddressconfirmation(
                              address: widget.editAddressconfirmation.address,
                              userLocation: widget.editAddressconfirmation.address.getLatLng());
                          context.go("/settings/address/view-address/edit", extra: data);
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.delete),
                        title: const Text('Delete'),
                        onTap: ()  {
                          var state = June.getState(() => AddressState());
                         state.deleteAddress(widget.editAddressconfirmation.address.id ?? 0);
                          state.fetchAddresses();
                          if (!mounted) return;
                          Navigator.pop(context);
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.star),
                        title: const Text('Make Default'),
                        onTap: () {
                          var state = June.getState(() => AddressState());
                          state.setDefaultAddress(widget.editAddressconfirmation.address.id ?? 0);
                          // Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    mapController?.dispose();
    super.dispose();
  }
}
