import 'dart:developer';

import 'package:customer_service_provider_hybrid/utils/app_colors.dart';
import 'package:customer_service_provider_hybrid/utils/app_strings.dart';
import 'package:customer_service_provider_hybrid/utils/constants.dart';
import 'package:customer_service_provider_hybrid/widgets/custom_circular_profile.dart';
import 'package:customer_service_provider_hybrid/widgets/custom_padding.dart';
import 'package:customer_service_provider_hybrid/widgets/custom_sizebox.dart';
import 'package:customer_service_provider_hybrid/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../auth/enums/social_type.dart';
import '../../auth/model/user_model.dart';
import '../../auth/providers/user_provider.dart';
import '../../utils/app_fonts.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  User? _user;
  UserProvider? _userProvider;

  @override
  void initState() {
    super.initState();
    _userProvider = context.read<UserProvider>();
    _getUserData();
  }

  void _getUserData() {
    if (_userProvider?.getCurrentUser != null) {
      log("in init");
      _user = _userProvider?.getCurrentUser;
      print("SOCIAL ${_user?.userSocialType}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomPadding(
      child: Consumer<UserProvider>(builder: (context, UserProvider, child) {
        return Column(
          children: [
            CustomSizeBox(),
            _imageWidget(image: UserProvider.getCurrentUser?.profileImage),
            CustomSizeBox(height: 20.h),
            _name(name: UserProvider.getCurrentUser?.fullName),
            CustomSizeBox(height: 25.h),
            if (_user?.userSocialType == SocialAuthType.google.name) ...[
              SizedBox(),
            ] else ...[
              _rowWidget(
                  firstTxt: AppStrings.EMAIL_ADDRESS,
                  secTxt: UserProvider.getCurrentUser?.email),
              CustomSizeBox(),
              _divider(),
            ],
            // if (_authRoleProvider?.role == AuthRole.business.name) ...[
            //   _rowWidget(
            //       firstTxt: AppStrings.EMAIL_ADDRESS,
            //       secTxt: UserProvider.getCurrentUser?.email),
            //   CustomSizeBox(),
            // ] else if (_authRoleProvider?.role ==
            //     AuthRole.user.name) ...[
            //   if (_user?.userSocialType ==
            //       SocialAuthType.google.name) ...[
            //     SizedBox(),
            //   ] else ...[
            //     _rowWidget(
            //         firstTxt: AppStrings.EMAIL_ADDRESS,
            //         secTxt: UserProvider.getCurrentUser?.email),
            //     CustomSizeBox(),
            //   ]
            // ],

            CustomSizeBox(),
            _rowWidget(
                firstTxt: AppStrings.PHONE_NUMBER,
                secTxt:
                    "${UserProvider.getCurrentUser?.phoneCode} ${UserProvider.getCurrentUser?.phoneNumber}" ??
                        ""),
            CustomSizeBox(),
            _divider(),
            CustomSizeBox(),
            _rowWidget(
                firstTxt: AppStrings.ADDRESS,
                secTxt: UserProvider.getCurrentUser?.address),
            CustomSizeBox(),
            _divider(),
            CustomSizeBox(),

            _rowWidget(
                firstTxt: AppStrings.PREFERRED_LANGUAGE,
                secTxt: Constants.joinPreferredLanguageText(
                    preferredLanguageList:
                        UserProvider.getCurrentUser?.languages)),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //   crossAxisAlignment: CrossAxisAlignment.start,
            //   children: [
            //     _boldText(AppStrings.PREFERRED_LANGUAGE),
            //     SizedBox(width: 20.w),
            //     _lightText(Constants.joinPreferredLanguageText(
            //         preferredLanguageList: UserProvider.getCurrentUser?.languages))
            //   ],
            // ),
          ],
        );
      }),
    );
  }

  Widget _imageWidget({String? image}) {
    return CustomCircularImageWidget(
      image: image,
      height: 100.h,
      width: 100.h,
      isFileImage: false,
      isViewAsset: image == null ? true : false,
      borderColor: AppColors.THEME_COLOR_PURPLE,
    );
  }

  Widget _name({String? name}) {
    return CustomText(
      text: name,
      fontColor: AppColors.THEME_COLOR_PURPLE,
      // fontweight: FontWeight.bold,
      fontFamily: AppFonts.Jost_SemiBold,
      fontSize: 17.sp,
    );
  }

  Widget _rowWidget({String? firstTxt, String? secTxt}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _boldText(text: firstTxt),
        SizedBox(width: 30.w),
        _lightText(text: secTxt),
      ],
    );
  }

  Widget _boldText({String? text}) {
    return CustomText(
      text: text,
      fontColor: AppColors.THEME_COLOR_BLACK,
      // fontweight: FontWeight.bold,
      fontFamily: AppFonts.Jost_SemiBold,
    );
  }

  Widget _lightText({String? text}) {
    return Flexible(
      child: CustomText(
        text: text,
        fontColor: AppColors.THEME_COLOR_LIGHT_GREY,
        fontSize: 14.sp,
        textAlign: TextAlign.right,
        fontFamily: AppFonts.Jost_Regular,
      ),
    );
  }

  Widget _divider() {
    return const Divider(
      color: AppColors.THEME_COLOR_LIGHT_GREY,
      thickness: 1,
    );
  }

