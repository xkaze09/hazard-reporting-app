import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hazard_reporting_app/backend/firestore.dart';
import 'package:hazard_reporting_app/data_types/globals.dart';
import 'package:hazard_reporting_app/data_types/reports.dart';

class ReportInfo extends StatelessWidget {
  final ReportsRecord report;

  const ReportInfo({super.key, required this.report});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // automaticallyImplyLeading: true,
        title: Text.rich(TextSpan(children: [
          TextSpan(text: report.title ?? 'Untitled'),
          const TextSpan(text: ' Report')
        ])),
        actions: [
          Column(
            children: [
              report.category?.icon ??
                  const Icon(Icons.question_mark, size: 20),
              Center(
                child: Text(report.category?.name ?? 'Unknown',
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
        child: ReportTile(
          report: report,
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
    return Column(
      children: [
        Row(children: [
          Expanded(child: report.image ?? Image.asset('assets/Hey.png')),
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
            text: getReporter(report.reporter)?.displayName ?? 'Anonymous',
          ),
          decoration: const InputDecoration(
              border: UnderlineInputBorder(),
              labelText: '',
              icon: Icon(Icons.person)),
        ),
        ModControl(report: report),
        ResponderControl(report: report),
      ],
    );
  }
}

class ModControl extends StatelessWidget {
  final ReportsRecord report;

  const ModControl({super.key, required this.report});

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: currentUser?.getRole() == 'Moderator',
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          TextButton(
              onPressed: () {
                if (report.isVerified ?? false) {
                  reportsCollection
                      .doc(report.id)
                      .update({"isVerified": false});
                } else {
                  reportsCollection.doc(report.id).update({"isVerified": true});
                }
              },
              child: Text(report.isVerified ?? false ? 'Revoke' : 'Verify')),
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
                                reportsCollection.doc(report.id).delete();
                                Navigator.of(context)
                                    .popUntil((route) => route.isFirst);
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
                    "dateResolving": Timestamp.fromMicrosecondsSinceEpoch(0),
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
                                  reportsCollection.doc(report.id).update({
                                    'isResolved': true,
                                    'isPending': false,
                                    'dateResolved': Timestamp.now(),
                                  });
                                  Navigator.of(context)
                                      .popUntil((route) => route.isFirst);
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
