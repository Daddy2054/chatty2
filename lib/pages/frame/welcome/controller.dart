import 'package:get/get.dart';

import '../../../common/routes/names.dart';
import 'state.dart';

class WelcomeController extends GetxController {
  WelcomeController();
  final title = "Chatty .";
  final state = WelcomeState();

  @override
  void onReady() {
    super.onReady();
    Future.delayed(
      const Duration(seconds: 3),
      () => Get.offAllNamed(AppRoutes.Message),
    );
  }
}
