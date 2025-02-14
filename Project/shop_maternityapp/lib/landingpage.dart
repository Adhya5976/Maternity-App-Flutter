import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:shop_maternityapp/homepage.dart';
import 'package:shop_maternityapp/login.dart';
import 'package:shop_maternityapp/signup.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF90BDE6),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                //Logo Goes Here
                Text("Logo"),
                Row(
                  children: [
                    TextButton(
                        onPressed: () {
                           Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Homepage(),
                              ));
                        },
                        child: Text(
                          'Home',
                          style: GoogleFonts.aclonica(
                              color: Colors.white, fontSize: 15),
                        )),
                    TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SignUpPage(),
                              ));
                        },
                        child: Text(
                          'SignUp',
                          style: GoogleFonts.aclonica(
                              color: Colors.white, fontSize: 15),
                        )),
                    TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LoginPage(),
                              ));
                        },
                        child: Text(
                          'Login',
                          style: GoogleFonts.aclonica(
                              color: Colors.white, fontSize: 15),
                        )),
                  ],
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'New Life Begin',
                      style: GoogleFonts.italiana(
                          fontSize: 52,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    Text(
                      'Cherishing Motherhood, Every Step of the Way',
                      style: GoogleFonts.sanchez(
                          fontSize: 25,
                          fontWeight: FontWeight.w100,
                          color: Colors.white),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        "Get Started",
                        style: GoogleFonts.aDLaMDisplay(color: Colors.black),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                  padding: EdgeInsets.only(right: 202, top: 50),
                  child: Lottie.asset('Assets/pregnentwomen.json',
                      fit: BoxFit.cover,
                      width: 450,
                      alignment: Alignment.center)),
            ],
          ),
        ],
      ),
    );
  }
}
