import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../types/address.dart';

class AddAddress extends StatefulWidget {
  const AddAddress({super.key});

  @override
  AddressInputScreenState createState() => AddressInputScreenState();
}

class AddressInputScreenState extends State<AddAddress> {
  LatLng _selectedLocation =
      const LatLng(32.22017044487108, -7.939553250867446);

  GoogleMapController? _mapController;
  bool _isLoadingLocation = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getCurrentLocation();
    });
  }

  Future<void> _getCurrentLocation() async {
    setState(() => _isLoadingLocation = true);

    try {
      final position = await Geolocator.getCurrentPosition();
      setState(() {
        _selectedLocation = LatLng(position.latitude, position.longitude);
      });
      _mapController?.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: _selectedLocation, zoom: 20),
        ),
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not get location: $e')),
        );
      }
    } finally {
      setState(() => _isLoadingLocation = false);
    }
  }

  @override
  void dispose() {
    _mapController?.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Map
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: _selectedLocation,
              zoom: 20,
            ),
            // style: _mapStyleString,
            onMapCreated: (controller) {
              _mapController = controller;
            },
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            onCameraMove: (position) {
              setState(() {
                _selectedLocation = position.target;
              });
            },
          ),

          // Location Pin
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.location_pin,
                  size: 50,
                  color: Theme.of(context).primaryColor,
                ),
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.4),
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ),
          ),

          // Top Bar
          Positioned(
            top: MediaQuery.of(context)
                .padding
                .top, // Adjust for status bar height
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: Row(
                mainAxisAlignment:
                    MainAxisAlignment.spaceBetween, // Space between elements
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context)
                          .primaryColor, // Background color for the button
                      borderRadius:
                          BorderRadius.circular(12), // Rounded corners
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back),

                      color: Colors.white, // Icon color
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  Expanded(
                    child: Align(
                      alignment:
                          Alignment.topCenter, // Align text at top-center
                      child: Container(
                        padding: const EdgeInsets.all(
                            8.0), // Padding for extra background around text
                        decoration: BoxDecoration(
                          color: Theme.of(context)
                              .primaryColor, // Background color for the text
                          borderRadius:
                              BorderRadius.circular(12), // Rounded corners
                        ),
                        child: const Text(
                          'Set Location',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white, // Text color
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 48),
                ],
              ),
            ),
          ),

          Positioned(
            right: 16,
            bottom: 300,
            child: FloatingActionButton(
              heroTag: 'location',
              onPressed: _getCurrentLocation,
              child: _isLoadingLocation
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Icon(Icons.my_location),
            ),
          ),

          Positioned(
            bottom: 60,
            left: 0,
            right: 0,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: ElevatedButton(
                onPressed: () {
                  Addressconfirmation confirm =
                      Addressconfirmation(userLocation: _selectedLocation, caller: ConfirmCaller.add);
                  context.go("/address/add/confirm", extra: confirm);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.secondary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Confirm Location',
                  style: TextStyle(
                      fontSize: 24,
                      color: Theme.of(context).colorScheme.primary),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
