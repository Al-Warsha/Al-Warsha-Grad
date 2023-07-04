import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:myapp/Screens/Client%20Screens/viewRequest.dart';

class RateScreen extends StatefulWidget {
  final String id;
  final int selection;

  static const String routeName = 'rating';

  RateScreen({required this.id, required this.selection});

  @override
  State<RateScreen> createState() => _RateScreenState(id, selection);
}

class _RateScreenState extends State<RateScreen> {
  String id;
  final int selection;
  late num rate;
  late String description;
  final db = FirebaseFirestore.instance;
  final textController = TextEditingController();

  _RateScreenState(this.id, this.selection);

  Future<void> updateDocument(num rate, String description) async {
    List<String> collections = ['emergencyAppointment', 'scheduleAppointment', 'winchAppointment']; // Replace with your collection names

    try {
      for (String collection in collections) {
        QuerySnapshot querySnapshot = await db.collection(collection).where('id', isEqualTo: id).get();

        for (QueryDocumentSnapshot snapshot in querySnapshot.docs) {
          DocumentReference documentRef = snapshot.reference;

          // Update the desired field in the document
          await documentRef.update({'rate': rate, 'rateDescription': description});
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Unable to submit the rate. Please try again.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CupertinoColors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: BackButton(
          color: Colors.black,
        ),
        title: Text(
          'Rate Service',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Container(
            child: RatingBar.builder(
              initialRating: 0,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
              itemBuilder: (context, _) => Icon(
                Icons.star,
                color: Color.fromRGBO(252, 84, 72, 1.0),
              ),
              onRatingUpdate: (rating) {
                rate = rating;
              },
            ),
          ),
          Divider(
            color: Color.fromRGBO(252, 84, 72, 1.0),
            indent: 30,
            endIndent: 30,
            thickness: 3,
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: TextFormField(
              controller: textController,
              maxLines: 5,
              decoration: const InputDecoration(
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(width: 3, color: Color.fromRGBO(252, 84, 72, 1.0)),
                ),
                hoverColor: Color.fromRGBO(252, 84, 72, 1.0),
                labelText: 'Description',
                labelStyle: TextStyle(color: Colors.black),
              ),
            ),
          ),
          Container(
            width: double.infinity,
            margin: EdgeInsets.all(30),
            child: ElevatedButton(
              onPressed: () async {
                description = textController.text;
                try {
                  //throw Exception('Simulated error');
                  await updateDocument(rate, description);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Rate submitted successfully!'),
                    ),
                  );
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ViewRequest(Id: id, selection: selection),
                    ),
                  );
                } catch (error) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Unable to submit the rate. Please try again.'),
                    ),
                  );
                }
              },
              child: Text("Submit"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromRGBO(252, 84, 72, 1.0),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
