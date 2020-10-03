
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget {
  UserImagePicker(this.imagePickfn);
  final void Function(File pickedImage) imagePickfn;
  @override
  _UserImagePickerState createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  File _pickedImage;
  File imageFile;
  void _takePicture() async {
    final picker = ImagePicker();
    final imageFile = await picker.getImage(
      source: ImageSource.camera,
      // maxWidth: 600,
    );
    setState(() {
      // _pickedImage = imageFile; // it is not working
      _pickedImage = File(imageFile.path); // new logic works
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      
      children: [
        CircleAvatar(
          radius: 40,
          backgroundImage:
              _pickedImage != null ? FileImage(_pickedImage) : null,
        ),
        FlatButton.icon(
          onPressed: _takePicture,
          textColor: Theme.of(context).primaryColor,
          icon: Icon(
            Icons.image,
          ),
          label: Text('Add Image'),
        ),
      ],
    );
  }
}
