import 'package:flutter/cupertino.dart';
import 'package:dialog_flowtter/dialog_flowtter.dart' as df;
import 'package:flutter/material.dart';
import 'BottomNavigationBarExample.dart';
import 'MessageScreen.dart';

class Chatbot extends StatefulWidget {

  const Chatbot({Key? key}) : super(key: key);

  @override
  State<Chatbot> createState() => _ChatbotState();
}

class _ChatbotState extends State<Chatbot> {

  late df.DialogFlowtter dialogFlowtter;
  final TextEditingController _controller=TextEditingController();

  List<Map<String,dynamic>> messages=[];

  @override
  void initState() {

    df.DialogFlowtter.fromFile().then((instance) => dialogFlowtter =instance);
    super.initState();

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        backgroundColor: Colors.white,
        title: Text(
          'El-Warsha Bot',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Color.fromRGBO(0, 0, 0, 1.0),
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => BottomNavigationBarExample()),
            );
          },
        ),
      ),

    body: Container(
        child: Column(
          children: [
            Expanded(child: MessagesScreen(messages: messages)),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              child: Container(padding: EdgeInsets.only(left: 15),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Color.fromRGBO(252, 84, 72, 1),
                    width: 1.5,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        sendMessage(_controller.text);
                        _controller.clear();
                      },
                      icon: Icon(Icons.send),
                    ),
                  ],
                ),
              ),
            )

          ],
        ),
      ),
    );
  }
  sendMessage(String text) async {
    if (text.isEmpty) {
      print('Message is empty');
    } else {
      setState(() {
        addMessage(df.Message(text: df.DialogText(text: [text])), true);
      });

      df.DetectIntentResponse response = await dialogFlowtter.detectIntent(
          queryInput: df.QueryInput(text: df.TextInput(text: text)));
      if (response.message == null) return;
      setState(() {
        addMessage(response.message!);
      });
    }
  }

  addMessage(df.Message message, [bool isUserMessage = false]) {
    messages.add({'message': message, 'isUserMessage': isUserMessage});
  }
}