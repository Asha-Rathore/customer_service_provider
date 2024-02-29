import 'dart:io';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:shimmer/shimmer.dart';

import '../utils/app_colors.dart';
import '../utils/asset_paths.dart';
import '../utils/network_strings.dart';

class CustomExtendedImageWidget extends StatelessWidget {
  final String? imagePath;
  final bool? isFile, isViewFallBackAsset, showFailedAssetImage;
  final VoidCallback? onTap;
  final String? placeHolderImagePath;
  final BoxFit? fit;
  final bool isClipped;

  const CustomExtendedImageWidget({
    Key? key,
    this.imagePath,
    this.isFile = false,
    this.onTap,
    this.fit,
    this.isClipped = false,
    this.placeHolderImagePath = AssetPath.USER_PLACEHOLDER_IMAGE,
    this.showFailedAssetImage = true,
    this.isViewFallBackAsset,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return isClipped == true ? _clipImageWidget() : _imageWidget();
  }

  Widget _clipImageWidget() {
    return ClipOval(
      // borderRadius: BorderRadius.circular(50),
      child: _imageWidget(),
    );
  }

  Widget _imageWidget() {
    return (imagePath != null && (imagePath?.isEmpty == false))
        ? isFile == true
            ? GestureDetector(
                onTap: onTap,
                child: ExtendedImage.file(
                  File(imagePath ?? ''),
                  fit: fit ?? BoxFit.cover,
                  loadStateChanged: (state) {
                    switch (state.extendedImageLoadState) {
                      // case LoadState.loading:
                      //   return Image.asset(
                      //     placeHolderImagePath,
                      //     fit: fit ?? BoxFit.cover,
                      //     color: Colors.black,
                      //   );
                      case LoadState.failed:
                        Logger().i("Failed Inside File");
                        return Image.asset(
                          placeHolderImagePath ?? AssetPath.USER_PLACEHOLDER_IMAGE,
                          fit: fit ?? BoxFit.cover,
                          color: Colors.black,
                        );
                      case LoadState.completed:
                        break;
                    }
                    return null;
                  },
                  //cancelToken: cancellationToken,
                ),
              )
            : GestureDetector(
                onTap: onTap,
                child: ExtendedImage.network(
                  NetworkStrings.IMAGE_BASE_URL + (imagePath ?? ""),

                  fit: fit ?? BoxFit.cover,
                  loadStateChanged: (state) {
                    print((NetworkStrings.IMAGE_BASE_URL + (imagePath ?? "")));
                    switch (state.extendedImageLoadState) {
                      case LoadState.loading:
                        return Shimmer.fromColors(
                          baseColor: AppColors.SHIMMER_BASE_COLOR,
                          highlightColor: AppColors.SHIMMER_HIGHLIGHT_COLOR,
                          child: Container(
                            color: Colors.grey,
                          ),
                        );
                      case LoadState.failed:
                        Logger().i("Failed Inside network");
                        print(imagePath);
                        return Image.asset(
                          placeHolderImagePath ?? AssetPath.USER_PLACEHOLDER_IMAGE,
                          fit: fit ?? BoxFit.cover,
                          //color: Colors.black,
                        );
                      //   break;
                      case LoadState.completed:
                        // TODO: Handle this case.
                        break;
                    }
                    return null;
                  },
                  //cancelToken: cancellationToken,
                ),
              )
        : isViewFallBackAsset == true
            ? ExtendedImage.asset(
                placeHolderImagePath ?? AssetPath.USER_PLACEHOLDER_IMAGE,
                fit: BoxFit.cover,
                width: 10,
              )
            : Container();
  }
}
