import 'package:flutter/material.dart';
import 'package:shop_maternityapp/dashboard.dart';
import 'package:shop_maternityapp/myaccount.dart';
import 'package:shop_maternityapp/orders.dart';
import 'package:shop_maternityapp/products.dart';
import 'package:shop_maternityapp/view_complaints.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  int selectedIndex = 0;

  List<String> pageName = [
    'Dashbard',
    'Products',
    'Orders',
    'Complaints',
    'My Account'
    // 'District',
    // 'Category',
    // 'Place',
    // 'Sub Category',
  ];
  List<IconData> pageIcon = [
    Icons.dashboard_outlined,
    Icons.dashboard_outlined,
    Icons.dashboard_outlined,
    Icons.dashboard_outlined,
    Icons.dashboard_outlined,
    // Icons.location_city_outlined,
    // Icons.category_outlined,
    // Icons.location_city
  ];

  List<Widget> pages = [
    Dashboard(),
    ManageProducts(),
    Orders(),
    ViewComplaints(),
    Myaccount()

  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Expanded(
              flex: 1,
              child: Container(
                color: const Color.fromARGB(255, 197, 216, 245),
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
