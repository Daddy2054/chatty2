import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import 'index.dart';

class VoiceCallController extends GetxController {
  VoiceCallController();
  final state = VoiceCallState();

  @override
  void onInit() {
    super.onInit();
    var data = Get.parameters;
    state.to_name.value = data['to_name'] ?? '';
    state.to_avatar.value = data['to_avatar'] ?? '';

    if (kDebugMode) {
      print('...your name is ${state.to_name.value}');
    }
  }
}
