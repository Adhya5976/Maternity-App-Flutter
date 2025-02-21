import 'package:admin_maternityapp/screen/category.dart';
import 'package:admin_maternityapp/screen/dashboard.dart';
import 'package:admin_maternityapp/screen/district.dart';
import 'package:admin_maternityapp/screen/place.dart';
import 'package:admin_maternityapp/screen/subcategory.dart';
import 'package:flutter/material.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  int selectedIndex = 0;

  List<String> pageName = [
    'Dashbard',
    'District',
    'Category',
    'Place',
    'Sub Category',
  ];
  List<IconData> pageIcon = [
    Icons.dashboard_outlined,
    Icons.location_city_outlined,
    Icons.category_outlined,
    Icons.location_city,
    Icons.category_outlined,
  ];

  List<Widget> pages = [Dashboard(), ManageDistrict(),ManageCategory(),ManagePlace(),ManageSubCategory()];  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Admin Dashboard"),
        backgroundColor: Color.fromARGB(255, 198, 176, 249),
      ),
      body: Row(
        children: [
          Expanded(
              flex: 1,
              child: Container(
                color:Color.fromARGB(255, 255, 154, 154),
                child: ListView.builder(
                  itemCount: pageName.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      onTap: () {
                        setState(() {
                          selectedIndex=index;
                        });
                      },
                      leading: Icon(pageIcon[index]),
                      title: Text(pageName[index]),
                    );
                  },
                ),
              )),
          Expanded(
              flex: 4,
              child: Container(
                color: const Color.fromARGB(255, 255, 254, 254),
                child: pages[selectedIndex],
              )),
        ],
      ),
    );
  }
}
