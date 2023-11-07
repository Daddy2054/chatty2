import 'package:chatty/pages/profile/widgets/profile_widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controller.dart';

class ProfilePage extends GetView<ProfileController> {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppbar(),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  buildProfilePhoto(controller,context),
                  buildName(
                    controller,
                    (value) {
                      controller.state.profile_detail.value.name = value;
                    },
                    controller.state.profile_detail.value.name ?? "",
                  ),
                  buildDescription(
                    controller,
                    (value) {
                      controller.state.profile_detail.value.description = value;
                    },
                    controller.state.profile_detail.value.description ??
                        "Enter a description. ",
                  ),
                  buildCompleteBtn(controller),
                  buildLogoutBtn(controller),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
