// lib/address/services/address_api.dart

import 'package:boma/address/types/address.dart';
import 'package:boma/dio.dart';
import 'package:dio/dio.dart';

class AddressAPI {
  final dioClient = DioClient();

  // Get all addresses
  Future<AddressResponse> getAddresses() async {
    try {
      final response = await dioClient.get('/addresses/');
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

  // Add new address
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

  // Update address
  Future<AddressResponse> updateAddress(String id, Address address) async {
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

  // Delete address
  Future<AddressResponse> deleteAddress(String id) async {
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

  // Set default address
  Future<AddressResponse> setDefaultAddress(String id) async {
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