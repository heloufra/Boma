import 'package:flutter/material.dart';
import '../types/address.dart';

class ConfirmAddressEdit extends StatefulWidget {
 final Address address;
  const ConfirmAddressEdit({super.key, required this.address});
  @override
  State<StatefulWidget> createState() {
    return _ConfirmAddress();
  }
}

class _ConfirmAddress extends State<ConfirmAddressEdit> {
  String _selectedAddressType = 'Apartment';
  final _formKey = GlobalKey<FormState>();
  final _labelController = TextEditingController();
  final _streetController = TextEditingController();
  final _houseNumberController = TextEditingController();
  final _buildingNumberController = TextEditingController();
  final _floorController = TextEditingController();
  final _apartmentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _labelController.text = widget.address.name;
    _streetController.text = widget.address.fullAddress;
    _houseNumberController.text = widget.address.apartmentNumber ?? "";
    _apartmentController.text = widget.address.apartmentNumber ?? "";
    _floorController.text = widget.address.floorNumber ?? "";
    _buildingNumberController.text = widget.address.buildingNumber ?? "";
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
      appBar: AppBar(
        title: const Text("Confirm Address"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: _buildForm(),
          )
        ],
      ),
    );
  }
}
