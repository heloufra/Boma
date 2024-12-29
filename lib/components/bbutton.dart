import 'package:flutter/material.dart';

class BButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final bool isOutlined;

  const BButton({
    super.key,
    required this.text,
    required this.onTap,
    this.isOutlined = false,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: MediaQuery.of(context).size.width / 3,
        height: 50,
        decoration: BoxDecoration(
          // Gradient background for futuristic look
          gradient: LinearGradient(
            colors: isOutlined
                ? [Colors.transparent, Colors.transparent]
                : [
                    colorScheme.secondary.withOpacity(0.7),
                    colorScheme.secondary,
                  ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          // Glassy, translucent effect
          color: isOutlined ? Colors.transparent : null,
          border: Border.all(
            color: colorScheme.secondary,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(20), // More rounded
          boxShadow: [
            BoxShadow(
              color: colorScheme.secondary.withOpacity(0.3),
              spreadRadius: 1,
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: Text(
          text,
          style: TextStyle(
            color: isOutlined 
              ? colorScheme.secondary 
              : colorScheme.primary,
            fontSize: 16,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
      ),
    );
  }
}

