import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../components/template.dart';
import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:image_picker/image_picker.dart';
import '../data_types/utils.dart';
import '../backend/firestore.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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
  final _createReportFormKey = GlobalKey<FormState>();
  
  Uint8List? _file;
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  String? _categoryControllerValue;

  bool _isLoading = false;
  void postReport() async {
    setState(() {
      _isLoading = true;
    });
    try {
      String res = await ImageStoreMethods().uploadPost(
        _subjectController.text,
        _descriptionController.text,
        _categoryControllerValue??'', 
        _locationController.text,  
        _file!
      );
      if (res == 'success') {
        setState(() {
          _isLoading = false;
        });
        showSnackBar('Posted');
        clearImage();
      } else {
        setState(() {
          _isLoading = false;
        });
        showSnackBar(res);
      }
    } catch (err) {
      showSnackBar(err.toString());
    }
  }

  void clearImage(){
    setState(() {
      _file = null;
    });
  }


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
                child: Form(
                  key: _createReportFormKey,
                  child: ListView(
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
                        value: _categoryControllerValue,
                        decoration: const InputDecoration(
                          labelText: 'Report Category',
                        ),
                        items: categoryList.map((category) {
                          return DropdownMenuItem<String>(
                            value: category.name,
                            child: Text(category.name),
                          );
                        }).toList(),
                        onChanged: (value) {
                            setState(() { 
                              _categoryControllerValue = value!;
                              });
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
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text('Take Photo'),
                      ),
                    ElevatedButton(
                      onPressed: postReport,
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text('Submit'),
                    ),
                  ],
                ),)
              ),
            );
          }
      )
    );
  }
}
