import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as path;
import 'package:user_maternityapp/homepage.dart';
import 'package:user_maternityapp/main.dart'; // Import path package

class CreatePost extends StatefulWidget {
  const CreatePost({super.key});

  @override
  State<CreatePost> createState() => _CreatePostState();
}

final TextEditingController _titleController = TextEditingController();

class _CreatePostState extends State<CreatePost> {
  File? _image;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<String?> _uploadImage() async {
    try {
      // Get current date and time
      String formattedDate =
          DateFormat('dd-MM-yyyy-HH-mm').format(DateTime.now());

      // Extract file extension from _image!
      String fileExtension =
          path.extension(_image!.path); // Example: .jpg, .png

      // Generate filename with extension
      String fileName = 'Recipe-$formattedDate$fileExtension';

      await supabase.storage.from('Post').upload(fileName, _image!);

      // Get public URL of the uploaded image
      final imageUrl = supabase.storage.from('Post').getPublicUrl(fileName);
      return imageUrl;
    } catch (e) {
      print('Image upload failed: $e');
      return null;
    }
  }

  Future<void> insertPost() async {
    try {
      String title = _titleController.text;
      
      String? url = await _uploadImage();
      await supabase.from('tbl_post').insert({
        'post_content': title,
        'post_file': url
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          "POST ADDED SUCCESSFULLY!!",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.green,
      ));
      Navigator.push(context,
                   MaterialPageRoute(
                       builder: (context) => const HomeScreen()),
                 );
                    
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          "Failed. Please Try Again!!",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.red,
      ));
      print("ERROR ADDING : $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    appBar: AppBar(
      title: Text('Create Post'),
      backgroundColor: Colors.blueAccent,
      centerTitle: true,
    ),
    body: SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Upload Placeholder
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                height: 300,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(8),
                  image: _image != null
                      ? DecorationImage(
                          image: FileImage(_image!), fit: BoxFit.cover)
                      : null,
                ),
                child: _image == null
                    ? const Center(child: Text("Add Image"))
                    : null, // Remove text when an image is selected
              ),
            ),
            const SizedBox(height: 20),

            // Recipe Title
            TextFormField(
              maxLines: 3,
              controller: _titleController,
              decoration: InputDecoration(
              
                labelText: "Post Title",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            
            // Add Step Button
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromRGBO(
                      255, 213, 85, 1), // Change this to any color you want
                  foregroundColor:
                      const Color.fromARGB(255, 0, 0, 0), // Text color
                  minimumSize: const Size(200, 50), // Width: 200, Height: 50
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        8), // Rectangular shape with slight rounding
                  ),
                ),
                onPressed: () {
                 insertPost();
                },
                child: const Text("NEXT"),
              ),
            ),
          ],
        ),
     ),
    )
    );
}
}