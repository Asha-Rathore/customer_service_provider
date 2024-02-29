import 'package:customer_service_provider_hybrid/utils/asset_paths.dart';
import 'package:flutter/material.dart';

class CustomDivider extends StatelessWidget {
  const CustomDivider({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.asset(AssetPath.GREY_DIVIDER_ICON);
  }
}