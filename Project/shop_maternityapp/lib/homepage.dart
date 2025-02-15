import 'package:flutter/material.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(image: AssetImage('Assets/8682612.jpg'), fit: BoxFit.cover)
        ),
        child: ListView(  
          children: [
            Container(
              padding: EdgeInsets.all(25),
              height: 200,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(50),
                  bottomRight: Radius.circular(50),
                )
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [CircleAvatar(
                  radius: 52,
                  child: Text('Shop'),
                ),
                Column(
                  children: [
                    Text("Welcome,"),
                    Text("Shop,"),
                  ],
                ),
                ],
              ),
            ),
            GridView.builder(gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3,
            childAspectRatio: 1.3,
            crossAxisSpacing: 40,
            mainAxisSpacing: 40
            ),
            padding: EdgeInsets.all(50),
            shrinkWrap: true,
            itemCount: 6,
            itemBuilder: (context, index) {
              return Card();
            },
            
            
            )
          ],
        ),
      )
    );
  }
}
