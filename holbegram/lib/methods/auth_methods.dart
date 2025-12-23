import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:typed_data';
import '../models/user.dart';
import 'package:holbergram/methods/user_storage.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> login({
    required String email,
    required String password,
  }) async {
    if (email.isEmpty || password.isEmpty) {
      return 'Please fill all the fields';
    }
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return 'success';
    } catch (e) {
      return e.toString();
    }
  }

  Future<String> signUpUser({
    required String email,
    required String password,
    required String username,
    Uint8List? file,
    String photoUrl = '',
  }) async {
    if (email.isEmpty || username.isEmpty || password.isEmpty) {
      return 'Please fill all the fields';
    }

    try {
      // 1. Create auth user
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      // 2. Get Firebase user
      User user = userCredential.user!;

      if (file != null) {
        photoUrl = await StorageMethods().uploadImageToStorage(
          false,
          'profPictures',
          file,
        );
      }

      // 3. Create Users model
      Users users = Users(
        uid: user.uid,
        email: email,
        username: username,
        bio: '',
        photoUrl: photoUrl,
        followers: [],
        following: [],
        posts: [],
        saved: [],
        searchKey: username[0].toLowerCase(),
      );

      // 4. Save to Firestore
      await _firestore.collection("users").doc(user.uid).set(users.toJson());

      // 5. Return success
      return 'success';
    } catch (e) {
      return e.toString();
    }
  }

  Future<Users> getUserDetails() async {
    // 1. Get current authenticated user
    User currentUser = _auth.currentUser!;

    //2. Get user document from Firestore
    DocumentSnapshot snap = await _firestore
        .collection('users')
        .doc(currentUser.uid)
        .get();

    // 3. Convert snapshot to Users model and return
    return Users.fromSnap(snap);
  }
}
