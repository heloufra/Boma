// // ignore_for_file: public_member_api_docs, sort_constructors_first
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';

// import 'package:boma/address/types/address.dart';

// class AddressInputScreen extends StatefulWidget {
//   final AddressEvent event;
//   const AddressInputScreen({
//     super.key,
//     required this.event,
//   });

//   @override
//   AddressInputScreenState createState() => AddressInputScreenState();
// }

// class AddressInputScreenState extends State<AddressInputScreen> {
//   final _formKey = GlobalKey<FormState>();
//   bool _isFullScreen = false;
//   LatLng _selectedLocation =
//       const LatLng(32.22017044487108, -7.939553250867446);
//   String _selectedAddressType = 'Apartment';
//     static late String _mapStyleString;


//   final _labelController = TextEditingController();
//   final _streetController = TextEditingController();
//   final _houseNumberController = TextEditingController();
//   final _floorController = TextEditingController();
//   final _apartmentController = TextEditingController();

//   GoogleMapController? _mapController;

//   bool _isLoadingLocation = false;

//   InputDecoration _getInputDecoration(String label) {
//     return InputDecoration(
//       labelText: label,
//       labelStyle: TextStyle(color: Theme.of(context).colorScheme.primary),
//       enabledBorder: OutlineInputBorder(
//         borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),
//         borderRadius: BorderRadius.circular(12),
//       ),
//       focusedBorder: OutlineInputBorder(
//         borderSide: BorderSide(color: Theme.of(context).colorScheme.secondary),
//         borderRadius: BorderRadius.circular(12),
//       ),
//       errorBorder: OutlineInputBorder(
//         borderSide: const BorderSide(color: Colors.red),
//         borderRadius: BorderRadius.circular(12),
//       ),
//       focusedErrorBorder: OutlineInputBorder(
//         borderSide: const BorderSide(color: Colors.red),
//         borderRadius: BorderRadius.circular(12),
//       ),
//     );
//   }

//   @override
//   void initState() {
//     super.initState();
//      WidgetsBinding.instance.addPostFrameCallback((_) {
//       rootBundle.loadString('assets/map_style.json').then((string) {
//         _mapStyleString = string;
//       });
//           _getCurrentLocation();
//     });
//   }

//   final Map<String, Map<String, dynamic>> _addressTypes = {
//     'Apartment': {
//       'label': 'Apartment',
//       'icon': Icons.apartment,
//       'showFloor': true,
//       'showUnit': true,
//     },
//     'House': {
//       'label': 'House',
//       'icon': Icons.home,
//       'showFloor': false,
//       'showUnit': false,
//     },
//     'Office': {
//       'label': 'Office',
//       'icon': Icons.business,
//       'showFloor': true,
//       'showUnit': true,
//     },
//     'Other': {
//       'label': 'Other',
//       'icon': Icons.location_city,
//       'showFloor': true,
//       'showUnit': true,
//     },
//   };

//   Widget _buildAddressTypeSelector() {
//     final colorScheme = Theme.of(context).colorScheme;
    
//     return Container(
//       padding: const EdgeInsets.all(8),
//       decoration: BoxDecoration(
//         color: colorScheme.surface,
//       ),
//       child: Wrap(
//         children: _addressTypes.entries.map((type) {
//           final isSelected = _selectedAddressType == type.key;
//           return Padding(
//             padding: const EdgeInsets.fromLTRB(0, 2, 4, 4),
//             child: ChoiceChip(
//               shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all( Radius.circular(20),)),
//               showCheckmark: false,
//               label: Row(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Icon(
//                     type.value['icon'] as IconData,
//                     size: 20,
//                     color: isSelected
//                         ?  Colors.white
//                         :  Colors.black,
//                   ),
//                   const SizedBox(width: 8),
//                   Text(type.value['label'] as String, style: const TextStyle(fontSize: 20),),
//                 ],
//               ),
//               selected: isSelected,
//               onSelected: (bool selected) {
//                 if (selected) {
//                   setState(() => _selectedAddressType = type.key);
//                 }
//               },
//               selectedColor: colorScheme.secondary,
//               backgroundColor: Colors.white,
//               labelStyle: TextStyle(
//                 color: isSelected
//                     ? colorScheme.onSecondary
//                     : Colors.black,
//               ),
//             ),
//           );
//         }).toList(),
//       ),
//     );
//   }

