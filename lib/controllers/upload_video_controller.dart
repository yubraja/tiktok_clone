import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:tiktok/constants.dart';
import 'package:video_compress/video_compress.dart';

class UploadVideoController extends GetxController {
  _compressVideo(String videoPath) async  {
    final compressedVideo= await VideoCompress.compressVideo(
      videoPath,
      quality: VideoQuality.MediumQuality,
    );
    return compressedVideo!.file;
  }

  Future<String> _uploadVideoToStorage(String id, String videoPath) async{
    Reference ref = firebaseStorage.ref().child('videos').child(id);
    UploadTask uploadTask=ref.putFile(_compressVideo(videoPath));
    TaskSnapshot snap =await uploadTask;
    String downloadUrl= await snap.ref.getDownloadURL();
    return downloadUrl;
  }

  uploadVideo(String name, String caption, String videoPath) async {
    try {
      String uid = firebaseAuth.currentUser!.uid;
      DocumentSnapshot userDoc =
          await fireStore.collection('users').doc(uid).get();

      var allDocs = await fireStore.collection('videos').get();
      int len = allDocs.docs.length;
      String videoUrl=await _uploadVideoToStorage('video $len', videoPath);
    } catch (e) {}
  }
}
