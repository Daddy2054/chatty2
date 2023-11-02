import 'package:chatty/common/entities/entities.dart';
import 'package:flutter/widgets.dart';

Widget ChatRightList(Msgcontent item) {
  return Container(
    child: Text(item.content!),
  );
}
