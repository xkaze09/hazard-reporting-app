import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hazard_reporting_app/backend/firebase_auth.dart';
import 'package:hazard_reporting_app/components/template.dart';
import 'package:hazard_reporting_app/pages/dashboard.dart';
import 'package:hazard_reporting_app/pages/map.dart';

import 'dart:typed_data';

import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import '../data_types/utils.dart';
import '../backend/firestore.dart';

Future<bool> askCameraPermission() async {
  PermissionStatus status = await Permission.camera.request();
  if (status.isDenied == true) {
    return askCameraPermission();
  } else {
    return true;
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

  late bool _isLoading = false;
  void postReport() async {
    if (_createReportFormKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      try {
        String res = await ImageStoreMethods().uploadPost(
            _subjectController.text,
            _descriptionController.text,
            _categoryControllerValue ?? '',
            _locationController.text,
            _file ?? Uint8List(0));
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
  void initState() {
    super.initState();
    getPosition().then((position) {
      reverseGeocode(position).then(
        (value) {
          setState(() {
            debugPrint(value);
            _locationController.text = value;
          });
        },
      );
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      try {
        askCameraPermission();
        askMapPermission();
      } catch (e) {
        debugPrint(e.toString());
      }
    });
  }

  @override
  void dispose() {
    // _subjectController.dispose();
    // _descriptionController.dispose();
    // _locationController.dispose();
    // _createReportFormKey.currentState?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _createReportFormKey,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Visibility(
                      visible:
                          authInstance.currentUser?.isAnonymous ??
                              false,
                      child: const Center(
                        child: Text(
                          'Create Report',
                          style: TextStyle(
                            fontSize: 24,
                            color: Color(0xFF146136),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 100,
                            child: Stack(
                              children: [
                                Positioned.fill(
                                  bottom: -1,
                                  child: Align(
                                    alignment: Alignment.bottomCenter,
                                    child: Container(
                                      height: 1,
                                      color: const Color(0xFF146136),
                                    ),
                                  ),
                                ),
                                TextFormField(
                                  style: const TextStyle(
                                      color: Color(0xFF146136)),
                                  decoration: const InputDecoration(
                                    labelText: 'Subject',
                                    labelStyle: TextStyle(
                                        fontSize: 18,
                                        color: Color(0xFF146136)),
                                    filled: true,
                                    fillColor: Colors.transparent,
                                    border: InputBorder.none,
                                    enabledBorder:
                                        UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Color(
                                                    0xFF146136))),
                                  ),
                                  maxLines: 3,
                                  maxLength: 30,
                                  controller: _subjectController,
                                  validator: (value) {
                                    if (value == null ||
                                        value.isEmpty) {
                                      return 'Please enter a subject';
                                    }
                                    return null;
                                  },
                                ),
                              ],
                            ),
                          ),
                          TextFormField(
                            style: const TextStyle(
                                color: Color(0xFF146136)),
                            decoration: const InputDecoration(
                              labelText: 'Short Description',
                              labelStyle: TextStyle(
                                  fontSize: 18,
                                  color: Color(0xFF146136)),
                              filled: true,
                              fillColor: Colors.transparent,
                              border: InputBorder.none,
                              enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Color(0xFF146136))),
                              contentPadding: EdgeInsets.only(
                                  left: 10,
                                  right: 10,
                                  top: 5,
                                  bottom: 5),
                            ),
                            maxLines: null,
                            maxLength: 500,
                            controller: _descriptionController,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: DropdownButtonFormField<String>(
                        decoration: const InputDecoration(
                          labelText: 'Report Category',
                          labelStyle: TextStyle(
                              fontSize: 18, color: Color(0xFF146136)),
                          filled: true,
                          fillColor: Colors.transparent,
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide.none,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide.none,
                          ),
                        ),
                        items: categoryList.map((category) {
                          return DropdownMenuItem<String>(
                            value: category.name,
                            child: Text(category.name),
                          );
                        }).toList(),
                        onChanged: (value) {
                          _categoryControllerValue = value!;
                        },
                        isExpanded: true,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: TextFormField(
                        style:
                            const TextStyle(color: Color(0xFF146136)),
                        decoration: const InputDecoration(
                          labelText: 'Location',
                          labelStyle: TextStyle(
                              fontSize: 18, color: Color(0xFF146136)),
                          filled: true,
                          fillColor: Colors.transparent,
                          border: InputBorder.none,
                          counterStyle:
                              TextStyle(color: Color(0xFF146136)),
                        ),
                        controller: _locationController,
                        readOnly: true,
                      ),
                    ),
                    const SizedBox(height: 20),
                    ReportImageContainer(file: _file),
                    const SizedBox(height: 30),
                    Center(
                      child: ElevatedButton(
                        onPressed: () => _imageSelect(context),
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all<Color>(
                                  const Color(0xFF146136)),
                          foregroundColor:
                              MaterialStateProperty.all<Color>(
                                  Colors.white),
                          shape: MaterialStateProperty.all<
                              RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                        child: const Text('Take Photo'),
                      ),
                    ),
                    const SizedBox(height: 30),
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              authInstance.currentUser!.isAnonymous
                                  ? logOut().then((value) =>
                                      Navigator.of(context).pop())
                                  : Navigator.of(context).push(
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              TemplateBody(
                                                title: 'Dashboard',
                                                child: Dashboard(),
                                              )));
                            },
                            child: const Text('Cancel'),
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all<Color>(
                                      Colors.grey),
                              foregroundColor:
                                  MaterialStateProperty.all<Color>(
                                      Colors.white),
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(20),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 20),
                          ElevatedButton(
                            onPressed: postReport,
                            child: const Text('Submit'),
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all<Color>(
                                      const Color(0xFF146136)),
                              foregroundColor:
                                  MaterialStateProperty.all<Color>(
                                      Colors.white),
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(20),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
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
        ? Center(
            child: Container(
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
          ))
        : Center(
            child: SizedBox(
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
          ));
  }
}
