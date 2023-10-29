// ignore_for_file: non_constant_identifier_names

import 'package:chatty/common/entities/entities.dart';
import 'package:chatty/common/store/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

import '../../common/apis/contact.dart';
import 'state.dart';

class ContactController extends GetxController {
  ContactController();
  final title = 'Chatty .';
  final state = ContactState();
  final token = UserStore.to.profile.token;
  final db = FirebaseFirestore.instance;

  @override
  void onReady() {
    super.onReady();
    asyncLoadAllData();
  }

 
 Future<void> goChat(ContactItem contactItem) async {
    var from_messages = await db
        .collection('message')
        .withConverter(
          fromFirestore: Msg.fromFirestore,
          toFirestore: (Msg msg, options) => msg.toFirestore(),
        )
        .where('from_token', isEqualTo: token)
        .where('to_token', isEqualTo: contactItem.token)
        .get();

    if (kDebugMode) {
      print('...from_messages ${from_messages.docs.isNotEmpty}');
    }

    var to_messages = await db
        .collection('message')
        .withConverter(
          fromFirestore: Msg.fromFirestore,
          toFirestore: (Msg msg, options) => msg.toFirestore(),
        )
        .where('from_token', isEqualTo: contactItem.token)
        .where('to_token', isEqualTo: token)
        .get();

    if (kDebugMode) {
      print('...to_messages ${to_messages.docs.isNotEmpty}');
    }

    if (from_messages.docs.isEmpty && to_messages.docs.isEmpty) {
      var profile = UserStore.to.profile;
      var msgdata = Msg(
        from_token: profile.token,
        to_token: contactItem.token,
        from_name: profile.name,
        to_name: contactItem.name,
        from_avatar: profile.avatar,
        to_avatar: contactItem.avatar,
        from_online: profile.online,
        to_online: contactItem.online,
        last_msg: '',
        last_time: Timestamp.now(),
        msg_num: 0,
      );

      var doc_id = await db
          .collection('message')
          .withConverter(
              fromFirestore: Msg.fromFirestore,
              toFirestore: (Msg msg, options) => msg.toFirestore())
          .add(msgdata);

      Get.offAllNamed('/chat', parameters: {
        'doc_id': doc_id.id,
        'to_token': contactItem.token ?? '',
        'to_name': contactItem.name ?? '',
        'to_avatar': contactItem.avatar ?? '',
        'to_online': contactItem.online.toString(),
      });

      if (kDebugMode) {
        print('...creating new document and adding user info done....');
      }
    } else {
      if (kDebugMode) {
        print('...users are older...');
      }
    }
  }
  
  asyncLoadAllData() async {
    EasyLoading.show(
      indicator: const CircularProgressIndicator(),
      maskType: EasyLoadingMaskType.clear,
      dismissOnTap: true,
    );
    state.contactList.clear();
    var result = await ContactAPI.post_contact();
    if (kDebugMode) {
      print('$asyncLoadAllData: $result.data!');
    }
    if (result.code == 0) {
      state.contactList.addAll(result.data!);
    }
    EasyLoading.dismiss();
  }
}