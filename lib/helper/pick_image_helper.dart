import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class PickImageHelper {

  Future<ImageSource?> showPicker(context) async {
    if (Platform.isIOS)
      return showCupertinoModalPopup<ImageSource>(
          context: context,
          builder: (BuildContext ctx) => CupertinoActionSheet(
                actions: [
                  CupertinoActionSheetAction(
                    onPressed: () =>
                        Navigator.of(context).pop(ImageSource.gallery),
                    child: Text('Photo Library'),
                  ),
                  CupertinoActionSheetAction(
                    onPressed: () =>
                        Navigator.of(context).pop(ImageSource.camera),
                    child: Text('Camera'),
                  )
                ],
              ));
    else
      return showModalBottomSheet(
        context: context,
        builder: (BuildContext ctx) => SafeArea(
          child: Container(
            child: Wrap(
              children: <Widget>[
                ListTile(
                    leading: Icon(Icons.photo_library),
                    title: Text('Photo Library'),
                    onTap: () =>
                        Navigator.of(context).pop(ImageSource.gallery)),
                ListTile(
                    leading: Icon(Icons.photo_camera),
                    title: Text('Camera'),
                    onTap: () => Navigator.of(context).pop(ImageSource.camera)),
              ],
            ),
          ),
        ),
      );
  }

  Future<File> pickImageFromSource(ImageSource imageSource) async {
    final image = await ImagePicker().pickImage(source: imageSource, imageQuality: 50);
    if (image == null) return File('');

    return File(image.path);
  }

  Future<File> pickVideoFromSource(ImageSource imageSource) async {
    final video = await ImagePicker().pickVideo(source: imageSource, maxDuration: Duration(seconds: 15));
    if (video == null) return File('');

    return File(video.path);
  }

  Future<List<File>> pickMultiImages() async {
    List<File> pickedImages = [];
    final images = await ImagePicker().pickMultiImage(imageQuality: 50);

    if(images != null) {
      pickedImages.addAll(images.map((image) => File(image.path)).toList());
    }

    return pickedImages;
  }

  // Future<File> imgFromCamera() async {
  //   final image = await ImagePicker()
  //       .pickImage(source: ImageSource.camera, imageQuality: 50);
  //
  //   if (image == null) return File('');
  //
  //   return File(image.path);
  // }
  //
  // Future<File> imgFromGallery() async {
  //   final image = await ImagePicker()
  //       .pickImage(source: ImageSource.gallery, imageQuality: 50);
  //
  //   if (image == null) return File('');
  //
  //   return File(image.path);
  // }
}
