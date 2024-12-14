class Register {
  final int name;
  final String avatarURL;

  Register({required this.name, required this.avatarURL});

  Map<String, dynamic> toJson() => {
      'name': name,
      'avatarURL': avatarURL,
  };
}
