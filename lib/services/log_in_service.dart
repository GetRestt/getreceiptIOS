
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_receipt/helpers/utils.dart';
import 'package:get_receipt/model/login_user_model.dart';
import 'package:get_receipt/pages/auth_page.dart';

import '../helpers/auth_helper.dart';
import 'loading_indicator_dialog.dart';


class LoginService extends ChangeNotifier {

  LoginUserModel? _userModel;

  LoginUserModel? get loggedInUserModel => _userModel;

  Future<bool> loginUser() async {

    bool login = await AuthHelper.instance.isLoggedIn();
    if (login == true) {
      _userModel = await AuthHelper.instance.currentUser();
      notifyListeners();
      return true;
    }else{
      return false;
    }

  }

void load(context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return Dialog(
        child: new Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            new CircularProgressIndicator(),
            new Text("..."),
          ],
        ),
      );
    },
  );
}

  Future<void> signOut(context) async {
    //await GoogleSignIn().signOut();
   /* showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          child: new Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              new CircularProgressIndicator(),
              new Text("..."),
            ],
          ),
        );
      },
    );*/
    //LoadingIndicatorDialog().show(context); // start dialog
    AuthHelper.instance.logout();
    //LoadingIndicatorDialog().dismiss();
    _userModel = null;
    Utils.mainAppNav.currentState!.pushNamed('/auth');

    //return const Auth();
  }

  bool isUserLoggedIn() {
    return _userModel != null;
  }

}