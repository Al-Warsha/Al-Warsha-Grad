import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Controller/auth_controller.dart';
import 'business_history.dart';
import 'businessowner_current_requests.dart';
import 'car_page.dart';

class BusinessOwnerHomepage extends StatefulWidget {
  static const String routeName = 'businessOwnerHomepage';

  const BusinessOwnerHomepage({Key? key}) : super(key: key);

  @override
  State<BusinessOwnerHomepage> createState() => _BusinessOwnerHomepageState();
}

class _BusinessOwnerHomepageState extends State<BusinessOwnerHomepage> {
  int checkedIndex = -1;
  List<String> cardNames = [
    'assets/images/b1.1.jpg',
    'assets/images/b1.2.jpg',
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
            Container(
              alignment: Alignment.topRight,
              margin: EdgeInsets.only(right: 40, top:20),
            child: ElevatedButton(
            onPressed: () {
                      // Perform logout action here
              AuthController.instance.logout();
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
                          'Hi, "Business Owner Name"',
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
                      MaterialPageRoute(builder: (context) => BusinessCurrentRequests()),
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
          width: 165,
          height: 165,
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