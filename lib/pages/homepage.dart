import 'package:flutter/material.dart';
import 'package:hazard_reporting_app/components/post_container.dart';
import 'package:hazard_reporting_app/data_types/utils.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: 15,
                itemBuilder: (BuildContext context, int index) {
                  return const PostContainer(
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
          showDialog(
              context: context,
              builder: (context) {
                return const FilterDialog();
              });
        },
        backgroundColor: const Color(0xFF29AB84),
        child: const Icon(Icons.filter_list),
      ),
    );
  }
}

class FilterDialog extends StatefulWidget {
  const FilterDialog({super.key});

  @override
  State<FilterDialog> createState() => _FilterDialogState();
}

class _FilterDialogState extends State<FilterDialog> {
  List<bool> filter = List.filled(Categories.values.length, false);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text('Filter'),
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.close),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        //Magic
        children: Categories.values.map((Categories cat) {
          return CheckboxListTile(
              value: filter[cat.index],
              dense: true,
              controlAffinity: ListTileControlAffinity.leading,
              onChanged: (bool? val) {
                setState(() {
                  filter[cat.index] = val ?? false;
                });
              },
              title: Text(cat.category.name));
        }).toList(),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text(
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
            backgroundColor: const Color(0xFF29AB84),
          ),
          child: const Text(
            'Apply Filter',
            style: TextStyle(color: Colors.black),
          ),
        ),
      ],
    );
  }
}
