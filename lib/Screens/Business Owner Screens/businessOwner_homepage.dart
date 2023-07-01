import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../Controller/auth_controller.dart';
import '../../Repositories/notification_service2.dart';
import 'business_history.dart';
import 'businessowner_current_requests.dart';


class BusinessOwnerHomepage extends StatefulWidget {
  static const String routeName = 'businessOwnerHomepage';

  const BusinessOwnerHomepage({Key? key}) : super(key: key);


  @override
  State<BusinessOwnerHomepage> createState() => _BusinessOwnerHomepageState();
}

class _BusinessOwnerHomepageState extends State<BusinessOwnerHomepage> {
  // final NotificationService2 _notificationService = NotificationService2();
  int checkedIndex = -1;
  List<String> cardNames = [
    'assets/images/b1.1.jpg',
    'assets/images/b1.2.jpg',
  ];
  String businessName = '';

  @override
  void initState() {
    super.initState();
    // Get the logged-in user's ID
    // final authController = AuthController();
    // final userId = authController.currentUserUid!; // Assert that it's not null
    // _notificationService.initializeNotifications2(userId);
    //_notificationService.listenForRequestChanges2(userId);
    fetchBusinessName();
  }


  Future<String> fetchBusinessNameFromCollection(String userId) async {
    DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore.instance
        .collection('BusinessOwners')
        .doc(userId)
        .get();

    if (snapshot.exists) {
      String businessName = snapshot.data()?['name'] ?? '';
      return businessName;
    } else {
      return '';
    }
  }
  Future<void> fetchBusinessName() async {
    String? userId = AuthController.instance.currentUserUid;
    // Use userId to fetch business name from "BusinessOwners" collection
    String fetchedBusinessName = await fetchBusinessNameFromCollection(userId!);

    if (mounted) {
      setState(() {
        businessName = fetchedBusinessName;
      });
    }
  }
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
                Container(
                  alignment: Alignment.topRight,
                  margin: EdgeInsets.only(right: 40, top:20),
                  child: ElevatedButton(
                    onPressed: () {
                      // Perform logout action here
                      AuthController.instance.logoutBusinessOwner();
                    },
                    child: Text('Logout', style: TextStyle(color: Colors.white)),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(Color(0xFFFC5448)),
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.topLeft,
                  margin: EdgeInsets.only(left: 40, top: 0),
                  child: Text(
                    'Homepage',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.topLeft,
                  margin: EdgeInsets.only(left: 40, top: 5),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Text(
                          'Hi,$businessName',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(45),
              child: Column(
                children: cardNames.map((imagePath) {
                  int index = cardNames.indexOf(imagePath);
                  return buildCard(index);
                }).toList(),
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.only(top: 0, bottom: 20, left: 80, right: 80),
              child: InkWell(
                onTap: () {
                  if (checkedIndex == 0){
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => BusinessCurrentRequests(initialSelection: 1,)),
                    );
                  }
                  else if (checkedIndex == 1){
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => BusinessHistory()),
                    );
                  }
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
                        fontWeight: FontWeight.bold,
                      ),
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
      child: Card(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Container(
          width: 163,
          height: 163,
          child: Stack(
            children: <Widget>[
              ColorFiltered(
                colorFilter: checked
                    ? ColorFilter.mode(Colors.red, BlendMode.color)
                    : ColorFilter.mode(
                    Colors.transparent, BlendMode.srcATop),
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.cover,
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
        ),
      ),
    );
  }}
