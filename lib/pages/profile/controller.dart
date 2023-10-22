import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';

import '../../common/apis/apis.dart';
import '../../common/entities/entities.dart';
import '../../common/store/store.dart';
import '../../common/widgets/toast.dart';
import 'index.dart';

class ProfileController extends GetxController {
  final state = ProfileState();
  TextEditingController? nameEditingController = TextEditingController();
  TextEditingController? descriptionEditingController = TextEditingController();
  File? _photo;
  final ImagePicker _picker = ImagePicker();
  ProfileController();

  goSave() async {
    if (state.profile_detail.value.name == null ||
        state.profile_detail.value.name!.isEmpty) {
      toastInfo(msg: "name not empty!");
      return;
    }
    if (state.profile_detail.value.description == null ||
        state.profile_detail.value.description!.isEmpty) {
      toastInfo(msg: "description not empty!");
      return;
    }
    if (state.profile_detail.value.avatar == null ||
        state.profile_detail.value.avatar!.isEmpty) {
      toastInfo(msg: "avatar not empty!");
      return;
    }

    LoginRequestEntity updateProfileRequestEntity = LoginRequestEntity();
    var userItem = state.profile_detail.value;
    updateProfileRequestEntity.avatar = userItem.avatar;
    updateProfileRequestEntity.name = userItem.name;
    updateProfileRequestEntity.description = userItem.description;
    updateProfileRequestEntity.online = userItem.online;

    var result =
        await UserAPI.UpdateProfile(params: updateProfileRequestEntity);
    if (kDebugMode) {
      print(result.code);
      print(result.msg);
    }
    if (result.code == 0) {
      UserItem userItem = state.profile_detail.value;
      await UserStore.to.saveProfile(userItem);
      Get.back(result: "finish");
    }
  }

  goLogout() async {
    await GoogleSignIn().signOut();
    await UserStore.to.onLogout();
  }

  Future imgFromGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      _photo = File(pickedFile.path);
      uploadFile();
    } else {
      if (kDebugMode) {
        print('No image selected.');
      }
    }
  }

  Future imgFromCamera() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      _photo = File(pickedFile.path);
      uploadFile();
    } else {
      if (kDebugMode) {
        print('No image selected.');
      }
    }
  }

  Future uploadFile() async {
    // if (_photo == null) return;
    // print(_photo);
    var result = await ChatAPI.upload_img(file: _photo);
    if (kDebugMode) {
      print(result.data);
    }
    if (result.code == 0) {
      state.profile_detail.value.avatar = result.data;
      state.profile_detail.refresh();
    } else {
      toastInfo(msg: "image error");
    }
  }

  asyncLoadAllData() async {
    // await
  }

  @override
  void onInit() {
    super.onInit();
    var userItem = Get.arguments;
    if (userItem != null) {
      state.profile_detail.value = userItem;
      if (state.profile_detail.value.name != null) {
        nameEditingController?.text = state.profile_detail.value.name!;
      }
      if (state.profile_detail.value.description != null) {
        descriptionEditingController?.text =
            state.profile_detail.value.description!;
      }
    }
  }

  // @override
  // void onReady() {
  //   super.onReady();
  // }

  // @override
  // void dispose() {
  //   super.dispose();
  // }
}
