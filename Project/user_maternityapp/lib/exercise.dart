import 'package:flutter/material.dart';
import 'package:user_maternityapp/main.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

class ExerciseScreen extends StatefulWidget {
  @override
  _ExerciseScreenState createState() => _ExerciseScreenState();
}

class _ExerciseScreenState extends State<ExerciseScreen> {
  List<Map<String, dynamic>> exercises = [];

  @override
  void initState() {
    super.initState();
    fetchExercises();
  }

  Future<void> fetchExercises() async {
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
          .from('tbl_exercise')
          .select()
          .eq('exercise_trimester', trimester);

      setState(() {
        exercises = List<Map<String, dynamic>>.from(response);
      });
    } catch (e) {
      print("Error fetching exercises: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Exercise Videos"),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: exercises.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: exercises.length,
              itemBuilder: (context, index) {
                final exercise = exercises[index];
                return ExerciseCard(exercise: exercise);
              },
            ),
    );
  }
}

class ExerciseCard extends StatelessWidget {
  final Map<String, dynamic> exercise;

  const ExerciseCard({Key? key, required this.exercise}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 5,
      margin: EdgeInsets.only(bottom: 16),
      child: ListTile(
        leading: Icon(Icons.play_circle_fill, size: 40, color: Colors.blue.shade100),
        title: Text(
          exercise['exercise_title'],
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(exercise['exercise_description']),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => VideoPlayerScreen(videoUrl: exercise['exercise_file']),
            ),
          );
        },
      ),
    );
  }
}

class VideoPlayerScreen extends StatefulWidget {
  final String videoUrl;

  const VideoPlayerScreen({Key? key, required this.videoUrl}) : super(key: key);

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController _controller;
  ChewieController? _chewieController;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((_) {
        setState(() {
          _chewieController = ChewieController(
            videoPlayerController: _controller,
            autoPlay: true,
            looping: false,
            fullScreenByDefault: true,
          );
        });
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: _chewieController != null &&
                _chewieController!.videoPlayerController.value.isInitialized
            ? Chewie(controller: _chewieController!)
            : CircularProgressIndicator(color: Colors.white),
      ),
    );
  }
}
