import 'dart:convert';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:chatty/common/store/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../common/apis/apis.dart';
import '../../../common/entities/entities.dart';
import '../../../common/values/values.dart';
import 'index.dart';

class VoiceCallController extends GetxController {
  VoiceCallController();
  final state = VoiceCallState();
  final player = AudioPlayer();
  String appID = APPID;
  final db = FirebaseFirestore.instance;
  // ignore: non_constant_identifier_names
  final profile_token = UserStore();
  late final RtcEngine engine;

  @override
  void onInit() {
    super.onInit();
    var data = Get.parameters;
    state.to_name.value = data['to_name'] ?? '';
    state.to_avatar.value = data['to_avatar'] ?? '';
    state.call_role.value = data['call_role'] ?? '';

    if (kDebugMode) {
      print('...your name is ${state.to_name.value}');
    }
    initEngine();
  }

  Future<void> initEngine() async {
    await player.setAsset('assets/Sound_Horizon.mp3');

    engine = createAgoraRtcEngine();
    await engine.initialize(
      RtcEngineContext(appId: appID),
    );
    engine.registerEventHandler(
      RtcEngineEventHandler(
        onError: (ErrorCodeType err, String msg) {
          if (kDebugMode) {
            print('...[onError] err: $err,,msg:$msg');
          }
        },
        onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
          if (kDebugMode) {
            print('...onConnection ${connection.toJson()}');
          }
          state.isJoined.value = true;
        },
        onUserJoined:
            (RtcConnection connection, int remoteUid, int elapsed) async {
          await player.pause();
        },
        onLeaveChannel: (RtcConnection connection, RtcStats stats) {
          if (kDebugMode) {
            print('...user left the room');
//            print('my stats ${stats.toJson()}');
          }
          state.isJoined.value = false;
        },
        onRtcStats: (RtcConnection connection, stats) {
          if (kDebugMode) {
            print('...time....');
            print(stats.duration);
          }
        },
      ),
    );
    await engine.enableAudio();
    await engine.setClientRole(role: ClientRoleType.clientRoleBroadcaster);
    await engine.setAudioProfile(
      profile: AudioProfileType.audioProfileDefault,
      scenario: AudioScenarioType.audioScenarioGameStreaming,
    );
    await joinChannel();
    if (state.call_role.value == 'anchor') {
      //send notification to other user
      await player.play();
    }
  }

  Future<String> getToken() async {
    if (state.call_role.value == 'anchor') {
      state.channelId.value = md5
          .convert(utf8.encode('${profile_token}_${state.to_token}'))
          .toString();
    } else {
      state.channelId.value = md5
          .convert(utf8.encode('${state.to_token}_$profile_token'))
          .toString();
    }
    CallTokenRequestEntity callTokenRequestEntity = CallTokenRequestEntity();
    callTokenRequestEntity.channel_name = state.channelId.value;
    if (kDebugMode) {
      print('...channel id is ${state.channelId.value}');
    }
    var res = await ChatAPI.call_token(params: callTokenRequestEntity);
    if (res.code == 0) {
      return res.data!;
    }
    return '';
  }

  Future<void> joinChannel() async {
    await Permission.microphone.request();
    EasyLoading.show(
      indicator: const CircularProgressIndicator(),
      maskType: EasyLoadingMaskType.clear,
      dismissOnTap: true,
    );

    String token = await getToken();

    await engine.joinChannel(
      token:
          '007eJxTYHA5+THMTuqE4panP01nO7dH2/UdCPdZ76BidMLDbJJGRZ0CQ7JBknmSuWmSsYWZsYmJSUqieapJYmpqiqWxuaWhYYpJwny71IZARoaNb8QYGKEQxBdgqEjMKklJKUpNqyjLyE3Jy2ZgAACW/SNW',
      channelId: 'xajtddrefxvhmdnk',
      uid: 0,
      options: const ChannelMediaOptions(
        clientRoleType: ClientRoleType.clientRoleBroadcaster,
      ),
    );
    EasyLoading.dismiss();
  }

  Future<void> leaveChannel() async {
    EasyLoading.show(
      indicator: const CircularProgressIndicator(),
      maskType: EasyLoadingMaskType.clear,
      dismissOnTap: true,
    );
    await player.pause();
    state.isJoined.value = false;
    EasyLoading.dismiss();
    Get.back();
  }

  Future<void> _dispose() async {
    await player.pause();
    await engine.leaveChannel();
    await engine.release();
    await player.stop();
    super.dispose();
  }

  @override
  void onClose() {
    _dispose();
    super.onClose();
  }

  @override
  void dispose() {
    _dispose();
    super.dispose();
  }
}
