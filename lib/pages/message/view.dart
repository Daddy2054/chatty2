import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'index.dart';

class MessagePage extends GetView<MessageController> {
  const MessagePage({super.key});

// slivers

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            CustomScrollView(
              slivers: [],
            ),
          ],
        ),
      ),
    );
  }
}
