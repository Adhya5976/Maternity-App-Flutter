import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AccountManagementPage extends StatefulWidget {
  const AccountManagementPage({super.key});

  @override
  State<AccountManagementPage> createState() => _AccountManagementPageState();
}

class _AccountManagementPageState extends State<AccountManagementPage> {
  final _formKey = GlobalKey<FormState>();
  
  // Shop Information
  final _shopNameController = TextEditingController(text: "Maternity Bliss");
  final _ownerNameController = TextEditingController(text: "Sarah Johnson");
  final _emailController = TextEditingController(text: "sarah@maternitybliss.com");
  final _phoneController = TextEditingController(text: "+1 (555) 123-4567");
  final _addressController = TextEditingController(text: "123 Maternity Lane, New York, NY 10001");
  final _websiteController = TextEditingController(text: "www.maternitybliss.com");
  final _descriptionController = TextEditingController(
    text: "Maternity Bliss is a premium maternity shop offering high-quality clothing, accessories, and care products for expecting mothers. We focus on comfort, style, and wellness throughout the pregnancy journey.",
  );
  
  // Business Hours
  final Map<String, Map<String, String>> _businessHours = {
    'Monday': {'open': '9:00 AM', 'close': '6:00 PM'},
    'Tuesday': {'open': '9:00 AM', 'close': '6:00 PM'},
    'Wednesday': {'open': '9:00 AM', 'close': '6:00 PM'},
    'Thursday': {'open': '9:00 AM', 'close': '6:00 PM'},
    'Friday': {'open': '9:00 AM', 'close': '6:00 PM'},
    'Saturday': {'open': '10:00 AM', 'close': '4:00 PM'},
    'Sunday': {'open': 'Closed', 'close': 'Closed'},
  };
  
  // Services
  final List<Map<String, dynamic>> _services = [
    {
      'name': 'Maternity Photoshoot',
      'duration': '1 hour',
      'price': 150.00,
      'isActive': true,
    },
    {
      'name': 'Prenatal Consultation',
      'duration': '45 minutes',
      'price': 75.00,
      'isActive': true,
    },
    {
      'name': 'Product Fitting',
      'duration': '30 minutes',
      'price': 0.00,
      'isActive': true,
    },
    {
      'name': 'Nutrition Consultation',
      'duration': '1 hour',
      'price': 90.00,
      'isActive': false,
    },
  ];
  
  // Password Change
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  
  bool _isEditingShopInfo = false;
  bool _isEditingBusinessHours = false;
  bool _isPasswordVisible = false;
  
  @override
  void dispose() {
    _shopNameController.dispose();
    _ownerNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _websiteController.dispose();
    _descriptionController.dispose();
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 245, 245, 250),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Text(
              "Account Management",
              style: GoogleFonts.sanchez(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 30),
            
            // Shop Information
            
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
