import 'package:customer_service_provider_hybrid/utils/asset_paths.dart';

class AppStrings {
  static const String APP_TITLE_TEXT = "Customer Service Provider";

  //------------------ WEBVIEW URL ------------------//
  static const String WEB_VIEW_URL = "https://www.lipsum.com/";

  // ------------------- SOCIAL LOGIN TYPE --------------- //
  static const String APPLE_AUTH_TEXT = "apple";
  static const String FACEBOOK_AUTH_TEXT = "facebook";
  static const String GOOGLE_AUTH_TEXT = "google";
  static const String PHONE_AUTH_TEXT = "phone";

  //----------------------------- KEYS ---------------
  static const String BEARER_TOKEN_KEY = "bearer_token";
  static const String USER_DATA_KEY = "user_data";
  static const String DATA_KEY = "data";

  //----------------- NOTIFICATION KEY TYPE ------------- //
  static const String EVENT_ADDED_NOTIFICATION_TYPE = "EVENT_ADDED";
  static const String CHAT_NOTIFICATION_TYPE = "chat";
  static const String NOTIFICATION_MESSAGE_ID_KEY = "notification_message_id";

  //------------------ SPLASH TEXT ------------------//
  static const String LETS_GET_STARTED_NOW = "Let's Get Started Now";

  //------------------ SELECT ROLE ------------------//
  static const String SELECT_YOUR_ROLE = "SELECT YOUR ROLE";
  static const String AS_A_USER = "As a User";
  static const String AS_A_BUSINESS_PROVIDER = "As a Business Provider";

  static const List<String> SERVICE_PROVIDERS_NAME = ["Dave","Jason Home Care Services","Carl"];
  static const String SELECT_SERVICE_PROVIDER = 'Select Service Provider';
  //------------------ PRELOGIN ------------------//
  static const String SOCIAL_LOGIN = "SOCIAL LOGIN";
  static const String LOGIN_WITH_EMAIL = "Login With Email";
  static const String LOGIN_WITH_GOOGLE = "Login With Google";
  static const String LOGIN_WITH_APPLE = "Login With Apple";

  //-------------- TERMS CONDITIONS AND PRIVACY POLICY ----------------------//
  static const String TERMS_CONDITION = "Terms & Conditions";
  static const String AND = " & ";
  static const String PRIVACY_POLICY = "Privacy Policy";
  static const String AGRREMT_TEXT = "By signing up, you agree to our \n";

  //------------------ AGREEMENT ------------------//
  static const String AGREEMENT = "AGREEMENT";
  static const String I_AGREE_WITH_THE_FOLLOWING = "I agree with the following";
  static const String DECLINE = "Decline";
  static const String ACCEPT = "Accept";

  // -------------- LOGIN  ---------------//
  static const String LOGIN = "LOGIN";
  static const String EMAIL_ADDRESS = "Email Address";
  static const String PASSWORD = "Password";
  static const String FORGOT_PASSWORD_BUTTON = "Forgot Password?";
  static const String LOG_IN = "Log In";
  static const String DONT_HAVE_AN_ACCOUNT = "Don't have an Account? ";
  static const String SIGNUP_NOW = "Signup Now!";

  // -------------- LOGIN  ---------------//
  static const String SIGN_UP = "Sign Up";
  static const String FULL_NAME = "Full Name";
  static const String CONFIRM_PASSWORD = "Confirm Password";
  static const String ALREADY_HAVE_AN_ACCOUNT = "Already have an Account? ";
  static const String LOGIN_NOW = "Login Now!";

  // -------------- VERIFICATION  ---------------//
  static const String VERIFICATION = "VERIFICATION";
  static const String WE_HAVE_SENT_YOU_EMAIL =
      "We have sent you an email containing 6 digits verification code. Please enter the code to verfiy your identity.";
  static const String CODE_DIDNT_RECEIVE = "Code didn't receive? ";
  static const String RESEND_CODE = "Resend Code";

