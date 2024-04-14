import 'package:flutter/material.dart';

import '../components/template.dart';
import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:image_picker/image_picker.dart';
import '../data_types/utils.dart';

void main() {
  // WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();
  runApp(const UPatrol());
}

class UPatrol extends StatelessWidget {
  const UPatrol({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'UPatrol',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const CreateReport(),
    );
  }
}

class CreateReport extends StatefulWidget {
  const CreateReport({super.key});

  @override
  State<CreateReport> createState() => _CreateReportState();
}

class _CreateReportState extends State<CreateReport> {
  
  Uint8List? _file;
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  String? _ratingControllerValue;

  _imageSelect(BuildContext context) async {
    return showDialog(
      context: context, 
      builder: (context) {
        return SimpleDialog(
          title: Text('Select Image'),
          children: [
            SimpleDialogOption(
              padding: EdgeInsets.all(20),
              child: Text('Take a Photo'),
              onPressed: () async {
                Navigator.of(context).pop();
                Uint8List file = await pickImage(
                  ImageSource.camera,
                );
                setState(() {
                  _file = file;
                });
              },
            ),
            SimpleDialogOption(
              padding: EdgeInsets.all(20),
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ]
        );
      });
  }
  @override
  Widget build(BuildContext context) {
    return Template(
      child: StatefulBuilder(builder:
        (BuildContext context,
          StateSetter setState) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      height: 200,
                      child: Column(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _subjectController,
                              decoration: const InputDecoration(
                                labelText: 'Subject',
                              ),
                              maxLines: 3,
                              maxLength: 30,
                            ),
                          ),
                          Expanded(
                            child: TextFormField(
                              controller: _descriptionController,
                              decoration: const InputDecoration(
                                labelText: 'Short Description',
                              ),
                              maxLines: 5,
                              maxLength: 500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: DropdownButtonFormField<String>(
                        value: _ratingControllerValue,
                        decoration: const InputDecoration(
                          labelText: 'Report Category',
                        ),
                        items: [
                          'Wet',
                          'Obstruction',
                          'Electrical',
                          'Fire',
                          'Structural',
                          'Visibility',
                          'Sanitation',
                          'Chemical',
                          'Vandalism',
                          'Misc'
                        ].map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (value) {
                            setState(() { _ratingControllerValue = value;});
                          },
                        isExpanded: true,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextFormField(                 //location fetching not yet automatic, just text field for now
                          controller: _locationController,
                        decoration: const InputDecoration(
                          labelText: 'Location',
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const SizedBox(height: 20),
                      _file == null ? 
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Text(
                          'Placeholder for Uploaded Photo',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                    )
                    :
                    SizedBox(
                        height: 300,
                        width: 300,
                        child: Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: MemoryImage(_file!),
                              fit: BoxFit.fill,
                              alignment: FractionalOffset.topCenter,
                            ),
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () => _imageSelect(context),
                        child: Text('Take Photo'),
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text('Submit'),
                    ),
                  ],
                ),
              ),
            );
          }
      )
    );
  }
}
