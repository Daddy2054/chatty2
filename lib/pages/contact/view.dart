import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../common/values/colors.dart';
import 'controller.dart';
import 'widgets/contact_list.dart';

class ContactPage extends GetView<ContactController> {
  const ContactPage({super.key});
  AppBar _buildAppBar() {
    return AppBar(
      title: Text(
        'Contact',
        style: TextStyle(
          color: AppColors.primaryText,
          fontSize: 16.sp,
          fontWeight: FontWeight.normal,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //   backgroundColor: AppColors.primaryElement,
      appBar: _buildAppBar(),
      body: SizedBox(
        width: 360.w,
        height: 780.h,
        child: const Center(
          child: ContactList(),
        ),
      ),
    );
  }
}
