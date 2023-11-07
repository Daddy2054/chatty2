import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../common/values/colors.dart';
import '../controller.dart';

AppBar buildAppbar() {
  return AppBar(
    title: Text(
      "Profile",
      style: TextStyle(
          color: AppColors.primaryText,
          fontSize: 16.sp,
          fontWeight: FontWeight.normal),
    ),
  );
}

Widget buildProfilePhoto(ProfileController controller, BuildContext context) {
  return Stack(
    alignment: Alignment.center,
    children: [
      Container(
        width: 120.w,
        height: 120.w,
        decoration: BoxDecoration(
            color: AppColors.primarySecondaryBackground,
            borderRadius: BorderRadius.all(Radius.circular(60.w)),
            boxShadow: [
              BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 2,
                  offset: const Offset(0, 1))
            ]),
        child: controller.state.profile_detail.value.avatar != null
            ? CachedNetworkImage(
                imageUrl: controller.state.profile_detail.value.avatar!,
                height: 120.w,
                width: 120.w,
                imageBuilder: (context, imageProvider) => Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(60.w)),
                      image: DecorationImage(
                          image: imageProvider, fit: BoxFit.fill)),
                ),
                errorWidget: (context, url, error) => const Image(
                  image: AssetImage('assets/images/account_header.png'),
                ),
              )
            : Image(
                width: 120.w,
                height: 120.h,
                fit: BoxFit.cover,
                image: const AssetImage("assets/images/account_header.png"),
              ),
      ),
      Positioned(
        bottom: 0.w,
        right: 0.w,
        height: 35.w,
        child: GestureDetector(
          onTap: () {
            _showPicker(context, controller);
          },
          child: Container(
            height: 35.w,
            width: 35.w,
            padding: EdgeInsets.all(7.w),
            decoration: BoxDecoration(
              color: AppColors.primaryElement,
              borderRadius: BorderRadius.all(
                Radius.circular(40.w),
              ),
            ),
            child: Image.asset("assets/icons/edit.png"),
          ),
        ),
      ),
    ],
  );
}

void _showPicker(BuildContext context, controller) {
  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) => SafeArea(
      child: Wrap(
        children: [
          ListTile(
            leading: const Icon(Icons.photo_library),
            title: const Text('Gallery'),
            onTap: () {
              controller.imgFromGallery();
            },
          ),
          ListTile(
            leading: const Icon(Icons.photo_camera),
            title: const Text('Camera'),
            onTap: () {
              controller.imgFromCamera();
            },
          ),
        ],
      ),
    ),
  );
}

Widget buildCompleteBtn(ProfileController controller) {
  return GestureDetector(
    onTap: () {
      controller.goSave();
    },
    child: Container(
      width: 295.w,
      height: 44.h,
      margin: EdgeInsets.only(top: 60.h, bottom: 30.h),
      decoration: BoxDecoration(
        color: AppColors.primaryElement,
        borderRadius: const BorderRadius.all(
          Radius.circular(5),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Complete",
            style: TextStyle(
                color: AppColors.primaryElementText,
                fontSize: 14.sp,
                fontWeight: FontWeight.normal),
          ),
        ],
      ),
    ),
  );
}

Widget buildLogoutBtn(ProfileController controller) {
  return GestureDetector(
    child: Container(
      width: 295.w,
      height: 44.h,
      margin: EdgeInsets.only(top: 0.h, bottom: 30.h),
      decoration: BoxDecoration(
          color: AppColors.primarySecondaryElementText,
          borderRadius: const BorderRadius.all(Radius.circular(5)),
          boxShadow: [
            BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 2,
                offset: const Offset(0, 1))
          ]),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Logout",
            style: TextStyle(
                color: AppColors.primaryElementText,
                fontSize: 14.sp,
                fontWeight: FontWeight.normal),
          ),
        ],
      ),
    ),
    onTap: () {
      Get.defaultDialog(
          title: "Are you sure to log out?",
          content: Container(),
          textConfirm: "Confirm",
          textCancel: "Cancel",
          confirmTextColor: Colors.white,
          onConfirm: () {
            controller.goLogout();
          },
          onCancel: () {
            if (kDebugMode) {
              print(" it's canceled ");
            }
          });
    },
  );
}

Widget buildName(
  ProfileController controller,
  void Function(String value)? func,
  String text,
) {
  return Container(
    width: 295.w,
    height: 44.h,
    decoration: BoxDecoration(
      color: AppColors.primaryBackground,
      borderRadius: BorderRadius.all(Radius.circular(5.w)),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.1),
          spreadRadius: 1,
          blurRadius: 2,
          offset: const Offset(0, 1),
        ),
      ],
    ),
    margin: EdgeInsets.only(bottom: 20.h, top: 60.h),
    child: _profileTextField(
      controller,
      controller.nameController,
      func,
      text,
    ),
  );
}

Widget buildDescription(
  ProfileController controller,
  void Function(String value)? func,
  String text,
) {
  return Container(
    width: 295.w,
    height: 44.h,
    decoration: BoxDecoration(
      color: AppColors.primaryBackground,
      borderRadius: BorderRadius.all(Radius.circular(5.w)),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.1),
          spreadRadius: 1,
          blurRadius: 2,
          offset: const Offset(0, 1),
        ),
      ],
    ),
    margin: EdgeInsets.only(bottom: 20.h, top: 0.h),
    child: _profileTextField(
      controller,
      controller.descriptionController,
      func,
      text,
    ),
  );
}

Widget _profileTextField(
  ProfileController controller,
  TextEditingController textEditingController,
  void Function(String value)? func,
  String text,
) {
  return TextField(
    onChanged: (value) => func!(value),
    controller: textEditingController,
    maxLines: null,
    keyboardType: TextInputType.multiline,
    autofocus: false,
    decoration: InputDecoration(
      hintText: text.trim(),
      contentPadding: EdgeInsets.only(
        left: 15.w,
        top: 0,
        bottom: 0,
      ),
      border: const OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.transparent,
        ),
      ),
      enabledBorder: const OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.transparent,
        ),
      ),
      disabledBorder: const OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.transparent,
        ),
      ),
      focusedBorder: const OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.transparent,
        ),
      ),
      hintStyle: const TextStyle(color: AppColors.primaryText),
    ),
    style: TextStyle(
      color: AppColors.primaryText,
      fontFamily: "Avenir",
      fontWeight: FontWeight.normal,
      fontSize: 14.sp,
    ),
  );
}
