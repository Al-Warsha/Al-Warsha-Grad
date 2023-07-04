import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'BottomNavigationBarExample.dart';
import 'add_car.dart';

class CarPage extends StatefulWidget {
  const CarPage({Key? key}) : super(key: key);

  @override
  State<CarPage> createState() => _CarPageState();
}

class _CarPageState extends State<CarPage> {
  late String loggedInUserName = '';

  @override
  void initState() {
    super.initState();
    fetchLoggedInUserName();
  }

  void fetchLoggedInUserName() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (userSnapshot.exists) {
        setState(() {
          loggedInUserName = userSnapshot['fullName'];
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => BottomNavigationBarExample()),
            );
          },
          icon: Icon(Icons.arrow_back),
          color: Colors.black,
        ),
        title: Text(
          'Car Page',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 16.0, top: 8.0),
                child: Text(
                  'Your cars ',
                  style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 16.0),
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('cars')
                    .where('userId', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text('Error fetching car data');
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFC5448))));
                  }

                  if (snapshot.hasData && snapshot.data?.docs.isEmpty == true) {
                    return Center(child: Text('No cars found'));
                  }

                  return ListView.separated(
                    padding: EdgeInsets.symmetric(horizontal: 5.0),
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: snapshot.data!.size,
                    itemBuilder: (context, index) {
                      DocumentSnapshot carSnapshot = snapshot.data!.docs[index];

                      final make = carSnapshot['make'] ?? 'Unknown';
                      final model = carSnapshot['model'] ?? 'Unknown';
                      final year = carSnapshot['year']?.toString() ?? 'Unknown';
                      final mileage = carSnapshot['mileage']?.toString() ?? 'Unknown';

                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        elevation: 5,
                        shadowColor: Color(0xFF6F6F6F),
                        child: Padding(
                          padding: EdgeInsets.all(20.0),
                          child: InkWell(
                            child: ListTile(
                              title: Text('Make: $make'),
                              subtitle: Text('Model: $model \nYear: $year\nMileage: $mileage'),
                              trailing: IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: Text('Delete Car'),
                                      content: Text('Are you sure you want to delete this car?'),
                                      actions: [
                                        TextButton(
                                          child: Text('Cancel'),
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                        ),
                                        TextButton(
                                          child: Text('Delete'),
                                          onPressed: () {
                                            String carId = carSnapshot.id;
                                            FirebaseFirestore.instance
                                                .collection('cars')
                                                .doc(carId)
                                                .delete()
                                                .then((value) {
                                              Navigator.pop(context);
                                            }).catchError((error) {
                                              print('Failed to delete car: $error');
                                            });
                                          },
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) => Divider(
                      color: Color.fromRGBO(252, 84, 72, 1.0),
                      indent: 30,
                      endIndent: 30,
                      thickness: 3,
                    ),
                  );
                },
              ),
              SizedBox(height: 16.0),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddCar(fromSchedule: false)),
          );
        },
        label: Text(
          'ADD ANOTHER CAR',
          style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
        ),
        icon: Icon(Icons.add),
        backgroundColor: Color(0xFFFC5448),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

