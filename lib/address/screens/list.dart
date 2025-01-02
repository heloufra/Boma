import 'package:boma/address/state/address.dart';
import 'package:flutter/material.dart';
import 'package:june/june.dart';

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
        title: const Text('Addresses'),
         actions: <Widget>[
          TextButton(
            onPressed: () {
             
            },
            child: const Icon(
              Icons.add,
            )
          ),
        ],
      ),
      body: Center(
        child: JuneBuilder(
          () => AddressState(), // Initialize the AddressState view model
          builder: (state) => Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              if (state.isLoading)
                const CircularProgressIndicator(), // Show loading indicator
              // if (state.isError)
                // Text('Error: ${state.errorMessage}'), // Show error message
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
                                  {
                                    // Addressconfirmation addressConfirm = Addressconfirmation(userLocation: LatLng(double.parse(address.latitude), double.parse(address.longitude)), addressType: address.type),
                                    // context.go("/address/edit",  addressConfirm),
                                  },
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
    );
  }
}
