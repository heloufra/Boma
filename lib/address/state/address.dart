// lib/address/types/address_status.dart
import 'package:june/june.dart';

import '../address.dart';

enum AddressStatus {
  initial,
  loading,
  loaded,
  error,
  updated,
  deleted
}


class AddressState extends JuneState {
  final AddressAPI _api = AddressAPI();

  AddressStatus status = AddressStatus.initial;
  List<Address> addresses = [];
  Address? selectedAddress;
  String? errorMessage;
  bool isLoading = false;

  // Getters for status checks
  bool get hasAddresses => addresses.isNotEmpty;
  bool get isInitial => status == AddressStatus.initial;
  bool get isError => status == AddressStatus.error;
  bool get hasSelectedAddress => selectedAddress != null;
  Address? get defaultAddress => 
      addresses.firstWhere((address) => address.isDefault == true, orElse: () => addresses.first);

  // Fetch all addresses
  Future<void> fetchAddresses() async {
    isLoading = true;
    setState();

    try {
      final response = await _api.getAddresses();

      if (response.success) {
        addresses = response.addresses ?? [];
        status = AddressStatus.loaded;
      } else {
        status = AddressStatus.error;
        errorMessage = response.message;
      }
    } catch (e) {
      status = AddressStatus.error;
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      setState();
    }
  }

  // Add new address
  Future<void> addAddress(Address address) async {
    isLoading = true;
    setState();

    try {
      final response = await _api.addAddress(address);

      if (response.success) {
        if (response.address != null) {
          addresses.add(response.address!);
        }
        status = AddressStatus.updated;
      } else {
        status = AddressStatus.error;
        errorMessage = response.message;
      }
    } catch (e) {
      status = AddressStatus.error;
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      setState();
    }
  }

  // Update existing address
  Future<void> updateAddress(int id, Address updatedAddress) async {
    isLoading = true;
    setState();

    try {
      final response = await _api.updateAddress(id, updatedAddress);

      if (response.success) {
        final index = addresses.indexWhere((address) => address.id == id);
        if (index != -1 && response.address != null) {
          addresses[index] = response.address!;
        }
        status = AddressStatus.updated;
      } else {
        status = AddressStatus.error;
        errorMessage = response.message;
      }
    } catch (e) {
      status = AddressStatus.error;
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      setState();
    }
  }

  // Delete address
  Future<void> deleteAddress(int id) async {
    isLoading = true;
    setState();

    try {
      final response = await _api.deleteAddress(id);

      if (response.success) {
        addresses.removeWhere((address) => address.id == id);
        if (selectedAddress?.id == id) {
          selectedAddress = null;
        }
        status = AddressStatus.deleted;
      } else {
        status = AddressStatus.error;
        errorMessage = response.message;
      }
    } catch (e) {
      status = AddressStatus.error;
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      setState();
    }
  }

  // Set default address
  Future<void> setDefaultAddress(int id) async {
    isLoading = true;
    setState();

    try {
      final response = await _api.setDefaultAddress(id);

      if (response.success) {
        // Update isDefault status for all addresses
        for (var address in addresses) {
          if (address.id == id) {
            final index = addresses.indexOf(address);
            addresses[index] = address.copyWith(isDefault: true);
          } else {
            final index = addresses.indexOf(address);
            addresses[index] = address.copyWith(isDefault: false);
          }
        }
        status = AddressStatus.updated;
      } else {
        status = AddressStatus.error;
        errorMessage = response.message;
      }
    } catch (e) {
      status = AddressStatus.error;
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      setState();
    }
  }

  // Select an address (for UI purposes)
  void selectAddress(Address address) {
    selectedAddress = address;
    setState();
  }

  // Clear selection
  void clearSelection() {
    selectedAddress = null;
    setState();
  }

  // Reset error state
  void clearError() {
    errorMessage = null;
    status = AddressStatus.initial;
    setState();
  }

  // Reset state
  void reset() {
    addresses = [];
    selectedAddress = null;
    errorMessage = null;
    status = AddressStatus.initial;
    isLoading = false;
    setState();
  }
}