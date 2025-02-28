import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:user_maternityapp/editprofile.dart';
import 'package:user_maternityapp/main.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Map<String, dynamic>? user;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchUser();
  }

  Future<void> fetchUser() async {
    try {
      String uid = supabase.auth.currentUser!.id;
      final response =
          await supabase.from('tbl_user').select().eq('id', uid).single();
      setState(() {
        user = response;
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching user: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  int calculateAge(String? dob) {
    if (dob == null) return 0;
    DateTime birthDate = DateTime.parse(dob);
    DateTime today = DateTime.now();
    int age = today.year - birthDate.year;
    if (today.month < birthDate.month ||
        (today.month == birthDate.month && today.day < birthDate.day)) {
      age--;
    }
    return age;
  }

  String calculatePregnancyDuration(String? pregnancyDate) {
    if (pregnancyDate == null) return 'Not Pregnant';
    DateTime startDate = DateTime.parse(pregnancyDate);
    Duration diff = DateTime.now().difference(startDate);
    int weeks = diff.inDays ~/ 7;
    int months = (weeks / 4).floor();
    return '$months months, $weeks weeks pregnant';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: Text('Profile', style: GoogleFonts.poppins(fontSize: 22)),
        centerTitle: true,
        elevation: 0,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : user == null
              ? Center(child: Text('User not found'))
              : Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(user!['user_name'] ?? 'Unknown',
                          style: GoogleFonts.poppins(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87)),
                      Text(
                        calculatePregnancyDuration(
                            user!['user_pregnancy_date']),
                        style: GoogleFonts.poppins(
                            fontSize: 16,
                            color: Colors.blueAccent,
                            fontWeight: FontWeight.w500),
                      ),
                      SizedBox(height: 20),
                      _buildInfoCard(
                          'Age',
                          '${calculateAge(user!['user_dob'])} years',
                          Icons.cake),
                      _buildInfoCard('Email', user!['user_email'], Icons.email),
                      _buildInfoCard(
                          'Contact', user!['user_contact'], Icons.phone),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => EditprofilePage()));
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueAccent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: EdgeInsets.symmetric(
                              horizontal: 40, vertical: 12),
                        ),
                        child: Text('Edit Profile',
                            style: GoogleFonts.poppins(
                                fontSize: 18, color: Colors.white)),
                      ),
                    ],
                  ),
                ),
    );
  }

  Widget _buildInfoCard(String title, String value, IconData icon) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ListTile(
        leading: Icon(icon, color: Colors.blueAccent, size: 30),
        title: Text(title,
            style:
                GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600)),
        subtitle: Text(value,
            style: GoogleFonts.poppins(fontSize: 16, color: Colors.grey[700])),
      ),
    );
  }
}
