import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:user_maternityapp/main.dart';

class WeightCheck extends StatefulWidget {
  const WeightCheck({super.key});

  @override
  State<WeightCheck> createState() => _WeightCheckState();
}

class _WeightCheckState extends State<WeightCheck> {
  Future<void> update() async {
    try {
      String userId = supabase.auth.currentUser!.id;
      print("Userid: $userId");
      print("Value: $weight");
      await supabase.from('tbl_user').update({
        'user_weight': weight,
      }).eq('user_id', userId);
    } catch (e) {
      print("Error : $e");
    }
  }

  double weight = 55.0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: 20,
            ),
            Text(
                "For more personalized insights, kindly share your weight.",
                style: GoogleFonts.sortsMillGoudy().copyWith(
                  color: Colors.blueAccent,
                  fontSize: 24,
                )),
            SizedBox(
              height: 55,
            ),
            SizedBox(
              height: 250,
              child: SfRadialGauge(
                axes: <RadialAxis>[
                  RadialAxis(
                    minimum: 0, // ✅ Min weight set to 0
                    maximum: 120, // ✅ Max weight set to 120
                    startAngle: 150,
                    endAngle: 30,
                    showLabels: true,
                    showTicks: true,
                    axisLineStyle: AxisLineStyle(
                      thickness: 8,
                      color: Colors.grey.shade300,
                    ),
                    majorTickStyle:
                        MajorTickStyle(length: 10, thickness: 1.5),
                    minorTicksPerInterval: 3,
                    pointers: <GaugePointer>[
                      MarkerPointer(
                        // ✅ Draggable Pointer
                        value: weight,
                        markerType: MarkerType.invertedTriangle,
                        color: Color(0xFFDC010E),
                        markerHeight: 15,
                        markerWidth: 15,
                        enableDragging: true, // ✅ Enables dragging
                        onValueChanged: (value) {
                          setState(() {
                            weight = double.parse(value.toStringAsFixed(
                                1)); // ✅ Update weight dynamically
                          });
                        },
                      ),
                    ],
                    annotations: <GaugeAnnotation>[
                      GaugeAnnotation(
                        widget: Text(
                          "${weight.toStringAsFixed(1)} KG", // ✅ Show 1 decimal place
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: const Color.fromARGB(255, 3, 3, 3),
                          ),
                        ),
                        angle: 90,
                        positionFactor: 1.5,
                      )
                    ],
                  )
                ],
              ),
            ),
            SizedBox(
              height: 155,
            ),
            ElevatedButton(
              onPressed: () {
                update();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                overlayColor: Color.fromARGB(255, 8, 8, 8),
                shadowColor: Colors.lightBlueAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
              child: Text(
                "NEXT",
                style: GoogleFonts.sortsMillGoudy().copyWith(
                  color: const Color.fromARGB(221, 255, 255, 255),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
