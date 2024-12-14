import 'dart:async';
import 'dart:io';
import 'package:boma/components/bbutton.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
// import 'package:image_picker/image_picker.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _fullNameController = TextEditingController();
  File? _image;
  Timer? timer;
  Timer? errorTimer;
  bool error = false;
  String errorMsg = '';
  bool isLoading = false;
  TextEditingController controller = TextEditingController();
  int errorSecondsRemaining = 5;
  Future<void> _pickImage() async {
    // final pickedFile = await ImagePicker().getImage(source: ImageSource.gallery);

    // setState(() {
    //   if (pickedFile != null) {
    //     _image = File(pickedFile.path);
    //   } else {
    //     error = true;
    //     errorMsg = 'No image selected';
    //   }
    // });
  }
  void startErrorTimer() {
    errorTimer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      if (errorSecondsRemaining == 0) {
        setState(() {
          timer.cancel();
          // Perform your action here
          error = false;
          errorMsg = "";
          errorSecondsRemaining = 5;
        });
      } else {
        setState(() {
          errorSecondsRemaining--;
        });
      }
    });
  }

  void _register() {
    if (_fullNameController.text.isEmpty) {
      setState(() {
        error = true;
        errorMsg = '🚨📢🔔 Enter full digits of your OTP';
      });
    } else {
      setState(() {
        isLoading = true;
        error = false;
        errorMsg = "";
      });
      context.go('/auth/location');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor:
            !error ? Theme.of(context).colorScheme.surface : Colors.red,
        title: Text(
          errorMsg,
          style: TextStyle(
            fontSize: 18,
            color: Theme.of(context).colorScheme.primary,
            fontWeight: FontWeight.normal,
          ),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (isLoading) // Show loading indicator when isLoading is true
                CircularProgressIndicator(
                  color: Theme.of(context).colorScheme.secondary,
                )
              else
                GestureDetector(
                  onTap: _pickImage,
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: Theme.of(context)
                        .colorScheme
                        .secondary
                        .withOpacity(0.1),
                    backgroundImage: _image != null ? FileImage(_image!) : null,
                    child: _image == null
                        ? Icon(Icons.camera_alt,
                            color: Theme.of(context).colorScheme.primary,
                            size: 30)
                        : null,
                  ),
                ),
              const SizedBox(height: 20),
              TextField(
                controller: _fullNameController,
                decoration: InputDecoration(
                  labelText: 'Full Name',
                  labelStyle: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 18,
                    fontWeight: FontWeight.normal,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.secondary,
                        width: 2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.secondary,
                        width: 2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  filled: true,
                  fillColor:
                      Theme.of(context).colorScheme.secondary.withOpacity(0.1),
                ),
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 20, 0, 8),
                    child: BButton(
                      text: 'Register',
                      onTap: _register,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
