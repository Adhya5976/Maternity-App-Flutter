import 'package:admin_maternityapp/main.dart';
import 'package:flutter/material.dart';

class ManageDistrict extends StatefulWidget {
  const ManageDistrict({super.key});

  @override
  State<ManageDistrict> createState() => _ManageDistrictState();
}

class _ManageDistrictState extends State<ManageDistrict> {
  final TextEditingController _districtController = TextEditingController();
  List<Map<String, dynamic>> districts = [];
  int eid = 0;

Future<void> insert() async {
  try {
    String districtName = _districtController.text.trim();

    // Check if district already exists
    final existingDistricts = await supabase
        .from("tbl_district")
        .select("district_name")
        .eq("district_name", districtName);

    if (existingDistricts.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("District already exists!")),
      );
      return;
    }

    // Insert new district
    await supabase.from("tbl_district").insert({
      'district_name': districtName,
    });

    _districtController.clear();
    fetchData();
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("District Added Successfully")),
    );
  } catch (e) {
    print("Error Inserting District: $e");
  }
}


  Future<void> fetchData() async {
    try {
      final response = await supabase.from("tbl_district").select();
      setState(() {
        districts = response;
      });
    } catch (e) {
      print("Error fetching Districts: $e");
    }
  }

  Future<void> delete(int id) async {
    try {
      await supabase.from('tbl_district').delete().eq('district_id', id);
      fetchData();
    } catch (e) {
      print("Error Deleting: $e");
    }
  }

  Future<void> update() async {
    try {
      await supabase.from('tbl_district').update({
        'district_name': _districtController.text,
      }).eq('district_id', eid);
      fetchData();
      _districtController.clear();
      setState(() {
        eid = 0;
      });
    } catch (e) {
      print("Error updating data: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            color: Color.fromARGB(255, 194, 170, 250),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _districtController,
                      keyboardType: TextInputType.name,
                      decoration: InputDecoration(
                        hintText: "Enter District",
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () {
                      eid == 0 ? insert() : update();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 182, 152, 251),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                    ),
                    child: Text(
                      eid == 0 ? "Add" : "Update",
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold,color: Colors.white),
                      
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: districts.length,
              itemBuilder: (context, index) {
                final data = districts[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Color.fromARGB(255, 194, 170, 250),
                      child: Text((index + 1).toString(),
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                    title: Text(
                      data['district_name'],
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () {
                            setState(() {
                              eid = data['district_id'];
                              _districtController.text = data['district_name'];
                            });
                          },
                          icon: const Icon(Icons.edit, color: Color.fromARGB(255, 160, 141, 247)),
                        ),
                        IconButton(
                          onPressed: () => delete(data['district_id']),
                          icon: const Icon(Icons.delete_outline_rounded, color: Color.fromARGB(255, 160, 141, 247)
                        ),
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
