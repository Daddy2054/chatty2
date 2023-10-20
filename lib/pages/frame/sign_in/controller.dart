import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'state.dart';

class SignInController extends GetxController {
  SignInController();
  final state = SignInState();

  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['openid']);

  void handlesignIn(String type) async {
    //1:google
    //2:facebook,
    //3:apple,
    //4:phone

    try {
      if (type == 'phone_number') {
        if (kDebugMode) {
          print('...you are logging in with $type');
        }
      } else if (type == 'google') {
        if (kDebugMode) {
          print('...you are logging in with $type');
        }
         var user = await _googleSignIn.signIn();
        if (user != null) {
          // String? displayName = user.displayName;
          // String email = user.email;
          // String id = user.id;
          // String photoUrl = user.photoUrl ?? 'assets/icons/google.png';
          // LoginRequestEntity loginPanelListRequestEntity = LoginRequestEntity();
          // loginPanelListRequestEntity.avatar = photoUrl;
          // loginPanelListRequestEntity.name = displayName;
          // loginPanelListRequestEntity.email = email;
          // loginPanelListRequestEntity.open_id = id;
          // loginPanelListRequestEntity.type = 2;
        }
      } else if (type == 'facebook') {
        if (kDebugMode) {
          print('...you are logging in with $type');
        }
      } else if (type == 'apple') {
        if (kDebugMode) {
          print('...you are logging in with $type');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('...error with login $e');
      }
    }
  }
}
