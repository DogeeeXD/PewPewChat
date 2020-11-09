import 'package:PewPewChat/screens/chatrooms_screen.dart';
import 'package:PewPewChat/widgets/responsive_widget.dart';
import 'package:flutter/material.dart';

class MessagesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ResponsiveWidget.isLargeScreen(context) ||
            ResponsiveWidget.isMediumScreen(context)
        ? Container(
            child: Column(
              children: [
                Text(
                  'Messages',
                  style: Theme.of(context).textTheme.headline6,
                ),
                ChatroomsScreen(),
              ],
            ),
          )
        : ChatroomsScreen();
  }
}
