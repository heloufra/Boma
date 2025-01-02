import 'package:boma/address/types/address.dart';
import 'package:boma/dio.dart';
import 'package:dio/dio.dart';

class AddressAPI {
  final dioClient = DioClient();

  Future<AddressResponse> getAddresses() async {
    try {
      final response = await dioClient.get('/c/address/');
      final List<Address> addresses = (response.data as List)
          .map((address) => Address.fromJson(address))
          .toList();

      return AddressResponse(
        success: true,
        message: 'Addresses fetched successfully',
        response: response,
        addresses: addresses,
      );
    } on DioException catch (e) {
      String message = DioClient.handleDioError(e);
      return AddressResponse(
        success: false,
        message: '🚨📢🔔 $message',
      );
    }
  }

  Future<AddressResponse> addAddress(Address address) async {
    try {
      final response = await dioClient.post(
        '/addresses/',
        data: address.toJson(),
      );

      return AddressResponse(
        success: true,
        message: 'Address added successfully',
        response: response,
        address: Address.fromJson(response.data),
      );
    } on DioException catch (e) {
      String message = DioClient.handleDioError(e);
      return AddressResponse(
        success: false,
        message: '🚨📢🔔 $message',
      );
    }
  }

  Future<AddressResponse> updateAddress(int id, Address address) async {
    try {
      final response = await dioClient.put(
        '/addresses/$id/',
        data: address.toJson(),
      );

      return AddressResponse(
        success: true,
        message: 'Address updated successfully',
        response: response,
        address: Address.fromJson(response.data),
      );
    } on DioException catch (e) {
      String message = DioClient.handleDioError(e);
      return AddressResponse(
        success: false,
        message: '🚨📢🔔 $message',
      );
    }
  }

  Future<AddressResponse> deleteAddress(int id) async {
    try {
      final response = await dioClient.delete('/addresses/$id/');
      
      return AddressResponse(
        success: true,
        message: 'Address deleted successfully',
        response: response,
      );
    } on DioException catch (e) {
      String message = DioClient.handleDioError(e);
      return AddressResponse(
        success: false,
        message: '🚨📢🔔 $message',
      );
    }
  }

  Future<AddressResponse> setDefaultAddress(int id) async {
    try {
      final response = await dioClient.post('/addresses/$id/set_default/');
      
      return AddressResponse(
        success: true,
        message: 'Default address set successfully',
        response: response,
        address: Address.fromJson(response.data),
      );
    } on DioException catch (e) {
      String message = DioClient.handleDioError(e);
      return AddressResponse(
        success: false,
        message: '🚨📢🔔 $message',
      );
    }
  }
}