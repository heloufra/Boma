import 'package:dio/dio.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Address {
  final int? id;
  final String name;
  final String type;
  final String city;
  final String fullAddress;
  final double latitude;
  final double longitude;
  final String? streetName;
  final String? buildingNumber;
  final String? floorNumber;
  final String? apartmentNumber;

  Address({
    this.id,
    required this.name,
    required this.type,
    required this.city,
    required this.fullAddress,
    required this.latitude,
    required this.longitude,
    this.streetName,
    this.buildingNumber,
    this.floorNumber,
    this.apartmentNumber,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      id: (json['id'] as num?)?.toInt(),
      name: json['name'] as String,
      type: json['type'] as String,
      city: json['city'] as String,
      fullAddress: json['full_address'] as String,
      latitude: double.parse(json['latitude'] as String),
      longitude: double.parse(json['longitude'] as String),
      streetName: json['street_name'] as String?,
      buildingNumber: json['building_number'] as String?,
      floorNumber: json['floor_number'] as String?,
      apartmentNumber: json['apartment_number'] as String?,
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
      'street_name': streetName,
      'building_number': buildingNumber,
      'floor_number': floorNumber,
      'apartment_number': apartmentNumber,
    };
  }

  LatLng getLatLng() { return LatLng(latitude, longitude);}
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

  const Addressconfirmation({
    required this.userLocation,
  });
}


class EditAddressconfirmation {
  final LatLng userLocation;
  final Address address;

  const EditAddressconfirmation({
    required this.userLocation,
    required this.address
  });
}