  // -------------- PROFILE  ---------------//
  static const String PROFILE = "Profile";
  static const String PHONE_NUMBER = "Phone Number";
  static const String ADDRESS = "Address";
  static const String PREFERRED_LANGUAGE = "Preferred Language";
  static const String CONTINUE = "Continue";
  static const String ENGLISH = "English";
  static const String SPANISH = "Spanish";
  static const String SAVE = "Save";
  static const String WEBSITE = "Website";
  static const String EDIT_YOUR_PROFILE = "Edit Your Profile";

  // -------------- SUCCESSFUL  ---------------//
  static const String SUCCESSFUL = "SUCCESSFUL";
  static const String YOUR_ACCOUNT_HAS_BEEN_CREATED =
      "Your Account has been created successfully.";
  static const String YOUR_PASSWORD_HAS_BEEN_CHANGED =
      "Your password has been changed successfully.";
  static const String YOUR_FEEDBACK_HAS_BEEN_POSTED =
      "Your feedback has been posted successfully.";
  static const String YOUR_PASSWORD_HAS_BEEN_CREATED =
      "Your password has been created successfully.";
  static const String YOUR_PAYMENT_FOR_SUBSCRIPTION =
      "Your payment for subscription has been successfully completed.";

  // -------------- FORGOT PASSWORD  ---------------//
  static const String FORGOT_PASSWORD = "FORGOT PASSWORD";

  // -------------- RESET PASSWORD  ---------------//
  static const String CREATE_NEW_PASSWORD = "CREATE NEW PASSWORD";
  static const String RESET_PASSWORD = "Reset Password";

  /////////////////////////////// USER INTERFACE ///////////////////////////////

  // -------------- BOTTOM NAVIGATION  ---------------//
  static const String CHAT = "Chat";

  // -------------- DRAWER  ---------------//
  static const String FAVOURITES = "Favourites";
  static const String SETTINGS = "Settings";
  static const String LOGOUT = "Logout";

  // -------------- HOME  ---------------//
  static const String HOME = "Home";
  static const String SEARCH_HERE = "Search here";

  // -------------- NOTIFICATION  ---------------//
  static const String NOTIFICATION = "NOTIFICATION";
  static const String TODAY = "Today";

  // -------------- COMPANY PROFILE  ---------------//
  static const String COMPANY_PROFILE = "COMPANY PROFILE";
  static const String DESCRIPTION = "Description";
  static const String SERVICES = "Services";
  static const String REVIEWS = "Reviews";
  static const String CALL_WITH_US = "Call with us";
  static const String CHAT_WITH_US = "Chat with us";
  static const String ADD_A_REVIEW = "Add a Review";
  static const String SERVICE_PROVIDER_NUMBER = "Service Provider Number";

  // -------------- FEEDBACK  ---------------//
  static const String YOUR_FEEDBACK = "YOUR FEEDBACK";
  static const String SHARE_YOUR_OWN_EXPERIENCE = "Share your own experience";
  static const String SUBMIT = "Submit";

  // -------------- CHAT  ---------------//
  static const String YESTERDAY = "Yesterday";
  static const String TYPE_YOUR_COMMENT_HERE = "Type your comment here...";

  // -------------- SETTINGS  ---------------//
  static const String PUSH_NOTIFICATIONS = "Push Notifications";
  static const String CHANGE_PASSWORD = "Change Password";
  static const String DELETE_ACCOUNT = "Delete Account";

  // -------------- CHANGE PASSWORD  ---------------//
  static const String OLD_PASSWORD = "Old Password";
  static const String NEW_PASSWORD = "New Password";
  static const String CONFIRM_NEW_PASSWORD = "Confirm New Password";

  // -------------- SERVICES DETAIL  ---------------//
  static const String SERVICES_DETAIL = "SERVICES DETAIL";
  static const String customerServiceProvider="Customer Service";

