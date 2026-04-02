import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class WatchScreen extends StatefulWidget {
  final String title;
  final String videoUrl;

  const WatchScreen({super.key, required this.title, required this.videoUrl});

  @override
  State<WatchScreen> createState() => _WatchScreenState();
}

class _WatchScreenState extends State<WatchScreen> {
  @override
  void initState() {
    super.initState();
    // 🚀 Cinematic Mode: Force landscape when the player opens
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    // Hide status bar for full immersion
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  }

  @override
  void dispose() {
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
          // 📺 Placeholder for Video Stream
          Center(
            child: Column(
              // 🚀 FIXED: Changed MainController to MainAxisAlignment
              mainAxisAlignment: MainAxisAlignment.center, 
              children: [
                const Icon(
                  Icons.play_circle_outline, 
                  color: Color(0xFF00f0ff), 
                  size: 80
                ),
                const SizedBox(height: 15),
                Text(
                  widget.title.toUpperCase(),
                  style: const TextStyle(
                    color: Colors.white, 
                    letterSpacing: 3, 
                    fontWeight: FontWeight.w900,
                    fontSize: 18
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "ESTABLISHING SECURE CONNECTION...",
                  style: TextStyle(
                    color: const Color(0xFF00f0ff).withOpacity(0.5), 
                    fontSize: 10,
                    letterSpacing: 1
                  ),
                ),
              ],
            ),
          ),

          // Cyberpunk Back Button
          Positioned(
            top: 30,
            left: 20,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFF00f0ff).withOpacity(0.3)),
                ),
                child: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
              ),
            ),
          ),
        ],
      ),
    );
  }
}