import 'package:flutter/material.dart';
import 'package:swara/src/widgets/chat_box.dart';
import 'package:swara/src/widgets/talk_button.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const routeName = '/';

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            ChatBox(),
            Expanded(
              child: TalkButton(),
            ),
          ],
        ),
      ),
    );
  }
}
