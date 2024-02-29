import 'dart:developer';

import 'package:customer_service_provider_hybrid/auth/bloc/social_login_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../../utils/app_dialogs.dart';
import '../../utils/app_route_name.dart';
import '../../utils/app_strings.dart';
import '../enums/social_type.dart';
import 'package:customer_service_provider_hybrid/utils/extension.dart';

class FirebaseAuthBloc {
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  UserCredential? _userCredential;
  User? _user;
  SocialLoginBloc _socialLoginBloc = SocialLoginBloc();

  ///-------------------- Google Sign In -------------------- ///
  Future<void> signInWithGoogle(
      {BuildContext? mainContext, String? authName, String? role}) async {
    try {
      GoogleSignIn _googleSignIn = GoogleSignIn(
        scopes: ['email'],
      );

      GoogleSignInAccount? _googleSignInAccount = await _googleSignIn.signIn();

      if (_googleSignInAccount != null) {
        // log("Access Token"+data.accessToken);
        await _googleSignIn.signOut();
        log("Google Sign in Account" + _googleSignInAccount.toString());
        _socialLoginMethod(
          context: mainContext!,
          authName: authName,
          socialToken: _googleSignInAccount.id,
          socialType: SocialAuthType.google.name,
          userFirstName: _googleSignInAccount.displayName?.splitName()[0],
          userLastName: _googleSignInAccount.displayName?.splitName()[1],
          userEmail: _googleSignInAccount.email ?? "",
          userImage: _googleSignInAccount.photoUrl ?? "",
        );
      }
    } catch (error) {
      log(error.toString());
      AppDialogs.showToast(message: error.toString());
    }
  }

  ///------------------ Apple Sign In -----------------///
  Future<void> signInWithApple({required BuildContext context})async{
    String? _givenName,_familyName,_userFullName;
    try{
      final credential=await SignInWithApple.getAppleIDCredential(
          scopes: [
            AppleIDAuthorizationScopes.email,
            AppleIDAuthorizationScopes.fullName,
          ]);
      try {

        if(credential!=null){
          // _givenName = credential.givenName ?? "";
          // _familyName = credential.familyName ?? "";
          // _userFullName = _givenName + " " + _familyName;

          _socialLoginMethod(
            context: context,
            socialToken: credential.userIdentifier,
            socialType: SocialAuthType.apple.name,
            userFirstName: credential.givenName,
            userLastName: credential.familyName,
            userEmail: credential.email,
          );
        }
        print("Apple sign in data is"+credential.givenName.toString()+'------------'+_userFullName.toString());
      } catch (e, s) {
        print(s);
      }
    }
    catch(error){
      print("Error in Apple Sigin in is"+error.toString());
    }
  }


  void _socialLoginMethod(
      {required BuildContext context,
      String? authName,
      String? socialToken,
      String? userFirstName,
      String? userLastName,
      String? userEmail,
      String? socialType,
      String? userImage}) {
    log("data");
    log("authName:${authName}");
    log("socialToken:${socialToken}");
    log("userFirstName:${userFirstName}");
    log("userLastName:${userLastName}");
    log("userEmail:${userEmail}");
    log("userImage:${userImage}");

    _socialLoginBloc.socialLoginBlocMethod(
      context: context,
      socialType: socialType,
      userSocialToken: socialToken ?? "123",
      userFirstName: userFirstName,
      userLastName: userLastName,
      userEmail: userEmail,

      // userImage: userImage,
      setProgressBar: () {
        AppDialogs.progressAlertDialog(context: context);
      },
    );
  }

  ///-------------------- Sign Out --------------------
  Future<void> _firebaseUserSignOut() async {
    await _firebaseAuth.signOut();
  }

  Future<void> resendPhoneCode(
      {required BuildContext context,
      required String countryCode,
      required String phoneNumber,
      required ValueChanged<String?> getVerificationId,
      required VoidCallback setProgressBar,
      required VoidCallback cancelProgressBar}) async {
    setProgressBar();
    try {
      _firebaseAuth.verifyPhoneNumber(
          phoneNumber: countryCode + phoneNumber,
          timeout: Duration(seconds: 60),
          verificationCompleted: (AuthCredential authCredential) async {},
          verificationFailed: (FirebaseAuthException authException) {
            print("verificationFailed");
            cancelProgressBar();
            AppDialogs.showToast(message: authException.message!);
            //print(authException.message);
          },
          codeSent: (String verificationId, int? forceResendingToken) {
            cancelProgressBar();
            getVerificationId(verificationId);
          },
          codeAutoRetrievalTimeout: (String verificationId) {
            print("Code auto retreival time out ");
            log(verificationId.toString());
          });
    } catch (error) {
      cancelProgressBar();
      AppDialogs.showToast(message: error.toString());
    }
  }
}
