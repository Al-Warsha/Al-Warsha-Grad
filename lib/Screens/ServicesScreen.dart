import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myapp/Controller/auth_controller.dart';
import 'package:myapp/Screens/Chatbot.dart';
import 'package:myapp/Screens/search.dart';
import 'package:myapp/Screens/viewMechanicsForAppointment.dart';
import 'package:myapp/Screens/viewMechanicsForEmergency.dart';
import 'package:myapp/Screens/winchService.dart';
import 'package:url_launcher/url_launcher.dart';
import '../Repositories/notification_service.dart';

class ServicesScreen extends StatefulWidget {
  static const String routeName = 'ServicesScreen';

  const ServicesScreen({Key? key}) : super(key: key);
  final String adminEmail = 'alwarsha.grad@gmail.com';

  @override
  State<ServicesScreen> createState() => _ServicesScreenState();
}

class _ServicesScreenState extends State<ServicesScreen> {
  final NotificationService _notificationService = NotificationService();

  @override
  void initState() {
    super.initState();
    // Get the logged-in user's ID
    final authController = AuthController();
    final userId = authController.currentUserUid!; // Assert that it's not null
    _notificationService.initializeNotifications();
    _notificationService.listenForRequestChanges(userId);
  }

  int checkedIndex = -1;
  List<String> cardNames = [
    'assets/images/s1.jpg',
    'assets/images/s2.jpg',
    'assets/images/s3.jpg',
    'assets/images/s4.jpg',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: CupertinoColors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 25),
            Column(
              children: [
                Row(
                  children: [
                    BackButton(color: Colors.black),
                    Container(
                      margin: EdgeInsets.only(right: 150),
                      child: Text(
                        'Services',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 20,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.mail_outline_rounded, size: 32), // Add the mail icon
                      onPressed: () {
                        // Handle mail icon button press
                        _launchEmail(widget.adminEmail);
                      },
                    ),

                    IconButton(
                      icon: Icon(Icons.manage_search, size: 32),
                      onPressed: () {
                        // Redirect to the search page
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Search()),
                        );
                      },
                    ),
                  ],
                ),
                Container(
                  alignment: Alignment.topLeft,
                  margin: EdgeInsets.only(
                      left: 40, top: 35), // Adjust the left margin as needed
                  child: Text(
                    'Service For',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.grey,
                      fontWeight:
                      FontWeight.bold, // Make the text bold
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.topLeft,
                  margin: EdgeInsets.only(
                      left: 40, top: 5), // Adjust the left margin as needed
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            right: 8.0), // Adjust the right padding as needed
                        child: Text(
                          'Default car',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                            fontWeight:
                            FontWeight.bold, // Make the text bold
                          ),
                        ),
                      ),
                      Icon(Icons.keyboard_arrow_down_outlined),
                    ],
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(45),
              child: GridView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: cardNames.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                ),
                itemBuilder: (BuildContext context, int index) {
                  return buildCard(index);
                },
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.only(
                  top: 50, bottom: 20, left: 80, right: 80),
              child: InkWell(
                onTap: () {
                  if (checkedIndex == 0) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => viewMechanicsForEmergency(),
                      ),
                    );
                  } else if (checkedIndex == 1)
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => viewMechanicsForAppointment(),
                      ),
                    );
                  else if (checkedIndex == 2)
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => winchService(),
                      ),
                    );
                  else if (checkedIndex == 3)
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Chatbot(),
                      ),
                    );
                  // else Navigator.pushNamed(context, 'AppointmentForMaintenance');
                  setState(() {});
                },
                child: Container(
                  width: double.infinity,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    color: Color.fromRGBO(252, 84, 72, 1),
                  ),
                  child: Center(
                    child: Text(
                      'CONTINUE',
                      style: TextStyle(
                          fontFamily: 'Urbanist',
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
      //bottomNavigationBar: BottomNavigationBarExample(),
    );
  }

  Widget buildCard(int index) {
    bool checked = index == checkedIndex;
    String imagePath = cardNames[index];

    // Check if the image path ends with '/service'
    bool isServiceImage = imagePath.contains('/service');

    return GestureDetector(
      onTap: () {
        setState(() {
          checkedIndex = index;
        });
      },
      child: Stack(
        children: <Widget>[
          Card(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Container(
              width: 165, // Set desired width
              height: 165, // Set desired height
              child: ColorFiltered(
                colorFilter: checked
                    ? ColorFilter.mode(Colors.red, BlendMode.color)
                    : ColorFilter.mode(
                    Colors.transparent, BlendMode.srcATop),
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Positioned(
            top: 12,
            right: 12,
            child: Offstage(
              offstage: !checked,
              child: Container(
                decoration: BoxDecoration(
                  color: Color.fromRGBO(252, 84, 72, 1),
                  border: Border.all(width: 1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.check,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
_launchEmail(String email) async {
  final Uri params = Uri(
    scheme: 'mailto',
    path: email,
  );

  String url = params.toString();

  try {
    await launch(url);
  } catch (e) {
    throw 'Could not launch email: $e';
  }
}

