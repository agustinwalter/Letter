import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:letter/models/user.dart';
import 'package:provider/provider.dart';

class AddImageScreen extends StatefulWidget {
  final String uid;
  const AddImageScreen({Key key, this.uid}) : super(key: key);
  @override
  _AddImageScreenState createState() => _AddImageScreenState();
}

class _AddImageScreenState extends State<AddImageScreen> {
  File userImage;
  bool loading = false;
  double screenWidth;

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: Text('Sube una foto'),
        ),
        child: SafeArea(
          child: Center(
              child: loading
                  ? CircularProgressIndicator()
                  : userImage == null ? pickImage() : sendImage()),
        ));
  }

  getImage(ImageSource source) async {
    setState(() => loading = true);
    File image = await ImagePicker.pickImage(source: source);
    if (image != null) {
      File cropped = await ImageCropper.cropImage(
          sourcePath: image.path,
          aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
          compressQuality: 100,
          maxHeight: 1000,
          maxWidth: 1000,
          compressFormat: ImageCompressFormat.jpg,
          androidUiSettings: AndroidUiSettings(
              toolbarTitle: 'Recorta la foto',
              activeControlsWidgetColor: CupertinoColors.activeBlue,
              dimmedLayerColor: CupertinoColors.white));
      setState(() {
        userImage = cropped;
        loading = false;
      });
    } else
      setState(() => loading = false);
  }

  Widget pickImage() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        RaisedButton.icon(
          elevation: 0,
          color: CupertinoColors.white,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
              side: BorderSide(color: CupertinoColors.activeBlue)),
          icon: Icon(Icons.image, color: CupertinoColors.activeBlue),
          label: Text(
            'Subir foto desde la galería',
            style: TextStyle(
                fontSize: 16,
                fontFamily: 'Lato',
                color: CupertinoColors.activeBlue),
          ),
          onPressed: () {
            getImage(ImageSource.gallery);
          },
        ),
        Text(
          'o',
          style: TextStyle(
            fontSize: 16,
            fontFamily: 'Lato',
          ),
        ),
        RaisedButton.icon(
          elevation: 0,
          color: CupertinoColors.white,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
              side: BorderSide(color: CupertinoColors.activeBlue)),
          icon: Icon(Icons.camera_alt, color: CupertinoColors.activeBlue),
          label: Text(
            'Subir foto desde la cámara',
            style: TextStyle(
                fontSize: 16,
                fontFamily: 'Lato',
                color: CupertinoColors.activeBlue),
          ),
          onPressed: () {
            getImage(ImageSource.camera);
          },
        ),
      ],
    );
  }

  Widget sendImage() {
    StorageUploadTask uploadTask = FirebaseStorage()
        .ref()
        .child('profilePics/${widget.uid}.jpg')
        .putFile(userImage);

    uploadTask.onComplete.then((value) async {
      String url = await value.ref.getDownloadURL();
      setState(() => userImage = null);
      Navigator.pop(context, url);
    });

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircleAvatar(
            backgroundImage: FileImage(userImage), radius: screenWidth * .35),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Text(
            'Tu foto se está subiendo',
            style: TextStyle(
              fontSize: 14,
              fontFamily: 'Lato',
            ),
          ),
        ),
        Container(
            width: screenWidth * .6,
            child: StreamBuilder<StorageTaskEvent>(
              stream: uploadTask.events,
              builder: (context, stream) {
                var e = stream?.data?.snapshot;
                double progress =
                    e != null ? e.bytesTransferred / e.totalByteCount : 0;
                return LinearProgressIndicator(value: progress);
              },
            )),
      ],
    );
  }
}
