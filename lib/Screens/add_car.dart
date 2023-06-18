import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'car_page.dart';

class AddCar extends StatefulWidget {
  const AddCar({Key? key}) : super(key: key);

  @override
  State<AddCar> createState() => _AddCarState();
}

class _AddCarState extends State<AddCar> {
  final TextEditingController _modelController = TextEditingController();
  final TextEditingController _makeController = TextEditingController();
  final TextEditingController _yearController = TextEditingController();
  final TextEditingController _mileageController = TextEditingController();

  bool _areAllFieldsFilled = false;

  @override
  void initState() {
    super.initState();
    _modelController.addListener(_checkIfAllFieldsFilled);
    _makeController.addListener(_checkIfAllFieldsFilled);
    _yearController.addListener(_checkIfAllFieldsFilled);
    _mileageController.addListener(_checkIfAllFieldsFilled);
  }

  @override
  void dispose() {
    _modelController.dispose();
    _makeController.dispose();
    _yearController.dispose();
    _mileageController.dispose();
    super.dispose();
  }

  void _checkIfAllFieldsFilled() {
    setState(() {
      _areAllFieldsFilled = _modelController.text.isNotEmpty &&
          _makeController.text.isNotEmpty &&
          _yearController.text.isNotEmpty &&
          _mileageController.text.isNotEmpty;
    });
  }

  Future<void> _saveCarInfo() async {
    final carInfo = {
      'model': _modelController.text,
      'make': _makeController.text,
      'year': _yearController.text,
      'mileage': _mileageController.text,
    };

    try {
      await FirebaseFirestore.instance.collection('cars').add(carInfo);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => CarPage()),
      );
    } catch (e) {
      // Handle any errors that occurred while saving the car info
      print('Error saving car info: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5),
      body: Stack(
        children: [
          Positioned(
            top: h * 0.3,
            left: w * 0.15,
            right: w * 0.15,
            child: Column(
              children: [
                Text(
                  "Add Car",
                  style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                Container(
                  width: w * 0.7,
                  child: TextFormField(
                    controller: _modelController,
                    decoration: InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                      hintText: "Model :",
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  width: w * 0.7,
                  child: TextFormField(
                    controller: _makeController,
                    decoration: InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                      hintText: "Make :",
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  width: w * 0.7,
                  child: TextFormField(
                    controller: _yearController,
                    decoration: InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                      hintText: "Year :",
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  width: w * 0.7,
                  child: TextFormField(
                    controller: _mileageController,
                    decoration: InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                      hintText: "Mileage : ",
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 30,
            left: 20,
            right: 20,
            child: Container(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _areAllFieldsFilled ? _saveCarInfo : null,
                child: Text(
                  'Add',
                  style: TextStyle(fontSize: 20),
                ),
                style: ElevatedButton.styleFrom(
                  primary: Color(0xFFFC5448),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
