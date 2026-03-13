import 'package:flutter/material.dart';

class AddEpisodeScreen extends StatefulWidget {
  const AddEpisodeScreen({super.key});

  @override
  _AddEpisodeScreenState createState() => _AddEpisodeScreenState();
}

class _AddEpisodeScreenState extends State<AddEpisodeScreen> {
  final _formKey = GlobalKey<FormState>();
  int _episodeNo = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF050508),
      appBar: AppBar(
        title: Text("ADD EPISODE", style: TextStyle(color: Color(0xFFFF0099))),
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Select Series ID", style: TextStyle(color: Colors.grey)),
              SizedBox(height: 8),
              TextFormField(
                style: TextStyle(color: Colors.white),
                decoration: _inputDeco("Content ID (e.g., 1)"),
              ),
              SizedBox(height: 20),

              Text("Episode Number", style: TextStyle(color: Colors.grey)),
              SizedBox(height: 8),
              Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Color(0xFFFF0099),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: IconButton(
                      icon: Icon(Icons.remove, color: Colors.white),
                      onPressed: () {
                        setState(() {
                          if (_episodeNo > 1) _episodeNo--;
                        });
                      },
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        '$_episodeNo',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Color(0xFFFF0099),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: IconButton(
                      icon: Icon(Icons.add, color: Colors.white),
                      onPressed: () {
                        setState(() {
                          if (_episodeNo < 30) _episodeNo++;
                        });
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              TextFormField(
                style: TextStyle(color: Colors.white),
                decoration: _inputDeco("Episode Title"),
              ),
              SizedBox(height: 16),
              TextFormField(
                style: TextStyle(color: Colors.white),
                decoration: _inputDeco("Video URL"),
              ),
              SizedBox(height: 16),
              TextFormField(
                style: TextStyle(color: Colors.white),
                decoration: _inputDeco("Duration (Minutes)"),
              ),
              SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFFF0099),
                  ),
                  icon: Icon(Icons.save, color: Colors.white),
                  label: Text(
                    "SAVE EPISODE",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed: () {
                    // Save logic
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDeco(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: Colors.grey[600]),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.white24),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Color(0xFFFF0099)),
      ),
      filled: true,
      fillColor: Color(0xFF121216),
    );
  }
}
