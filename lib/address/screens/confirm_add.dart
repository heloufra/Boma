import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:june/june.dart';

import '../types/address.dart';
import '../state/address.dart';

class ConfirmAddressAdd extends StatefulWidget {
  final Addressconfirmation addressconfirmation;
  const ConfirmAddressAdd({super.key, required this.addressconfirmation});
  @override
  State<StatefulWidget> createState() {
    return _ConfirmAddress();
  }
}

class _ConfirmAddress extends State<ConfirmAddressAdd> {
  static const maxSeconds = 4;
  int secondsRemaining = maxSeconds;
  Timer? timer;
  bool error = false;
  String errorMsg = '';
  bool isLoading = false;

  String _selectedAddressType = 'apartment';
  final _formKey = GlobalKey<FormState>();
  final _labelController = TextEditingController();
  final _streetController = TextEditingController();
  final _houseNumberController = TextEditingController();
  final _floorController = TextEditingController();
  final _apartmentController = TextEditingController();
  final _buildingController = TextEditingController();

  InputDecoration _getInputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
            decoration: _getInputDecoration('Street name'),
            validator: (value) {
              if (value?.isEmpty ?? true) {
                return 'Please enter a street';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          if (_selectedAddressType != "house") ...[
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 16),
              child: TextFormField(
                controller: _buildingController,
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
                        return 'Please enter a house number';
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
                if (_formKey.currentState?.validate() ?? false) {
                  _saveAddress();
                }
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

  final Map<String, Map<String, dynamic>> _addressTypes = {
    'apartment': {
      'label': 'Apartment',
      'icon': Icons.apartment,
      'showFloor': true,
      'showUnit': true,
    },
    'house': {
      'label': 'House',
      'icon': Icons.home,
      'showFloor': false,
      'showUnit': false,
    },
    'office': {
      'label': 'Office',
      'icon': Icons.business,
      'showFloor': true,
      'showUnit': true,
    },
    'other': {
      'label': 'Other',
      'icon': Icons.location_city,
      'showFloor': true,
      'showUnit': true,
    },
  };

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

  void _saveAddress() {
    var state = June.getState(() => AddressState());

    final newAddress = Address(
      name: _labelController.text,
      type: _selectedAddressType,
      city: 'BenGuerir',
      fullAddress: (_selectedAddressType != "house") ? 
          '${_streetController.text}, ${_buildingController.text}, ${_floorController.text}, ${_apartmentController.text}' : 
           '${_streetController.text}, ${_houseNumberController.text}',
      apartmentNumber: (_selectedAddressType == "house") ? _houseNumberController.text :_apartmentController.text,
      floorNumber: _floorController.text,
      buildingNumber: _buildingController.text,
      streetName: _streetController.text,
      latitude: widget.addressconfirmation.userLocation.latitude,
      longitude: widget.addressconfirmation.userLocation.longitude,
    );

    state.addAddress(newAddress).then((_) {
      if (state.isError) {
        setState(() {
          error = true;
          errorMsg = state.errorMessage ?? "";
          startTimer();
        });
        if (!mounted) return;
        state.resetErrors();
      } else {
        state.fetchAddresses();
        if (!mounted) return;
        context.go('/settings/address/');
      }
    });
  }

 @override
  void dispose() {
    timer?.cancel();
    _labelController.dispose();
    _streetController.dispose();
    _houseNumberController.dispose();
    _floorController.dispose();
    _apartmentController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor:
            !error ? Theme.of(context).colorScheme.surface : Colors.red,
        title: Text(
          errorMsg,
          style: TextStyle(
            fontSize: 18,
            color: Theme.of(context).colorScheme.primary,
            fontWeight: FontWeight.normal,
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              _saveAddress();
            },
            child: Text(
              'Save',
              style: TextStyle(color: Theme.of(context).colorScheme.secondary),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _buildForm(),
      ),
    );
  }
}