//   Future<void> _getCurrentLocation() async {
//     setState(() {
//       _isLoadingLocation = true;
//     });

//     try {
//       LocationPermission permission = await Geolocator.checkPermission();
//       if (permission == LocationPermission.denied) {
//         permission = await Geolocator.requestPermission();
//         if (permission == LocationPermission.denied) {
//           throw Exception('Location permissions are denied');
//         }
//       }

//       if (permission == LocationPermission.deniedForever) {
//         throw Exception('Location permissions are permanently denied');
//       }

//       final Position position = await Geolocator.getCurrentPosition();
//       setState(() {
//         _selectedLocation = LatLng(position.latitude, position.longitude);
//       });

//       _mapController?.animateCamera(
//         CameraUpdate.newCameraPosition(
//           CameraPosition(
//             target: _selectedLocation,
//             zoom: 20,
//           ),
//         ),
//       );
//     } catch (e) {
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Error getting location: ${e.toString()}')),
//         );
//       }
//     } finally {
//       setState(() {
//         _isLoadingLocation = false;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: [
//           GoogleMap(
//             initialCameraPosition: const CameraPosition(
//               target: LatLng(32.22017044487108, -7.939553250867446),
//               zoom: 20,
//             ),
//             onMapCreated: (GoogleMapController controller) {
//               _mapController = controller;
//             },
//             myLocationButtonEnabled: true,
//             myLocationEnabled: true,
//             onCameraMove: (CameraPosition position) {
//               setState(() {
//                 _selectedLocation = position.target;
//               });
//             },
//                           style: _mapStyleString,

