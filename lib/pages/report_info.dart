import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
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
      appBar: AppBar(
        // automaticallyImplyLeading: true,
        title: Text(widget.report.title ?? 'Untitled'),
        actions: [
          Transform.translate(
            offset: Offset(-20, 10),
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
          const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
      child: Column(
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            SizedBox(
                height: size.shortestSide * 0.8,
                width: size.shortestSide * 0.6,
                child: report.image ?? Image.asset('assets/Hey.png')),
          ]),
          TextField(
            //Title
            readOnly: true,
            controller: TextEditingController(
              text: report.title ?? 'Untitled',
            ),
            decoration: const InputDecoration(
                border: UnderlineInputBorder(),
                labelText: 'Title',
                icon: Icon(Icons.note)),
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
                icon: Icon(Icons.list)),
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
                icon: Icon(Icons.map)),
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
                icon: Icon(Icons.person)),
          ),
          (currentUser?.getRole() == 'Moderator')
              ? ModControl(report: report)
              : const SizedBox(
                  height: 0,
                ),
          if (role == "Moderator")
            ModControl(report: report)
          else if (role == "Responder")
            ResponderControl(report: report)
          else if (role == "User" &&
              currentUser?.uid == reporter?.uid)
            ReporterControl(report: report)
        ],
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
      children: [
        TextButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) =>
                      EditReportInfo(report: widget.report)));
            },
            child: const Text('Edit')),
        TextButton(
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Delete Report'),
                      content: const Text(
                          'Are you sure about deleting this report?'),
                      actions: [
                        TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('No')),
                        TextButton(
                            onPressed: () {
                              reportsCollection
                                  .doc(widget.report.id)
                                  .delete();
                              Navigator.of(context)
                                  .popUntil((route) => route.isFirst);
                            },
                            child: const Text('Yes'))
                      ],
                    );
                  });
            },
            child: const Text('Delete Report')),
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          TextButton(
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
              },
              child: Text(widget.report.isVerified ?? false
                  ? 'Revoke'
                  : 'Verify')),
          TextButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Delete Report'),
                        content: const Text(
                            'Are you sure about deleting this report?'),
                        actions: [
                          TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text('No')),
                          TextButton(
                              onPressed: () {
                                reportsCollection
                                    .doc(widget.report.id)
                                    .delete();
                                Navigator.of(context).popUntil(
                                    (route) => route.isFirst);
                              },
                              child: const Text('Yes'))
                        ],
                      );
                    });
              },
              child: const Text('Reject')),
        ],
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
              child: Text(report.isPending ?? false
                  ? 'Cancel Resolving'
                  : 'Start Resolving')),
          Visibility(
            visible: report.isPending ?? false,
            child: TextButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Resolve Report'),
                          content: const Text(
                              'Are you sure that the issue has been resolved?'),
                          actions: [
                            TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text('No')),
                            TextButton(
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
                                child: const Text('Yes'))
                          ],
                        );
                      });
                },
                child: const Text('Mark Resolved')),
          ),
        ],
      ),
    );
  }
}
