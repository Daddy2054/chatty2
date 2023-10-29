import 'package:chatty/common/values/colors.dart';
import 'package:chatty/pages/message/voicecall/controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class VoiceCallPage extends GetView<VoiceCallController> {
  const VoiceCallPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary_bg,
      body: SafeArea(
        child: Obx(
          () => Container(
            child: Stack(
              children: [
                Positioned(
                  top: 10.h,
                  left: 30.w,
                  right: 30.w,
                  child: Column(
                    children: [
                      Container(
                        child: Text(
                          controller.state.callTime.value,
                          style: TextStyle(
                            color: AppColors.primaryElementText,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
