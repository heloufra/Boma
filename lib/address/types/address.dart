import 'package:dio/dio.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Address {
  final int? id;
  final String name;
  final String type;
  final String city;
  final String fullAddress;
  final String latitude;
  final String longitude;
  final bool? isDefault;

  Address({
    this.id,
    required this.name,
    required this.type,
    required this.city,
    required this.fullAddress,
    required this.latitude,
    required this.longitude,
    this.isDefault,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      id: json['id'],
      name: json['name'],
      type: json['type'],
      city: json['city'],
      fullAddress: json['full_address'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      isDefault: json['is_default'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'city': city,
      'full_address': fullAddress,
      'latitude': latitude,
      'longitude': longitude,
      'is_default': isDefault,
    };
  }

  Address copyWith({
    int? id,
    String? name,
    String? type,
    String? city,
    String? fullAddress,
    String? latitude,
    String? longitude,
    bool? isDefault,
  }) {
    return Address(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      city: city ?? this.city,
      fullAddress: fullAddress ?? this.fullAddress,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      isDefault: isDefault ?? this.isDefault,
    );
  }
}

class AddressResponse {
  final bool success;
  final String message;
  final Response? response;
  final Address? address;
  final List<Address>? addresses;

  AddressResponse({
    required this.success,
    required this.message,
    this.response,
    this.address,
    this.addresses,
  });
}

class Addressconfirmation {
  final LatLng userLocation;
  final String addressType;

  Addressconfirmation({
    required this.userLocation,
    required this.addressType
  });
}