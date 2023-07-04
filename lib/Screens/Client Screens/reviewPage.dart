import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../Shared/network/local/firebase_utils.dart';


class ReviewPage extends StatefulWidget{
  final mechanicid;

  ReviewPage(this.mechanicid);

  @override
  State<ReviewPage> createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  late Future<List<DocumentSnapshot<Map<String, dynamic>>>> reviewsFuture;

  @override
  void initState() {
    super.initState();
    reviewsFuture = getReviews(widget.mechanicid);
  }


  @override
  Widget build(BuildContext context) {
    double baseWidth = 360;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: BackButton(
          color: Colors.black,
        ),
        title: Text(
          'Reviews',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder<List<DocumentSnapshot<Map<String, dynamic>>>>(
        future: reviewsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Show a loading indicator while fetching the data
            return Center(child: CircularProgressIndicator(color: Colors.red));
          } else if (snapshot.hasError) {
            // Show an error message if an error occurred
            return Text('Error: ${snapshot.error}');
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            // Show a message when there are no reviews
            return Center(child: Text('No reviews found'));
          } else {
            // The data is available, use it in your widget
            final dataList = snapshot.data!;

            return Column(
              children: [
                Expanded(
                  child: ListView.separated(
                    padding: EdgeInsets.symmetric(horizontal: 5),
                    shrinkWrap: true,
                    itemCount: dataList.length,
                    itemBuilder: (context, index) {
                      final data = dataList[index].data();

                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10 * fem),
                        ),
                        elevation: 5,
                        shadowColor: Color(0xff6f6f6f),
                        child: Padding(
                          padding: EdgeInsets.all(20),
                          child: ListTile(
                            title: Container(
                              child: Row(
                                children: [
                                  Icon(Icons.star,
                                      size: 18, color: Colors.yellow),
                                  SizedBox(width: 8),
                                  Text(data?['rate'].toString() ?? ''),
                                ],
                              ),
                            ),
                            subtitle: Text(data?['rateDescription'] ?? 'N/A'),
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) =>
                        Divider(
                          color: Color.fromRGBO(252, 84, 72, 1.0),
                          indent: 30,
                          endIndent: 30,
                          thickness: 3,
                        ),
                  ),
                ),
              ],
            );

          }
        },
      ),
    );

  }}
