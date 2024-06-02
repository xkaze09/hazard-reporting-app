import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hazard_reporting_app/backend/firebase_auth.dart';
import 'package:hazard_reporting_app/data_types/globals.dart';
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

class CreateReportOld extends StatefulWidget {
  const CreateReportOld({super.key});

  @override
  State<CreateReportOld> createState() => _CreateReportOldState();
}

class _CreateReportOldState extends State<CreateReportOld> {
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
      body: StatefulBuilder(
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
                      label: 'Subject',
                      isRequired: true,
                    ),
                    ReportFormField(
                      controller: _descriptionController,
                      label: 'Short Description',
                      isRequired: false,
                    ),
                    const SizedBox(height: 10),
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
                          _categoryControllerValue = value!;
                        },
                        isExpanded: true,
                      ),
                    ),
                    ReportFormField(
                      controller: _locationController,
                      label: 'Location',
                      isRequired: false,
                      readOnly: true,
                    ),
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
                    Visibility(
                      visible:
                          authInstance.currentUser?.isAnonymous ??
                              false,
                      child: ElevatedButton(
                        onPressed: () {
                          logOut().then(
                              (value) => Navigator.of(context).pop());
                        },
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text('Cancel'),
                      ),
                    )
                  ],
                ),
              )),
        );
      }),
    );
  }
}

class ReportFormField extends StatelessWidget {
  const ReportFormField(
      {super.key,
      required this.controller,
      required this.label,
      required this.isRequired,
      this.readOnly});

  final TextEditingController controller;
  final bool isRequired;
  final String label;
  final bool? readOnly;

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
            readOnly: readOnly ?? false,
            controller: controller,
            validator: (value) {
              if (isRequired == true &&
                  (value == null || value.isEmpty)) {
                return 'Please enter a subject';
              }
              return null;
            },
            decoration: InputDecoration(
              labelText: label,
            ),
          ),
        )
      ],
    );
  }
}

// class ReportDropdownField extends StatelessWidget {
//   const ReportDropdownField(
//       {super.key, required this.onPressed, required this.label});

//   final ValueChanged<String> onPressed;
//   final String label;

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         const SizedBox(height: 10),
//         Container(
//           decoration: BoxDecoration(
//             color: Colors.grey[200],
//             borderRadius: BorderRadius.circular(10),
//           ),
//           child: DropdownButtonFormField<String>(
//             value: onPressed,
//             decoration: const InputDecoration(
//               labelText: 'Report Category',
//             ),
//             items: categoryList.map((category) {
//               return DropdownMenuItem<String>(
//                 value: category.name,
//                 child: Text(category.name),
//               );
//             }).toList(),
//             onChanged: (value) {
//                 onPressed(value!);
//             },
//             isExpanded: true,
//           ),
//         ),
//       ],
//     );
//   }
// }

// class ReportDropdownField extends StatefulWidget {
//   const ReportDropdownField(
//       {super.key, required this.controllerValue, required this.onChanged, required this.label});

//   final String controllerValue;
//   final ValueChanged<String> onChanged;
//   final String label;

//   @override
//   State<ReportDropdownField> createState() =>
//       _ReportDropdownFieldState();
// }

// class _ReportDropdownFieldState extends State<ReportDropdownField> {
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         const SizedBox(height: 10),
//         Container(
//           decoration: BoxDecoration(
//             color: Colors.grey[200],
//             borderRadius: BorderRadius.circular(10),
//           ),
//           child: DropdownButtonFormField<String>(
//             value: widget.controllerValue,
//             decoration: const InputDecoration(
//               labelText: 'Report Category',
//             ),
//             items: categoryList.map((category) {
//               return DropdownMenuItem<String>(
//                 value: category.name,
//                 child: Text(category.name),
//               );
//             }).toList(),
//             onChanged: (value) {
//               setState(() {
//                 widget.onChanged(value!);
//               });
//             },
//             isExpanded: true,
//           ),
//         ),
//       ],
//     );
//   }
// }

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
