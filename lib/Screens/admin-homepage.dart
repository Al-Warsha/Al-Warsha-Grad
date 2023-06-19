import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myapp/Screens/pending-signUp-requests.dart';
import '../Controller/auth_controller.dart';
import 'all-business-accounts.dart';

class AdminHomepage extends StatefulWidget {
  static const String routeName = 'ServicesScreen';

  const AdminHomepage({Key? key}) : super(key: key);

  @override
  State<AdminHomepage> createState() => _AdminHomepageState();
}

class _AdminHomepageState extends State<AdminHomepage> {
  int checkedIndex = -1;
  List<String> cardNames = [
    'assets/images/a1.jpg',
    'assets/images/a2.jpg',

  ];
  @override
  Widget build(BuildContext context) {
    double baseWidth = 360;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;
    final double w = MediaQuery.of(context).size.width;
    final double h = MediaQuery.of(context).size.height;
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
                  margin: EdgeInsets.only(right: 16 * fem, top:20 * fem),
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
                  margin: EdgeInsets.only(left: 0, top: 25*fem),

                ),
                Text(
                  "Admin Dashboard",
                  style: TextStyle(fontFamily: "Poppins",fontSize:40, fontWeight: FontWeight.bold),
                ),
                Image.asset(
                  "img/breakLogin.jpg",
                  width: w * 0.5,
                  height: h * 0.01,
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

            Padding(
              padding: EdgeInsets.only(top: ffem*20, bottom: 20, left: 80, right: 80),
              child: InkWell(
                onTap: () {
                  if (checkedIndex == 0)
                  {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PendingSignUpRequests(
                        ),
                      ),
                    );
                  }
                  else if (checkedIndex == 1)
                  {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AllBusinessOwnerAccount(
                        ),
                      ),
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
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ),
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
