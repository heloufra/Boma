import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AddressEditScreen extends StatefulWidget {
  const AddressEditScreen({super.key});

  @override
  AddressEditScreenState createState() => AddressEditScreenState();
}

class AddressEditScreenState extends State<AddressEditScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isExpanded = false;
  late String _mapStyleString;
  LatLng _selectedLocation =
      const LatLng(32.22017044487108, -7.939553250867446);

  final _labelController = TextEditingController();
  final _streetController = TextEditingController();
  final _districtController = TextEditingController();
  final _notesController = TextEditingController();
  final _houseNumberController = TextEditingController();
  final _floorController = TextEditingController();
  final _apartmentController = TextEditingController();

    final DraggableScrollableController _draggableController = DraggableScrollableController();


  String _selectedAddressType = 'Apartment';

  GoogleMapController? _mapController;
  bool _isLoadingLocation = false;

  @override
  void initState() {
    super.initState();
  
        _draggableController.addListener(_onScrollChanged);

     WidgetsBinding.instance.addPostFrameCallback((_) {
      rootBundle.loadString('assets/map_style.json').then((string) {
        _mapStyleString = string;
      });
          _getCurrentLocation();
    });

  }
  void _onScrollChanged() {
    setState(() {
      _isExpanded = _draggableController.size > 0.3;
    });
  }

