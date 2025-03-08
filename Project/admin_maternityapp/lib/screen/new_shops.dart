import 'package:flutter/material.dart';

class NewShops extends StatefulWidget {
  const NewShops({super.key});

  @override
  State<NewShops> createState() => _NewShopsState();
}

class _NewShopsState extends State<NewShops> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("This page is for displaying new shops",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold)
      )
    );
  }
}