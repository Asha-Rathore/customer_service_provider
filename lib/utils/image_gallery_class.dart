import 'dart:io';
import 'package:customer_service_provider_hybrid/utils/app_colors.dart';
import 'package:customer_service_provider_hybrid/widgets/custom_divider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import 'app_navigation.dart';
import 'app_strings.dart';

class ImageGalleryClass {
  ImagePicker picker = ImagePicker();
  XFile? getFilePath;
  CroppedFile? croppedImageFile;
  File? imageFile;
  Map<String, dynamic>? imageGalleryBottomSheet(
      {required BuildContext context,
      required ValueChanged<String?> onMediaChanged}) {
    showModalBottomSheet(
        context: context,
        builder: (_) {
          return Container(
            color: AppColors.THEME_COLOR_WHITE,
            child: SafeArea(
              child: Wrap(
                children: <Widget>[
                  GestureDetector(
                      onTap: () {
                        getCameraImage(
                            onMediaChanged: onMediaChanged, context: context);
                      },
                      child: _cameraIconRow()),
                  const CustomDivider(),
                  GestureDetector(
                      onTap: () {
                        getGalleryImage(
                            onMediaChanged: onMediaChanged, context: context);
                      },
                      child: _galleryIconRow()),
                ],
              ),
            ),
          );
        });
    return null;
  }

  Widget _cameraIconRow() {
    return Container(
      color: Colors.transparent,
      padding: const EdgeInsets.only(top: 16.0, bottom: 16.0),
      child: Row(
        children: const [
          SizedBox(
            width: 15.0,
          ),
          Icon(
            Icons.camera_enhance,
            color: AppColors.THEME_COLOR_PURPLE,
          ),
          SizedBox(
            width: 15.0,
          ),
          Text(
            "Camera",
            style: TextStyle(
              color: AppColors.THEME_COLOR_PURPLE,
            ),
            textScaleFactor: 1.3,
          ),
        ],
      ),
    );
  }

  Widget _galleryIconRow() {
    return Container(
      color: Colors.transparent,
      padding: const EdgeInsets.only(top: 16.0, bottom: 16.0),
      child: Row(
        children: const [
          SizedBox(
            width: 15.0,
          ),
          Icon(
            Icons.image,
            color: AppColors.THEME_COLOR_PURPLE,
          ),
          SizedBox(
            width: 15.0,
          ),
          Text(
            "Gallery",
            style: TextStyle(
              color: AppColors.THEME_COLOR_PURPLE,
            ),
            textScaleFactor: 1.3,
          ),
        ],
      ),
    );
  }

  void getCameraImage(
      {required ValueChanged<String?> onMediaChanged,
      BuildContext? context}) async {
    try {
      getFilePath =
          await picker.pickImage(source: ImageSource.camera, imageQuality: 70);
      if (getFilePath != null) {
        cropImage(
            imageFilePath: getFilePath!.path,
            onMediaChanged: onMediaChanged,
            context: context);
      } else {
        AppNavigation.navigatorPop(context!);
      }
    } on PlatformException catch (e) {}
  }

  void getGalleryImage(
      {required ValueChanged<String?> onMediaChanged,
      BuildContext? context}) async {
    try {
      getFilePath =
          await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
      if (getFilePath != null) {
        cropImage(
            imageFilePath: getFilePath!.path,
            onMediaChanged: onMediaChanged,
            context: context);
      } else {
        AppNavigation.navigatorPop(context!);
      }
    } on PlatformException catch (e) {}
  }

  void cropImage(
      {String? imageFilePath,
      BuildContext? context,
      required ValueChanged<String?> onMediaChanged}) async {
    croppedImageFile = await ImageCropper().cropImage(
      sourcePath: imageFilePath!,
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
        CropAspectRatioPreset.ratio3x2,
        CropAspectRatioPreset.original,
        CropAspectRatioPreset.ratio4x3,
        CropAspectRatioPreset.ratio16x9
      ],
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: AppStrings.APP_TITLE_TEXT,
          toolbarColor: AppColors.THEME_COLOR_BLACK,
          toolbarWidgetColor: AppColors.THEME_COLOR_WHITE,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false,
        ),
      ],
    );
    if (croppedImageFile != null) {
      onMediaChanged(File(croppedImageFile!.path).path);
    } else {
      onMediaChanged(null);
    }
    AppNavigation.navigatorPop(context!);
  }
}
