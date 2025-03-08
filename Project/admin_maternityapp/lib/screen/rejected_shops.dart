import 'package:flutter/material.dart';

class RejectedShop extends StatefulWidget {
  const RejectedShop({super.key});

  @override
  State<RejectedShop> createState() => _RejectedShopState();
}

class _RejectedShopState extends State<RejectedShop> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("This page is for displaying rejected shops",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold)
      )
    );
  }
}