  /////////////////////////////// BUSINESS INTERFACE ///////////////////////////////
  ///
  // -------------- SUBSCRIPTION PLAN  ---------------//
  static const String SUBSCRIPTION_PLAN = "Subscription Plan";
  static const String CHOOSE_YOUR_PACKAGE = "Choose Your Package";
  static const String PREMIUM_PACKAGE = "Premium Package";
  static const String MONTHLY = "Monthly";
  static const String SUBSCRIBE = "Subscribe";
  static const String SKIP_FOR_NOW = "Skip For Now!";

  // -------------- CARD DETAILS  ---------------//
  static const String ADD_CARD_DETAILS = "ADD CARD DETAILS";
  static const String ACCOUNT_HOLDER = "Account Holder";
  static const String ACCOUNT_NUMBER = "Account Number";
  static const String EXPIRY_DATE = "Expiry Date";
  static const String CVC = "CVC";

  // -------------- ADD A SERVICE  ---------------//
  static const String ADD_A_SERVICE = "ADD A SERVICE";
  static const String SERVICE_NAME = "Service Name";
  static const String LOCATION = "Location";
  static const String ADD = "Add";

  // -------------- HOME  ---------------//
  static const String MY_SERVICES = "My Services";

  // -------------- SERVICE DETAIL  ---------------//
  static const String MORE_SERVICES = "More Services";

  // -------------- EDIT YOUR SERVICE ---------------//
  static const String EDIT_YOUR_SERVICE = "EDIT YOUR SERVICE";
  static const String DELETE = "Delete";

  // -------------- CARD DETAILS  ---------------//
  static const String CARD_DETAILS = "Card Details";
  static const String APPLE_PAY = "Apple Pay";
  static const String PAYPAL = "Paypal";
  static const String ADD_NEW_CARD = "Add New Card";

  // -------------- TEMP TEXT  ---------------//
  static const String JOHN_SMITH = "John Smith";
  static const String LISA_MARIE = "Lisa Marie";
  static const String WILLIAM_ROY = "William Roy";
  static const String JOHN_SMITH_EMAIL = "john.smith@example.com";
  static const String LOREM_IPSUM = "Lorem Ipsum";
  static const String COMPANY_NAME = "Company Name";
  static const String LOREM_IPSUM_SMALL_TEXT =
      "Lorem ipsum doloing to the companytur apiscing elit te.";
  static const String LOREM_IPSUM_DOLOR = "Lorem ipsum dolor sit amet";
  static const String TEMP_DATE = "Jan, 05 2023";
  static const String TEMP_MIN = "12 min";
  static const String TEMP_RATING = "4.5";
  static const String TEMP_COMPANY_ADDRESS =
      "123 Lorem Ipsum Dummy Adress, NewYork, USA";
  static const String TEMP_COMPANY_EMAIL = "info@example.com";
  static const String TEMP_COMPANY_NUMBER = " 123 456 789 0";
  static const String TEMP_COMPANY_WEBSITE = "www.companyname.com";
  static const String TEMP_SUBSCRIPTION_PACKAGE = "\$ 9.99/";
  static const String TEMP_NEW_YORK = "NewYork, USA";
  static const String TEMP_CARD_NUMBER = "**** **** **** 1234";
  static const String LOREM_IPSUM_MEDIUM_TEXT =
      "Lorem ipsum doloing to the companytur apiscing elit te. Lorem ipsum doloing to the companytur apiscing elit te.";

  //------------------ DIALOG Text ---------------------//
  static const String ARE_YOU_SURE = "Are you sure";
  static const String DO_YOU_WANT_TO_LOGOUT = "Are you sure you want to logout?";
  static const String DO_YOU_WANT_TO_EXIT = "Are you sure you want to exit?";
  static const String DO_YOU_WANT_TO_DELETE_SERVICE = "Are you sure you want to delete the service?";
  static const String DO_YOU_WANT_TO_DELETE_ACCOUNT = "Do you want to delete this account?";
  static const String DO_YOU_WANT_TO_DELETE_REVIEW = "Do you want to delete review?";
  static const String NO = "NO";
  static const String DO_YOU_WANT_TO_DELETE_THIS_NOTIFICATION =
      "Do you want to delete this notification?";
  static const String YES = "YES";

