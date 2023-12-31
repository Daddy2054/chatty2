import 'package:chatty/common/values/values.dart';
import 'package:chatty/pages/message/chat/index.dart';
import 'package:chatty/pages/message/chat/widgets/chat_left_list.dart';
import 'package:chatty/pages/message/chat/widgets/chat_right_list.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ChatList extends GetView<ChatController> {
  const ChatList({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Container(
        color: AppColors.primaryBackground,
        padding: EdgeInsets.only(
          bottom: 70.h,
        ),
        child: GestureDetector(
          onTap: () {
            controller.closeAllPop();
          },
          child: CustomScrollView(
            controller: controller.myScrollController,
            reverse: true,
            slivers: [
              SliverToBoxAdapter(
                child: Container(),
              ),
              SliverPadding(
                padding: EdgeInsets.symmetric(
                  vertical: 0.w,
                  horizontal: 0.w,
                ),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      var item = controller.state.msgcontentList[index];
                      if (controller.token == item.token) {
                        //user token with msglist token
                        return chatRightList(item);
                      }
                      return chatLeftList(item);
                    },
                    childCount: controller.state.msgcontentList.length,
                  ),
                ),
              ),
              SliverPadding(
                padding: EdgeInsets.symmetric(
                  vertical: 0.w,
                  horizontal: 0.w,
                ),
                sliver: SliverToBoxAdapter(
                  child: controller.state.isLoading.value
                      ? const Align(
                          alignment: Alignment.center,
                          child: Text('loading...'),
                        )
                      : Container(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
