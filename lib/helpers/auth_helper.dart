import 'package:shared_preferences/shared_preferences.dart';
import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' as models;
import 'package:get_receipt/main.dart';

import '../model/login_user_model.dart';


class AuthHelper {
  AuthHelper._privateConstructor();
  static final AuthHelper _instance = AuthHelper._privateConstructor();
  static AuthHelper get instance => _instance;

  static final Future<SharedPreferences> _prefs =
  SharedPreferences.getInstance();

  static final account = Account(client);

  Future<String?> getUserId() async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getString('userId');
  }
  Future<LoginUserModel> currentUser() async {
    final SharedPreferences prefs = await _prefs;
    return LoginUserModel(
      uid: prefs.getString('userId'),
      phoneNo: prefs.getString('phoneNo'),
    );
  }


  Future<bool> isLoggedIn() async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getBool('isLoggedIn') ?? false;
  }

  static Future<void> setLoggedIn(bool value) async {
    final SharedPreferences prefs = await _prefs;
    prefs.setBool('isLoggedIn', value);
  }

  Future<String> loginWithNumber (String phone) async{
    try{
      final  token = await account.createPhoneToken(
          userId: ID.unique(),
          phone: phone
      );
      return token.userId;

    }on AppwriteException {
      rethrow;
    }
  }

  Future<models.Session> verifyOTP({
  required String userId,
    required String otp,
    required String phoneNo,
})
  async {
    final SharedPreferences prefs = await _prefs;
    try{
      final session = await account.createSession(
          userId: userId,
          secret: otp
      );
      prefs.setString('userId', session.userId);
      prefs.setString('phoneNo', phoneNo);
      setLoggedIn(true);
      return session;

    }catch (e){
      rethrow;
    }
  }



  logout() async {
    final SharedPreferences prefs = await _prefs;
    prefs.remove('userId');
    prefs.remove('phoneNo');
    setLoggedIn(false);
    account.deleteSessions();
  }
}