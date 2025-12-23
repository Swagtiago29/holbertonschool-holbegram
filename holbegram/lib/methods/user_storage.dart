import 'dart:typed_data';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class StorageMethods {
  final String cloudinaryUrl =
      "https://api.cloudinary.com/v1_1/dl7zikcxa/image/upload";
  final String cloudinaryPreset = "ml_default";

  Future<String> uploadImageToStorage(
    bool isPost,
    String childName,
    Uint8List file,
  ) async {
    String uniqueId = const Uuid().v1();
    var uri = Uri.parse(cloudinaryUrl);
    var request = http.MultipartRequest('POST', uri);

    // Always set upload preset and folder
    request.fields['upload_preset'] = cloudinaryPreset;
    request.fields['folder'] = childName;

    // Only set public_id for posts
    if (isPost) {
      request.fields['public_id'] = uniqueId;
    }

    var multipartFile = http.MultipartFile.fromBytes(
      'file',
      file,
      filename: '$uniqueId.jpg',
    );
    request.files.add(multipartFile);

    print('Uploading image with ${file.length} bytes to folder "$childName"');
    var response = await request.send();
    var responseData = await response.stream.toBytes();
    var responseString = String.fromCharCodes(responseData);

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(responseString);
      return jsonResponse['secure_url'];
    } else {
      print(
        'Cloudinary upload failed: $responseString',
      ); // <-- print full error
      throw Exception('Failed to upload image to Cloudinary: $responseString');
    }
  }
}
