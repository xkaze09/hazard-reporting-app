import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../components/template.dart';
import 'dart:typed_data';

import 'package:image_picker/image_picker.dart';
import '../data_types/utils.dart';
import '../backend/firestore.dart';

void main() async {
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
  final TextEditingController _subjectController =
      TextEditingController();
  final TextEditingController _descriptionController =
      TextEditingController();
  final TextEditingController _locationController =
      TextEditingController();
  String? _categoryControllerValue;

  // ignore: unused_field
  bool _isLoading = false;
  void postReport() async {
    setState(() {
      _isLoading = true;
    });
    try {
      String res = await ImageStoreMethods().uploadPost(
          _subjectController.text,
          _descriptionController.text,
          _categoryControllerValue ?? '',
          _locationController.text,
          _file!);
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

  void clearImage() {
    setState(() {
      _file = null;
    });
  }

  _imageSelect(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
              title: const Text('Select Image'),
              children: [
                SimpleDialogOption(
                  padding: const EdgeInsets.all(20),
                  child: const Text('Take a Photo'),
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
                  padding: const EdgeInsets.all(20),
                  child: const Text('Cancel'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ]);
        });
  }

  @override
  Widget build(BuildContext context) {
    return Template(child: StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
      return Center(
        child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _createReportFormKey,
              child: ListView(
                children: [
                  ReportFormField(
                      controller: _subjectController,
                      label: 'Subject'),
                  ReportFormField(
                      controller: _descriptionController,
                      label: 'Short Description'),
                  ReportDropdownField(
                      controllerValue: _categoryControllerValue,
                      label: 'Report Category'),
                  ReportFormField(
                      controller: _locationController,
                      label: 'Location'),
                  const SizedBox(height: 40),
                  ReportImageContainer(file: _file),
                  const SizedBox(height: 40),
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
              ),
            )),
      );
    }));
  }
}

class ReportFormField extends StatelessWidget {
  const ReportFormField(
      {super.key, required this.controller, required this.label});

  final TextEditingController controller;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(10),
          ),
          child: TextFormField(
            controller: controller,
            decoration: InputDecoration(
              labelText: label,
            ),
          ),
        )
      ],
    );
  }
}

class ReportDropdownField extends StatefulWidget {
  ReportDropdownField(
      {super.key, this.controllerValue, required this.label});

  String? controllerValue;
  final String label;

  @override
  State<ReportDropdownField> createState() =>
      _ReportDropdownFieldState();
}

class _ReportDropdownFieldState extends State<ReportDropdownField> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(10),
          ),
          child: DropdownButtonFormField<String>(
            value: widget.controllerValue,
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
                widget.controllerValue = value!;
              });
            },
            isExpanded: true,
          ),
        ),
      ],
    );
  }
}

class ReportImageContainer extends StatefulWidget {
  const ReportImageContainer({super.key, this.file});

  final Uint8List? file;

  @override
  State<ReportImageContainer> createState() =>
      _ReportImageContainerState();
}

class _ReportImageContainerState extends State<ReportImageContainer> {
  @override
  Widget build(BuildContext context) {
    return widget.file == null
        ? Container(
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
        : SizedBox(
            height: 400,
            width: 300,
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: MemoryImage(widget.file!),
                  fit: BoxFit.fill,
                  alignment: FractionalOffset.topCenter,
                ),
              ),
            ),
          );
  }
}
