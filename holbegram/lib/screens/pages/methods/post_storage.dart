import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:typed_data';
import 'package:holbergram/methods/user_storage.dart';
import 'package:uuid/uuid.dart';

class PostStorage {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final StorageMethods storage = StorageMethods();

  Future<String> uploadPost(
    String caption,
    String uid,
    String username,
    String profImage,
    Uint8List image,
  ) async {
    String res = "Some error occurred";

    try {
      // 1️⃣ Upload image to Cloudinary
      String postUrl = await storage.uploadImageToStorage(true, 'posts', image);

      // 2️⃣ Generate post ID
      String postId = const Uuid().v1();

      // 3️⃣ Save post data to Firestore
      await _firestore.collection('posts').doc(postId).set({
        'caption': caption,
        'uid': uid,
        'username': username,
        'profImage': profImage,
        'postId': postId,
        'postUrl': postUrl,
        'likes': [],
        'datePublished': Timestamp.now(),
      });

      // 4️⃣ Save postId inside user document
      await FirebaseFirestore.instance.collection('users').doc(uid).update({
        'posts': FieldValue.arrayUnion([postId]),
      });

      res = 'OK';
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  Future<String> deletePost(String postId, String publicId) async {
    String res = "Some error Occurred";
    try {
      await _firestore.collection('posts').doc(postId).delete();
      res = 'OK';
    } catch (e) {
      res = e.toString();
    }
    return res;
  }
}
