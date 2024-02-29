import 'dart:io';

import 'package:customer_service_provider_hybrid/content/bloc/content_bloc.dart';
import 'package:customer_service_provider_hybrid/widgets/custom_app_template.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../utils/app_colors.dart';
import '../../utils/app_dialogs.dart';
import '../../utils/app_strings.dart';
import '../../utils/asset_paths.dart';
import '../../widgets/custom_error_widget.dart';

class ContentScreen extends StatefulWidget {
  String title;
  String contentType;
  ContentScreen({
    Key? key,
    required this.title,
    required this.contentType
  }) : super(key: key);

  @override
  State<ContentScreen> createState() => _ContentScreenState();
}

class _ContentScreenState extends State<ContentScreen> {

  double _opacity = 0.0;
  ContentBloc _contentBloc = ContentBloc();
  Future? _getContentData;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getContentMethod();
    if (Platform.isAndroid) WebView.platform = AndroidWebView();
  }
  
  @override
  Widget build(BuildContext context) {
    return CustomAppTemplate(
      title: widget.title,
      child: _termsPrivacyWidget(),
    );
  }

  Widget _termsPrivacyWidget() {
    return FutureBuilder<dynamic>(
        future: _getContentData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: AppDialogs.circularProgressWidget());
          } else {
            return snapshot.data?["data"] != null
                ?
            // WebView(
            //   initialUrl: snapshot.data["data"]["content"],
            // )
            Opacity(
              opacity: _opacity,
              child: WebView(
                initialUrl: snapshot.data["data"]["content"],
                onPageStarted: (String? pageUrl){
                  _opacity == 0.0 ?
                  setState(() {
                    _opacity = 1.0;
                  }):null;
                },
                onPageFinished: (String? pageUrl){
                  _opacity == 0.0 ?
                  setState(() {
                    _opacity = 1.0;
                  }):null;
                },
              ),
            )
                : Center(
              child: CustomErrorWidget(
                errorImagePath: AssetPath.DATA_NOT_FOUND_ICON,
                errorText: AppStrings.DATA_NOT_FOUND_ERROR,
                imageSize: 70.h,
                //imageColor: AppColors.THEME_COLOR_WHITE,
              ),
            );
          }
        });
  }

  void _getContentMethod() {
    print("Content Type:${widget.contentType}");
    _getContentData = _contentBloc.content(
        context: context, contentType: widget.contentType);
  }
}
