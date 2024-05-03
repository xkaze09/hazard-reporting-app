import 'package:flutter/material.dart';
import 'package:hazard_reporting_app/components/post_container.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Home Page',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF146136),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: 15,
                itemBuilder: (BuildContext context, int index) {
                  return PostContainer(
                    displayName: '[Display Name]',
                    location: '[Location]',
                    title: '[Title]',
                    category: '[Category]',
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showFilterDialog(context);
        },
        backgroundColor: Color(0xFF29AB84),
        child: Icon(Icons.filter_list),
      ),
    );
  }

  void _showFilterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Filter'),
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(Icons.close),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildFilterCheckbox('Wet'),
              _buildFilterCheckbox('Obstruction'),
              _buildFilterCheckbox('Electrical'),
              _buildFilterCheckbox('Fire'),
              _buildFilterCheckbox('Structural'),
              _buildFilterCheckbox('Visibility'),
              _buildFilterCheckbox('Sanitation'),
              _buildFilterCheckbox('Chemical'),
              _buildFilterCheckbox('Vandalism'),
              _buildFilterCheckbox('Misc'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                'Reset',
                style: TextStyle(color: Colors.black), 
              ),
            ),
            ElevatedButton(
              onPressed: () {
                // implement apply filter 
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF29AB84), 
              ),
              child: Text(
                'Apply Filter',
                style: TextStyle(color: Colors.black), 
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildFilterCheckbox(String filter) {
    return Row(
      children: [
        Checkbox(
          // Implement to manage selected filters
          value: false,
          onChanged: (value) {
            // Implement to manage selected filters
          },
        ),
        Text(filter),
      ],
    );
  }
}
