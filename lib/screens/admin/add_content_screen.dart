import 'package:flutter/material.dart';

class AddContentScreen extends StatefulWidget {
  const AddContentScreen({super.key});

  @override
  _AddContentScreenState createState() => _AddContentScreenState();
}

class _AddContentScreenState extends State<AddContentScreen> {
  final _formKey = GlobalKey<FormState>();
  String _type = 'series';
  String _status = 'ongoing';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF050508),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "INITIALIZE NEW CONTENT",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              _buildTextField("Title"),
              _buildTextField("Slug (URL Friendly)"),
              _buildTextField("Description", maxLines: 3),
              _buildTextField("Thumbnail URL"),
              _buildTextField("Cover URL"),
              _buildTextField("Video URL (Trailer/Movie)"),
              Row(
                children: [
                  Expanded(child: _buildTextField("Release Year")),
                  SizedBox(width: 16),
                  Expanded(child: _buildTextField("Studio")),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: _buildDropdown(
                      "Type",
                      ['movie', 'series'],
                      _type,
                      (val) => setState(() => _type = val!),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: _buildDropdown(
                      "Status",
                      ['ongoing', 'completed'],
                      _status,
                      (val) => setState(() => _status = val!),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFFF0099),
                  ),
                  icon: Icon(Icons.upload, color: Colors.white),
                  label: Text(
                    "PUBLISH TO DATABASE",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // Trigger POST to /api/contents
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Content Submitted!')),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        style: TextStyle(color: Colors.white),
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.grey),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white24),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFFFF0099)),
          ),
          filled: true,
          fillColor: Color(0xFF121216),
        ),
      ),
    );
  }

  Widget _buildDropdown(
    String label,
    List<String> items,
    String currentValue,
    ValueChanged<String?> onChanged,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: DropdownButtonFormField<String>(
        initialValue: currentValue,
        dropdownColor: Color(0xFF121216),
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.grey),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white24),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFFFF0099)),
          ),
          filled: true,
          fillColor: Color(0xFF121216),
        ),
        items: items
            .map(
              (e) => DropdownMenuItem(value: e, child: Text(e.toUpperCase())),
            )
            .toList(),
        onChanged: onChanged,
      ),
    );
  }
}
