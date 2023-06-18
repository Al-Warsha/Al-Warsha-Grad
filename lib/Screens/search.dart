import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Search extends StatefulWidget {
  const Search({Key? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<Search> {
  TextEditingController _searchController = TextEditingController();
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String _selectedFilter = 'All';
  String _selectedBrand = 'All Brands';
  List<DocumentSnapshot> _searchResults = [];

  void _searchCarRepairCenters(String searchText, String name) {
    String start = searchText;
    String end = searchText + '\uf8ff';

    Query<Map<String, dynamic>> query = _firestore.collection('carcenters');

    if (_selectedFilter == 'All') {
      Query<Map<String, dynamic>> initialQuery = query
          .where(name, isGreaterThanOrEqualTo: start)
          .where(name, isLessThanOrEqualTo: end);

      initialQuery.get().then(
            (QuerySnapshot<Map<String, dynamic>> snapshot) {
          List<DocumentSnapshot<Map<String, dynamic>>> results = snapshot.docs;

          setState(() {
            _searchResults = results;
          });
        },
      ).catchError(
            (error) {
          print('Error searching car repair centers: $error');
        },
      );
    } else if (_selectedFilter == 'Rating') {
      Query<Map<String, dynamic>> filteredQuery = query
          .where(name, isGreaterThanOrEqualTo: start)
          .where(name, isLessThanOrEqualTo: end);

      filteredQuery.get().then(
            (QuerySnapshot<Map<String, dynamic>> snapshot) {
          List<DocumentSnapshot<Map<String, dynamic>>> filteredResults = snapshot.docs;

          List<DocumentSnapshot<Map<String, dynamic>>> sortedResults =
          filteredResults
            ..sort((a, b) =>
                (b.data()?['rating'] ?? 0).compareTo(a.data()?['rating'] ?? 0));

          setState(() {
            _searchResults = sortedResults;
          });
        },
      ).catchError(
            (error) {
          print('Error searching car repair centers: $error');
        },
      );
    }

  }

  void _searchByBrand(String searchText) {
    String start = searchText;
    String end = searchText + '\uf8ff';

    Query<Map<String, dynamic>> query = _firestore.collection('carcenters');

    if (_selectedBrand == 'All Brands') {
      Query<Map<String, dynamic>> brandQuery = query
          .where('name', isGreaterThanOrEqualTo: start)
          .where('name', isLessThanOrEqualTo: end);

      brandQuery.get().then(
            (QuerySnapshot<Map<String, dynamic>> snapshot) {
          List<DocumentSnapshot<Map<String, dynamic>>> results = snapshot.docs;

          setState(() {
            _searchResults = results;
          });
        },
      ).catchError(
            (error) {
          print('Error searching car repair centers: $error');
        },
      );
    } else {
      Query<Map<String, dynamic>> brandQuery = query
          .where('brands', arrayContains: _selectedBrand)
          .where('name', isGreaterThanOrEqualTo: start)
          .where('name', isLessThanOrEqualTo: end);

      brandQuery.get().then(
            (QuerySnapshot<Map<String, dynamic>> snapshot) {
          List<DocumentSnapshot<Map<String, dynamic>>> results = snapshot.docs;

          setState(() {
            _searchResults = results;
          });
        },
      ).catchError(
            (error) {
          print('Error searching car repair centers: $error');
        },
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFFC5448),
        title: Text('Search'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Search for services:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _searchController,
              onChanged: (value) {
                if (_selectedFilter == 'Supported brand') {
                  _searchByBrand(value);
                } else {
                  _searchCarRepairCenters(value, 'name');
                }
              },
              decoration: InputDecoration(
                hintText: 'Search...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Filter by category:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            DropdownButton<String>(
              value: _selectedFilter,
              icon: const Icon(Icons.arrow_downward),
              iconSize: 24,
              elevation: 16,
              style: const TextStyle(color: Colors.black),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedFilter = newValue!;
                  _searchController.clear();
                  _searchResults.clear();
                });
              },
              items: <String>[
                'All',
                'Location',
                'Rating',
                'Supported brand',
              ].map<DropdownMenuItem<String>>(
                    (String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                },
              ).toList(),
            ),
            if (_selectedFilter == 'Supported brand')
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 16),
                  Text(
                    'Select brand:',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16),
                  DropdownButton<String>(
                    value: _selectedBrand,
                    icon: const Icon(Icons.arrow_downward),
                    iconSize: 24,
                    elevation: 16,
                    style: const TextStyle(color: Colors.black),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedBrand = newValue!;
                        _searchController.clear();
                        _searchResults.clear();
                      });
                    },
                    items: <String>[
                      'All Brands',
                      'TOYOTA',
                      'KIA',
                      'BMW',
                      'Nissan',
                      'Hyundai',
                      'Honda',
                      'Renault',
                      'Chevrolet',
                      'Mercedes Benz',
                      'Cadillac',
                      'Jeep',
                      'Volkswagen',
                      'Audi',
                      'Ford',
                      'Lamborghini',
                      'Tesla',
                    ].map<DropdownMenuItem<String>>(
                          (String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      },
                    ).toList(),
                  ),
                ],
              ),
            SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: _searchResults.length,
                itemBuilder: (BuildContext context, int index) {
                  DocumentSnapshot document = _searchResults[index];
                  String name = document['name'];
                  String location = document['location'];
                  return ListTile(
                    title: Text(name),
                    subtitle: Text(location),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        setState(() {
                          _searchResults.removeAt(index);
                        });
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
