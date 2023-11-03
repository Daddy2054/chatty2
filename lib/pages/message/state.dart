import 'package:get/get.dart';

import '../../common/entities/entities.dart';

class MessageState {
  // ignore: non_constant_identifier_names
  var head_detail = UserItem().obs;
  RxBool tabStatus = true.obs;
  RxList<Message> msgList = <Message>[].obs;
}
