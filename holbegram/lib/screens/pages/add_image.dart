import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:holbergram/widgets/text_field.dart';
import 'package:holbergram/screens/pages/methods/post_storage.dart';
import 'package:provider/provider.dart';
import 'package:holbergram/providers/user_provider.dart';

class AddImage extends StatefulWidget {
  final void Function()? onPostSuccess;
  const AddImage({super.key, this.onPostSuccess});

  @override
  State<AddImage> createState() => _AddImageState();
}

class _AddImageState extends State<AddImage> {
  Uint8List? _image;
  bool _isLoading = false;
  final TextEditingController _captionController = TextEditingController();

  // 📸 Pick from gallery
  Future<void> selectImageFromGallery() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedImage = await picker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedImage != null) {
      final Uint8List imageBytes = await pickedImage.readAsBytes();
      setState(() => _image = imageBytes);
    }
  }

  // 📷 Take photo
  Future<void> selectImageFromCamera() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedImage = await picker.pickImage(
      source: ImageSource.camera,
    );

    if (pickedImage != null) {
      final Uint8List imageBytes = await pickedImage.readAsBytes();
      setState(() => _image = imageBytes);
    }
  }

  // 📝 Upload post
  Future<void> postImage() async {
    // 1. Get the user from provider
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final user = userProvider.getUser;

    // ✅ CHECK: This "promotes" user from Users? to Users (non-nullable)
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error: User data not found. Please try again.'),
        ),
      );
      return;
    }

    // Check image
    if (_image == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please select an image')));
      return;
    }

    // Check caption
    if (_captionController.text.trim().isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Caption cannot be empty')));
      return;
    }

    setState(() => _isLoading = true);

    try {
      // 🚀 Now user.uid, user.username, etc., will work without errors!
      String res = await PostStorage().uploadPost(
        _captionController.text.trim(),
        user.uid,
        user.username,
        user.photoUrl,
        _image!,
      );

      if (!mounted) return;

      if (res == 'OK') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Post uploaded successfully!')),
        );
        setState(() {
          _image = null;
          _captionController.clear();
        });
        if (widget.onPostSuccess != null) widget.onPostSuccess!();
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $res')));
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Upload failed: $e')));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _captionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).getUser;

    // 2. If user data isn't fetched yet, show a loading spinner
    if (user == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator(color: Colors.red)),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add Image',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 26),
        ),
        actions: [
          TextButton(
            onPressed: _isLoading ? null : postImage,
            child: const Text(
              'Post',
              style: TextStyle(
                color: Colors.red,
                fontSize: 26,
                fontFamily: 'Billabong',
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(8),
            child: Column(
              children: [
                const SizedBox(height: 10),
                TextFieldInput(
                  controller: _captionController,
                  isPassword: false,
                  hintText: 'Write a caption...',
                  keyboardType: TextInputType.text,
                ),
                const SizedBox(height: 20),

                // Image preview
                _image != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.memory(
                          _image!,
                          height: 300,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      )
                    : Image.asset('assets/images/addimage.png', height: 300),

                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.image_outlined, size: 50),
                      onPressed: selectImageFromGallery,
                      color: Colors.red,
                    ),
                    IconButton(
                      icon: const Icon(Icons.photo_camera_outlined, size: 50),
                      onPressed: selectImageFromCamera,
                      color: Colors.red,
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Loading overlay
          if (_isLoading)
            Container(
              color: Colors.black54,
              child: const Center(
                child: CircularProgressIndicator(color: Colors.red),
              ),
            ),
        ],
      ),
    );
  }
}
