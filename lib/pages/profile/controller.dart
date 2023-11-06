import 'package:chatty/common/apis/apis.dart';
import 'package:chatty/common/entities/entities.dart';
import 'package:chatty/common/widgets/toast.dart';
import 'package:chatty/pages/profile/state.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../common/store/user.dart';

class ProfileController extends GetxController {
  ProfileController();

  final title = "Chatty .";
  final state = ProfileState();
  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  @override
  void onInit() {
    super.onInit();
    var userItem = Get.arguments;
    if (userItem != null) {
      state.profile_detail.value = userItem;
    }
  }

  Future<void> goLogout() async {
    await GoogleSignIn().signOut();
    await UserStore.to.onLogout();
  }

  Future<void> goSave() async {
    if (state.profile_detail.value.name == null ||
        state.profile_detail.value.name!.isEmpty) {
      toastInfo(msg: "Name can not be empty");
      return;
    }
    if (state.profile_detail.value.description == null ||
        state.profile_detail.value.description!.trim().isEmpty) {
      toastInfo(msg: "Description can not be empty");
      return;
    }

    LoginRequestEntity loginRequestEntity = LoginRequestEntity();
    var userItem = state.profile_detail.value;
    loginRequestEntity.avatar = userItem.avatar;
    loginRequestEntity.name = userItem.name;
    loginRequestEntity.description = userItem.description;
    loginRequestEntity.online = userItem.online ?? 0;
    print('online status ${loginRequestEntity.online}');
    var result = await UserAPI.UpdateProfile(params: loginRequestEntity);
    if (result.code == 0) {
      UserItem userItem = state.profile_detail.value;
      await UserStore.to.saveProfile(userItem);
      Get.back(result: 'finish');
    } else {
      print('${result.msg}');
    }
  }
}
