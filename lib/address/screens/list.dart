import 'package:boma/address/state/address.dart';
import 'package:flutter/material.dart';
import 'package:june/june.dart';
import '../types/address.dart';

class AddressManagementScreen extends StatefulWidget {
  const AddressManagementScreen({super.key});

  @override
  State<AddressManagementScreen> createState() =>
      _AddressManagementScreenState();
}

class _AddressManagementScreenState extends State<AddressManagementScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      var state = June.getState(() => AddressState());
      _getUserAddress(state);
    });
  }

  Future<void> _getUserAddress(AddressState state) async {
    await state.fetchAddresses();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Addresses'),
      ),
      body: Center(
        child: JuneBuilder(
          () => AddressState(), // Initialize the AddressState view model
          builder: (state) => Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              if (state.isLoading)
                const CircularProgressIndicator(), // Show loading indicator
              if (state.isError)
                Text('Error: ${state.errorMessage}'), // Show error message
              if (!state.isLoading && !state.isError && state.hasAddresses)
                Expanded(
                  child: ListView.builder(
                    itemCount: state.addresses.length,
                    itemBuilder: (context, index) {
                      final address = state.addresses[index];
                      return ListTile(
                        title: Text(address.name),
                        subtitle: Text(address.fullAddress),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () =>
                                  _showAddressForm(context, address: address),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () => state.deleteAddress(address.id!),
                            ),
                          ],
                        ),
                        onTap: () => state.selectAddress(address),
                      );
                    },
                  ),
                ),
              if (!state.isLoading && !state.isError && !state.hasAddresses)
                const Text('No addresses found.'),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddressForm(context),
        tooltip: 'Add Address',
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddressForm(BuildContext context, {Address? address}) {
    showDialog(
      context: context,
      builder: (context) => AddressFormDialog(address: address),
    );
  }
}

class AddressFormDialog extends StatefulWidget {
  final Address? address;

  const AddressFormDialog({super.key, this.address});

  @override
  _AddressFormDialogState createState() => _AddressFormDialogState();
}

class _AddressFormDialogState extends State<AddressFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late String name, type, city, fullAddress, latitude, longitude;
  bool isDefault = false;

  @override
  void initState() {
    super.initState();
    if (widget.address != null) {
      name = widget.address!.name;
      type = widget.address!.type;
      city = widget.address!.city;
      fullAddress = widget.address!.fullAddress;
      latitude = widget.address!.latitude;
      longitude = widget.address!.longitude;
      isDefault = widget.address!.isDefault ?? false;
    } else {
      name = '';
      type = '';
      city = '';
      fullAddress = '';
      latitude = '';
      longitude = '';
      isDefault = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.address == null ? 'Add Address' : 'Edit Address'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextFormField(
                initialValue: name,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
                onSaved: (value) => name = value!,
              ),
              TextFormField(
                initialValue: type,
                decoration: const InputDecoration(labelText: 'Type'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a type';
                  }
                  return null;
                },
                onSaved: (value) => type = value!,
              ),
              TextFormField(
                initialValue: city,
                decoration: const InputDecoration(labelText: 'City'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a city';
                  }
                  return null;
                },
                onSaved: (value) => city = value!,
              ),
              TextFormField(
                initialValue: fullAddress,
                decoration: const InputDecoration(labelText: 'Full Address'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a full address';
                  }
                  return null;
                },
                onSaved: (value) => fullAddress = value!,
              ),
              TextFormField(
                initialValue: latitude,
                decoration: const InputDecoration(labelText: 'Latitude'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a latitude';
                  }
                  return null;
                },
                onSaved: (value) => latitude = value!,
              ),
              TextFormField(
                initialValue: longitude.toString(),
                decoration: const InputDecoration(labelText: 'Longitude'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a longitude';
                  }
                  return null;
                },
                onSaved: (value) => longitude = value!,
              ),
              CheckboxListTile(
                title: const Text('Is Default'),
                value: isDefault,
                onChanged: (value) => setState(() => isDefault = value!),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: _submitForm,
          child: Text(widget.address == null ? 'Add' : 'Update'),
        ),
      ],
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final address = Address(
        id: widget.address?.id,
        name: name,
        type: type,
        city: city,
        fullAddress: fullAddress,
        latitude: latitude,
        longitude: longitude,
        isDefault: isDefault,
      );

      // // final addressState = JuneProvider.of<AddressState>(context);
      // if (widget.address == null) {
      //   addressState.addAddress(address);
      // } else {
      //   addressState.updateAddress(widget.address!.id!, address);
      // }

      Navigator.of(context).pop();
    }
  }
}