//           ),
//           Center(
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 TweenAnimationBuilder(
//                   tween:
//                       Tween<double>(begin: 0, end: _isLoadingLocation ? 20 : 0),
//                   duration: const Duration(milliseconds: 500),
//                   builder: (context, double value, child) {
//                     return Transform.translate(
//                       offset: Offset(0, -value),
//                       child: child,
//                     );
//                   },
//                   child: Icon(
//                     CupertinoIcons.location_solid,
//                     size: 100,
//                     color: Theme.of(context).colorScheme.surface,
//                   ),
//                 ),
//                 Container(
//                   width: 8,
//                   height: 8,
//                   decoration: BoxDecoration(
//                     color: Colors.black.withOpacity(0.4),
//                     shape: BoxShape.circle,
//                   ),
//                 ),
//               ],
//             ),
//           ),

//           Positioned(
//             right: 30,
//             bottom: 200,
//             child: FloatingActionButton(
//               onPressed: _getCurrentLocation,
//               child: _isLoadingLocation
//                   ? SizedBox(
//                       width: 30,
//                       height: 30,
//                       child: CircularProgressIndicator(
//                         color: Theme.of(context).colorScheme.surface,
//                         strokeWidth: 2,
//                       ),
//                     )
//                   : const Icon(Icons.my_location),
//             ),
//           ),

//           DraggableScrollableSheet(
//             snap: false,
//             initialChildSize: _isFullScreen ? 0.95 : 0.2,
//             minChildSize: _isFullScreen ? 0.95 : 0.2,
//             maxChildSize: _isFullScreen ? 0.95 : 0.2,
//             builder: (context, scrollController) {
//               return GestureDetector(
//                 onTap: () {
//                   if (!_isFullScreen) {
//                     setState(() {
//                       _isFullScreen = true;
//                     });
//                   }
//                 },
//                 child: Container(
//                   decoration: BoxDecoration(
//                     color: Theme.of(context).colorScheme.surface,
//                     borderRadius: _isFullScreen
//                         ? BorderRadius.zero
//                         : const BorderRadius.vertical(top: Radius.circular(20)),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.grey.withOpacity(0.5),
//                         spreadRadius: 2,
//                         blurRadius: 7,
//                       ),
//                     ],
//                   ),
//                   child: Column(
//                     children: [
//                       if (_isFullScreen)
//                         Container(
//                           padding: const EdgeInsets.symmetric(
//                             horizontal: 8,
//                             vertical: 16,
//                           ),
//                           child: Row(
//                             children: [
//                               IconButton(
//                                 icon: const Icon(Icons.close),
//                                 color: Theme.of(context).colorScheme.primary,
//                                 onPressed: () {
//                                   setState(() {
//                                     _isFullScreen = false;
//                                   });
//                                 },
//                               ),
//                               Expanded(
//                                 child: Text(
//                                   'Address Details',
//                                   style: TextStyle(
//                                     color:
//                                         Theme.of(context).colorScheme.primary,
//                                     fontSize: 20,
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                   textAlign: TextAlign.center,
//                                 ),
//                               ),
//                               const SizedBox(width: 48),
//                             ],
//                           ),
//                         ),
//                       if (!_isFullScreen)
//                         Center(
//                           child: Container(
//                             width: 40,
//                             height: 4,
//                             margin: const EdgeInsets.symmetric(vertical: 12),
//                             decoration: BoxDecoration(
//                               color: Colors.grey[300],
//                               borderRadius: BorderRadius.circular(2),
//                             ),
//                           ),
//                         ),
//                       Expanded(
//                         child: SingleChildScrollView(
//                           controller: scrollController,
//                           child: Padding(
//                             padding: const EdgeInsets.all(16.0),
//                             child: _isFullScreen
//                                 ? _buildForm()
//                                 : _buildAddressButton(),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               );
//             },
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildAddressButton() {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         Padding(
//           padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
//           child: Text(
//             'Confirm',
//             style: TextStyle(
//               color: Theme.of(context).colorScheme.primary,
//               fontSize: 24,
//               fontWeight: FontWeight.bold,
//               decoration: TextDecoration.underline
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildForm() {
//     return Form(
//       key: _formKey,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           TextFormField(
//             controller: _labelController,
//             decoration: _getInputDecoration('Address Label'),
//             validator: (value) {
//               if (value?.isEmpty ?? true) {
//                 return 'Please enter an address label';
//               }
//               return null;
//             },
//           ),
//           const SizedBox(height: 16),
//           TextFormField(
//             controller: _streetController,
//             // cursorColor: Colors.white,
//             decoration: _getInputDecoration('Street name'),
//             validator: (value) {
//               if (value?.isEmpty ?? true) {
//                 return 'Please enter a street';
//               }
//               return null;
//             },
//           ),
//           const SizedBox(height: 16),
//           if (_selectedAddressType != "House") ...[
//             Padding(
//               padding: const EdgeInsets.fromLTRB(0, 0, 0, 16),
//               child: TextFormField(
//                       controller: _apartmentController,
//                       decoration: _getInputDecoration('Building number'),
//                     ),
//             ),
//             Row(
//               children: [
//                 Expanded(
//                   child: TextFormField(
//                     controller: _floorController,
//                     decoration: _getInputDecoration('Floor'),
//                     keyboardType: TextInputType.number,
//                   ),
//                 ),
//                 const SizedBox(width: 16),
//                 Expanded(
//                   child: TextFormField(
//                     controller: _apartmentController,
//                     decoration: _getInputDecoration('Apartment Number'),
//                     keyboardType: TextInputType.number,
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(width: 16),
//           ] else ...[
//             Row(
//               children: [
//                 Expanded(
//                   child: TextFormField(
//                     controller: _houseNumberController,
//                     decoration: _getInputDecoration('House Number'),
//                     keyboardType: TextInputType.number,
//                     validator: (value) {
//                       if (value?.isEmpty ?? true) {
//                         return 'Please enter a street';
//                       }
//                       return null;
//                     },
//                   ),
//                 ),
//               ],
//             ),
//           ],
//           _buildAddressTypeSelector(),
//           const SizedBox(height: 24),
//           SizedBox(
//             width: double.infinity,
//             child: ElevatedButton(
//               onPressed: () {
//                 if (_formKey.currentState?.validate() ?? false) {
//                 }
//               },
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Theme.of(context).colorScheme.secondary,
//                 padding: const EdgeInsets.symmetric(vertical: 16),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//               ),
//               child: Text(
//                 'Save Address',
//                 style: TextStyle(
//                   fontSize: 16,
//                   color: Theme.of(context).colorScheme.primary,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     _labelController.dispose();
//     _streetController.dispose();
//     _houseNumberController.dispose();
//     _floorController.dispose();
//     _apartmentController.dispose();
//     _mapController?.dispose();
//     super.dispose();
//   }
// }
