import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:myapp/Screens/Client%20Screens/scheduleCard.dart';

class RateScreen extends StatefulWidget{
  final String id;
  static const String routeName = 'rating';

  RateScreen({required this.id});


  @override
  State<RateScreen> createState() => _RateScreenState(id);
}

class _RateScreenState extends State<RateScreen> {
  String id;
  late num rate;
  late String description;
  final db = FirebaseFirestore.instance;
  final textController = TextEditingController();

  _RateScreenState(this.id);

  Future<void> updateDocument(num rate, String description) async {
    List<String> collections = ['emergencyAppointment', 'scheduleAppointment']; // Replace with your collection names

    for (String collection in collections) {
      QuerySnapshot querySnapshot = await db.collection(collection).where('id', isEqualTo: id).get();

      for (QueryDocumentSnapshot snapshot in querySnapshot.docs) {
        DocumentReference documentRef = snapshot.reference;

        // Update the desired field in the document
        await documentRef.update({'rate': rate, 'rateDescription': description});

      }
    }
  }


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Color.fromRGBO(238, 238, 238, 1.0),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        title: Text('Rate Service', textAlign: TextAlign.left, style: TextStyle(color: Colors.black),),
        leading: BackButton(
          color: Colors.black,
        ),),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Container(
            // padding: EdgeInsets.only(top: 50, bottom: 50),
            child: RatingBar.builder(
              initialRating: 0,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
              itemBuilder: (context, _) => Icon(
                Icons.star,
                color: Color.fromRGBO(252,84, 72, 1.0),
              ),
              onRatingUpdate: (rating) {
                rate = rating;
              },
            ),
          ),
          Divider(
            color: Color.fromRGBO(252,84, 72, 1.0),
            indent: 30,
            endIndent: 30,
            thickness: 3
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: TextFormField(
              controller: textController,
              maxLines: 5,
              decoration: const InputDecoration(
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(
                      width: 3,
                      color: Color.fromRGBO(252,84, 72, 1.0)),
                ),
                hoverColor: Color.fromRGBO(252,84, 72, 1.0),
                labelText: 'Description',
                labelStyle: TextStyle(color: Colors.black)

                  )
            ),
          ),
          Container(
            width: double.infinity,
            margin: EdgeInsets.all(30),
            child: ElevatedButton(
              onPressed: ()async{
                description = textController.text;
                updateDocument(rate, description);
                // Navigator.pop(context);
                Navigator.popUntil(context, (route) => route.settings.name == ScheduleCard.routeName);
              },
              child: Text("Submit"),
              style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromRGBO(252,84, 72, 1.0)
              ),
            ),
          ),
        ],
      ),
    );
  }
}