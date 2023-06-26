import 'package:flutter/material.dart';
import 'package:myapp/Screens/Client%20Screens/user_profile_screen.dart';
import '../../Shared/Notification.dart';
import 'ServicesScreen.dart';
import 'add_car.dart';
import 'car_page.dart';
import 'clientRequests.dart';

class BottomNavigationBarExample extends StatefulWidget {
  static const String routeName = 'BottomNavigationBarExample';

  const BottomNavigationBarExample({Key? key}) : super(key: key);

  @override
  _BottomNavigationBarExampleState createState() =>
      _BottomNavigationBarExampleState();
}

class _BottomNavigationBarExampleState
    extends State<BottomNavigationBarExample> {
  int _selectedIndex = 2;

  static const TextStyle optionStyle =
  TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static final List<Widget> _widgetOptions = <Widget>[
    AddCar(fromSchedule: false,),
    const UserProfileScreen(),
    const ServicesScreen(),
    const ClientRequests(),
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
                'assets/images/b1.jpg',
                width: 24,
                height: 24,
              ),
            ),
            label: 'Car',
          ),
          BottomNavigationBarItem(
            icon: ColorFiltered(
              colorFilter: _selectedIndex == 1
                  ? ColorFilter.mode(
                  Color.fromRGBO(252, 84, 72, 1), BlendMode.color)
                  : ColorFilter.mode(Colors.transparent, BlendMode.srcATop),
              child: Image.asset(
                'assets/images/b2.jpg',
                width: 24,
                height: 24,
              ),
            ),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: ColorFiltered(
              colorFilter: _selectedIndex == 2
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
              colorFilter: _selectedIndex == 3
                  ? ColorFilter.mode(
                  Color.fromRGBO(252, 84, 72, 1), BlendMode.color)
                  : ColorFilter.mode(Colors.transparent, BlendMode.srcATop),
              child: Image.asset(
                'assets/images/b4.jpg',
                width: 24,
                height: 24,
              ),
            ),
            label: 'Requests',
          ),
          BottomNavigationBarItem(
            icon: ColorFiltered(
              colorFilter: _selectedIndex == 4
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
