import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserAvatar extends StatefulWidget {
  const UserAvatar(
      {super.key,
      required this.onPickAvatar,
      required this.action,
      this.avatarUrl});

  final void Function(File avatar) onPickAvatar;
  final String action;
  final String? avatarUrl;

  @override
  State<StatefulWidget> createState() => _UserAvatarState();
}

class _UserAvatarState extends State<UserAvatar> {
  File? _avatarFile;

  void _addAvatar() async {
    dynamic avatar;

    if (Platform.isAndroid || Platform.isIOS) {
      avatar = await ImagePicker().pickImage(
        source: ImageSource.camera,
        imageQuality: 50,
        maxWidth: 150,
      );
    } else {
      avatar = await ImagePicker().pickImage(source: ImageSource.gallery);
    }

    if (avatar == null) {
      return;
    }

    setState(() {
      _avatarFile = File(avatar.path);
    });

    widget.onPickAvatar(_avatarFile!);
  }

  ImageProvider? _setAvatar() {
    if (_avatarFile != null) {
      return FileImage(_avatarFile!);
    }
    return widget.avatarUrl != null ? NetworkImage(widget.avatarUrl!) : null;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundColor: Colors.grey,
          foregroundImage: _setAvatar(),
        ),
        TextButton.icon(
          onPressed: _addAvatar,
          icon: const Icon(Icons.image),
          label: Text("${widget.action} Avatar",
              style: TextStyle(
                color: Theme.of(context).primaryColor,
              )),
        )
      ],
    );
  }
}
