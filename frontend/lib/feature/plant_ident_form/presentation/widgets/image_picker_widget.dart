import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/theme/theme.dart';

class ImagePickerWidget extends StatefulWidget {
  const ImagePickerWidget({super.key, required this.func});

  final Function func;

  @override
  State<ImagePickerWidget> createState() => _ImagePickerWidgetState();
}

class _ImagePickerWidgetState extends State<ImagePickerWidget> {
  File? image;

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.sizeOf(context).height;
    final double width = MediaQuery.sizeOf(context).width;

    return SizedBox(
      height: height * 0.1,
      width: width,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20), // Image border
        child: GestureDetector(
          onTap: () {
            _pickImageFromGallery();
          },
          child: image != null
              ? Image.file(
                  image!,
                  fit: BoxFit.cover,
                )
              : Container(
                  color: Colors.transparent,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.file_upload_outlined,
                        color: colors.grayGreen,
                        size: 40,
                      ),
                      Text(
                        "Загрузите фотографию",
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge
                            ?.merge(TextStyle(color: colors.grayGreen)),
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }

  void _pickImageFromGallery() async {
    try {
      final pickedImage =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedImage != null) {
        setState(() {
          image = File(pickedImage.path);
        });
        widget.func(image);
      } else {
        debugPrint("User didn't pick any image.");
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
