import 'dart:async';
import 'package:boma/components/bbutton.dart';
import 'package:flutter/material.dart';
import '../../components/btextfield.dart';
import '../types/address.dart';

class ConfirmAddress extends StatefulWidget {
  final Addressconfirmation? confirm;

  const ConfirmAddress({
    super.key,
    required this.confirm,
  });

  @override
  State<ConfirmAddress> createState() => _ConfirmAddressState();
}

class _ConfirmAddressState extends State<ConfirmAddress> {
  final _formKey = GlobalKey<FormState>();
  final _addressNameController = TextEditingController();
  final _streetController = TextEditingController();
  final _buildingController = TextEditingController();
  final _floorController = TextEditingController();
  final _unitController = TextEditingController();
  final _cityController = TextEditingController();
  String _selectedAddressType = 'Apartment';

  Timer? errorTimer;
  bool error = false;
  String errorMsg = '';
  bool isLoading = false;
  int errorSecondsRemaining = 5;

  void startErrorTimer() {
    errorTimer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      if (errorSecondsRemaining == 0) {
        setState(() {
          timer.cancel();
          error = false;
          errorMsg = "";
          errorSecondsRemaining = 5;
        });
      } else {
        setState(() {
          errorSecondsRemaining--;
        });
      }
    });
  }

  void showError(String message) {
    setState(() {
      error = true;
      errorMsg = message;
      errorSecondsRemaining = 5;
    });
    startErrorTimer();
  }

  void submitAddress() {
    if (_formKey.currentState?.validate() ?? false) {
      // Perform the submit action here
      // e.g., send the data to a server or save it locally
      setState(() {
        isLoading = true;
      });

      // Simulate a network request
      Future.delayed(const Duration(seconds: 2), () {
        setState(() {
          isLoading = false;
        });
        // Show success message or navigate to another screen
      });
    } else {
      showError("Please fill in all required fields correctly.");
    }
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

  @override
  void dispose() {
    _addressNameController.dispose();
    _streetController.dispose();
    _buildingController.dispose();
    _floorController.dispose();
    _unitController.dispose();
    _cityController.dispose();
    super.dispose();
  }

  Widget _buildAddressTypeSelector() {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: colorScheme.surface,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _addressTypes.entries.map((type) {
                final isSelected = _selectedAddressType == type.key;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          type.value['icon'] as IconData,
                          size: 24,
                          color: isSelected
                              ? colorScheme.onSecondary
                              : colorScheme.secondary,
                        ),
                        const SizedBox(width: 8),
                        Text(type.value['label'] as String),
                      ],
                    ),
                    selected: isSelected,
                    onSelected: (bool selected) {
                      if (selected) {
                        setState(() => _selectedAddressType = type.key);
                      }
                    },
                    selectedColor: colorScheme.secondary,
                    backgroundColor: colorScheme.surface,
                    labelStyle: TextStyle(
                      color: isSelected
                          ? colorScheme.onSecondary
                          : colorScheme.primary,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final currentType = _addressTypes[_selectedAddressType]!;

    return Scaffold(
       appBar: AppBar(
        automaticallyImplyLeading:  error ? false : true,
        backgroundColor:
            !error ? Theme.of(context).colorScheme.surface : Colors.red,
        title: Text(
          errorMsg == "" ?  "Add New Address" :  errorMsg,
          style: TextStyle(
            fontSize:  errorMsg == "" ?  24:  18,
            color: Theme.of(context).colorScheme.primary,
            fontWeight: FontWeight.normal,
          ),
        ),
      ),
      backgroundColor: colorScheme.surface,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Btextfield(
                    controller: _addressNameController,
                    labelText: 'Address Label (e.g. Home, Office)',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter an address label';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 16),

                  Btextfield(
                    controller: _streetController,
                    labelText: 'Street Name',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the street name';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 16),

                  Row(
                    children: [
                      Expanded(
                        child: Btextfield(
                          controller: _buildingController,
                          labelText: currentType['icon'] == Icons.home
                              ? 'House No.'
                              : 'Building No.',
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter the building/house number';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
                      if (currentType['showFloor'])
                        Expanded(
                          child: Btextfield(
                            controller: _floorController,
                            labelText: 'Floor',
                            validator: (value) {
                              if (currentType['showFloor'] &&
                                  (value == null || value.isEmpty)) {
                                return 'Please enter the floor number';
                              }
                              return null;
                            },
                          ),
                        ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  if (currentType['showUnit'])
                    Btextfield(
                      controller: _unitController,
                      labelText: currentType['icon'] == Icons.business
                          ? 'Suite No.'
                          : 'Unit/Apartment No.',
                      validator: (value) {
                        if (currentType['showUnit'] &&
                            (value == null || value.isEmpty)) {
                          return 'Please enter the unit/apartment number';
                        }
                        return null;
                      },
                    ),
                  const SizedBox(height: 24),

                  _buildAddressTypeSelector(),

                  const SizedBox(height: 24),

                  // Submit Button
                  BButton(
                    text: "Save",
                    onTap:  submitAddress,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}