import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../common/values/colors.dart';
import 'controller.dart';

class ChatPage extends GetView<ChatController> {
  const ChatPage({super.key});

  AppBar _buildAppBar() {
    return AppBar(
      title: Obx(() {
        return Text(
          '${controller.state.to_name}',
          overflow: TextOverflow.clip,
          maxLines: 1,
          style: TextStyle(
            fontFamily: 'Avenir',
            fontWeight: FontWeight.bold,
            color: AppColors.primaryText,
            fontSize: 16.sp,
          ),
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
    );
  }
}
