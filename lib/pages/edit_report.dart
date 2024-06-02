import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hazard_reporting_app/backend/firestore.dart';
import 'package:hazard_reporting_app/data_types/globals.dart';
import 'package:hazard_reporting_app/data_types/reports.dart';
import 'package:hazard_reporting_app/data_types/utils.dart';

class EditReportInfo extends StatefulWidget {
  final ReportsRecord report;

  const EditReportInfo({super.key, required this.report});

  @override
  State<EditReportInfo> createState() => _ReportInfoState();
}

class _ReportInfoState extends State<EditReportInfo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        // automaticallyImplyLeading: true,
        title: Text(widget.report.title ?? 'Untitled'),
        actions: [
          Column(
            children: [
              widget.report.category?.icon ??
                  const Icon(Icons.question_mark, size: 20),
              Center(
                child: Text(widget.report.category?.name ?? 'Unknown',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 10,
                    )),
              )
            ],
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: ReportTile(
          report: widget.report,
        ),
      ),
    );
  }
}

class ReportTile extends StatelessWidget {
  final ReportsRecord report;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  ReportTile({super.key, required this.report});

  ReporterRecord? getReporter(DocumentReference? report) {
    ReporterRecord? reporter;
    report?.get().then((DocumentSnapshot snapshot) {
      reporter = ReporterRecord.fromFirestore(
          snapshot as DocumentSnapshot<Map<String, dynamic>>?,
          SnapshotOptions());
    });
    return reporter;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    final TextEditingController titleController =
        TextEditingController(text: report.title ?? "Untitled");
    final TextEditingController descController =
        TextEditingController(text: report.description ?? "");
    String categoryControllerValue = "";

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            Row(children: [
              SizedBox(
                  height: size.shortestSide * 0.2 * 3,
                  width: size.shortestSide * 0.2 * 4,
                  child:
                      report.image ?? Image.asset('assets/Hey.png')),
            ]),
            const SizedBox(height: 16),
            TextField(
              //Title
              controller: titleController,
              decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Title',
                  labelStyle:
                      TextStyle(fontSize: 14, color: Colors.grey),
                  icon: Icon(Icons.note, color: Color(0xFF146136))),
            ),
            const SizedBox(height: 16),
            TextField(
              //Description
              controller: descController,
              decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: '',
                  labelStyle:
                      TextStyle(fontSize: 14, color: Colors.grey),
                  icon: Icon(
                    Icons.list,
                    color: Color(0xFF146136),
                  )),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: categoryControllerValue,
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
                categoryControllerValue = value!;
              },
              isExpanded: true,
            ),
            const SizedBox(height: 16),
            TextField(
              //Reporter
              readOnly: true,
              controller: TextEditingController(
                text: getReporter(report.reporter)?.displayName ??
                    'Anonymous',
              ),
              decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: '',
                  labelStyle:
                      TextStyle(fontSize: 14, color: Colors.grey),
                  icon: Icon(
                    Icons.person,
                    color: Color(0xFF146136),
                  )),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                    onPressed: () async {
                      if (titleController.text.isEmpty) {
                        showSnackBar("Report cannot be untitled");
                      } else {
                        try {
                          await reportsCollection
                              .doc(report.id)
                              .update({
                            "title": titleController.text,
                            "description": descController.text,
                          });
                          showSnackBar("Report Success");
                        } catch (e) {
                          showSnackBar(
                              "An error has occured. Please try again.");
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF29AB84),
                      padding:
                          const EdgeInsets.symmetric(horizontal: 24),
                    ),
                    child: const Text(
                      "Confirm Changes",
                      style: TextStyle(color: Colors.white),
                    )),
                ElevatedButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            backgroundColor: Colors.white,
                            title: const Text(
                              'Delete Report',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                            content: const Text(
                              'Are you sure about deleting this report?',
                              style: TextStyle(color: Colors.black),
                            ),
                            actions: [
                              TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  style: TextButton.styleFrom(
                                    backgroundColor: Colors.grey,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(
                                                4.0)),
                                    padding:
                                        const EdgeInsets.symmetric(
                                            horizontal: 16.0),
                                  ),
                                  child: const Text('No',
                                      style: TextStyle(
                                          color: Colors.white))),
                              TextButton(
                                  onPressed: () {
                                    reportsCollection
                                        .doc(report.id)
                                        .delete();
                                    Navigator.of(context).popUntil(
                                        (route) => route.isFirst);
                                  },
                                  style: TextButton.styleFrom(
                                    backgroundColor:
                                        const Color(0xFFD95767),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(
                                                4.0)),
                                    padding:
                                        const EdgeInsets.symmetric(
                                            horizontal: 16.0),
                                  ),
                                  child: const Text('Yes',
                                      style: TextStyle(
                                          color: Colors.white)))
                            ],
                          );
                        });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFD95767),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 24),
                  ),
                  child: const Text('Reject',
                      style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
