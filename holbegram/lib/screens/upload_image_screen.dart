import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';
import 'package:holbergram/methods/auth_methods.dart';
import 'package:holbergram/screens/home.dart';

class AddPicture extends StatefulWidget {
  final String email;
  final String password;
  final String username;

  const AddPicture({
    super.key,
    required this.email,
    required this.password,
    required this.username,
  });

  @override
  State<AddPicture> createState() => _AddPictureState();
}

class _AddPictureState extends State<AddPicture> {
  Uint8List? _image;

  Future<void> selectImageFromGallery() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedImage = await picker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedImage != null) {
      final Uint8List imageBytes = await pickedImage.readAsBytes();
      setState(() {
        _image = imageBytes;
      });
    }
  }

  Future<void> selectImageFromCamera() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedImage = await picker.pickImage(
      source: ImageSource.camera,
    );

    if (pickedImage != null) {
      final Uint8List imageBytes = await pickedImage.readAsBytes();
      setState(() {
        _image = imageBytes;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 28),
            Text(
              'Holbegram',
              style: TextStyle(fontFamily: 'Billabong', fontSize: 50),
            ),

            Image.asset('assets/images/logo.png', width: 80, height: 60),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  const SizedBox(height: 28),

                  Text(
                    'Hello, ${widget.username} Welcome to Holbegram',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),

                  Text(
                    'Choose and image from your gallery or take a new one',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 35),

                  CircleAvatar(
                    radius: 125, // half of 250
                    backgroundColor: const Color.fromARGB(0, 255, 255, 255),
                    backgroundImage: _image != null
                        ? MemoryImage(_image!)
                        : null,
                    child: _image == null
                        ? Image.asset(
                            'assets/images/icon.png',
                            width: 200,
                            height: 200,
                          )
                        : null,
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.image_outlined, size: 50),
                        onPressed: selectImageFromGallery,
                        color: const Color.fromARGB(218, 226, 37, 24),
                      ),
                      IconButton(
                        icon: const Icon(Icons.photo_camera_outlined, size: 50),
                        onPressed: selectImageFromCamera,
                        color: const Color.fromARGB(218, 226, 37, 24),
                      ),
                    ],
                  ),

                  const SizedBox(height: 35),

                  SizedBox(
                    height: 45,
                    width: 130,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: WidgetStatePropertyAll(
                          Color.fromARGB(218, 226, 37, 24),
                        ),
                        shape: WidgetStatePropertyAll(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                      onPressed: () async {
                        final res = await AuthMethods().signUpUser(
                          email: widget.email,
                          password: widget.password,
                          username: widget.username,
                          file: _image,
                        );

                        if (!context.mounted) return;

                        if (res == 'success') {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Success'))
                          );
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (_) => Home()));
                    
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(res))
                          );
                        }

                      },
                      child: Text(
                        'Next',
                        style: TextStyle(color: Colors.white, fontSize: 30),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
