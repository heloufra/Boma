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
  List<Address> _addresses = [];
  Address? selectedAddress;
  String? errorMessage;
  bool isLoading = false;

  bool get hasAddresses => addresses.isNotEmpty;
  bool get isInitial => status == AddressStatus.initial;
  bool get isError => status == AddressStatus.error;
  bool get hasSelectedAddress => selectedAddress != null;
  bool get isLoaded => status == AddressStatus.loaded;
  List<Address> get addresses => _addresses;

  Future<void> fetchAddresses() async {
    isLoading = true;
    setState();

    try {
      final response = await _api.getAddresses();

      if (response.success) {
        _addresses = response.addresses ?? [];
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

  void selectAddress(Address address) {
    selectedAddress = address;
    setState();
  }

  void clearSelection() {
    selectedAddress = null;
    setState();
  }

  void clearError() {
    errorMessage = null;
    status = AddressStatus.initial;
    setState();
  }

  void reset() {
    _addresses = [];
    selectedAddress = null;
    errorMessage = null;
    status = AddressStatus.initial;
    isLoading = false;
    setState();
  }
}