import 'package:chatty/common/entities/base.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

import '../../common/apis/apis.dart';
import '../../common/routes/routes.dart';
import '../../common/store/store.dart';
import 'state.dart';

class MessageController extends GetxController {
  MessageController();
  final state = MessageState();

  Future<void> goProfile() async {
    await Get.toNamed(
      AppRoutes.Profile,
      arguments: state.head_detail.value,
    );
  }

  goTabStatus() {
    EasyLoading.show(
        indicator: const CircularProgressIndicator(),
        maskType: EasyLoadingMaskType.clear,
        dismissOnTap: true);
    state.tabStatus.value = !state.tabStatus.value;
    if (state.tabStatus.value) {
      //  asyncLoadMsgData();
    } else {}

    EasyLoading.dismiss();
  }

  @override
  void onReady() {
    super.onReady();
    firebaseMessageSetup();
  }

  Future<void> getProfile() async {
    var profile = UserStore.to.profile;
    state.head_detail.value = profile;
    state.head_detail.refresh();
  }

  @override
  void onInit() {
    super.onInit();
    getProfile();
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
      await ChatAPI.bind_fcmtoken(params: bindFcmTokenRequestEntity);
    }
  }
}
