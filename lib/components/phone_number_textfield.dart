import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PhoneNumberField extends StatelessWidget {
  final TextEditingController controller;

  const PhoneNumberField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    // Get theme colors
    final colorScheme = Theme.of(context).colorScheme;

    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.phone,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(9),
        ],
        decoration: InputDecoration(
          prefixText: '+212 ',
          prefixStyle: TextStyle(
            color: colorScheme.primary,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
          labelText: 'Phone Number',
          labelStyle: TextStyle(
            color: colorScheme.primary,
            fontSize: 18,
            fontWeight: FontWeight.normal,
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: colorScheme.secondary, width: 2),
            borderRadius: BorderRadius.circular(20), // More rounded
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: colorScheme.secondary, width: 2),
            borderRadius: BorderRadius.circular(20), // More rounded
          ),
          filled: true,
          fillColor: colorScheme.secondary.withOpacity(0.1),
        ),
        style: TextStyle(
          color: colorScheme.primary,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}