void toggleExpansion() {
    if (!_isExpanded) {
      _draggableController.animateTo(
        0.2,
        duration: const Duration(milliseconds: 800),
        curve: Curves.ease, // Bouncy animation
      );
    } else {
      _draggableController.animateTo(
        0.9,
        duration: const Duration(milliseconds: 800),
        curve: Curves.ease,
      );
    }
    setState(() {
      _isExpanded = !_isExpanded;
    });
}


  final Map<String, Map<String, dynamic>> _addressTypes = {
    'Apartment': {
      'label': 'Apartment',
      'icon': Icons.apartment,
      'showFloor': true,
      'showUnit': true,
    },
    'House': {
      'label': 'House',
      'icon': Icons.home,
      'showFloor': false,
      'showUnit': false,
    },
    'Office': {
      'label': 'Office',
      'icon': Icons.business,
      'showFloor': true,
      'showUnit': true,
    },
    'Other': {
      'label': 'Other',
      'icon': Icons.location_city,
      'showFloor': true,
      'showUnit': true,
    },
  };

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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not get location: $e')),
      );
    } finally {
      setState(() => _isLoadingLocation = false);
    }
  }

  Widget _buildAddressTypeSelector() {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: colorScheme.surface,
      ),
      child: Wrap(
        children: _addressTypes.entries.map((type) {
          final isSelected = _selectedAddressType == type.key;
          return Padding(
            padding: const EdgeInsets.fromLTRB(0, 2, 4, 4),
            child: ChoiceChip(
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                Radius.circular(20),
              )),
              showCheckmark: false,
              label: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    type.value['icon'] as IconData,
                    size: 16,
                    color: isSelected ? Colors.white : Colors.black,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    type.value['label'] as String,
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
              selected: isSelected,
              onSelected: (bool selected) {
                if (selected) {
                  setState(() => _selectedAddressType = type.key);
                }
              },
              selectedColor: colorScheme.secondary,
              backgroundColor: Colors.white,
              labelStyle: TextStyle(
                color: isSelected ? colorScheme.onSecondary : Colors.black,
              ),
            ),
          );
        }).toList(),
      ),
    );
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
              setState(() 
              {
                _selectedLocation = position.target;
                _isExpanded = false;
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
  top: MediaQuery.of(context).padding.top, // Adjust for status bar height
  left: 0,
  right: 0,
  child: Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween, // Space between elements
      children: [
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor, // Background color for the button
            borderRadius: BorderRadius.circular(12), // Rounded corners
          ),
          child: IconButton(
            icon: const Icon(Icons.arrow_back),
            
            color: Colors.white,  // Icon color
            onPressed: () => Navigator.pop(context),
          ),
        ),
        
        Expanded(
          child: Align(
            alignment: Alignment.topCenter,  // Align text at top-center
            child: Container(
              padding: const EdgeInsets.all(8.0),  // Padding for extra background around text
              decoration: BoxDecoration(
                     color: Theme.of(context).primaryColor,  // Background color for the text
                borderRadius: BorderRadius.circular(12),  // Rounded corners
              ),
              child: const Text(
                'Edit Address',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,  // Text color
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
        
        // Balance for the back button with SizedBox
        const SizedBox(width: 48),
      ],
    ),
  ),
)
,

          // Current Location Button
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

          // Bottom Sheet
          DraggableScrollableSheet(
            controller: _draggableController,
            initialChildSize: _isExpanded ? 0.85 : 0.2,
            minChildSize: 0.2,
            maxChildSize: 0.85,
            builder: (context, scrollController) {
              return Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(20)),
                ),
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Drag Handle
                      Center(
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 12),
                          width: 40,
                          height: 4,
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.secondary,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),

                      // Location Info
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // const Text(
                            //   'Selected Location',
                            //   style: TextStyle(
                            //     fontSize: 20,
                            //     fontWeight: FontWeight.bold,
                            //   ),
                            // ),
                            // const SizedBox(height: 8),
                            // Text(
                            //   'Lat: ${_selectedLocation.latitude.toStringAsFixed(6)}\nLng: ${_selectedLocation.longitude.toStringAsFixed(6)}',
                            //   style: TextStyle(
                            //     color: Colors.grey[600],
                            //   ),
                            // ),
                            const SizedBox(height: 16),
                            if (!_isExpanded)
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: () {
                                    setState(() => _isExpanded = true);
                                    toggleExpansion();
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        Theme.of(context).colorScheme.secondary,
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 16),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: Text(
                                    'Confirm Location',
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary),
                                  ),
                                ),
                              ),
                            if (_isExpanded) ...[
                              const SizedBox(height: 24),
                              _buildForm(),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            controller: _labelController,
            decoration: _getInputDecoration('Address Label'),
            validator: (value) {
              if (value?.isEmpty ?? true) {
                return 'Please enter an address label';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _streetController,
            // cursorColor: Colors.white,
            decoration: _getInputDecoration('Street name'),
            validator: (value) {
              if (value?.isEmpty ?? true) {
                return 'Please enter a street';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          if (_selectedAddressType != "House") ...[
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 16),
              child: TextFormField(
                controller: _apartmentController,
                decoration: _getInputDecoration('Building number'),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _floorController,
                    decoration: _getInputDecoration('Floor'),
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    controller: _apartmentController,
                    decoration: _getInputDecoration('Apartment Number'),
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 16),
          ] else ...[
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _houseNumberController,
                    decoration: _getInputDecoration('House Number'),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return 'Please enter a street';
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
          ],
          _buildAddressTypeSelector(),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                if (_formKey.currentState?.validate() ?? false) {}
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.secondary,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'Save Address',
                style: TextStyle(
                  fontSize: 16,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  InputDecoration _getInputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    );
  }

  // void _saveAddress() {
  //   if (_formKey.currentState?.validate() ?? false) {
  //     // Here you would typically save the address
  //     Navigator.pop(context, {
  //       'label': _labelController.text,
  //       'street': _streetController.text,
  //       'district': _districtController.text,
  //       'notes': _notesController.text,
  //       'latitude': _selectedLocation.latitude,
  //       'longitude': _selectedLocation.longitude,
  //     });
  //   }
  // }

  @override
  void dispose() {
    _labelController.dispose();
    _streetController.dispose();
    _districtController.dispose();
    _notesController.dispose();
    _mapController?.dispose();
       _draggableController.removeListener(_onScrollChanged);
    _draggableController.dispose();
    super.dispose();
  }
}
