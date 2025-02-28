import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:user_maternityapp/addpost.dart';
import 'package:user_maternityapp/dietplan.dart';
import 'package:user_maternityapp/exercise.dart';
import 'package:user_maternityapp/profilepage.dart';
import 'package:user_maternityapp/shopping.dart';
import 'package:user_maternityapp/weighttracker.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context),
              const SizedBox(height: 20),
              _buildCountdownCard(),
              const SizedBox(height: 30),
              _buildFeatureRow(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Hello, User 👋',
          style: GoogleFonts.poppins(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        GestureDetector(
          onTap: () {
             Navigator.push(context, MaterialPageRoute(builder: (context) => ProfilePage()));
          },
          child: CircleAvatar(
            radius: 25,
            backgroundColor: Colors.blue.shade200,
            child: Icon(Icons.person, color: Colors.white, size: 28),
          ),
        ),
      ],
    );
  }

  Widget _buildCountdownCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blueAccent, Colors.blue.shade400],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.shade100,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '36 days until your baby arrives 🎉',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            'Stay healthy and keep tracking your progress!',
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureRow(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          child: _buildFeatureCard(Icons.fitness_center, 'Exercise',ExerciseScreen(),context),),
        const SizedBox(height: 15),
        _buildFeatureCard(Icons.restaurant_menu, 'Diet Plans',DietPlanScreen(),context),
        const SizedBox(height: 15),
        _buildFeatureCard(Icons.monitor_weight, 'Weight Tracker',WeightTrackingPage(),context),
        const SizedBox(height: 15),
        _buildFeatureCard(Icons.shopping_bag, 'Shopping',ShoppingPage(),context),
        const SizedBox(height: 15),
        _buildFeatureCard(Icons.add_a_photo_sharp, 'Post',CreatePost(),context),
      ],
    );
  }

  Widget _buildFeatureCard(IconData icon, String title, Widget page, BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push( context, MaterialPageRoute(builder: (context) => page));
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 25,
              backgroundColor: Colors.blue.shade100,
              child: Icon(icon, color: Colors.blue, size: 30),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
            ),
            const Icon(Icons.arrow_forward_ios, color: Colors.black45, size: 20),
          ],
        ),
      ),
    );
  }
}


