import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatty/pages/message/chat/widgets/chat_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../common/values/colors.dart';
import 'controller.dart';

class ChatPage extends GetView<ChatController> {
  const ChatPage({super.key});

  AppBar _buildAppBar() {
    return AppBar(
      title: Obx(
        () {
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
        },
      ),
      actions: [
        Container(
          margin: EdgeInsets.only(right: 20.w),
          child: Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 44.w,
                height: 44.h,
                child: CachedNetworkImage(
                  imageUrl: controller.state.to_avatar.value,
                  imageBuilder: (context, imageProvider) => Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(22.w),
                      image: DecorationImage(image: imageProvider),
                    ),
                  ),
                  errorWidget: (context, url, error) => const Image(
                    image: AssetImage('assets/images/account_header.png'),
                  ),
                ),
              ),
              Positioned(
                bottom: 5.w,
                right: 0.w,
                height: 14.w,
                child: Container(
                  width: 14.w,
                  height: 14.h,
                  decoration: BoxDecoration(
                    color: controller.state.to_online.value == '1'
                        ? AppColors.primaryElementStatus
                        : AppColors.primarySecondaryElementText,
                    borderRadius: BorderRadius.circular(12.w),
                    border: Border.all(
                      width: 2,
                      color: AppColors.primaryElementText,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Obx(
        () => SafeArea(
          child: Stack(
            children: [
              const ChatList(),
              Positioned(
                bottom: 0.h,
                child: Container(
                  //    color: Colors.red,
                  width: 360.w,
                  padding: EdgeInsets.only(
                    left: 20.w,
                    bottom: 10.h,
                    right: 20.w,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 270.w,
                        padding: EdgeInsets.only(
                          top: 10.h,
                          bottom: 10.h,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primaryBackground,
                          border: Border.all(
                            color: AppColors.primarySecondaryElementText,
                          ),
                          borderRadius: BorderRadius.circular(
                            5.w,
                          ),
                        ),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 220.w,
                              child: TextField(
                                controller: controller.myInputController,
                                keyboardType: TextInputType.multiline,
                                autofocus: false,
                                decoration: InputDecoration(
                                  hintText: 'Message...',
                                  contentPadding: EdgeInsets.only(
                                    left: 15.w,
                                    top: 0,
                                    bottom: 0,
                                  ),
                                  // border: BorderSide.none,
                                  border: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.transparent,
                                    ),
                                  ),
                                  focusedBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.transparent,
                                    ),
                                  ),
                                  enabledBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.transparent,
                                    ),
                                  ),
                                  hintStyle: const TextStyle(
                                    color:
                                        AppColors.primarySecondaryElementText,
                                  ),
                                ),
                              ),
                            ),
                            GestureDetector(
                              child: SizedBox(
                                width: 40.w,
                                height: 40.w,
                                child: Image.asset('assets/icons/send.png'),
                              ),
                              onTap: () {
                                controller.sendMessage();
                              },
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          controller.goMore();
                        },
                        child: Container(
                          height: 40.w,
                          width: 40.h,
                          padding: EdgeInsets.all(8.w),
                          decoration: BoxDecoration(
                              color: AppColors.primaryElement,
                              borderRadius: BorderRadius.circular(40.w),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.2),
                                  spreadRadius: 2,
                                  blurRadius: 2,
                                  offset: const Offset(1, 1),
                                ),
                              ]),
                          child: Image.asset(
                            'assets/icons/add.png',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              controller.state.more_status.value
                  ? Positioned(
                      right: 20.w,
                      bottom: 70.w,
                      height: 200.h,
                      width: 40.w,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            child: Container(
                              height: 40.h,
                              width: 40.w,
                              padding: EdgeInsets.all(10.w),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(40.w),
                                color: AppColors.primaryBackground,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.2),
                                    spreadRadius: 2,
                                    blurRadius: 2,
                                    offset: const Offset(1, 1),
                                  ),
                                ],
                              ),
                              child: Image.asset(
                                'assets/icons/file.png',
                              ),
                            ),
                            onTap: () {},
                          ),
                          GestureDetector(
                            child: Container(
                              height: 40.h,
                              width: 40.w,
                              padding: EdgeInsets.all(10.w),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(40.w),
                                color: AppColors.primaryBackground,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.2),
                                    spreadRadius: 2,
                                    blurRadius: 2,
                                    offset: const Offset(1, 1),
                                  ),
                                ],
                              ),
                              child: Image.asset(
                                'assets/icons/photo.png',
                              ),
                            ),
                            onTap: () {
                              controller.imgFromGallery();
                            },
                          ),
                          GestureDetector(
                            child: Container(
                              height: 40.h,
                              width: 40.w,
                              padding: EdgeInsets.all(10.w),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(40.w),
                                color: AppColors.primaryBackground,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.2),
                                    spreadRadius: 2,
                                    blurRadius: 2,
                                    offset: const Offset(1, 1),
                                  ),
                                ],
                              ),
                              child: Image.asset(
                                'assets/icons/call.png',
                              ),
                            ),
                            onTap: () {
                              controller.audioCall();
                            },
                          ),
                          GestureDetector(
                            child: Container(
                              height: 40.h,
                              width: 40.w,
                              padding: EdgeInsets.all(10.w),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(40.w),
                                color: AppColors.primaryBackground,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.2),
                                    spreadRadius: 2,
                                    blurRadius: 2,
                                    offset: const Offset(1, 1),
                                  ),
                                ],
                              ),
                              child: Image.asset(
                                'assets/icons/video.png',
                              ),
                            ),
                            onTap: () {},
                          ),
                        ],
                      ),
                    )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }
}
