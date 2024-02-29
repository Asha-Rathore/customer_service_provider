import '../enums/otp_verification_type.dart';

class OtpVerficationArguments {
  final OTPVerificationType? otpVerificationType;
  final int? userId;
  bool? isProfile;
  String? fullName;
  String? emailAddress;

  OtpVerficationArguments(
      {this.otpVerificationType,
      this.userId,
      this.emailAddress,
      this.fullName,
      this.isProfile});
}
