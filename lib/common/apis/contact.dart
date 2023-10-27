// ignore_for_file: non_constant_identifier_names

import '../entities/entities.dart';
import '../utils/utils.dart';

class ContactAPI {
  /// contact page
  /// get all contact of users info
  static Future<ContactResponseEntity> post_contact() async {
    var response = await HttpUtil().post(
      'api/contact',
    );
    return ContactResponseEntity.fromJson(response);
  }


}
