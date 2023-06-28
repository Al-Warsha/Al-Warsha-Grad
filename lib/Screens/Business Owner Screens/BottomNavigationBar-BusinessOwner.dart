import 'package:flutter/material.dart';
import '../Shared Screens/Notification.dart';
import 'businessOwner_homepage.dart';

class BottomNavigationBarBusinessOwner extends StatefulWidget {
  static const String routeName = 'BottomNavigationBarExample';

  const BottomNavigationBarBusinessOwner({Key? key}) : super(key: key);

  @override
  _BottomNavigationBarBusinessOwnerState createState() =>
      _BottomNavigationBarBusinessOwnerState();
}

class _BottomNavigationBarBusinessOwnerState
    extends State<BottomNavigationBarBusinessOwner> {
  int _selectedIndex = 1;

  static const TextStyle optionStyle =
  TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static List<Widget> _widgetOptions = <Widget>[
    Text(
      'screen 1',
      style: optionStyle,
    ),
    BusinessOwnerHomepage(),
    Notifications(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: ColorFiltered(
              colorFilter: _selectedIndex == 0
                  ? ColorFilter.mode(
                  Color.fromRGBO(252, 84, 72, 1), BlendMode.color)
                  : ColorFilter.mode(Colors.transparent, BlendMode.srcATop),
              child: Image.asset(
                'assets/images/b2.jpg',
                width: 25,
                height: 25,
              ),
            ),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: ColorFiltered(
              colorFilter: _selectedIndex == 1
                  ? ColorFilter.mode(
                  Color.fromRGBO(252, 84, 72, 1), BlendMode.color)
                  : ColorFilter.mode(Colors.transparent, BlendMode.srcATop),
              child: Image.asset(
                'assets/images/b3.jpg',
                width: 24,
                height: 24,
              ),
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: ColorFiltered(
              colorFilter: _selectedIndex == 2
                  ? ColorFilter.mode(
                  Color.fromRGBO(252, 84, 72, 1), BlendMode.color)
                  : ColorFilter.mode(Colors.transparent, BlendMode.srcATop),
              child: Image.asset(
                'assets/images/b5.jpg',
                width: 24,
                height: 24,
              ),
            ),
            label: 'Notification',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Color.fromRGBO(252, 84, 72, 1),
        onTap: _onItemTapped,
      ),
    );
  }
}
