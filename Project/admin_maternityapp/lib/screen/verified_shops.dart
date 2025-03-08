import 'package:flutter/material.dart';

class VerifiedShops extends StatefulWidget {
  const VerifiedShops({super.key});

  @override
  State<VerifiedShops> createState() => _VerifiedShopsState();
}

class _VerifiedShopsState extends State<VerifiedShops> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("This page is for displaying Verified shops",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold)
      )
    );
  }
}