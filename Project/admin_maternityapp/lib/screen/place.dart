import 'package:admin_maternityapp/main.dart';
import 'package:flutter/material.dart';

class ManagePlace extends StatefulWidget {
  const ManagePlace({super.key});

  @override
  State<ManagePlace> createState() => _ManagePlaceState();
}

class _ManagePlaceState extends State<ManagePlace> {
  final TextEditingController _placeController = TextEditingController();

  Future<void> insert() async {
    try {
      await supabase.from("tbl_place").insert({
        'place_name': _placeController.text,
        'district_id':selectedDistrict
      });
      _placeController.clear();
      fetchData();
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Inserted")));
    } catch (e) {
      print("Error Inserting Place");
    }
  }

  List<Map<String, dynamic>> place = [];
  Future<void> fetchData() async {
    try {
      final response = await supabase.from("tbl_place").select("*,tbl_district(*)");
      setState(() {
        place = response;
      });
    } catch (e) {
      print("Error fetching Place: $e");
    }
  }

  Future<void> delete(int id) async {
    try {
      await supabase.from('tbl_place').delete().eq('id', id);
      fetchData();
    } catch (e) {
      print("Error Deleteing: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    fetchData();
    fetchDistrict();
  }

  int eid = 0;

  Future<void> update() async {
    try {
      await supabase.from('tbl_place').update({
        'place_name': _placeController.text,
      }).eq('id', eid);
      fetchData();
      _placeController.clear();
      setState(() {
        eid = 0;
      });
    } catch (e) {
      print("Error updating data: $e");
    }
  }

  List<Map<String, dynamic>> districts = [];

  String? selectedDistrict;

  Future<void> fetchDistrict() async {
    try {
      final response = await supabase.from("tbl_district").select();
      setState(() {
        districts = response;
      });
    } catch (e) {
      print("Error fetching District: $e");
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
                  hintText: "Enter District",
                  hintStyle: TextStyle(color: const Color.fromARGB(255, 6, 6, 6)),
                  border: OutlineInputBorder(),),
                  value: selectedDistrict,
                    items: districts.map((district) {
                      return DropdownMenuItem(
                        value: district['district_id'].toString(),
                          child: Text(district['district_name']));
                    }).toList(),
                    onChanged: (value){
                      setState(() {
                        selectedDistrict=value;
                      });
                    })),
            Expanded(
              child: TextFormField(
                controller: _placeController,
                keyboardType: TextInputType.name,
                style: TextStyle(color: const Color.fromARGB(255, 8, 8, 8)),
                decoration: InputDecoration(
                  hintText: "Enter Place",
                  hintStyle: TextStyle(color: const Color.fromARGB(255, 6, 6, 6)),
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
          itemCount: place.length,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            final data = place[index];
            return ListTile(
              leading: Text((index + 1).toString()),
              title: Text(data['place_name']),
              subtitle: Text(data['tbl_district']['district_name']),
              trailing: SizedBox(
                width: 80,
                child: Row(
                  children: [
                    IconButton(
                        onPressed: () {
                          setState(() {
                            eid = data['id'];
                            _placeController.text = data['place_name'];
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
