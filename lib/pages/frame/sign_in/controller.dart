import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../common/apis/apis.dart';
import '../../../common/entities/entities.dart';
import '../../../common/routes/names.dart';
import '../../../common/store/store.dart';
import 'state.dart';

class SignInController extends GetxController {
  SignInController();
  final state = SignInState();

  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['openid']);

  void handlesignIn(String type) async {
    //1:email 2:google 3:facebook 4:apple 5:phone

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
          String? displayName = user.displayName;
          String email = user.email;
          String id = user.id;
          String photoUrl = user.photoUrl ?? 'assets/icons/google.png';
          LoginRequestEntity loginPageListRequestEntity = LoginRequestEntity();
          loginPageListRequestEntity.avatar = photoUrl;
          loginPageListRequestEntity.name = displayName;
          loginPageListRequestEntity.email = email;
          loginPageListRequestEntity.open_id = id;
          loginPageListRequestEntity.type = 2;
          asyncPostAllData(loginPageListRequestEntity);
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

asyncPostAllData(LoginRequestEntity loginRequestEntity) async {
  // EasyLoading.show(
  //   indicator: const CircularProgressIndicator(),
  //   maskType: EasyLoadingMaskType.clear,
  //   dismissOnTap: true,
  // );
  var result = await UserAPI.Login(params: loginRequestEntity);
  if (kDebugMode) {
    print(result);
  }
  // if (result.code == 0) {
  //   await UserStore.to.saveProfile(result.data!);
  //   EasyLoading.dismiss();
  if (kDebugMode) {
    print("let's go to the message page");
  }
  var response = await Dio().get('http://10.0.2.2:8000/api/index');
  //var response = await Dio().get('http://192.168.0.149:8000/api/index');
  //var response = await HttpUtil().get('/api/index');
//    var response = await dio.get(
  if (kDebugMode) {
    print(response);
  }
  UserStore.to.setIsLogin = true;
  Get.offAllNamed(AppRoutes.Message);
  // } else {
  // EasyLoading.dismiss();
  // toastInfo(msg: 'internet error');
  // }
}
