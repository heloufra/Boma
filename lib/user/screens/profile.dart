import 'package:flutter/material.dart';

import '../../components/btextfield.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  final TextEditingController _nameController =
      TextEditingController(text: "hamza");
  final TextEditingController _emailController =
      TextEditingController(text: "hamza@gmail.com");
  String _selectedLanguage = "en";

  void _saveProfile() {
    // Handle save profile logic
    print("Profile saved");
    print("Name: ${_nameController.text}");
    print("Email: ${_emailController.text}");
    print("Language: $_selectedLanguage");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // automaticallyImplyLeading: false, // Removes the back button
        // leading: Icons.abc(context),
        // title: const Text("User Profile"),
        actions: [
          TextButton(
            onPressed: _saveProfile,
            child: Text(
              "Save",
              style: TextStyle(
                color: Theme.of(context).colorScheme.secondary,
                fontSize: 18
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Btextfield(controller: _nameController, labelText: 'Full Name'),
            const SizedBox(height: 16),

            Btextfield(controller: _emailController, labelText: "Email"),
            const SizedBox(height: 16),

            DropdownButtonFormField<String>(
              value: _selectedLanguage,
              decoration: InputDecoration(
                labelText: 'language',
                labelStyle: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: 18,
                  fontWeight: FontWeight.normal,
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.secondary, width: 2),
                  borderRadius: BorderRadius.circular(20),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.secondary, width: 2),
                  borderRadius: BorderRadius.circular(20),
                ),
                filled: true,
                fillColor:
                    Theme.of(context).colorScheme.secondary.withOpacity(0.1),
              ),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedLanguage = newValue!;
                });
              },
              // items: <String>['English 🇬🇧', 'العربية 🇲🇦', 'Français 🇫🇷'].map<DropdownMenuItem<String>>((String value) {
              items: <String>['en', 'fr', 'ar'].map<DropdownMenuItem<String>>((String value) {

                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),

            const Spacer(),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.secondary,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                  textStyle: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold)),
              child:  const Text('Sign Out'),
            ),
            const SizedBox(height: 18),
            ElevatedButton(
              onPressed: () {
                // Handle delete account
                // print("Delete Account pressed");
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.shade600,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                  textStyle: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold)),
              child: const Text("Delete Account"),
              // style: ElevatedButton.styleFrom(primary: Colors.red),
            ),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
