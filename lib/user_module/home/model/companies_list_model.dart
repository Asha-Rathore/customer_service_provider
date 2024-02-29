
class CompaniesListData {
/*
{
  "id": 12,
  "otp": null,
  "role": "business",
  "full_name": "Demo User",
  "email": "business@gmail.com",
  "phone_number": "2222434556",
  "phone_code": null,
  "country_code": null,
  "address": null,
  "website": null,
  "profile_image": "profile_image/9BsyJ4EhvGUzeWSu5oVdUurUyWOTAZetFwhfYZq3.png",
  "company_name": null,
  "company_description": "company_descriptioncompany_descriptioncompany_descriptioncompany_descriptioncompany_descriptioncompany_descriptioncompany_descriptioncompany_descriptioncompany_description",
  "card_id": null,
  "is_card": 0,
  "customer_id": null,
  "account_verified": 1,
  "email_verified_at": "2023-10-17T11:10:08.000000Z",
  "device_type": "android",
  "device_token": "123",
  "is_social": 0,
  "is_forgot": 0,
  "user_social_token": null,
  "user_social_type": null,
  "is_profile_complete": 1,
  "is_blocked": 0,
  "subscription_id": null,
  "api_token": "57|D3IFk2LNeDuxfZoXRutCGjzIBlL8lNPFNrlsuUWe39c0a02d",
  "notifications": 1,
  "deleted_at": null,
  "created_at": "2023-10-17T11:09:47.000000Z",
  "updated_at": "2023-10-30T06:24:38.000000Z",
  "is_favorite_count": 1
}
*/

  int? id;
  String? otp;
  String? role;
  String? fullName;
  String? email;
  String? phoneNumber;
  String? phoneCode;
  String? countryCode;
  String? address;
  String? website;
  String? profileImage;
  String? companyName;
  String? companyDescription;
  String? cardId;
  int? isCard;
  String? customerId;
  int? accountVerified;
  String? emailVerifiedAt;
  String? deviceType;
  String? deviceToken;
  int? isSocial;
  int? isForgot;
  String? userSocialToken;
  String? userSocialType;
  int? isProfileComplete;
  int? isBlocked;
  String? subscriptionId;
  String? apiToken;
  int? notifications;
  String? deletedAt;
  String? createdAt;
  String? updatedAt;
  int? isFavoriteCount;

