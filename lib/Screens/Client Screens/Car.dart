import 'package:flutter/material.dart';

class Car extends StatelessWidget {
  static const String routeName='Car';
  const Car({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: 25,),
          Row(children: [
            BackButton( color: Colors.black,),
            Text('add new car', style: TextStyle(fontSize: 20, color: Colors.black)),
          ]),
        ],
      ),
    );
  }
}
