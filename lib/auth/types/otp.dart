class Otp {
  final int phoneNumber;
  final int otp;

  Otp({required this.phoneNumber,required this.otp});

  Map<String, dynamic> toJson() => {
      'phone_number': phoneNumber,
      'otp': otp,
  };
}
