import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hazard_reporting_app/backend/firebase_auth.dart';
import 'package:hazard_reporting_app/backend/firestore.dart';
import 'package:hazard_reporting_app/data_types/globals.dart';
import 'package:hazard_reporting_app/data_types/reports.dart';
import 'package:hazard_reporting_app/pages/edit_report.dart';

class ReportInfo extends StatefulWidget {
  final ReportsRecord report;

  const ReportInfo({super.key, required this.report});

  @override
  State<ReportInfo> createState() => _ReportInfoState();
}

class _ReportInfoState extends State<ReportInfo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        // automaticallyImplyLeading: true,
        title: Text(widget.report.title ?? 'Untitled'),
        actions: [
          Transform.translate(
            offset: const Offset(-20, 10),
            child: Column(
              children: [
                Icon(
                  widget.report.category?.icon.icon,
                  size: 30,
                  color: widget.report.category?.color,
                ),
                Center(
                  child:
                      Text(widget.report.category?.name ?? 'Unknown',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 14,
                          )),
                )
              ],
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: ReportTile(
          report: widget.report,
        ),
      ),
    );
  }
}

class ReportTile extends StatelessWidget {
  final ReportsRecord report;

  const ReportTile({super.key, required this.report});

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
    late Size size = MediaQuery.sizeOf(context);
    String role = currentUser?.getRole() ?? "User";
    ReporterRecord? reporter = getReporter(report.reporter);
    return Padding(
      padding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Container(
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
        child: Column(
          children: [
            Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                      height: size.shortestSide * 0.8,
                      width: size.shortestSide * 0.6,
                      child: report.image ??
                          Image.asset('assets/Hey.png')),
                ]),
            const SizedBox(height: 8),
            TextField(
              //Title
              readOnly: true,
              controller: TextEditingController(
                text: report.title ?? 'Untitled',
              ),
              decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Title',
                  labelStyle:
                      TextStyle(fontSize: 14, color: Colors.grey),
                  icon: Icon(
                    Icons.note,
                    color: Color(0xFF146136),
                  )),
            ),
            TextField(
              //Description
              readOnly: true,
              controller: TextEditingController(
                text: report.description ?? 'No Description',
              ),
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
            TextField(
              //Location
              readOnly: true,
              controller: TextEditingController(
                text: report.address ?? 'Untitled',
              ),
              decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: '',
                  labelStyle:
                      TextStyle(fontSize: 14, color: Colors.grey),
                  icon: Icon(
                    Icons.map,
                    color: Color(0xFF146136),
                  )),
            ),
            TextField(
              //Reporter
              readOnly: true,
              controller: TextEditingController(
                text: reporter?.displayName ?? 'Anonymous',
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
            if (role == "Moderator")
              ModControl(report: report)
            else if (role == "Responder")
              ResponderControl(report: report)
            else if (role == "User" &&
                authInstance.currentUser?.uid == reporter?.uid)
              ReporterControl(report: report)
          ],
        ),
      ),
    );
  }
}

class ReporterControl extends StatefulWidget {
  final ReportsRecord report;
  const ReporterControl({super.key, required this.report});

  @override
  State<StatefulWidget> createState() => _ReporterControlState();
}

class _ReporterControlState extends State<ReporterControl> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(width: 16),
        Padding(
          padding: const EdgeInsets.only(top: 16),
          child: ElevatedButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) =>
                      EditReportInfo(report: widget.report)));
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF29AB84),
              padding: const EdgeInsets.symmetric(horizontal: 24),
            ),
            child: const Text('Edit',
                style: TextStyle(color: Colors.white)),
          ),
        ),
        const SizedBox(width: 30),
        Padding(
          padding: const EdgeInsets.only(top: 16),
          child: ElevatedButton(
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
                                  BorderRadius.circular(4.0)),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16.0),
                        ),
                        child: const Text('No',
                            style: TextStyle(color: Colors.white)),
                      ),
                      TextButton(
                        onPressed: () {
                          reportsCollection
                              .doc(widget.report.id)
                              .delete();
                          Navigator.of(context)
                              .popUntil((route) => route.isFirst);
                        },
                        style: TextButton.styleFrom(
                          backgroundColor: const Color(0xFFD95767),
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(4.0)),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16.0),
                        ),
                        child: const Text('Yes',
                            style: TextStyle(color: Colors.white)),
                      ),
                    ],
                  );
                },
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFD95767),
              padding: const EdgeInsets.symmetric(horizontal: 24),
            ),
            child: const Text('Reject',
                style: TextStyle(color: Colors.white)),
          ),
        ),
        const SizedBox(width: 16),
      ],
    );
  }
}

