import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  final Key key;
  final String message;
  final String userName;
  final String userImage;

  final bool isMe;

  MessageBubble(
    this.message,
    this.userName,
    this.userImage,
    this.isMe, {
    this.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        isMe
            ? Container()
            : Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: CircleAvatar(
                  backgroundImage: NetworkImage(userImage),
                ),
              ),
        Column(
          crossAxisAlignment:
              isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Text(
              userName,
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 12,
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: isMe
                    ? Theme.of(context).accentColor
                    : Theme.of(context).primaryColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                  bottomLeft: !isMe ? Radius.circular(0) : Radius.circular(20),
                  bottomRight: isMe ? Radius.circular(0) : Radius.circular(20),
                ),
              ),
              constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.7),
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
              margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              child: Column(
                crossAxisAlignment:
                    isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  Text(
                    message,
                    style: TextStyle(
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.start,
                  ),
                ],
              ),
            ),
          ],
        ),
        isMe
            ? Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: CircleAvatar(
                  backgroundImage: NetworkImage(userImage),
                ),
              )
            : Container(),
      ],
    );
  }
}
