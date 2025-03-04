import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget{
  const UserImagePicker({super.key,required this.onpickimg});

  final void Function(File pickedimg) onpickimg;

  @override
  State<UserImagePicker> createState() {
    return _UserImagePickerState();
  }
}

class _UserImagePickerState extends State<UserImagePicker> {
  
  File? _pickedimgfile;

  void _pickimage() async {
    final pickedimg = await ImagePicker().pickImage(
      source: ImageSource.camera,
      imageQuality: 50,
      maxWidth: 150,
    );

    if (pickedimg==null) {
      return;
    }

    setState(() {
      _pickedimgfile = File(pickedimg.path);
    });

    widget.onpickimg(_pickedimgfile!);

  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundColor: Colors.grey,
          foregroundImage: _pickedimgfile != null ?FileImage(_pickedimgfile!) : null,
        ),
        TextButton.icon(
          onPressed: _pickimage,
          icon: const Icon(Icons.image),
          label: Text('Add Image',
          style: TextStyle(
            color: Theme.of(context).colorScheme.primary
          ),
          )
        )
      ],
    );
  }
}