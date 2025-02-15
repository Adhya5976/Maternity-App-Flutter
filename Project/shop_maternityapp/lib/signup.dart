import 'package:flutter/material.dart';
import 'package:shop_maternityapp/main.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  List<Map<String, dynamic>> districts = [];
  String? selectedDistrict;
   final TextEditingController _districtController = TextEditingController();
final TextEditingController _nameController = TextEditingController();
final TextEditingController _passwordController = TextEditingController();
final TextEditingController _contactController = TextEditingController();
final TextEditingController _emailController = TextEditingController();
final TextEditingController _confirmpasswordController = TextEditingController();


final formkey = GlobalKey<FormState>();

  Future<void> register() async {
    try {
      final authentication = await supabase.auth.signUp(password: _passwordController.text, email: _emailController.text);
      String uid = authentication.user!.id;
      insertShop(uid);
    } catch (e) {
      print("Error: $e");
}
}

  Future<void> fetchDistrict() async {
    try {
      final response = await supabase.from("tbl_district").select();
      setState(() {
        districts = List<Map<String, dynamic>>.from(response);
      });
    } catch (e) {
      print("Error fetching District: $e");
    }
  }
   Future<void> insertShop(String uid) async {
    try {
      await supabase.from("tbl_shop").insert({
        'shop_name':_nameController.text,
        'shop_password':_passwordController.text,
        'shop_contact':_contactController.text,
        'shop_email':_emailController.text,
        'place_id':selectedPlace
      });
      _nameController.clear();
      _passwordController.clear();
      _contactController.clear();
      _districtController.clear();
      _emailController.clear();
      _confirmpasswordController.clear();
     
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Inserted")));
    } catch (e) {
      print("Error Inserting User: $e");
    }
  }
 List<Map<String, dynamic>> places = [];
  String? selectedPlace;

  Future<void> fetchPlace(String id) async {
    try {
      final response = await supabase.from("tbl_place").select().eq('district_id', id);
      setState(() {
        places = response;
      });
    } catch (e) {
      print("Error fetching Places: $e");
    }
  }
  @override
  void initState() {
    super.initState();
    fetchDistrict();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.lightBlue.shade100, Colors.blue.shade300],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: formkey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Create Your Account',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueGrey.shade800,
                    ),
                  ),
                  SizedBox(height: 50),
                  SizedBox(
                    width: 350,
                    child: TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: 'Full Name',
                        prefixIcon: Icon(Icons.person),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        filled: true,
                        fillColor: Colors.white70,
                      ),
                    ),
                  ),
                  SizedBox(height: 15),
              
                  // Corrected Dropdown
                  SizedBox(
                    width: 350,
                    child: DropdownButtonFormField<String>(
                      value: selectedDistrict,
                      hint: Text("Select District"),
                      items: districts.map((data) {
                        return DropdownMenuItem<String>(
                          value: data['district_id'].toString(),
                          child: Text(data['district_name']),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedDistrict = newValue;
                        });
              fetchPlace(newValue!);
                      },
                      decoration: InputDecoration(
                        labelText: 'District',
                        prefixIcon: Icon(Icons.location_city_outlined),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        filled: true,
                        fillColor: Colors.white70,
                      ),
                    ),
                  ),
                  SizedBox(height: 15),
              SizedBox(
                
                    width: 350,
                    child: DropdownButtonFormField<String>(
                      value: selectedPlace,
                      hint: Text("Select Place"),
                      items: places.map((data) {
                        return DropdownMenuItem<String>(
                          value: data['id'].toString(),
                          child: Text(data['place_name']),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedPlace = newValue;
                        });
                      },
                      decoration: InputDecoration(
                        labelText: 'Place',
                        prefixIcon: Icon(Icons.place),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        filled: true,
                        fillColor: Colors.white70,
                      ),
                    ),
                  ),
                  SizedBox(height: 15),
                  SizedBox(
                    width: 350,
                    child: TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        prefixIcon: Icon(Icons.email),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        filled: true,
                        fillColor: Colors.white70,
                      ),
                    ),
                  ),
                  SizedBox(height: 15),
                  SizedBox(
                    width: 350,
                    child: TextFormField(
                      obscureText: true,
                      controller: _passwordController,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        prefixIcon: Icon(Icons.lock),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        filled: true,
                        fillColor: Colors.white70,
                      ),
                    ),
                  ),
                  SizedBox(height: 15),
                  SizedBox(
                    width: 350,
                    child: TextFormField(
                      obscureText: true,
                      controller: _confirmpasswordController,
                      decoration: InputDecoration(
                        labelText: 'Confirm Password',
                        prefixIcon: Icon(Icons.lock_reset),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        filled: true,
                        fillColor: Colors.white70,
                      ),
                    ),
                  ),
                  SizedBox(height: 15),
                  SizedBox(
                    width: 350,
                    child: TextFormField(
                      controller: _contactController,
                      decoration: InputDecoration(
                        labelText: 'Contact',
                        prefixIcon: Icon(Icons.phone),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        filled: true,
                        fillColor: Colors.white70,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      // Handle sign-up action
                       register();
              
                    },
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      iconColor: Colors.blueAccent,
                    ),
                    child: Text(
                      'Sign Up',
                      style: TextStyle(fontSize: 18, color: Colors.black),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}



