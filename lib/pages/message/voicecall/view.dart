import 'package:chatty/common/values/colors.dart';
import 'package:chatty/pages/message/voicecall/controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class VoiceCallPage extends GetView<VoiceCallController> {
  const VoiceCallPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary_bg,
      body: Obx(
        () => Container(
          child: Stack(
            children: [
              Positioned(
                child: Column(
                  children: [
                    Container(
                      child: Text(controller.state.callTime.value),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
