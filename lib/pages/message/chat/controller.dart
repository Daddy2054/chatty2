// ignore_for_file: non_constant_identifier_names

import 'dart:io';

import 'package:chatty/common/store/user.dart';
import 'package:chatty/common/widgets/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../common/apis/apis.dart';
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
  dynamic listener;
  var isLoadmore = true;
  File? _photo;
  final ImagePicker _picker = ImagePicker();
  ScrollController myScrollController = ScrollController();

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

  @override
  void onReady() {
    super.onReady();
    state.msgcontentList.clear();
    final messages = db
        .collection('message')
        .doc(doc_id)
        .collection('msglist')
        .withConverter(
          fromFirestore: Msgcontent.fromFirestore,
          toFirestore: (Msgcontent msg, options) => msg.toFirestore(),
        )
        .orderBy(
          'addtime',
          descending: true,
        )
        .limit(15);

    listener = messages.snapshots().listen((event) {
      List<Msgcontent> tempMsgList = <Msgcontent>[];
      for (var change in event.docChanges) {
        switch (change.type) {
          case DocumentChangeType.added:
            if (change.doc.data() != null) {
              tempMsgList.add(change.doc.data()!);
              // print('${change.doc.data()!}');
              // print('...newly added ${myInputController.text}');
            }
          case DocumentChangeType.modified:
          // TODO: Handle this case.
          case DocumentChangeType.removed:
          // TODO: Handle this case.
        }
      }
      for (var element in tempMsgList.reversed) {
        //state.msgcontentList.value.insert(0, element);
        state.msgcontentList.insert(0, element);
      }

      state.msgcontentList.refresh();
      SchedulerBinding.instance.addPostFrameCallback((_) {
        if (myScrollController.hasClients) {
          myScrollController.animateTo(
            //top to the very top of your list
            //lowest index is 0
            myScrollController.position.minScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    });

    myScrollController.addListener(() {
      if ((myScrollController.offset + 10) >
          (myScrollController.position.maxScrollExtent)) {
        if (isLoadmore) {
          state.isLoading.value = true;
          //to stop unnecessary request to firebase
          isLoadmore = false;
          asyncLoadMoreData();
          if (kDebugMode) {
            print("...loading...");
          }
        }
      }
    });
  }

  Future imgFromGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      _photo = File(pickedFile.path);
      uploadFile();
    } else {
      if (kDebugMode) {
        print('No image selected');
      }
    }
    return;
  }

  Future uploadFile() async {
    if (kDebugMode) {
      print("ok");
    }
    var result = await ChatAPI.upload_img(file: _photo);
    if (kDebugMode) {
      print(result.data);
    }
    if (result.code == 0) {
      sendImageMessage(result.data!);
    } else {
      toastInfo(msg: "sending image error");
    }
  }

  Future<void> asyncLoadMoreData() async {
    final messages = await db
        .collection("message")
        .doc(doc_id)
        .collection("msglist")
        .withConverter(
            fromFirestore: Msgcontent.fromFirestore,
            toFirestore: (Msgcontent msg, options) => msg.toFirestore())
        .orderBy("addtime", descending: true)
        .where(
          'addtime',
//          isLessThan: state.msgcontentList.value.last.addtime,
          isLessThan: state.msgcontentList.last.addtime,
        )
        .limit(10)
        .get();

    if (messages.docs.isNotEmpty) {
      for (var element in messages.docs) {
        var data = element.data();
        //    state.msgcontentList.value.add(data);
        state.msgcontentList.add(data);
      }
//      print(state.msgcontentList.value.length);
      if (kDebugMode) {
        print('msgcontentList.length: ${state.msgcontentList.length}');
      }
    }

    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      isLoadmore = true;
    });
    state.isLoading.value = false;
  }

  Future<void> sendImageMessage(String url) async {
    //created an object to send  to firebase
    final content = Msgcontent(
        token: token, content: url, type: "image", addtime: Timestamp.now());

    await db
        .collection("message")
        .doc(doc_id)
        .collection("msglist")
        .withConverter(
            fromFirestore: Msgcontent.fromFirestore,
            toFirestore: (Msgcontent msg, options) => msg.toFirestore())
        .add(content)
        .then((DocumentReference doc) {
      if (kDebugMode) {
        print("...base id is $doc_id..new image doc id is ${doc.id}");
      }
    });

    //collection().get().docs.data()
    var messageResult = await db
        .collection("message")
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
      await db.collection("message").doc(doc_id).update({
        "to_msg_num": to_msg_num,
        "from_msg_num": from_msg_num,
        "last_msg": "【image】",
        "last_time": Timestamp.now(),
      });
    }
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
        'last_time': Timestamp.now(),
      });
    }
  }

  @override
  void onClose() {
    super.onClose();
    listener.cancel();
    myInputController.dispose();
    myScrollController.dispose();
  }

  void closeAllPop() async {
    Get.focusScope?.unfocus();
    state.more_status.value = false;
  }
}
