import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:user_maternityapp/main.dart';

class EditprofilePage extends StatefulWidget {
  const EditprofilePage({super.key});

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditprofilePage> {
  final _formKey = GlobalKey<FormState>();
  Map<String, dynamic>? user;
  bool isLoading = true;
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController contactController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController pregnancyDateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchUser();
  }

  Future<void> fetchUser() async {
    try {
      String uid = supabase.auth.currentUser!.id;
      final response = await supabase.from('tbl_user').select().eq('id', uid).single();
      setState(() {
        user = response;
        nameController.text = user!['user_name'] ?? '';
        emailController.text = user!['user_email'] ?? '';
        contactController.text = user!['user_contact'] ?? '';
        dobController.text = user!['user_dob'] ?? '';
        pregnancyDateController.text = user!['user_pregnancy_date'] ?? '';
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching user: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> updateUser() async {
    if (_formKey.currentState!.validate()) {
      try {
        String uid = supabase.auth.currentUser!.id;
        await supabase.from('tbl_user').update({
          'user_name': nameController.text,
          'user_contact': contactController.text,
          'user_dob': dobController.text,
          'user_pregnancy_date': pregnancyDateController.text,
        }).eq('id', uid);
        Navigator.pop(context);
      } catch (e) {
        print('Error updating user: $e');
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: Text('Edit Profile', style: GoogleFonts.poppins(fontSize: 22)),
        centerTitle: true,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    _buildTextField('Name', nameController),
                    _buildTextField('Contact', contactController),
                    _buildDateField('Date of Birth', dobController),
                    _buildDateField('Pregnancy Date', pregnancyDateController),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: updateUser,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                      ),
                      child: Text('Save Changes', style: GoogleFonts.poppins(fontSize: 18, color: Colors.white)),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter $label';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildDateField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
          suffixIcon: Icon(Icons.calendar_today),
        ),
        readOnly: true,
        onTap: () async {
          DateTime? pickedDate = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(1900),
            lastDate: DateTime(2100),
          );
          if (pickedDate != null) {
              controller.text = DateFormat('yyyy-MM-dd').format(pickedDate);
          }
        },
      ),
    );
  }
}