  //------------------ Error Text ---------------------//
  //Email
  static const String EMAIL_EMPTY_ERROR = "Email field can't be empty.";
  static const String EMAIL_INVALID_ERROR = "Please enter valid email address.";

  //Password
  static const String PASSWORD_EMPTY_ERROR = "Password field can't be empty.";
  static const String OLD_PASSWORD_EMPTY_ERROR =
      "Old Password field can't be empty.";
  static const String PASSWORD_INVALID_LENGTH_ERROR =
      "The password must be at least 8 characters.";
  static const String PASSWORD_INCORRECT_ERROR =
      "Password is incorrect.";
  static const String PASSWORD_INVALID_ERROR =
      "Password must be of 8 characters long and contains at least 1 uppercase, 1 lowercase, 1 digit and 1 special character.";
  static const String NEW_PASSWORD_EMPTY_ERROR =
      "New Password field can't be empty.";
  //Confirm Password
  static const String CONFIRM_PASSWORD_EMPTY_ERROR =
      "Confirm Password field can't be empty.";
  static const String CONFIRM_NEW_PASSWORD_EMPTY_ERROR =
      "Confirm New Password field can't be empty.";
  static const String PASSWORD_SAME_ERROR =
      "Old password and New password can't be same";
  static const String PASSWORD_DIFFERENT_ERROR =
      "Password and Confirm Password must be same.";
  static const String NEW_PASSWORD_DIFFERENT_ERROR =
      " New Password and Confirm Password must be same.";
  static const String CONFIRM_NEW_PASSWORD_DIFFERENT_ERROR =
      " New Password and Confirm New Password must be same.";

  //PHONE NO
  static const String PHONE_NO_EMPTY_ERROR = 'Phone no field can\'t be empty.';
  static const String PHONE_NO_INVALID_LENGTH = 'Invalid phone number.';

  //OTP
  static const String OTP_EMPTY_ERROR = "The OTP field is required.";
  static const String FILE_TEXT = "File";
  static const String ASSET_TEXT = "Asset";
  static const String ENTER_EMAIL_REGISTERED =
      "Please enter your registered email";
  static const String LOGIN_SUCESSFULLY = "Login Successfully.";
  static const String INVALID_EMAIL = "Invalid Email.";
  static const String LOGOUT_SUCCESSFULLY = "Logout Successfully.";
  static const String NAME_EMPTY_ERROR = "Full Name can't be empty.";
  static const String PROFILE_IMAGE_ERROR =
      "Your Image do not contain face please upload valid Image.";
  static const String BIO_EMPTY_ERROR = "Bio can't be empty.";
  static const String NUMBER_EMPTY_ERROR = "Number can't be empty.";
  static const String QUANTITY_EMPTY_ERROR = "Quantity can't be empty.";
  static const String ADDRESS_EMPTY_ERROR = 'Address can\'t be empty.';
  static const String NUMBER_INVALID_ERROR = "Phone Number is not valid.";
  static const String CURRENT_PASSWORD_EMPTY_ERROR =
      "Current Password can't be empty.";
  static const String CONFIRM_PASSWORD_INVALID_ERROR =
      "Confirm Password must be 8 characters long and contains at least 1 upper case, 1 lower case, 1 digit & 1 special character.";
  static const String NEW_PASSWORD_INVALID_ERROR =
      "New Password must be 8 characters long and contains at least 1 upper case, 1 lower case, 1 digit & 1 special character.";
  static const String CURRENT_PASSWORD_INVALID_ERROR =
      "Current Password must be 8 characters long and contains at least 1 upper case, 1 lower case, 1 digit & 1 special character.";
  static const String CONFIRM_NEW_PASSWORD_INVALID_ERROR =
      "confirm New Password must be 8 characters long and contains at least 1 upper case, 1 lower case, 1 digit & 1 special character.";
  static const String DATA_NOT_FOUND_ERROR = "Data not found.";
  static const String CHAT_NOT_FOUND_ERROR = "Chat not found.";
  static const String COMPANIES_NOT_FOUND_ERROR = "Companies not found.";
  static const String COMPANY_PROFILE_NOT_FOUND_ERROR = "Company Profile not found.";
  static const String SERVICES_NOT_FOUND_ERROR = "Services not found.";
  static const String REVIEWS_NOT_FOUND_ERROR = "Reviews not found.";
  static const String NOTIFICATIONS_NOT_FOUND_ERROR = "Notifications not found.";
  static const String MY_SERVICES_NOT_FOUND_ERROR = "My Services not found.";
  static const String SERVICE_DETAIL_NOT_FOUND_ERROR = "Service Details not found.";
  static const String FAVORITE_COMPANIES_NOT_FOUND_ERROR = "No favourite found.";

