import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:shop_maternityapp/main.dart';
import 'package:file_picker/file_picker.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  File? _shopImage;
  final picker = ImagePicker();
  List<Map<String, dynamic>> districts = [];
  String? selectedDistrict;
  final TextEditingController _districtController = TextEditingController();
  final TextEditingController _placeController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  final TextEditingController _proofController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _confirmpasswordController =
      TextEditingController();

  final formkey = GlobalKey<FormState>();

  Uint8List? _imageBytes; // Used for Web

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      _imageBytes =
          await pickedFile.readAsBytes(); // Convert to Uint8List for Web
      setState(() {}); // Refresh UI
    }
  }

  PlatformFile? pickedProof;

  Future<void> handleProofPick() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: false, // Only single file upload
    );
    if (result != null) {
      setState(() {
        pickedProof = result.files.first;
        _proofController.text = result.files.first.name;
      });
    }
  }

  Future<String?> uploadImage() async {
    if (_imageBytes == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select an image first!')),
      );
      return "";
    }

    try {
      final String fileName =
          'shop_photos/${DateTime.now().millisecondsSinceEpoch}.png';

      // Upload the file to Supabase Storage (Bucket: "shop_photos")
      await supabase.storage.from('shop').uploadBinary(
            fileName,
            _imageBytes!,
          );

      // Get the public URL of the uploaded image
      final imageUrl =
          supabase.storage.from('shop').getPublicUrl(fileName);

      print('Image uploaded successfully: $imageUrl');
      return imageUrl;
    } catch (e) {
      print('Upload Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Upload Failed!')),
      );
      return null;
    }
  }

  Future<String?> proofUpload() async {
    try {
      final bucketName = 'shop'; // Replace with your bucket name
      String formattedDate =
          DateFormat('dd-MM-yyyy-HH-mm').format(DateTime.now());
      final filePath = "$formattedDate-${pickedProof!.name}";
      await supabase.storage.from(bucketName).uploadBinary(
            filePath,
            pickedProof!.bytes!, // Use file.bytes for Flutter Web
          );
      final publicUrl =
          supabase.storage.from(bucketName).getPublicUrl(filePath);
      // await updateImage(uid, publicUrl);
      return publicUrl;
    } catch (e) {
      print("Error photo upload: $e");
      return null;
    }
  }

  Future<void> register() async {
    try {
      final authentication = await supabase.auth.signUp(
          password: _passwordController.text, email: _emailController.text);
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
      String? imageUrl = await uploadImage();
      String? proofUrl = await proofUpload();
      await supabase.from("tbl_shop").insert({
        'shop_name': _nameController.text,
        'shop_password': _passwordController.text,
        'shop_address': _addressController.text,
        'shop_contact': _contactController.text,
        'shop_email': _emailController.text,
        'place_id': selectedPlace,
        'shop_logo': imageUrl,
        'shop_proof': proofUrl,
      });
      _nameController.clear();
      _passwordController.clear();
      _addressController.clear();
      _proofController.clear();
      _districtController.clear();
      _placeController.clear();
      _contactController.clear();
      _districtController.clear();
      _emailController.clear();
      _confirmpasswordController.clear();
      setState(() {
        _shopImage = null;
      });

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Inserted")));
    } catch (e) {
      print("Error Inserting User: $e");
    }
  }

  List<Map<String, dynamic>> places = [];
  String? selectedPlace;

  Future<void> fetchPlace(String id) async {
    try {
      final response =
          await supabase.from("tbl_place").select().eq('district_id', id);
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
                  SizedBox(height: 15),
                  GestureDetector(
                    onTap: pickImage,
                    child: CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.grey[300],
                      child: _imageBytes != null
                          ? ClipOval(
                              child: Image.memory(
                                _imageBytes!,
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                              ),
                            )
                          : Icon(Icons.add_a_photo,
                              size: 40, color: Colors.grey[700]),
                    ),
                  ),

                  SizedBox(height: 15),
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
                      controller: _addressController,
                      decoration: InputDecoration(
                        labelText: 'Address',
                        prefixIcon: Icon(Icons.home_max_outlined),
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
                  SizedBox(height: 15),
                  SizedBox(
                    width: 350,
                    child: TextFormField(
                      controller: _proofController,
                      readOnly: true,
                      onTap: handleProofPick,
                      decoration: InputDecoration(
                        labelText: 'Proof',
                        prefixIcon: Icon(Icons.phone),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        filled: true,
                        fillColor: Colors.white70,
                      ),
                    ),
                  ),
                  SizedBox(height: 15),
                  ElevatedButton(
                    onPressed: () {
                      // Handle sign-up action
                      register();
                    },
                    style: ElevatedButton.styleFrom(
                      padding:
                          EdgeInsets.symmetric(horizontal: 50, vertical: 15),
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
