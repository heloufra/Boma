import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';


class LocationScreen extends StatefulWidget {
  const LocationScreen({super.key});

  @override
  _LocationScreenState createState() => _LocationScreenState();
}
class _LocationScreenState extends State<LocationScreen> with SingleTickerProviderStateMixin {
  late GoogleMapController _mapController;
  final Location _location = Location();
  final Set<Marker> _markers = {};
  LatLng? _userLocation;
  final bool _movingWidgetVisible = true;
  
  // Controllers for address fields
  final TextEditingController _streetController = TextEditingController();
  final TextEditingController _numberController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  
  late AnimationController _slideController;
  late Animation<double> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _checkPermissionsAndGetLocation();
    
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );


  }

  @override
  void dispose() {
    _slideController.dispose();
    _streetController.dispose();
    _numberController.dispose();
    _cityController.dispose();
    super.dispose();
  }

  void _toggleWidget() {
    if (_slideController.status == AnimationStatus.completed) {
      _slideController.reverse();
    } else {
      _slideController.forward();
    }
  }
Future<void> _checkPermissionsAndGetLocation() async {
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    // Check if location services are enabled
    serviceEnabled = await _location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await _location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    // Check if location permissions are granted
    permissionGranted = await _location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await _location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    // Get the user's location
    final loc = await _location.getLocation();
    setState(() {
      _userLocation = LatLng(loc.latitude!, loc.longitude!);
      _markers.add(Marker(
        markerId: const MarkerId('userLocation'),
        position: _userLocation!,
      ));
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    if (_userLocation != null) {
      _mapController.moveCamera(CameraUpdate.newLatLng(_userLocation!));
    }
  }
    @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    
    // Initialize the animation here where we have access to MediaQuery
    _slideAnimation = Tween<double>(
      begin:MediaQuery.of(context).size.height / 2,
      end: MediaQuery.of(context).size.height,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.ease,
    ));
  }
  // Modified build method
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Scaffold(

      body: Stack(
        children: [
          Listener(
            onPointerDown: (_) {
              _slideController.forward();
            },
            onPointerUp: (_) {
              _slideController.reverse();
            },
            child: GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: _userLocation ?? const LatLng(0, 0),
                zoom: 15,
              ),
              markers: _markers,
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
            ),
          ),
          AnimatedBuilder(
            animation: _slideAnimation,
            builder: (context, child) {
              return Positioned(
                top: _slideAnimation.value,
                left: 0,
                right: 0,
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.5,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 10,
                        offset: const Offset(0, -2),
                      ),
                    ],
                  ),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Confirm Your Address',
                          style: TextStyle(
                            color: colorScheme.primary,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 20),
                        // Street Field
                        TextField(
                          controller: _streetController,
                          decoration: InputDecoration(
                            labelText: 'Street Name',
                            labelStyle: TextStyle(
                              color: colorScheme.primary,
                              fontSize: 18,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: colorScheme.secondary, width: 2),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: colorScheme.secondary, width: 2),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            filled: true,
                            fillColor: colorScheme.secondary.withOpacity(0.1),
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Street Number Field
                        TextField(
                          controller: _numberController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: 'Street Number',
                            labelStyle: TextStyle(
                              color: colorScheme.primary,
                              fontSize: 18,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: colorScheme.secondary, width: 2),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: colorScheme.secondary, width: 2),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            filled: true,
                            fillColor: colorScheme.secondary.withOpacity(0.1),
                          ),
                        ),
                        const SizedBox(height: 16),
                        // City Field
                        TextField(
                          controller: _cityController,
                          decoration: InputDecoration(
                            labelText: 'City',
                            labelStyle: TextStyle(
                              color: colorScheme.primary,
                              fontSize: 18,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: colorScheme.secondary, width: 2),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: colorScheme.secondary, width: 2),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            filled: true,
                            fillColor: colorScheme.secondary.withOpacity(0.1),
                          ),
                        ),
                        const SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _onConfirm,
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              backgroundColor: colorScheme.primary,
                            ),
                            child: const Text(
                              'Confirm Location',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

 void _onConfirm() {
    // Handle the confirmation with all address details
    final address = {
      'street': _streetController.text,
      'number': _numberController.text,
      'city': _cityController.text,
      'latitude': _userLocation?.latitude,
      'longitude': _userLocation?.longitude,
    };
    
    // Add your confirmation logic here
    print(address); // For debugging
  }
  // ... rest of your existing code ...
}