  //-------------- APP LISTS ----------------------//

  //---------------DESIGNER------------------------//
  static const List<String> USER_APP_BAR_TITLE = [
    CHAT,
    HOME,
    PROFILE,
  ];

  static const List<String> BUSINESS_APP_BAR_TITLE = [
    HOME,
    ADD_A_SERVICE,
    CHAT,
  ];
  static const List<String> USER_NAV_BAR_ITEMS = [
    AssetPath.CHAT_ICON,
    AssetPath.HOME_ICON,
    AssetPath.PROFILE_ICON,
  ];

  static const List<String> USER_DRAWER_TITLE_LIST = [
    HOME,
    FAVOURITES,
    SETTINGS,
    PRIVACY_POLICY,
    TERMS_CONDITION,
    LOGOUT,
  ];
  static const List<String> USER_DRAWER_ICONS_LIST = [
    AssetPath.DRAWER_HOME_ICON,
    AssetPath.DRAWER_FAVORITES_ICON,
    AssetPath.SETTINGS_ICON,
    AssetPath.PRIVACY_TERMS_ICON,
    AssetPath.PRIVACY_TERMS_ICON,
    AssetPath.LOGOUT_ICON,
  ];

  static const List<String> BUSINESS_DRAWER_TITLE_LIST = [
    HOME,
    SETTINGS,
    SUBSCRIPTION_PLAN,
    // CARD_DETAILS,
    PRIVACY_POLICY,
    TERMS_CONDITION,
    LOGOUT,
  ];
  static const List<String> BUSINESS_DRAWER_ICONS_LIST = [
    AssetPath.DRAWER_HOME_ICON,
    AssetPath.SETTINGS_ICON,
    AssetPath.SUBSCRIPTION_ICON,
    // AssetPath.CARD_DETAIL_ICON,
    AssetPath.PRIVACY_TERMS_ICON,
    AssetPath.PRIVACY_TERMS_ICON,
    AssetPath.LOGOUT_ICON,
  ];

  static const List<String> LANGUAGES = [
    ENGLISH,
    "Spain",
    "China",
    "France",
    "USA",
    "Germany",
    "Australia",
  ];
  static const defaultCountryCode="US";

  static const String SEARCH_INBOX_ERROR =
      "Search can be done after loading data.";

  static const String langaugeListPath='assets/files/languages.json';
  static const List<String> ENGLISH_NUMBERS = [
    TEMP_COMPANY_NUMBER,
    TEMP_COMPANY_NUMBER,
    TEMP_COMPANY_NUMBER,
    TEMP_COMPANY_NUMBER,
    TEMP_COMPANY_NUMBER,
    TEMP_COMPANY_NUMBER,
  ];

  //-------------- MAP LISTS ----------------------//

