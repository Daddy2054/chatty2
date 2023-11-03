import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../common/routes/routes.dart';
import '../../common/values/colors.dart';
import 'index.dart';

class MessagePage extends GetView<MessageController> {
  const MessagePage({super.key});

  Widget _headBar() {
    return Center(
      child: Container(
        width: 320.w,
        height: 44.h,
        margin: EdgeInsets.only(
          bottom: 20.h,
          top: 20.h,
        ),
        child: Row(
          children: [
            Stack(
              children: [
                GestureDetector(
                  child: Container(
                    width: 44.h,
                    height: 44.h,
                    decoration: BoxDecoration(
                      color: AppColors.primarySecondaryBackground,
                      borderRadius: BorderRadius.all(Radius.circular(22.h)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.red.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 20,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                    child: controller.state.head_detail.value.avatar == null
                        ? Image.asset('assets/images/account_header.png')
                        : CachedNetworkImage(
                            imageUrl:
                                controller.state.head_detail.value.avatar!,
                            height: 44.h,
                            width: 44.w,
                            imageBuilder: (context, imageProvider) => Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(
                                    22.w,
                                  ),
                                ),
                                image: DecorationImage(
                                  image: imageProvider,
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                            errorWidget: (context, url, error) => const Image(
                              image: AssetImage(
                                'assets/images/account_header.png',
                              ),
                            ),
                          ),
                  ),
                  onTap: () {
                    controller.goProfile();
                  },
                ),
                Positioned(
                  bottom: 5.w,
                  right: 0.w,
                  height: 14.w,
                  child: Container(
                    width: 14.w,
                    height: 14.w,
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 2.w,
                        color: AppColors.primaryElementText,
                      ),
                      color: AppColors.primaryElementStatus,
                      borderRadius: BorderRadius.all(
                        Radius.circular(
                          12.w,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _headTabs() {
    return Container(
      height: 70,
      width: 300,
      color: Colors.red,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () => SafeArea(
          child: Stack(
            children: [
              CustomScrollView(
                slivers: [
                  SliverAppBar(
                    pinned: true,
                    title: _headBar(),
                  ),
                  SliverPadding(
                    padding: EdgeInsets.symmetric(
                      vertical: 0.w,
                      horizontal: 0.w,
                    ),
                    sliver: SliverToBoxAdapter(
                      child: _headTabs(),
                    ),
                  ),
                ],
              ),
              Positioned(
                right: 20.w,
                bottom: 70.w,
                height: 50.w,
                width: 50.w,
                child: GestureDetector(
                  onTap: () {
                    Get.toNamed(AppRoutes.Contact);
                  },
                  child: Container(
                    height: 50.w,
                    width: 50.w,
                    padding: EdgeInsets.all(10.w),
                    decoration: BoxDecoration(
                      color: AppColors.primaryElement,
                      borderRadius: BorderRadius.all(
                        Radius.circular(40.w),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 2,
                          blurRadius: 2,
                          offset: const Offset(1, 1),
                        ),
                      ],
                    ),
                    child: Image.asset('assets/icons/contact.png'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