// Widget _languages(firstTxt, secTxt) {
//   return Row(
//     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//     crossAxisAlignment: CrossAxisAlignment.start,
//     children: [
//       _boldText(firstTxt),
//       SizedBox(width: 20.w),
//       _lightText(secTxt),
//     ],
//   );
// }
}

// import 'dart:developer';
//
// import 'package:customer_service_provider_hybrid/utils/app_colors.dart';
// import 'package:customer_service_provider_hybrid/utils/app_strings.dart';
// import 'package:customer_service_provider_hybrid/utils/constants.dart';
// import 'package:customer_service_provider_hybrid/widgets/custom_circular_profile.dart';
// import 'package:customer_service_provider_hybrid/widgets/custom_padding.dart';
// import 'package:customer_service_provider_hybrid/widgets/custom_sizebox.dart';
// import 'package:customer_service_provider_hybrid/widgets/custom_text.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:provider/provider.dart';
//
// import '../../auth/model/user_model.dart';
// import '../../auth/providers/user_provider.dart';
// import '../../utils/app_fonts.dart';
//
// class ProfileScreen extends StatefulWidget {
//   const ProfileScreen({Key? key}) : super(key: key);
//
//   @override
//   State<ProfileScreen> createState() => _ProfileScreenState();
// }
//
// class _ProfileScreenState extends State<ProfileScreen> {
//   @override
//   void initState() {
//     // _userProvider = context.read<UserProvider>();
//     // if (_userProvider?.getCurrentUser != null) {
//     //   log("in init");
//     //   _user = _userProvider?.getCurrentUser;
//     // }
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return CustomPadding(
//       child: Consumer<UserProvider>(builder: (context, UserProvider, child) {
//         return Column(
//           children: [
//             CustomSizeBox(),
//             _imageWidget(image: UserProvider.getCurrentUser?.profileImage),
//             CustomSizeBox(height: 20.h),
//             _name(name: UserProvider.getCurrentUser?.fullName),
//             CustomSizeBox(height: 25.h),
//             _rowWidget(
//                 AppStrings.EMAIL_ADDRESS, UserProvider.getCurrentUser?.email),
//             CustomSizeBox(),
//             _divider(),
//             CustomSizeBox(),
//             _rowWidget(
//                 AppStrings.PHONE_NUMBER,
//                 "${UserProvider.getCurrentUser?.phoneCode} ${UserProvider.getCurrentUser?.phoneNumber}" ??
//                     ""),
//             CustomSizeBox(),
//             _divider(),
//             CustomSizeBox(),
//             _rowWidget(
//                 AppStrings.ADDRESS, UserProvider.getCurrentUser?.address),
//             CustomSizeBox(),
//             _divider(),
//             CustomSizeBox(),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 _boldText(AppStrings.PREFERRED_LANGUAGE),
//                 SizedBox(width: 20.w),
//                 Expanded(
//                   child: SizedBox(
//                     height: 100.h,
//                     child: ListView.builder(
//                       shrinkWrap: true,
//                       physics: BouncingScrollPhysics(),
//                       scrollDirection: Axis.horizontal,
//                       itemCount: UserProvider.getCurrentUser?.languages?.length,
//                       itemBuilder: ((context, index) {
//                         return CustomText(
//                           text: UserProvider
//                               .getCurrentUser?.languages?[index].languageName,
//                           fontColor: AppColors.THEME_COLOR_LIGHT_GREY,
//                           fontSize: 14.sp,
//                           textAlign: TextAlign.right,
//                           fontFamily: AppFonts.Jost_Regular,
//                         );
//                         // return _lightText(UserProvider.getCurrentUser?.languages?[index].languageName);
//                       }),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         );
//       }),
//     );
//   }
//
//   Widget _imageWidget({String? image}) {
//     return CustomCircularImageWidget(
//       image: image,
//       height: 100.h,
//       width: 100.h,
//       isFileImage: false,
//       isViewAsset: image == null ? true : false,
//       borderColor: AppColors.THEME_COLOR_PURPLE,
//     );
//   }
//
//   Widget _name({String? name}) {
//     return CustomText(
//       text: name,
//       fontColor: AppColors.THEME_COLOR_PURPLE,
//       // fontweight: FontWeight.bold,
//       fontFamily: AppFonts.Jost_SemiBold,
//       fontSize: 17.sp,
//     );
//   }
//
//   Widget _rowWidget(firstTxt, secTxt) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         _boldText(firstTxt),
//         SizedBox(width: 20.w),
//         _lightText(secTxt),
//       ],
//     );
//   }
//
//   Widget _boldText(text) {
//     return CustomText(
//       text: text,
//       fontColor: AppColors.THEME_COLOR_BLACK,
//       // fontweight: FontWeight.bold,
//       fontFamily: AppFonts.Jost_SemiBold,
//     );
//   }
//
//   Widget _lightText(text) {
//     return Expanded(
//       child: CustomText(
//         text: text,
//         fontColor: AppColors.THEME_COLOR_LIGHT_GREY,
//         fontSize: 14.sp,
//         textAlign: TextAlign.right,
//         fontFamily: AppFonts.Jost_Regular,
//       ),
//     );
//   }
//
//   Widget _divider() {
//     return const Divider(
//       color: AppColors.THEME_COLOR_LIGHT_GREY,
//       thickness: 1,
//     );
//   }
//
//   Widget _languages(firstTxt, secTxt) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         _boldText(firstTxt),
//         SizedBox(width: 20.w),
//         _lightText(secTxt),
//       ],
//     );
//   }
// }
