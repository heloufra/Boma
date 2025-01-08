import 'package:june/june.dart';
import '../address.dart';

enum AddressStatus { initial, loading, loaded, error, updated, deleted }

class AddressState extends JuneState {
  final AddressAPI _api = AddressAPI();
  AddressStatus status = AddressStatus.initial;
  List<Address> _addresses = [];
  Address? selectedAddress;
  String? errorMessage;
  bool isLoading = false;
  int? _defaultAddressId;

  bool get hasAddresses => addresses.isNotEmpty;
  bool get isInitial => status == AddressStatus.initial;
  bool get isError => status == AddressStatus.error;
  bool get hasSelectedAddress => selectedAddress != null;
  bool get isLoaded => status == AddressStatus.loaded;
  List<Address> get addresses => _addresses;

  Address? get defaultAddress {
    if (_defaultAddressId == null) return null;
    try {
      return _addresses
          .firstWhere((address) => address.id == _defaultAddressId);
    } catch (_) {
      return null;
    }
  }

  void resetErrors() {
    status = AddressStatus.loaded;
    setState();
  }

  void setDefaultAddress(int id) {
    if (_addresses.any((address) => address.id == id)) {
      _defaultAddressId = id;
      setState();
    }
  }

  Future<void> fetchAddresses() async {
    isLoading = true;
    setState();

    try {
      final response = await _api.getAddresses();

      if (response.success) {
        _addresses = response.addresses ?? [];
        status = AddressStatus.loaded;
        if (_addresses.isNotEmpty && _defaultAddressId == null) {
          _defaultAddressId = _addresses.first.id;
        }
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
        status = AddressStatus.loaded;
      } else {
        status = AddressStatus.error;
        errorMessage = response.message;
      }
    } catch (e) {
      status = AddressStatus.error;
      errorMessage = e.toString();
    } finally {
     
      if (id == _defaultAddressId) {
        setDefaultAddress(addresses.first.id ?? 0);
      }
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