  static Map<String, dynamic> companyList = {
    "CompanyList": [
      {
        'image': AssetPath.IMAGE1,
        'title': LOREM_IPSUM,
        'companyName': COMPANY_NAME,
        'description': LOREM_IPSUM_SMALL_TEXT,
        'isFav': false
      },
      {
        'image': AssetPath.IMAGE2,
        'title': LOREM_IPSUM,
        'companyName': COMPANY_NAME,
        'description': LOREM_IPSUM_SMALL_TEXT,
        'isFav': false
      },
      {
        'image': AssetPath.IMAGE3,
        'title': LOREM_IPSUM,
        'companyName': COMPANY_NAME,
        'description': LOREM_IPSUM_SMALL_TEXT,
        'isFav': false
      },
      {
        'image': AssetPath.IMAGE4,
        'title': LOREM_IPSUM,
        'companyName': COMPANY_NAME,
        'description': LOREM_IPSUM_SMALL_TEXT,
        'isFav': false
      },
      {
        'image': AssetPath.IMAGE5,
        'title': LOREM_IPSUM,
        'companyName': COMPANY_NAME,
        'description': LOREM_IPSUM_SMALL_TEXT,
        'isFav': false
      },
      {
        'image': AssetPath.IMAGE6,
        'title': LOREM_IPSUM,
        'companyName': COMPANY_NAME,
        'description': LOREM_IPSUM_SMALL_TEXT,
        'isFav': false
      },
    ],
  };
  static const String text="text";
  static const String image="image";
  static const String receiver="receiver";
  static const String sender="sender";

  static Map<String, dynamic> chatList = {
    "ChatList": [
      {
        'image': AssetPath.COMPANY_IMAGE,
        'time': TEMP_MIN,
        'companyName': COMPANY_NAME,
        'description': LOREM_IPSUM_SMALL_TEXT
      },
      {
        'image': AssetPath.COMPANY_IMAGE,
        'time': TEMP_MIN,
        'companyName': COMPANY_NAME,
        'description': LOREM_IPSUM_SMALL_TEXT
      },
      {
        'image': AssetPath.COMPANY_IMAGE,
        'time': TEMP_MIN,
        'companyName': COMPANY_NAME,
        'description': LOREM_IPSUM_SMALL_TEXT
      },
      {
        'image': AssetPath.COMPANY_IMAGE,
        'time': TEMP_MIN,
        'companyName': COMPANY_NAME,
        'description': LOREM_IPSUM_SMALL_TEXT
      },
      {
        'image': AssetPath.COMPANY_IMAGE,
        'time': TEMP_MIN,
        'companyName': COMPANY_NAME,
        'description': LOREM_IPSUM_SMALL_TEXT
      },
      {
        'image': AssetPath.COMPANY_IMAGE,
        'time': TEMP_MIN,
        'companyName': COMPANY_NAME,
        'description': LOREM_IPSUM_SMALL_TEXT
      },
    ],
  };

  static Map<String, dynamic> notificationList = {
    "NotificationList": [
      {
        'date': TEMP_DATE,
        'title': LOREM_IPSUM_DOLOR,
        'description': LOREM_IPSUM_SMALL_TEXT
      },
      {
        'date': TEMP_DATE,
        'title': LOREM_IPSUM_DOLOR,
        'description': LOREM_IPSUM_SMALL_TEXT
      },
      {
        'date': TEMP_DATE,
        'title': LOREM_IPSUM_DOLOR,
        'description': LOREM_IPSUM_SMALL_TEXT
      },
      {
        'date': TEMP_DATE,
        'title': LOREM_IPSUM_DOLOR,
        'description': LOREM_IPSUM_SMALL_TEXT
      },
      {
        'date': TEMP_DATE,
        'title': LOREM_IPSUM_DOLOR,
        'description': LOREM_IPSUM_SMALL_TEXT
      },
      {
        'date': TEMP_DATE,
        'title': LOREM_IPSUM_DOLOR,
        'description': LOREM_IPSUM_SMALL_TEXT
      },
    ],
  };





