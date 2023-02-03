import 'package:connectivity_plus/connectivity_plus.dart';

class AppConstant {
  // static String BASE_URL_LOCAL = 'http://192.168.1.24:3000/';
  // static String BASE_URL_LOCAL = 'https://43ac-2401-4900-1f3f-b88-56b-d37-c330-7f2a.in.ngrok.io/';
  // static String BASE_URL_LOCAL = 'http://6380-113-20-17-186.in.ngrok.io/';
  static String BASE_URL_LIVE = 'http://44.224.133.189:3000/';
  // static String BASE_URL_LIVE = 'http://demoapi.pac-hub.net/';

  static String MODE_LOGIN = BASE_URL_LIVE + "auth/login";
  static String FORGOT_PASSWORD = BASE_URL_LIVE + "password/forgotpassword";
  static String MODE_COLLEGE_RECRUITERES = BASE_URL_LIVE + "collegerecruiters/all?";
  static String MODE_DASHBAORD = BASE_URL_LIVE + "admin/dashboard";
  static String CHANGE_PASSWORD = BASE_URL_LIVE + "user/reset-password";
  static String RECENT_USERS = BASE_URL_LIVE + "admin/recent";
  static String ADMIN_USERS = BASE_URL_LIVE + "admin/users?";
  static String TRAINER_USERS = BASE_URL_LIVE + "trainer";
  static String Coach_advisior = BASE_URL_LIVE + "coach/all?";
  static String Coach_athletes = BASE_URL_LIVE + "athletes/all?";
  static String assign_trainer_athletes = BASE_URL_LIVE + "admin/assign-trainer";
  static String update_playerid = BASE_URL_LIVE + "admin/update-playerid";
  static String admin_reject = BASE_URL_LIVE + "admin/reject";
  static String admin_Approval = BASE_URL_LIVE + "admin/approval";
  static String mamage_profile = BASE_URL_LIVE + "profile/manageprofile";
  static String BOOK_MARK = BASE_URL_LIVE + "user/bookmarklist?";
  static String Stats = BASE_URL_LIVE + "pointstreak/individualplayerstats";
  static String Delete = BASE_URL_LIVE + "file-upload/deleteFile";
  //////////////TODO MESSAGE API URL///// ////////////////////////////
  static String Message_send = BASE_URL_LIVE + "message/send";
  static String Message_All_chat_listing = BASE_URL_LIVE + "message/chats";
  static String Message_chats = BASE_URL_LIVE + "message/mychats";
  static String Message_delete = BASE_URL_LIVE + "message/delete";
  static String Message_favourite = BASE_URL_LIVE + "message/archive";
  static String Message_read = BASE_URL_LIVE + "message/read";
  static String Hard_delete_message = BASE_URL_LIVE + "message/harddelete";

  //////////////TODO public_profile API URL///// ////////////////////////////

  static String public_profile = BASE_URL_LIVE + "publicprofile";

  ////////////////////////TODO COACH SEARCH athelete ///////////////////////////////
  static String COACH_athletesearch = BASE_URL_LIVE + "pointstreak/playerstats?";

  ////////////////////////TODO DASHBOARD CARD COUNT COACH & athelete ///////////////////////////////
  static String COACH_athlete_Dashboard_card_count = BASE_URL_LIVE + "audit/userdashboard";

  ////////////////////////TODO Managesubscription ///////////////////////////////
  static String Subscription_All_list_BILLING_HISTORY = BASE_URL_LIVE + "billingHistory";
  static String CANCEL_SUBSCRIPTION = BASE_URL_LIVE + "canclesubscription";

  ////////////////////////TODO Pending payment ///////////////////////////////
  static String pendingPaymentguser = BASE_URL_LIVE + "admin/pendinguser";
  static String paymentLink = BASE_URL_LIVE + "admin/paymentlink";

  /////////////////////TODO BOOKMARK TICK API ////////////////////////////////////
  static String BookMarkListTICK = BASE_URL_LIVE + "user/bookmark";

  /////////////////////TODO ADMIN SPORTS API ////////////////////////////////////
  static String SELECTSPORTS = BASE_URL_LIVE + "sports";

  /////////////////////TODO ATHELETE position-played API ////////////////////////////////////
  static String POSITIONPLAYED = BASE_URL_LIVE + "position-played";
  /////////////////////TODO COACH MANAGEPROFILE PERSONAL DETAILS DIVISION API ////////////////////////////////////
  static String DIVISIONLISTING = BASE_URL_LIVE + "division";

  /////////////////////TODO PLAN UPGRADE FOR SUBSCRIPTION PAYMENT API ////////////////////////////////////
  static String STRIPEPAYMENT = "http://13.127.163.159:1433/payment";
/////////////////////TODO PLAN UPGRADE FOR SUBSCRIPTION PAYMENT STRIPEKEY API ////////////////////////////////////
  static String CLIENTTRAINER = BASE_URL_LIVE+"client/trainer";

  /////////////////////TODO  MY myplansandfeatures API ////////////////////////////////////
  static String my_plans_and_features = BASE_URL_LIVE+"myplansandfeatures";

  /////////////////////TODO solicited API ////////////////////////////////////
  static String Solicited = BASE_URL_LIVE + "admin/solicited";

  /////////////////////TODO solicited-user API ////////////////////////////////////
  static String solicited_use = BASE_URL_LIVE + "admin/solicited-user";
}
