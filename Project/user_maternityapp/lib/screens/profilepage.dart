import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:user_maternityapp/main.dart';
import 'package:intl/intl.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Map<String, dynamic>? user;
  bool isLoading = true;
  bool isEditing = false;

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    fetchUser();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _contactController.dispose();
    super.dispose();
  }

  Future<void> fetchUser() async {
    try {
      String uid = supabase.auth.currentUser?.id ?? '';
      if (uid.isEmpty) return;
      final response = await supabase.from('tbl_user').select().eq('id', uid).single();
      setState(() {
        user = response;
        isLoading = false;
        _populateFields();
      });
    } catch (e) {
      print('Error fetching user: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  void _populateFields() {
    _nameController.text = user?['user_name'] ?? '';
    _emailController.text = user?['user_email'] ?? '';
    _contactController.text = user?['user_contact'] ?? '';
    _selectedDate = user?['user_dob'] != null ? DateTime.parse(user!['user_dob']) : null;
  }

  int calculateAge(String? dob) {
    if (dob == null) return 0;
    DateTime birthDate = DateTime.parse(dob);
    DateTime today = DateTime.now();
    int age = today.year - birthDate.year;
    if (today.month < birthDate.month || (today.month == birthDate.month && today.day < birthDate.day)) {
      age--;
    }
    return age;
  }

  String calculatePregnancyDuration(String? pregnancyDate) {
    if (pregnancyDate == null) return 'Not Pregnant';
    DateTime startDate = DateTime.parse(pregnancyDate);
    Duration diff = DateTime.now().difference(startDate);
    int weeks = diff.inDays ~/ 7;
    int days = diff.inDays % 7;
    return '$weeks weeks, $days days pregnant';
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _updateProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      isLoading = true;
    });

    try {
      await supabase.from('tbl_user').update({
        'user_name': _nameController.text,
        'user_email': _emailController.text,
        'user_contact': _contactController.text,
        'user_dob': _selectedDate?.toIso8601String(),
      }).eq('id', supabase.auth.currentUser!.id);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Profile updated successfully')),
      );

      setState(() {
        isEditing = false;
        fetchUser(); // Refresh user data
      });
    } catch (e) {
      print('Error updating profile: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update profile')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Logout'),
          content: Text('Are you sure you want to logout?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Logout'),
              onPressed: () async {
                await supabase.auth.signOut();
                Navigator.of(context).pushReplacementNamed('/login'); // Adjust this to your login route
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.blue[700],
        title: Text('Profile', style: GoogleFonts.poppins(fontSize: 22)),
        centerTitle: true,
        elevation: 0,
        actions: [
          if (!isEditing)
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () => setState(() => isEditing = true),
            ),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : user == null
              ? Center(child: Text('User not found'))
              : SingleChildScrollView(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.blue[200],
                        child: Text(
                          user!['user_name']?[0].toUpperCase() ?? '?',
                          style: GoogleFonts.poppins(fontSize: 40, color: Colors.white),
                        ),
                      ),
                      SizedBox(height: 20),
                      if (!isEditing) ...[
                        Text(
                          user!['user_name'] ?? 'Unknown',
                          style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87),
                        ),
                        SizedBox(height: 5),
                        Text(
                          calculatePregnancyDuration(user!['user_pregnancy_date']),
                          style: GoogleFonts.poppins(fontSize: 16, color: Colors.blue[700], fontWeight: FontWeight.w500),
                        ),
                        SizedBox(height: 20),
                        _buildInfoCard('Age', '${calculateAge(user!['user_dob'])} years', Icons.cake),
                        _buildInfoCard('Email', user!['user_email'], Icons.email),
                        _buildInfoCard('Contact', user!['user_contact'], Icons.phone),
                      ],
                      if (isEditing)
                        _buildEditForm(),
                      SizedBox(height: 30),
                      if (!isEditing) ...[
                        _buildActionButton('My Bookings', Icons.calendar_today, () {
                          // Navigate to Bookings page
                        }),
                        _buildActionButton('Change Password', Icons.lock, () {
                          // Implement change password functionality
                        }),
                        _buildActionButton('Logout', Icons.exit_to_app, _showLogoutDialog),
                      ],
                    ],
                  ),
                ),
    );
  }

  Widget _buildInfoCard(String title, String value, IconData icon) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ListTile(
        leading: Icon(icon, color: Colors.blue[700], size: 30),
        title: Text(title, style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600)),
        subtitle: Text(value, style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[700])),
      ),
    );
  }

  Widget _buildActionButton(String title, IconData icon, VoidCallback onPressed) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ElevatedButton.icon(
        icon: Icon(icon, color: Colors.white),
        label: Text(title, style: GoogleFonts.poppins(fontSize: 16)),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue[700],
          foregroundColor: Colors.white,
          minimumSize: Size(double.infinity, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onPressed: onPressed,
      ),
    );
  }

  Widget _buildEditForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _nameController,
            decoration: InputDecoration(labelText: 'Name'),
            validator: (value) => value!.isEmpty ? 'Please enter your name' : null,
          ),
          TextFormField(
            controller: _emailController,
            decoration: InputDecoration(labelText: 'Email'),
            validator: (value) => value!.isEmpty ? 'Please enter your email' : null,
          ),
          TextFormField(
            controller: _contactController,
            decoration: InputDecoration(labelText: 'Contact'),
            validator: (value) => value!.isEmpty ? 'Please enter your contact' : null,
          ),
          ListTile(
            title: Text('Date of Birth'),
            subtitle: Text(_selectedDate == null ? 'Not set' : DateFormat('dd-MM-yyyy').format(_selectedDate!)),
            trailing: Icon(Icons.calendar_today),
            onTap: () => _selectDate(context),
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () => setState(() => isEditing = false),
                child: Text('Cancel'),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
              ),
              ElevatedButton(
                onPressed: _updateProfile,
                child: Text('Save'),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue[700]),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

