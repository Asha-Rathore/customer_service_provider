class NetworkStrings {
  //---------------------------  API BASE URL ----------------------------
  static const String API_BASE_URL =
      "https://server1.appsstaging.com/3559/customer_service_provider/public/api/";
  static const String SOCKET_BASE_URL = "https://server1.appsstaging.com:3049/";
  static const String IMAGE_BASE_URL =
      "https://server1.appsstaging.com/3559/customer_service_provider/public/storage/";

  //---------------------------- API HEADER TEXT ----------------------------
  static const String ACCEPT = 'application/json';

  //--------------------------------- API ENDPOINTS  ---------------------------------
  /// AUTHENTICATION END POINTS
  static const String SIGNUP_ENDPOINT = "signup";
  static const String LOGIN_ENDPOINT = "login";
  static const String LOGOUT_ENDPOINT = "logout";
  static const String SOCIAL_LOGIN_ENDPOINT = "social-login";
  static const String VERIFY_OTP_ENDPOINT = "verification";
  static const String FORGET_PASSWORD_ENDPOINT = "forgot-password";
  static const String RESET_PASSWORD_ENDPOINT = "reset-password";
  static const String CHANGE_PASSWORD_ENDPOINT = "change-password";
  static const String RESEND_OTP_CODE_ENDPOINT = "resend-otp";
  static const String COMPLETE_PROFILE_ENDPOINT = "complete-profile";
  static const String USER_PROFILE_ENDPOINT = "user-profile";
  static const String DELETE_ACCOUNT_ENDPOINT = "delete-account";

  /// CORE MODULE END POINTS
  static const String CONTENT_ENDPOINT = "content";
  static const String COMPANY_SERVICES = "company-services";
  static const String COMPANIES_ENDPOINT = "companies";
  static const String FAVORITE_LIST_ENDPOINT = "favorite-list";
  static const String ADD_TO_FAVORITE_ENDPOINT = "add-to-favorite";
  static const String REVIEWS_ENDPOINT = "reviews";
  static const String COMPANY_DETAILS_ENDPOINT = "company-details";
  static const String ENABLE_NOTIFICATION_ENDPOINT = "enable-notifications";
  static const String SUBSCRIPTIONS_ENDPOINT = "subscriptions";
  static const String SERVICE_DETAILS_ENDPOINT = "service-details";
  static const String ADD_REVIEW_ENDPOINT = "add-review";
  static const String DELETE_REVIEW_ENDPOINT = "delete-review/";
  static const String SERVICES_ENDPOINT = "services";
  static const String CHAT_MESSAGES_ENDPOINT = "chat-messages";
  static const String CHAT_ATTACHMENT_ENDPOINT = "chat-attachment";
  static const String ADD_SUBSCRIPTION_ENDPOINT = "add-subscription";
  static const String DELETE_SERVICE_ENDPOINT = "delete-service";
  static const String NOTIFICATIONS_ENDPOINT = "notifications";
  static const String DELETE_NOTIFICATION_ENDPOINT = "delete-notification/";

  /// CONTENT PARAMS
  static const String TERMS_AND_CONDITION = "terms-and-condition";
  static const String PRIVACY_POLICY = "privacy-policy";

  /// BUSINESS END POINTS
  static const String ADD_SERVICE_ENDPOINT = "add-service";

  // /// NOTIFICATION TYPES
  // static const String TYPE_REVIEW = "Review";
  // static const String TYPE_ADMIN = "Admin";
  // static const String TYPE_SERVICE = "Service";

  /// API STATUS CODE
  static const int SUCCESS_CODE = 200;
  static const int UNAUTHORIZED_CODE = 401;
  static const int CARD_ERROR_CODE = 402;
  static const int BAD_REQUEST_CODE = 400;
  static const int FORBIDDEN_CODE = 403;

  /// API MESSAGES
  static const int API_SUCCESS_STATUS = 1;
  static const int ACCOUNT_UNVERIFIED = 0;
  static const int ACCOUNT_VERIFIED = 1;
  static const int PROFILE_INCOMPLETED = 0;
  static const String IS_SOCIAL = "1";
  static const int PROFILE_COMPLETED = 1;
  static const int IS_FAVORITE = 1;
  static const int IN_NOT_FAVORITE = 0;

  /// API TOAST MESSAGES
  static const String NO_INTERNET_CONNECTION = "No Internet Connection!";
  static const String SOMETHING_WENT_WRONG = "Something Went Wrong";

  /////////////// SOCKET EMIT EVENTS ////////////////
  static const String GET_MESSAGES_EVENT = "get_messages";
  static const String SEND_MESSAGE_EVENT = "send_message";

  /////////////// SOCKET RESPONSE KEYS ////////////////
  static const String GET_MESSAGES_KEY = "get_messages";
  static const String GET_MESSAGE_KEY = "get_message";
}
