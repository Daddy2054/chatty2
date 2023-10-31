// ignore_for_file: non_constant_identifier_names

import 'package:chatty/common/store/user.dart';
import 'package:chatty/common/widgets/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/entities/entities.dart';
import '../../../common/routes/routes.dart';
import 'index.dart';

class ChatController extends GetxController {
  ChatController();

  final state = ChatState();

  late String doc_id;
  final myInputController = TextEditingController();
  //get the user or sender's token
  final token = UserStore.to.profile.token;

  void goMore() {
    state.more_status.value = !state.more_status.value;
  }

  void audioCall() {
    state.more_status.value = false;
    Get.toNamed(AppRoutes.VoiceCall, parameters: {
      'to_token': state.to_token.value,
      "to_name": state.to_name.value,
      'to_avatar': state.to_avatar.value,
      'call_role': 'anchor',
      'doc_id': doc_id,
    });
  }

  @override
  void onInit() {
    super.onInit();
    var data = Get.parameters;
    if (kDebugMode) {
      print(data);
    }
    doc_id = data['doc_id']!;
    state.to_token.value = data['to_token'] ?? '';
    state.to_name.value = data['to_name'] ?? '';
    state.to_avatar.value = data['to_avatar'] ?? '';
    state.to_online.value = data['to_online'] ?? '1';
  }

  void sendMessage() {
    String sendContent = myInputController.text;
    print('...$sendContent...');
    if (sendContent.isEmpty) {
      toastInfo(msg: 'content is empty');
    }

    Msgcontent(
      token: token,
      content: sendContent,
      type: 'text',
      addtime: Timestamp.now(),
    );
  }
}
