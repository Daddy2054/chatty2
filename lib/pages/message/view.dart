import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../common/entities/entities.dart';
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
    return Center(
      child: Container(
          height: 48,
          width: 350,
          decoration: const BoxDecoration(
            color: AppColors.primarySecondaryBackground,
            borderRadius: BorderRadius.all(
              Radius.circular(5),
            ),
          ),
          padding: EdgeInsets.all(4.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () => controller.goTabStatus(),
                child: Container(
                  width: 155.w,
                  height: 40.h,
                  decoration: controller.state.tabStatus.value
                      ? BoxDecoration(
                          color: AppColors.primaryBackground,
                          borderRadius: const BorderRadius.all(
                            Radius.circular(5),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              spreadRadius: 2,
                              blurRadius: 3,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        )
                      : const BoxDecoration(),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Chat',
                        style: TextStyle(
                          color: AppColors.primaryThreeElementText,
                          fontWeight: FontWeight.normal,
                          fontSize: 14.sp,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () => controller.goTabStatus(),
                child: Container(
                  width: 155.w,
                  height: 40.h,
                  decoration: controller.state.tabStatus.value
                      ? const BoxDecoration()
                      : BoxDecoration(
                          color: AppColors.primaryBackground,
                          borderRadius: const BorderRadius.all(
                            Radius.circular(5),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              spreadRadius: 2,
                              blurRadius: 3,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Call',
                        style: TextStyle(
                          color: AppColors.primaryThreeElementText,
                          fontWeight: FontWeight.normal,
                          fontSize: 14.sp,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          )),
    );
  }

  Widget _chatListItem(Message item) {
    return Container(
      padding: EdgeInsets.only(top: 10.h, left: 0.w, right: 0.w, bottom: 10.h,),
      child: InkWell(
        onTap: () {
          if (item.doc_id != null) {
            Get.toNamed("/chat", parameters: {
              "doc_id": item.doc_id!,
              "to_token": item.token!,
              "to_name": item.name!,
              "to_avatar": item.avatar!,
              "to_online": item.online.toString(),
            });
          }
        },
        child: Row(
          children: [
            Container(
              width: 44.h,
              height: 44.h,
              margin: EdgeInsets.only(top: 0.h, left: 0.w, right: 10.w,),
              decoration: BoxDecoration(
                  color: AppColors.primarySecondaryBackground,
                  borderRadius: BorderRadius.all(Radius.circular(22.h)),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 2,
                        offset: const Offset(0, 1))
                  ]),
              child: item.avatar == null
                  ? const Image(
                      image: AssetImage("assets/images/account_header.png"),
                    )
                  : CachedNetworkImage(
                      imageUrl: item.avatar!,
                      height: 44.w,
                      width: 44.w,
                      imageBuilder: (context, imageProvider) => Container(
                        decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(22.w)),
                            image: DecorationImage(
                                image: imageProvider, fit: BoxFit.fill)),
                      ),
                      errorWidget: (context, url, error) => const Image(
                        image: AssetImage('assets/images/account_header.png'),
                      ),
                    ),
            ),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 175.w,
                    height: 44.w,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${item.name}",
                          overflow: TextOverflow.clip,
                          maxLines: 1,
                          softWrap: false,
                          style: TextStyle(
                              fontFamily: "Avenir",
                              fontWeight: FontWeight.bold,
                              color: AppColors.thirdElement,
                              fontSize: 14.sp,),
                        ),
                        Text(
                          "${item.last_msg}",
                          overflow: TextOverflow.clip,
                          maxLines: 1,
                          softWrap: false,
                          style: TextStyle(
                              fontFamily: "Avenir",
                              fontWeight: FontWeight.normal,
                              color: AppColors.primarySecondaryElementText,
                              fontSize: 12.sp,),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 86.w,
                    height: 44.w,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '',
                          // item.last_time==null?""
                          //     :duTimeLineFormat((item.last_time as Timestamp).toDate()),
                          maxLines: 1,
                          softWrap: false,
                          style: TextStyle(
                              fontFamily: "Avenir",
                              fontWeight: FontWeight.normal,
                              color: AppColors.primaryElementText,
                              fontSize: 11.sp),
                        ),
                        item.msg_num == 0
                            ? Container()
                            : Container(
                                decoration: const BoxDecoration(
                                    color: Colors.red,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                padding: EdgeInsets.only(
                                  left: 4.w,
                                  right: 4.w,
                                ),
                                child: Text(
                                  "${item.msg_num}",
                                  maxLines: 1,
                                  softWrap: false,
                                  style: TextStyle(
                                      fontFamily: "Avenir",
                                      fontWeight: FontWeight.normal,
                                      color: AppColors.primaryElementText,
                                      fontSize: 11.sp),
                                ),
                              )
                      ],
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
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
                  SliverPadding(
                    padding: EdgeInsets.symmetric(
                      vertical: 0.w,
                      horizontal: 20.w,
                    ),
                    sliver: controller.state.tabStatus.value
                        ? SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (context, index) {
                                var item = controller.state.msgList[index];
                                return _chatListItem(item);
                              },
                              childCount: controller.state.msgList.length,
                            ),
                          )
                        : SliverToBoxAdapter(
                            child: Container(),
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
