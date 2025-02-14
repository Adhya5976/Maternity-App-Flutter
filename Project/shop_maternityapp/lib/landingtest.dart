import 'package:flutter/material.dart';

class MaternityLandingPage extends StatelessWidget {
  const MaternityLandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Wavy Background
          Positioned.fill(
            child: CustomPaint(
              painter: WavyPainter(),
            ),
          ),

          // Content
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Navigation Bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    _navButton("Home"),
                    _navButton("Read More"),
                    _navButton("Contact"),
                    _navButton("Sign Up"),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Main Content
              Expanded(
                child: Row(
                  children: [
                    // Left Side (Text and Button)
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "New Life Inside",
                              style: TextStyle(
                                fontSize: 40,
                                fontWeight: FontWeight.bold,
                                color: Colors.brown,
                              ),
                            ),
                            const SizedBox(height: 20),
                            const Text(
                              "Lorem ipsum dolor sit amet, consectetur adipiscing elit. "
                              "Vivamus quis dolor non dui lacinia facilisis eget vel tortor. "
                              "Curabitur at hendrerit orci.",
                              style: TextStyle(fontSize: 16, color: Colors.black54),
                            ),
                            const SizedBox(height: 20),
                            ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              child: const Text(
                                "Read More",
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Right Side (Image)
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Image.asset(
                          'new.png', // Replace with actual asset path
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _navButton(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: TextButton(
        onPressed: () {},
        child: Text(
          text,
          style: const TextStyle(fontSize: 16, color: Colors.black87),
        ),
      ),
    );
  }
}

// Custom Painter for Wavy Background
class WavyPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()..color = const Color(0xFFF6D7B0);
    
    Path path = Path();
    path.moveTo(1, size.height * 0.3);
    path.quadraticBezierTo(size.width * 0.25, size.height * 0.15, size.width * 0.5, size.height * 0.25);
    path.quadraticBezierTo(size.width * 0.65, size.height * 0.35, size.width, size.height * 0.2);
    path.lineTo(size.width, 0);
    path.lineTo(0, 0);
    path.close();
    
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
