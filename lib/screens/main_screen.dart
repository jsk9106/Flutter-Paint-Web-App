import 'package:flutter/material.dart';
import 'components/left_menu.dart';
import 'components/top_menu.dart';
import 'game/painting_screen.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            const TopMenu(),
            Expanded(
              child: Row(
                children: const [
                  LeftMenu(),
                  PaintingScreen(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


