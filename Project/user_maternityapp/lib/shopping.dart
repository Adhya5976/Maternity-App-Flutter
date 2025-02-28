import 'package:flutter/material.dart';

class ShoppingPage extends StatefulWidget {
  const ShoppingPage({super.key});
 @override
  _ShoppingPageState createState() => _ShoppingPageState();
}

class _ShoppingPageState extends State<ShoppingPage> {
  final List<Map<String, String>> shoppingItems = [
    {'name': 'Prenatal Vitamins', 'price': '\$20'},
    {'name': 'Maternity Clothes', 'price': '\$50'},
    {'name': 'Baby Stroller', 'price': '\$150'},
    {'name': 'Nursing Pillow', 'price': '\$30'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Shopping'),
        backgroundColor: Colors.pinkAccent,
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(10),
        itemCount: shoppingItems.length,
        itemBuilder: (context, index) {
          return Card(
            elevation: 4,
            margin: EdgeInsets.symmetric(vertical: 8),
            child: ListTile(
              title: Text(
                shoppingItems[index]['name']!,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text('Price: ${shoppingItems[index]['price']}'),
              leading: Icon(Icons.shopping_cart, color: Colors.pinkAccent),
            ),
          );
        },
      ),
    );
  }
}