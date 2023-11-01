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

//firebase data instance
  final db = FirebaseFirestore.instance;

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

  Future<void> sendMessage() async {
    String sendContent = myInputController.text;
    // if (kDebugMode) {
    //   print('...$sendContent...');
    // }
    if (sendContent.isEmpty) {
      toastInfo(msg: 'content is empty');
    }
//created an object to send to firebase
    final content = Msgcontent(
      token: token,
      content: sendContent,
      type: 'text',
      addtime: Timestamp.now(),
    );

    await db
        .collection('message')
        .doc(doc_id)
        .collection('msglist')
        .withConverter(
            fromFirestore: Msgcontent.fromFirestore,
            toFirestore: (Msgcontent msg, options) => msg.toFirestore())
        .add(content)
        .then((DocumentReference doc) {
      // if (kDebugMode) {
      //   print('...base id is $doc_id, new message doc id is ${doc.id}');
      // }
      myInputController.clear();
    });

    var messageResult = await db
        .collection('message')
        .doc(doc_id)
        .withConverter(
            fromFirestore: Msg.fromFirestore,
            toFirestore: (Msg msg, options) => msg.toFirestore())
        .get();

//to know if we have any unread messages or calls
    if (messageResult.data() != null) {
      var item = messageResult.data()!;
      int to_msg_num = item.to_msg_num == null ? 0 : item.to_msg_num!;
      int from_msg_num = item.from_msg_num == null ? 0 : item.from_msg_num!;
      if (item.from_token == token) {
        from_msg_num = from_msg_num + 1;
      } else {
        to_msg_num = to_msg_num + 1;
      }
      await db.collection('message').doc(doc_id).update({
        'to_msg_num': to_msg_num,
        'from_msg_num': from_msg_num,
        'last_msg': sendContent,
        'last_time':Timestamp.now(),
      });
    }
  }
}
