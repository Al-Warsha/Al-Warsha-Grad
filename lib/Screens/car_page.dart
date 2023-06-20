import 'package:flutter/material.dart';
import 'package:myapp/Screens/search.dart';
import 'package:url_launcher/url_launcher.dart';


import 'add_car.dart';

class CarPage extends StatefulWidget {
  const CarPage({Key? key}) : super(key: key);

  @override
  State<CarPage> createState() => _CarPageState();
}

class _CarPageState extends State<CarPage> {
  final List<String> carImages = [
    'assets/images/car1.jpg',
    'assets/images/car2jpg.jpg',
    'assets/images/car3.jpg',
    'assets/images/car4.jpg',
  ];

  final String adminEmail = 'admin@email.com';

  @override
  Widget build(BuildContext context) {
    final double listViewHeight = (MediaQuery.of(context).size.height / 2) - 80.0;
    final double imageWidth = MediaQuery.of(context).size.width * 0.7;
    final double imageHeight = listViewHeight * 0.9;

    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 16.0, top: 16.0),
                child: Text(
                  'Hi, Ameer',
                  style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16.0, top: 8.0),
                child: Text(
                  'Which car needs your help?',
                  style: TextStyle(fontSize: 18.0, color: Color(0xFF6F6F6F)),
                ),
              ),
              SizedBox(height: 16.0),
              SizedBox(
                height: listViewHeight,
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  scrollDirection: Axis.horizontal,
                  itemCount: carImages.length,
                  itemBuilder: (context, index) {
                    return Stack(
                      children: [
                        Container(
                          width: imageWidth,
                          height: imageHeight,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.0),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 2.0,
                                blurRadius: 5.0,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: Image.asset(
                              carImages[index],
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: double.infinity,
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 20.0,
                          right: 0.0,
                          child: Container(
                            width: 40.0,
                            height: 40.0,
                            decoration: BoxDecoration(
                              color: const Color(0xFFFC5448),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: IconButton(
                              icon: const Icon(
                                Icons.arrow_forward,
                                color: Colors.white,
                                size: 24.0,
                              ),
                              onPressed: () {
                                // TODO: Navigate to car details page
                              },
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                  separatorBuilder: (context, index) {
                    return SizedBox(width: 16.0);
                  },
                ),
              ),
              const SizedBox(height: 32.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Cultus AGS 2017',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      '1000 CC. AUTOMATIC PETROL',
                      style: TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.normal,
                        color: Color(0xFF6F6F6F),
                      ),
                    ),
                    SizedBox(height: 8.0),
                    Row(
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Icon(Icons.info, color: Colors.black),
                        ),
                        SizedBox(width: 8.0),
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Icon(Icons.build, color: Colors.black),
                        ),
                        SizedBox(width: 8.0),
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Icon(Icons.description, color: Colors.black),
                        ),
                      ],
                    ),
                    SizedBox(height: 100.0),
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => AddCar(fromSchedule: false,)),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          primary: const Color(0xFFFC5448),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32.0,
                            vertical: 12.0,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                        ),
                        child: Text(
                          'ADD ANOTHER CAR',
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 16.0),
                    Container(
                      height: 60.0,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2.0,
                            blurRadius: 5.0,
                            offset: const Offset(0, -2),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          IconButton(
                            onPressed: () {},
                            icon: Icon(Icons.directions_car, color: const Color(0xFF6F6F6F)),
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: Icon(Icons.account_circle, color: const Color(0xFF6F6F6F)),
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: Icon(Icons.home, color: const Color(0xFF6F6F6F)),
                          ),
                          IconButton(
                            onPressed: () {
                              _launchEmail(adminEmail);
                            },
                            icon: Icon(Icons.all_inbox_sharp, color: const Color(0xFF6F6F6F)),
                          ),
                          IconButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => Search()),
                              );
                            },
                            icon: Icon(Icons.notifications_active, color: const Color(0xFF6F6F6F)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _launchEmail(String email) async {
    final Uri params = Uri(
      scheme: 'mailto',
      path: email,
    );

    String url = params.toString();

    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch email';
    }
  }
}