  static Map<String, dynamic> servicesList = {
    "ServicesList": [
      {
        'image': AssetPath.IMAGE1,
        'title': LOREM_IPSUM,
        'companyName': COMPANY_NAME,
        'description': LOREM_IPSUM_SMALL_TEXT,
      },
      {
        'image': AssetPath.IMAGE2,
        'title': LOREM_IPSUM,
        'companyName': COMPANY_NAME,
        'description': LOREM_IPSUM_SMALL_TEXT,
      },
      {
        'image': AssetPath.IMAGE3,
        'title': LOREM_IPSUM,
        'companyName': COMPANY_NAME,
        'description': LOREM_IPSUM_SMALL_TEXT,
      },
      {
        'image': AssetPath.IMAGE4,
        'title': LOREM_IPSUM,
        'companyName': COMPANY_NAME,
        'description': LOREM_IPSUM_SMALL_TEXT,
      },
      {
        'image': AssetPath.IMAGE5,
        'title': LOREM_IPSUM,
        'companyName': COMPANY_NAME,
        'description': LOREM_IPSUM_SMALL_TEXT,
      },
      {
        'image': AssetPath.IMAGE6,
        'title': LOREM_IPSUM,
        'companyName': COMPANY_NAME,
        'description': LOREM_IPSUM_SMALL_TEXT,
      },
    ],
  };

  static Map<String, dynamic> reviewsList = {
    "ReviewsList": [
      {
        'image': AssetPath.USER_IMAGE,
        'name': LISA_MARIE,
        'rating': "4.5",
        'review': LOREM_IPSUM_MEDIUM_TEXT,
      },
      {
        'image': AssetPath.USER_IMAGE,
        'name': LISA_MARIE,
        'rating': "4",
        'review': LOREM_IPSUM_MEDIUM_TEXT,
      },
      {
        'image': AssetPath.USER_IMAGE,
        'name': LISA_MARIE,
        'rating': "3.5",
        'review': LOREM_IPSUM_MEDIUM_TEXT,
      },
      {
        'image': AssetPath.USER_IMAGE,
        'name': LISA_MARIE,
        'rating': "4.6",
        'review': LOREM_IPSUM_MEDIUM_TEXT,
      },
    ],
  };

  static Map<String, dynamic> subscriptionList = {
    "SubscriptionList": [
      {
        'subscriptionPlan': PREMIUM_PACKAGE,
        'price': "9.99",
        'duration': MONTHLY,
        'description': AppStrings.LOREM_IPSUM_MEDIUM_TEXT,
      },
      {
        'subscriptionPlan': PREMIUM_PACKAGE,
        'price': "9.99",
        'duration': MONTHLY,
      },
      // {
      //   'subscriptionPlan': PREMIUM_PACKAGE,
      //   'price': "9.99",
      //   'duration': MONTHLY,
      // },
    ],
  };

  static Map<String, dynamic> cardsList = {
    "cardsData": [
      {
        "image": AssetPath.APPLE_PAY_ICON,
        "name": APPLE_PAY,
        "optionValue": 2,
      },
      {
        "image": AssetPath.PAYPAL_ICON,
        "name": PAYPAL,
        "optionValue": 5,
      },
      {
        "image": AssetPath.MASTERCARD_ICON,
        "name": TEMP_CARD_NUMBER,
        "optionValue": 3,
      },
      {
        "image": AssetPath.VISA_ICON,
        "name": TEMP_CARD_NUMBER,
        "optionValue": 6,
      },
    ]
  };




  ////////// PUSH NOTIFICATION CHANNEL /////////////
  static const String NOTIFICATION_ID = "customer_service_provider_channel_1";
  static const String NOTIFICATION_TITLE = "Customer Service Provider Notification";
  static const String NOTIFICATION_DESCRIPTION = "This channel is used for important notifications.";


  /////////// PUSH NOTIFICATION TYPE ///////////
  static const String FOREGROUND_NOTIFICATION = "foreground";
  static const String BACKGROUND_NOTIFICATION = "background";
  static const String KILLED_NOTIFICATION = "killed";


  /////////// LOCAL NOTIFICATION CHANNEL ///////////
  static const String LOCAL_NOTIFICATION_ID = "customer_service_provider_local_channel1";
  static const String LOCAL_NOTIFICATION_TITLE = "Customer Service Provider local Notification.";
  static const String LOCAL_NOTIFICATION_DESCRIPTION = "This channel is used for local notifications.";

  
}
