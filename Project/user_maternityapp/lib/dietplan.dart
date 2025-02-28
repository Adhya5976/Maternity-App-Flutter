import 'package:flutter/material.dart';
import 'package:user_maternityapp/main.dart';

class DietPlanScreen extends StatefulWidget {
  @override
  _DietPlanScreenState createState() => _DietPlanScreenState();
}

class _DietPlanScreenState extends State<DietPlanScreen> {
  List<Map<String, dynamic>> dietPlans = [];

  @override
  void initState() {
    super.initState();
    fetchDietPlans();
  }

  Future<void> fetchDietPlans() async {
    try {
      final user = await supabase
          .from('tbl_user')
          .select()
          .eq('id', supabase.auth.currentUser!.id)
          .single();

      DateTime pregnancyDate = DateTime.parse(user['user_pregnancy_date']);
      DateTime currentDate = DateTime.now();
      int weeksPregnant = currentDate.difference(pregnancyDate).inDays ~/ 7;
      int trimester = (weeksPregnant ~/ 13) + 1;

      if (trimester < 1) trimester = 1;
      if (trimester > 3) trimester = 3;

      final response = await supabase
          .from('tbl_dietplan')
          .select()
          .eq('dietplan_month', trimester);

      setState(() {
        dietPlans = List<Map<String, dynamic>>.from(response);
      });
    } catch (e) {
      print("Error fetching diet plans: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Diet Plan"),
        centerTitle: true,
        backgroundColor: Colors.blue.shade400,
      ),
      body: dietPlans.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: dietPlans.length,
              itemBuilder: (context, index) {
                final diet = dietPlans[index];
                return DietPlanCard(diet: diet);
              },
            ),
    );
  }
}

class DietPlanCard extends StatelessWidget {
  final Map<String, dynamic> diet;

  const DietPlanCard({Key? key, required this.diet}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 5,
      margin: EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              diet['dietplan_title'],
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              diet['dietplan_description'],
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
            Divider(),
            buildMealRow("🍽️ Breakfast:", diet['dietplan_breakfast']),
            buildMealRow("🍛 Lunch:", diet['dietplan_lunch']),
            buildMealRow("🥗 Dinner:", diet['dietplan_dinner']),
            SizedBox(height: 10),
            Text(
              "Trimester: ${diet['dietplan_month']}",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.blue.shade400),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildMealRow(String mealType, String meal) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Text(
            mealType,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              meal,
              style: TextStyle(color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }
}
