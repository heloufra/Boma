import 'dart:async';
import 'package:boma/address/address.dart';
import 'package:boma/components/bbutton.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:flutter/services.dart';

class LocationScreen extends StatefulWidget {
  final MarkerMapsCaller caller;
  const LocationScreen({super.key, required this.caller});

  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen>
    with SingleTickerProviderStateMixin {
  final Location _location = Location();
  LatLng? _userLocation;
  String _selectedType = 'house';
  late Animation<double> _slideAnimation;
  BitmapDescriptor markerIcon = BitmapDescriptor.defaultMarker;
  static late String _mapStyleString;

  final Completer<GoogleMapController> _controllerMap = Completer(); // ?

  late GoogleMapController _mapController; // ?
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _streetController = TextEditingController();
  final TextEditingController _floorNumberController = TextEditingController();
  final TextEditingController _homeNumberController = TextEditingController();
  late AnimationController _slideController;

  ByteData? imageData;
  Marker? marker;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkPermissionsAndGetLocation();
      rootBundle.loadString('assets/map_style.json').then((string) {
        _mapStyleString = string;
      });
      rootBundle
          .load('assets/images/home.png')
          .then((data) => setState(() => imageData = data));
    });
    addHomeMarker();
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _slideController.dispose();
    _streetController.dispose();
    _floorNumberController.dispose();
    _homeNumberController.dispose();
    super.dispose();
  }

  Future<void> _checkPermissionsAndGetLocation() async {
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    serviceEnabled = await _location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await _location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await _location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await _location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    Position position = await Geolocator.getCurrentPosition();

    setState(() {
      _userLocation = LatLng(position.latitude, position.longitude);
    });
  }

  void addHomeMarker() {
    setState(() {
      marker = Marker(
          icon: BitmapDescriptor.bytes(
              imageData?.buffer.asUint8List() ?? Uint8List(2),
              height: 100,
              width: 110),
          markerId: const MarkerId('userLocation'),
          position: _userLocation ??
              const LatLng(32.22153850282008, -7.938427631369669),
          draggable: false,
          onDragEnd: (newPosition) {
            setState(() {
              _userLocation = newPosition;
            });
          });
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    _controllerMap.complete(controller);

    _mapController = controller;
    if (_userLocation != null) {
      _mapController.moveCamera(CameraUpdate.newLatLng(_userLocation!));
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _slideAnimation = Tween<double>(
      begin: MediaQuery.of(context).size.height / 2,
      end: MediaQuery.of(context).size.height,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.linear,
    ));
  }

  void _onConfirm() {
    final address = {
      'street': _streetController.text,
      'number': _homeNumberController.text,
      'city': "Beng",
      'latitude': _userLocation?.latitude,
      'longitude': _userLocation?.longitude,
    };
    address;
    if (widget.caller == MarkerMapsCaller.add) {
      context.go("/address/add");
    } 
    else if (widget.caller == MarkerMapsCaller.edit) {
      // context.go('/address/edit',
      //     extra: Addressconfirmation(
      //         userLocation: _userLocation as LatLng,
      //         addressType: _selectedType));
    } else {
      context.go('/address/view');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (imageData == null) {
      return const Center(child: CircularProgressIndicator());
    }
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
              style: _mapStyleString,
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: _userLocation ??
                    const LatLng(32.22153850282008, -7.938427631369669),
                zoom: 18,
              ),
              markers: {marker as Marker},
              onCameraMove: (position) {
                setState(() {
                  _userLocation = position.target;
                });
              },
              myLocationEnabled: false,
              myLocationButtonEnabled: false,
            ),
          ),
          AnimatedBuilder(
            animation: _slideAnimation,
            builder: (context, child) {
              return Positioned(
                top: _slideAnimation.value * 1.25,
                left: 0,
                right: 0,
                child: Container(
                  height: MediaQuery.of(context).size.height * 1,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            _buildAddressTypeCard('house', Icons.home),
                            _buildAddressTypeCard('apartment', Icons.apartment),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            _buildAddressTypeCard('office', Icons.business),
                            _buildAddressTypeCard('others', Icons.more_horiz),
                          ],
                        ),
                        //  Spacer(),
                        const SizedBox(
                          height: 18,
                        ),
                        BButton(text: "Next", onTap: () => {_onConfirm()})
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

  Widget _buildAddressTypeCard(String type, IconData icon) {
    final isSelected = _selectedType == type;

    return InkWell(
      onTap: () {
        setState(() {
          _selectedType = type;
        });
        // widget.onTypeSelected(type);
      },
      child: Container(
        width: 140,
        padding: const EdgeInsets.all(8),
        margin: const EdgeInsets.fromLTRB(10, 10, 10, 5),
        decoration: BoxDecoration(
          color: isSelected
              ? Theme.of(context).colorScheme.secondary
              : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? Theme.of(context).primaryColor
                : Colors.grey.shade300,
          ),
          boxShadow: [
            if (isSelected)
              BoxShadow(
                color: Theme.of(context).primaryColor.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 32,
              color: isSelected ? Colors.white : Colors.black,
            ),
            const SizedBox(height: 8),
            Text(
              type, // Make sure to add the extension below
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: isSelected ? Colors.white : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
