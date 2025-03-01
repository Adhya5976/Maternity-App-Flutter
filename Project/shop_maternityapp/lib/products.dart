import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shop_maternityapp/main.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as path; // Import path package

class ProductManagementPage extends StatefulWidget {
  const ProductManagementPage({super.key});

  @override
  State<ProductManagementPage> createState() => _ProductManagementPageState();
}

class _ProductManagementPageState extends State<ProductManagementPage> {
  final nameController = TextEditingController();
  final descController = TextEditingController();
  final priceController = TextEditingController();
  final imageController = TextEditingController();

  PlatformFile? pickedImage;

  // Handle File Upload Process
  Future<void> handleImagePick() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: false, // Only single file upload
    );
    if (result != null) {
      setState(() {
        pickedImage = result.files.first;
        imageController.text = result.files.first.name;
      });
    }
  }

  Future<String?> photoUpload() async {
    try {
      final bucketName = 'product'; // Replace with your bucket name
      String formattedDate =
          DateFormat('dd-MM-yyyy-HH-mm').format(DateTime.now());
      final filePath = "$formattedDate-${pickedImage!.name}";
      await supabase.storage.from(bucketName).uploadBinary(
            filePath,
            pickedImage!.bytes!, // Use file.bytes for Flutter Web
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


  final List<Map<String, dynamic>> _products = [
    {
      'id': '1',
      'name': 'Maternity Dress - Floral',
      'category': 'Clothing',
      'price': 79.99,
      'stock': 15,
      'image': 'Assets/product1.jpg',
    },
    {
      'id': '2',
      'name': 'Pregnancy Support Belt',
      'category': 'Accessories',
      'price': 45.50,
      'stock': 23,
      'image': 'Assets/product2.jpg',
    },
    {
      'id': '3',
      'name': 'Prenatal Vitamins',
      'category': 'Nutrition',
      'price': 29.99,
      'stock': 42,
      'image': 'Assets/product3.jpg',
    },
    {
      'id': '4',
      'name': 'Maternity Leggings',
      'category': 'Clothing',
      'price': 34.99,
      'stock': 18,
      'image': 'Assets/product4.jpg',
    },
    {
      'id': '5',
      'name': 'Stretch Mark Cream',
      'category': 'Care',
      'price': 22.50,
      'stock': 30,
      'image': 'Assets/product5.jpg',
    },
  ];

  String _searchQuery = '';
  String _selectedCategory = 'All';

  List<Map<String, dynamic>> get _filteredProducts {
    return _products.where((product) {
      final matchesSearch =
          product['name'].toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesCategory = _selectedCategory == 'All' ||
          product['category'] == _selectedCategory;
      return matchesSearch && matchesCategory;
    }).toList();
  }

  List<Map<String, dynamic>> category = [];
  String? selectedCategory;

  String? selectedSUbcat;

  Future<void> insert() async {
    try {
      String? url = await photoUpload();
      await supabase.from("tbl_product").insert({
        'product_name': nameController.text,
        'subcategory_id': selectedSUbcat,
        'product_description': descController.text,
        'product_price': priceController.text,
        'product_image': url,
      });

  

      nameController.clear();
      descController.clear();
      priceController.clear();
      imageController.clear();

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Product Inserted")));
      Navigator.pop(context);
    } catch (e) {
      print("Error Inserting Product");
    }
  }

  Future<void> fetchCat() async {
    try {
      final response = await supabase.from("tbl_category").select();
      setState(() {
        category = List<Map<String, dynamic>>.from(response);
      });
    } catch (e) {
      print("Error fetching Category: $e");
    }
  }



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchCat();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 245, 245, 250),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Product Management",
                  style: GoogleFonts.sanchez(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    _showAddProductDialog(context);
                  },
                  icon: Icon(Icons.add),
                  label: Text("Add Product"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 198, 176, 249),
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),

            // Search and Filter
            Row(
              children: [
                Expanded(
                  child: TextField(
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value;
                      });
                    },
                    decoration: InputDecoration(
                      hintText: "Search products...",
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      contentPadding: EdgeInsets.symmetric(vertical: 10),
                    ),
                  ),
                ),
                SizedBox(width: 20),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _selectedCategory,
                      items: [
                        'All',
                        'Clothing',
                        'Accessories',
                        'Nutrition',
                        'Care'
                      ]
                          .map((category) => DropdownMenuItem(
                                value: category,
                                child: Text(category),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedCategory = value!;
                        });
                      },
                      hint: Text("Category"),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),

            // Products Grid
            Expanded(
              child: _filteredProducts.isEmpty
                  ? Center(
                      child: Text(
                        "No products found",
                        style: GoogleFonts.sanchez(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                      ),
                    )
                  : GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount:
                            MediaQuery.of(context).size.width > 1200 ? 4 : 3,
                        childAspectRatio: 0.8,
                        crossAxisSpacing: 20,
                        mainAxisSpacing: 20,
                      ),
                      itemCount: _filteredProducts.length,
                      itemBuilder: (context, index) {
                        final product = _filteredProducts[index];
                        return _buildProductCard(product);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductCard(Map<String, dynamic> product) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product Image
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
                image: DecorationImage(
                  image: AssetImage(product['image']),
                  fit: BoxFit.cover,
                ),
              ),
              child: Stack(
                children: [
                  Positioned(
                    top: 10,
                    right: 10,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        product['category'],
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 198, 176, 249),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Product Details
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product['name'],
                  style: GoogleFonts.sanchez(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '\$${product['price'].toStringAsFixed(2)}',
                      style: GoogleFonts.sanchez(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 198, 176, 249),
                      ),
                    ),
                    Text(
                      'Stock: ${product['stock']}',
                      style: GoogleFonts.sanchez(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          _showEditProductDialog(context, product);
                        },
                        icon: Icon(Icons.edit, size: 16),
                        label: Text("Edit"),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.blue,
                          side: BorderSide(color: Colors.blue),
                          padding: EdgeInsets.symmetric(vertical: 0),
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          _showDeleteConfirmation(context, product);
                        },
                        icon: Icon(Icons.delete, size: 16),
                        label: Text("Delete"),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.red,
                          side: BorderSide(color: Colors.red),
                          padding: EdgeInsets.symmetric(vertical: 0),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showAddProductDialog(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    List<Map<String, dynamic>> subcat = [];

    Future<void> fetchSubcat(String id, Function setState) async {
      try {
        final response = await supabase
            .from("tbl_subcategory")
            .select()
            .eq('category_id', id);
        print(response);
        setState(() {
          subcat = response;
        });
      } catch (e) {
        print("Error fetching Subcategories: $e");
      }
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Add New Product"),
        content: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: StatefulBuilder(
              builder: (context, setState) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    /// Product Name Field
                    TextFormField(
                      controller: nameController,
                      decoration: InputDecoration(
                        labelText: "Product Name",
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter product name';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 15),

                    /// Product Description Field
                    TextFormField(
                      controller: descController,
                      decoration: InputDecoration(
                        labelText: "Product Description",
                        border: OutlineInputBorder(),
                      ),
                      minLines: 1,
                      maxLines: null,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter product description';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 15),

                    /// Product Price Field
                    TextFormField(
                      controller: priceController,
                      decoration: InputDecoration(
                        labelText: "Price (\$)",
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter price';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Please enter a valid number';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 15),

                    /// Category Dropdown
                    DropdownButtonFormField<String>(
                      value: selectedCategory,
                      hint: Text("Select Category"),
                      items: category.map((data) {
                        return DropdownMenuItem<String>(
                          value: data['id'].toString(),
                          child: Text(data['category_name']),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedCategory = newValue;
                          selectedSUbcat = null; // Reset subcategory
                          subcat.clear(); // Clear previous subcategories
                        });
                        fetchSubcat(newValue!, setState);
                      },
                      decoration: InputDecoration(
                        labelText: 'Category',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 15),

                    /// Subcategory Dropdown
                    DropdownButtonFormField<String>(
                      value: selectedSUbcat,
                      hint: Text("Select Subcategory"),
                      items: subcat.map((data) {
                        return DropdownMenuItem<String>(
                          value: data['id'].toString(),
                          child: Text(data['subcategory_name']),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedSUbcat = newValue;
                        });
                      },
                      decoration: InputDecoration(
                        labelText: 'Subcategory',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 15),

                    /// Image Picker Field
                    TextFormField(
                      onTap: handleImagePick,
                      controller: imageController,
                      decoration: InputDecoration(
                        labelText: "Image",
                        border: OutlineInputBorder(),
                      ),
                      readOnly: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select an image';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 15),
                  ],
                );
              },
            ),
          ),
        ),
        actions: [
          /// Cancel Button
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel"),
          ),

          /// Add Product Button
          ElevatedButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                insert(); // Insert logic
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color.fromARGB(255, 198, 176, 249),
              foregroundColor: Colors.white,
            ),
            child: Text("Add Product"),
          ),
        ],
      ),
    );
  }

  void _showEditProductDialog(
      BuildContext context, Map<String, dynamic> product) {
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController(text: product['name']);
    final priceController =
        TextEditingController(text: product['price'].toString());
    final stockController =
        TextEditingController(text: product['stock'].toString());
    String category = product['category'];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Edit Product"),
        content: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: "Product Name",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter product name';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 15),
                DropdownButtonFormField<String>(
                  value: category,
                  decoration: InputDecoration(
                    labelText: "Category",
                    border: OutlineInputBorder(),
                  ),
                  items: ['Clothing', 'Accessories', 'Nutrition', 'Care']
                      .map((category) => DropdownMenuItem(
                            value: category,
                            child: Text(category),
                          ))
                      .toList(),
                  onChanged: (value) {
                    category = value!;
                  },
                ),
                SizedBox(height: 15),
                TextFormField(
                  controller: priceController,
                  decoration: InputDecoration(
                    labelText: "Price (\$)",
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter price';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Please enter a valid number';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 15),
                TextFormField(
                  controller: stockController,
                  decoration: InputDecoration(
                    labelText: "Stock",
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter stock quantity';
                    }
                    if (int.tryParse(value) == null) {
                      return 'Please enter a valid number';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 15),
                ElevatedButton.icon(
                  onPressed: () {
                    // Image upload logic would go here
                  },
                  icon: Icon(Icons.upload),
                  label: Text("Change Image"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[200],
                    foregroundColor: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                // Update product logic would go here
                setState(() {
                  final index =
                      _products.indexWhere((p) => p['id'] == product['id']);
                  if (index != -1) {
                    _products[index] = {
                      'id': product['id'],
                      'name': nameController.text,
                      'category': category,
                      'price': double.parse(priceController.text),
                      'stock': int.parse(stockController.text),
                      'image': product['image'],
                    };
                  }
                });
                Navigator.pop(context);
              }
            },
            child: Text("Save Changes"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Color.fromARGB(255, 198, 176, 249),
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(
      BuildContext context, Map<String, dynamic> product) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Delete Product"),
        content: Text("Are you sure you want to delete '${product['name']}'?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _products.removeWhere((p) => p['id'] == product['id']);
              });
              Navigator.pop(context);
            },
            child: Text("Delete"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
