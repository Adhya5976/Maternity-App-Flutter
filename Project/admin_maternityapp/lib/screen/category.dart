import 'package:admin_maternityapp/main.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ManageCategory extends StatefulWidget {
  const ManageCategory({super.key});

  @override
  State<ManageCategory> createState() => _ManageCategoryState();
}

class _ManageCategoryState extends State<ManageCategory> {
  final TextEditingController _categoryController = TextEditingController();

  Future<void> insert() async {
    try {
      await supabase.from("tbl_category").insert({
        'category_name': _categoryController.text,
      });
      _categoryController.clear();
      fetchData();
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Inserted")));
    } catch (e) {
      print("Error Inserting Category");
    }
  }

  List<Map<String, dynamic>> category = [];
  Future<void> fetchData() async {
    try {
      final response = await supabase.from("tbl_category").select();
      setState(() {
        category = response;
      });
    } catch (e) {
      print("Error fetching Category: $e");
    }
  }

  Future<void> delete(int id) async {
    try {
      await supabase.from('tbl_category').delete().eq('id', id);
      fetchData();
    } catch (e) {
      print("Error Deleteing: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  int eid = 0;

  Future<void> update() async {
    try {
      await supabase.from('tbl_category').update({
        'category_name': _categoryController.text,
      }).eq('id', eid);
      fetchData();
      _categoryController.clear();
      setState(() {
        eid = 0;
      });
    } catch (e) {
      print("Error updating data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _categoryController,
                keyboardType: TextInputType.name,
                style: TextStyle(color: const Color.fromARGB(255, 8, 8, 8)),
                decoration: InputDecoration(
                  hintText: "Enter Category",
                  hintStyle: TextStyle(color: const Color.fromARGB(255, 12, 0, 5)),
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
                child: Text("Submit")),
          ],
        ),
        ListView.builder(
          itemCount: category.length,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            final data = category[index];
            return ListTile(
              leading: Text((index + 1).toString()),
              title: Text(data['category_name']),
              trailing: SizedBox(
                width: 80,
                child: Row(
                  children: [
                    IconButton(
                        onPressed: () {
                          setState(() {
                            eid = data['id'];
                            _categoryController.text = data['category_name'];
                          });
                        },
                        icon: Icon(Icons.edit)),
                    IconButton(
                        onPressed: () {
                          delete(data['id']);
                        },
                        icon: Icon(Icons.delete)),
                  ],
                ),
              ),
            );
          },
        )
      ],
    );
  }
}
