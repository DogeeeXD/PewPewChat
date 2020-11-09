import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget {
  final Function(File pickedImage) imagePickFn;

  UserImagePicker(this.imagePickFn);

  @override
  _UserImagePickerState createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  final picker = ImagePicker();
  File _pickedImage;

  void _pickImage() async {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: Text('Pick image using'),
        children: [
          ListTile(
            title: Text('Camera'),
            onTap: () async {
              Navigator.pop(context);
              final pickedImageFile = await picker.getImage(
                source: ImageSource.camera,
                imageQuality: 70,
                maxWidth: 150,
              );
              setState(() {
                if (pickedImageFile != null) {
                  _pickedImage = File(pickedImageFile.path);
                } else {
                  print('No image selected');
                }
              });
              widget.imagePickFn(_pickedImage);
            },
          ),
          ListTile(
            title: Text('Gallery'),
            onTap: () async {
              Navigator.pop(context);
              final pickedImageFile = await picker.getImage(
                source: ImageSource.gallery,
                imageQuality: 70,
                maxWidth: 150,
              );
              setState(() {
                if (pickedImageFile != null) {
                  _pickedImage = File(pickedImageFile.path);
                } else {
                  print('No image selected');
                }
              });
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: CircleAvatar(
        radius: 50,
        backgroundImage: _pickedImage != null ? FileImage(_pickedImage) : null,
        child: _pickedImage != null ? null : Text('Pick Image'),
      ),
      onTap: _pickImage,
    );
  }
}
