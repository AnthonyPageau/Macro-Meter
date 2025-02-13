import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserAvatar extends StatefulWidget {
  const UserAvatar({
    super.key,
    required this.onPickAvatar,
  });

  final void Function(File avatar) onPickAvatar;

  @override
  State<StatefulWidget> createState() {
    return _UserAvatarState();
  }
}

class _UserAvatarState extends State<UserAvatar> {
  File? _avatarFile;

  void _addAvatar() async {
    final avatar = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
      maxWidth: 150,
    );

    if (avatar == null) {
      return;
    }

    setState(() {
      _avatarFile = File(avatar.path);
    });

    widget.onPickAvatar(_avatarFile!);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundColor: Colors.grey,
          foregroundImage: _avatarFile != null ? FileImage(_avatarFile!) : null,
        ),
        TextButton.icon(
          onPressed: _addAvatar,
          icon: const Icon(Icons.image),
          label: Text("Ajouter Avatar",
              style: TextStyle(
                color: Theme.of(context).primaryColor,
              )),
        )
      ],
    );
  }
}