class ModControl extends StatefulWidget {
  final ReportsRecord report;

  const ModControl({super.key, required this.report});

  @override
  State<ModControl> createState() => _ModControlState();
}

class _ModControlState extends State<ModControl> {
  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: currentUser?.getRole() == 'Moderator',
      child: Padding(
        padding: const EdgeInsets.only(top: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
                onPressed: () {
                  if (widget.report.isVerified ?? false) {
                    reportsCollection
                        .doc(widget.report.id)
                        .update({"isVerified": false});
                  } else {
                    reportsCollection
                        .doc(widget.report.id)
                        .update({"isVerified": true});
                  }
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF29AB84),
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                ),
                child: Text(
                    widget.report.isVerified ?? false
                        ? 'Revoke'
                        : 'Verify',
                    style: const TextStyle(color: Colors.white))),
            const SizedBox(width: 16),
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) =>
                          EditReportInfo(report: widget.report)));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                ),
                child: const Text("Edit",
                    style: TextStyle(color: Colors.white))),
            const SizedBox(width: 16),
            ElevatedButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        backgroundColor: Colors.white,
                        title: const Text('Delete Report',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            )),
                        content: const Text(
                            'Are you sure about deleting this report?',
                            style: TextStyle(color: Colors.black)),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            style: TextButton.styleFrom(
                              backgroundColor: Colors.grey,
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(4.0)),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16.0),
                            ),
                            child: const Text('No',
                                style:
                                    TextStyle(color: Colors.white)),
                          ),
                          TextButton(
                            onPressed: () {
                              reportsCollection
                                  .doc(widget.report.id)
                                  .delete();
                              Navigator.of(context)
                                  .popUntil((route) => route.isFirst);
                            },
                            style: TextButton.styleFrom(
                              backgroundColor:
                                  const Color(0xFFD95767),
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(4.0)),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16.0),
                            ),
                            child: const Text('Yes',
                                style:
                                    TextStyle(color: Colors.white)),
                          ),
                        ],
                      );
                    });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFD95767),
                padding: const EdgeInsets.symmetric(horizontal: 24),
              ),
              child: const Text('Reject',
                  style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}

class ResponderControl extends StatelessWidget {
  final ReportsRecord report;

  const ResponderControl({super.key, required this.report});

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: currentUser?.getRole() == 'Responder',
      child: Padding(
        padding: const EdgeInsets.only(top: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
                onPressed: () {
                  if (report.isPending ?? false) {
                    reportsCollection.doc(report.id).update({
                      "isPending": false,
                      "dateResolving":
                          Timestamp.fromMicrosecondsSinceEpoch(0),
                    });
                  } else {
                    reportsCollection.doc(report.id).update({
                      "isPending": true,
                      "dateResolving": Timestamp.now(),
                    });
                  }
                  //TODO implement stuff
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: report.isPending ?? false
                      ? const Color(0xFFD95767)
                      : const Color(0xFF29AB84),
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                ),
                child: Text(
                  report.isPending ?? false
                      ? 'Cancel Resolving'
                      : 'Start Resolving',
                  style: const TextStyle(color: Colors.white),
                )),
            const SizedBox(width: 16),
            Visibility(
              visible: report.isPending ?? false,
              child: ElevatedButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            backgroundColor: Colors.white,
                            title: const Text(
                              'Resolve Report',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                            content: const Text(
                              'Are you sure that the issue has been resolved?',
                              style: TextStyle(color: Colors.black),
                            ),
                            actions: [
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                style: TextButton.styleFrom(
                                  backgroundColor:
                                      const Color(0xFFD95767),
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(4.0)),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16.0),
                                ),
                                child: const Text('No',
                                    style: TextStyle(
                                        color: Colors.white)),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  reportsCollection
                                      .doc(report.id)
                                      .update({
                                    'isResolved': true,
                                    'isPending': false,
                                    'dateResolved': Timestamp.now(),
                                  });
                                  Navigator.of(context).pop();
                                },
                                style: TextButton.styleFrom(
                                  backgroundColor:
                                      const Color(0xFF29AB84),
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(4.0)),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16.0),
                                ),
                                child: const Text('Yes',
                                    style: TextStyle(
                                        color: Colors.white)),
                              ),
                            ],
                          );
                        });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF29AB84),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 24),
                  ),
                  child: const Text('Mark Resolved',
                      style: TextStyle(color: Colors.white))),
            ),
            const SizedBox(width: 16),
          ],
        ),
      ),
    );
  }
}
