import 'package:admin_maternityapp/main.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ManageSubCategory extends StatefulWidget {
  const ManageSubCategory({super.key});

  @override
  State<ManageSubCategory> createState() => _ManageSubCategoryState();
}

class _ManageSubCategoryState extends State<ManageSubCategory> {
  final TextEditingController _subcategoryController = TextEditingController();

  Future<void> insert() async {
    try {
      await supabase.from("tbl_subcategory").insert({
        'subcategory_name': _subcategoryController.text,
        'category_id':selectedCategory
      });
      _subcategoryController.clear();
      fetchData();
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Inserted")));
    } catch (e) {
      print("Error Inserting SubCategory: $e");
    }
  }

  List<Map<String, dynamic>> subcategory = [];
  Future<void> fetchData() async {
    try {
      final response = await supabase.from("tbl_subcategory").select("*,tbl_category(*)");
      setState(() {
        subcategory = response;
      });
    } catch (e) {
      print("Error fetching SubCategory: $e");
    }
  }

  Future<void> delete(int id) async {
    try {
      await supabase.from('tbl_subcategory').delete().eq('subcategory_id', id);
      fetchData();
    } catch (e) {
      print("Error Deleteing: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    fetchData();
    fetchCategory();
  }

  int eid = 0;

  Future<void> update() async {
    try {
      await supabase.from('tbl_subcategory').update({
        'subcategory_name': _subcategoryController.text,
      }).eq('id', eid);
      fetchData();
      _subcategoryController.clear();
      setState(() {
        eid = 0;
      });
    } catch (e) {
      print("Error updating data: $e");
    }
  }

  List<Map<String, dynamic>> categories = [];

  String? selectedCategory;

  Future<void> fetchCategory() async {
    try {
      final response = await supabase.from("tbl_category").select();
      setState(() {
        categories = response;
      });
    } catch (e) {
      print("Error fetching Category: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
                child: DropdownButtonFormField(
                    decoration: InputDecoration(
                      hintText: "Enter Category",
                      hintStyle:
                          TextStyle(color: const Color.fromARGB(255, 6, 6, 6)),
                      border: OutlineInputBorder(),
                    ),
                    value: selectedCategory,
                    items: categories.map((category) {
                      return DropdownMenuItem(
                          value: category['id'].toString(),
                          child: Text(category['category_name']));
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedCategory = value;
                      });
                    })),
            Expanded(
              child: TextFormField(
                controller: _subcategoryController,
                keyboardType: TextInputType.name,
                style: TextStyle(color: const Color.fromARGB(255, 8, 8, 8)),
                decoration: InputDecoration(
                  hintText: "Enter SubCategory",
                  hintStyle:
                      TextStyle(color: const Color.fromARGB(255, 12, 0, 5)),
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                if (eid == 0) {
                  insert();
                } else {
                  update();
                }
              },
              child: Text("Submit"),
            ),
          ],
        ),
        subcategory.isEmpty
            ? Container() // Show loading indicator if no data
            : ListView.builder(
                itemCount: subcategory.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  final data = subcategory[index];
                  return ListTile(
                    leading: Text((index + 1).toString()),
                    title: Text(data['subcategory_name']),
                    subtitle: Text(data['tbl_category']['category_name']),
                    trailing: SizedBox(
                      width: 80,
                      child: Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              setState(() {
                                eid = data['id'];
                                _subcategoryController.text =
                                    data['subcategory_name'];
                              });
                            },
                            icon: Icon(Icons.edit),
                          ),
                          IconButton(
                            onPressed: () {
                              delete(data['id']);
                            },
                            icon: Icon(Icons.delete),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ],
    );
  }
}
