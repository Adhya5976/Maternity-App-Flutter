import 'package:admin_maternityapp/main.dart';
import 'package:flutter/material.dart';

class ManageDistrict extends StatefulWidget {
  const ManageDistrict({super.key});

  @override
  State<ManageDistrict> createState() => _ManageDistrictState();
}

class _ManageDistrictState extends State<ManageDistrict> {
  final TextEditingController _districtController = TextEditingController();


  Future<void> insert() async {
    try {
      await supabase.from("tbl_district").insert({
        'district_name':_districtController.text,
      });
      _districtController.clear();
      fetchData();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Inserted")));
    } catch (e) {
      print("Error Inserting District");
    }
  }

  List<Map<String,dynamic>> districts = [];

  Future<void> fetchData() async {
    try {
      final response = await supabase.from("tbl_district").select();
      setState(() {
        districts=response;
      });
    } catch (e) {
      print("Error fetching District: $e");
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

  @override
  void initState() {
    super.initState();
    fetchData();
  }

int eid = 0;
Future<void> update()async{
  try {
    await supabase.from('tbl_district').update({
      'district_name' :_districtController.text,
  }).eq('district_id', eid);
  fetchData();
  _districtController.clear();
  setState(() {
    eid=0;
  });
  } catch (e) {
   print("Error updating data: $e" );
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
                controller: _districtController,
                keyboardType: TextInputType.name,
                style: TextStyle(color: const Color.fromARGB(255, 8, 8, 8)),
                decoration: InputDecoration(
                  hintText: "Enter District",
                  hintStyle: TextStyle(color: const Color.fromARGB(255, 18, 18, 18)),
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            ElevatedButton(onPressed: () {
              if(eid==0){
              insert();
            }
            else{
              update();
            }
            },
            child :Text("Submit")),
          ],
        ),
        ListView.builder(
          itemCount: districts.length,
          shrinkWrap: true,
          itemBuilder: (context, index) {
          final data = districts[index];
          return ListTile(
            leading: Text((index + 1).toString()),
            title: Text(data['district_name']),
            trailing: SizedBox(
              width: 80,
child: Row(
 children: [
                    IconButton(onPressed: (){
                      setState(() {
                        eid=data['district_id'];
                        _districtController.text=data['district_name'];
                      });
                    }, icon: Icon(Icons.edit)),
                    IconButton(onPressed: (){
                      delete(data['district_id']);
                       },
                                 icon: Icon(Icons.delete)),
                  ],
                ),
              ),
            );
          }
    
        )
      ]
      );
          }
      
  }   
  