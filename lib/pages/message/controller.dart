import 'package:firebase_messaging/firebase_messaging.dart';
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
    String? fcmtoken = await FirebaseMessaging.instance.getToken();
  }
}
