import 'package:flutter/material.dart';

class MessagesScreen extends StatefulWidget {
  final List<Map<String, dynamic>> messages;

  const MessagesScreen({Key? key, required this.messages}) : super(key: key);

  @override
  _MessagesScreenState createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    return ListView.separated(
      itemBuilder: (context, index) {
        final message = widget.messages[index]['message'];
        final isUserMessage = widget.messages[index]['isUserMessage'];
        final cardColor = isUserMessage
            ? Color.fromRGBO(252, 84, 72, 1)
            : Color.fromRGBO(252, 84, 72, 1).withOpacity(0.8);

        return Container(
          padding: EdgeInsets.symmetric(vertical: 4, horizontal: 10),
          child: Row(
            mainAxisAlignment: isUserMessage
                ? MainAxisAlignment.end
                : MainAxisAlignment.start,
            children: [
              Container(
                constraints: BoxConstraints(maxWidth: w * 2 / 3),
                child: Card(
                  elevation: isUserMessage ? 2 : 0,
                  color: isUserMessage ? Colors.white : cardColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                      bottomRight: isUserMessage ? Radius.circular(0) : Radius.circular(20),
                      topLeft: isUserMessage ? Radius.circular(20) : Radius.circular(0),
                    ),
                    side: isUserMessage
                        ? BorderSide(
                      color: cardColor,
                      width: 1.5,
                    )
                        : BorderSide.none,
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: 14,
                      horizontal: 14,
                    ),
                    child: Text(
                      message.text.text[0],
                      style: TextStyle(
                        color: isUserMessage ? Colors.black : Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
      separatorBuilder: (_, i) => Padding(padding: EdgeInsets.only(top: 10)),
      itemCount: widget.messages.length,
    );
  }
}
