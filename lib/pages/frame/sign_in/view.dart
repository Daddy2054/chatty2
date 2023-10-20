import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../common/values/values.dart';
import 'index.dart';

class SignInPage extends GetView<SignInController> {
  const SignInPage({super.key});

  Widget _buildLogo() {
    return Container(
      margin: EdgeInsets.only(
        top: 100.h,
        bottom: 80.h,
      ),
      child: Text(
        'Chatty .',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: AppColors.primaryText,
          fontWeight: FontWeight.bold,
          fontSize: 34.sp,
        ),
      ),
    );
  }

  Widget _buildThirdPartyGoogleLogin(
    String loginType,
    String logo,
  ) {
    return Container(
      width: 295.w,
      height: 44.h,
      padding: EdgeInsets.all(10.h),
      margin: EdgeInsets.only(
        bottom: 15.h,
      ),
      decoration: BoxDecoration(
        color: AppColors.primaryBackground,
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
        children: [
          Container(
            padding: EdgeInsets.only(
              left: 40.w,
              right: 30.w,
            ),
            child: Image.asset('assets/icons/$logo.png'),
          ),
          Text(
            'Sign in with $loginType',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.primaryText,
              fontWeight: FontWeight.normal,
              fontSize: 14.sp,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primarySecondaryBackground,
      body: Center(
        child: Column(
          children: [
            _buildLogo(),
            _buildThirdPartyGoogleLogin('Google', 'google'),
            _buildThirdPartyGoogleLogin('Facebook', 'facebook'),
            _buildThirdPartyGoogleLogin('Apple', 'apple'),
          ],
        ),
      ),
    );
  }
}