  CompaniesListData({
    this.id,
    this.otp,
    this.role,
    this.fullName,
    this.email,
    this.phoneNumber,
    this.phoneCode,
    this.countryCode,
    this.address,
    this.website,
    this.profileImage,
    this.companyName,
    this.companyDescription,
    this.cardId,
    this.isCard,
    this.customerId,
    this.accountVerified,
    this.emailVerifiedAt,
    this.deviceType,
    this.deviceToken,
    this.isSocial,
    this.isForgot,
    this.userSocialToken,
    this.userSocialType,
    this.isProfileComplete,
    this.isBlocked,
    this.subscriptionId,
    this.apiToken,
    this.notifications,
    this.deletedAt,
    this.createdAt,
    this.updatedAt,
    this.isFavoriteCount,
  });
  CompaniesListData.fromJson(Map<String, dynamic> json) {
    id = json['id']?.toInt();
    otp = json['otp']?.toString();
    role = json['role']?.toString();
    fullName = json['full_name']?.toString();
    email = json['email']?.toString();
    phoneNumber = json['phone_number']?.toString();
    phoneCode = json['phone_code']?.toString();
    countryCode = json['country_code']?.toString();
    address = json['address']?.toString();
    website = json['website']?.toString();
    profileImage = json['profile_image']?.toString();
    companyName = json['company_name']?.toString();
    companyDescription = json['company_description']?.toString();
    cardId = json['card_id']?.toString();
    isCard = json['is_card']?.toInt();
    customerId = json['customer_id']?.toString();
    accountVerified = json['account_verified']?.toInt();
    emailVerifiedAt = json['email_verified_at']?.toString();
    deviceType = json['device_type']?.toString();
    deviceToken = json['device_token']?.toString();
    isSocial = json['is_social']?.toInt();
    isForgot = json['is_forgot']?.toInt();
    userSocialToken = json['user_social_token']?.toString();
    userSocialType = json['user_social_type']?.toString();
    isProfileComplete = json['is_profile_complete']?.toInt();
    isBlocked = json['is_blocked']?.toInt();
    subscriptionId = json['subscription_id']?.toString();
    apiToken = json['api_token']?.toString();
    notifications = json['notifications']?.toInt();
    deletedAt = json['deleted_at']?.toString();
    createdAt = json['created_at']?.toString();
    updatedAt = json['updated_at']?.toString();
    isFavoriteCount = json['is_favorite_count']?.toInt();
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['otp'] = otp;
    data['role'] = role;
    data['full_name'] = fullName;
    data['email'] = email;
    data['phone_number'] = phoneNumber;
    data['phone_code'] = phoneCode;
    data['country_code'] = countryCode;
    data['address'] = address;
    data['website'] = website;
    data['profile_image'] = profileImage;
    data['company_name'] = companyName;
    data['company_description'] = companyDescription;
    data['card_id'] = cardId;
    data['is_card'] = isCard;
    data['customer_id'] = customerId;
    data['account_verified'] = accountVerified;
    data['email_verified_at'] = emailVerifiedAt;
    data['device_type'] = deviceType;
    data['device_token'] = deviceToken;
    data['is_social'] = isSocial;
    data['is_forgot'] = isForgot;
    data['user_social_token'] = userSocialToken;
    data['user_social_type'] = userSocialType;
    data['is_profile_complete'] = isProfileComplete;
    data['is_blocked'] = isBlocked;
    data['subscription_id'] = subscriptionId;
    data['api_token'] = apiToken;
    data['notifications'] = notifications;
    data['deleted_at'] = deletedAt;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['is_favorite_count'] = isFavoriteCount;
    return data;
  }
}

class CompaniesList {
/*
{
  "status": 1,
  "message": "Companies",
  "data": [
    {
      "id": 12,
      "otp": null,
      "role": "business",
      "full_name": "Demo User",
      "email": "business@gmail.com",
      "phone_number": "2222434556",
      "phone_code": null,
      "country_code": null,
      "address": null,
      "website": null,
      "profile_image": "profile_image/9BsyJ4EhvGUzeWSu5oVdUurUyWOTAZetFwhfYZq3.png",
      "company_name": null,
      "company_description": "company_descriptioncompany_descriptioncompany_descriptioncompany_descriptioncompany_descriptioncompany_descriptioncompany_descriptioncompany_descriptioncompany_description",
      "card_id": null,
      "is_card": 0,
      "customer_id": null,
      "account_verified": 1,
      "email_verified_at": "2023-10-17T11:10:08.000000Z",
      "device_type": "android",
      "device_token": "123",
      "is_social": 0,
      "is_forgot": 0,
      "user_social_token": null,
      "user_social_type": null,
      "is_profile_complete": 1,
      "is_blocked": 0,
      "subscription_id": null,
      "api_token": "57|D3IFk2LNeDuxfZoXRutCGjzIBlL8lNPFNrlsuUWe39c0a02d",
      "notifications": 1,
      "deleted_at": null,
      "created_at": "2023-10-17T11:09:47.000000Z",
      "updated_at": "2023-10-30T06:24:38.000000Z",
      "is_favorite_count": 1
    }
  ]
}
*/

  int? status;
  String? message;
  List<CompaniesListData?>? data;

  CompaniesList({
    this.status,
    this.message,
    this.data,
  });
  CompaniesList.fromJson(Map<String, dynamic> json) {
    status = json['status']?.toInt();
    message = json['message']?.toString();
    if (json['data'] != null) {
      final v = json['data'];
      final arr0 = <CompaniesListData>[];
      v.forEach((v) {
        arr0.add(CompaniesListData.fromJson(v));
      });
      this.data = arr0;
    }
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (this.data != null) {
      final v = this.data;
      final arr0 = [];
      v!.forEach((v) {
        arr0.add(v!.toJson());
      });
      data['data'] = arr0;
    }
    return data;
  }
}
