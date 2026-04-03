import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

class WatchScreen extends StatefulWidget {
  final String title;
  final String videoUrl;

  const WatchScreen({super.key, required this.title, required this.videoUrl});

  @override
  State<WatchScreen> createState() => _WatchScreenState();
}

class _WatchScreenState extends State<WatchScreen> {
  late VideoPlayerController _videoPlayerController;
  ChewieController? _chewieController;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    // 🚀 Cinematic Mode: Force landscape when the player opens
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

    _initializePlayer();
  }

  Future<void> _initializePlayer() async {
    try {
      _videoPlayerController =
          VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl));
      await _videoPlayerController.initialize();

      _chewieController = ChewieController(
        videoPlayerController: _videoPlayerController,
        autoPlay: true,
        looping: false,
        aspectRatio: _videoPlayerController.value.aspectRatio,
        materialProgressColors: ChewieProgressColors(
          playedColor: const Color(0xFF00f0ff),
          handleColor: const Color(0xFFFF0099),
          backgroundColor: Colors.white24,
          bufferedColor: Colors.white54,
        ),
      );

      if (mounted) setState(() => _isLoading = false);
    } catch (e) {
      debugPrint("🚨 VIDEO ERROR: $e");
    }
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController?.dispose();
    // 🚀 Reset System: Back to portrait and show UI when leaving
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // --- 1. THE VIDEO PLAYER ---
          Center(
            child: _isLoading
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const CircularProgressIndicator(color: Color(0xFF00f0ff)),
                      const SizedBox(height: 15),
                      Text(
                        widget.title.toUpperCase(),
                        style: const TextStyle(
                            color: Colors.white,
                            letterSpacing: 3,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "ESTABLISHING SECURE CONNECTION...",
                        style: TextStyle(
                            color: const Color(0xFF00f0ff).withOpacity(0.5),
                            fontSize: 10,
                            letterSpacing: 1),
                      ),
                    ],
                  )
                : Chewie(controller: _chewieController!),
          ),

          // --- 2. THE PERMANENT BACK BUTTON ---
          // 🚀 Removed the 'if (_isLoading)' so you can ALWAYS exit!
          Positioned(
            top: 25,
            left: 25,
            child: GestureDetector(
              onTap: () {
                // Pause the video before popping to prevent audio playing in the background
                _videoPlayerController.pause();
                Navigator.pop(context);
              },
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors
                      .black87, // Darker background to see it over bright videos
                  shape: BoxShape.circle,
                  border:
                      Border.all(color: const Color(0xFF00f0ff), width: 1.5),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF00f0ff).withOpacity(0.5),
                      blurRadius: 10,
                      spreadRadius: 1,
                    )
                  ],
                ),
                child:
                    const Icon(Icons.arrow_back, color: Colors.white, size: 24),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
