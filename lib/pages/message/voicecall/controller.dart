import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:chatty/common/store/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';

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

    if (kDebugMode) {
      print('...your name is ${state.to_name.value}');
    }
  }

  Future<void> initengine() async {
    await player.setAsset('assets/Sound_Horison.mp3');

    engine = createAgoraRtcEngine();
    await engine.initialize(
      RtcEngineContext(appId: appID),
    );
    engine.registerEventHandler(
      RtcEngineEventHandler(
        onError: (ErrorCodeType err, String msg) {
          if (kDebugMode) {
            print('[onError] err: $err,,msg:$msg');
          }
        },
        onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
          if (kDebugMode) {
            print('onConnection ${connection.toJson()}');
          }
          state.isJoined.value = true;
        },
        onUserJoined:
            (RtcConnection connection, int remoteUid, int elapsed) async {
          await player.pause();
        },
      ),
    );
  }
}
