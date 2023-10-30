import 'package:chatty/common/entities/base.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../../common/routes/routes.dart';
import 'state.dart';

class MessageController extends GetxController {
  MessageController();
  final state = MessageState();

  Future<void> goProfile() async {
    await Get.toNamed(AppRoutes.Profile);
  }

  @override
  void onReady() {
    super.onReady();
    firebaseMessageSetup();
  }

  firebaseMessageSetup() async {
    String? fcmToken = await FirebaseMessaging.instance.getToken();
    if (kDebugMode) {
      print('...my device token is $fcmToken');
    }
    if (fcmToken != null) {
      BindFcmTokenRequestEntity bindFcmTokenRequestEntity =
          BindFcmTokenRequestEntity();
      bindFcmTokenRequestEntity.fcmtoken = fcmToken;
  //    await ChatAPI.bind_fcmtoken(params: bindFcmTokenRequestEntity);
    }
  }
}
