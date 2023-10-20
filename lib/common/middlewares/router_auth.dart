import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../routes/routes.dart';
import '../store/store.dart';

///Check if you are logged in
class RouteAuthMiddleware extends GetMiddleware {
  // priority Smaller numbers have higher priority
  @override
  int? priority = 0;

  RouteAuthMiddleware({required this.priority});

  @override
  RouteSettings? redirect(String? route) {
    if (UserStore.to.isLogin ||
        route == AppRoutes.SIGN_IN ||
        route == AppRoutes.INITIAL) {
      return null;
    } else {
      Future.delayed(
        const Duration(seconds: 2),
        () => Get.snackbar(
          "Tips",
          "Login expired, please login again!",
        ),
      );
      return const RouteSettings(name: AppRoutes.SIGN_IN);
    }
  }
}
