import 'package:get/get.dart';

import '../../../common/routes/names.dart';
import 'index.dart';

class VoiceCallController extends GetxController {
  VoiceCallController();
  final title = 'Chatty .';
  final state = VoiceCallState();

  @override
  void onReady() {
    super.onReady();
    Future.delayed(
        const Duration(seconds: 3), () => Get.offAllNamed(AppRoutes.Message));
  }
}
