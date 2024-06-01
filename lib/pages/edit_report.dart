import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hazard_reporting_app/backend/firestore.dart';
import 'package:hazard_reporting_app/data_types/globals.dart';
import 'package:hazard_reporting_app/data_types/reports.dart';

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
      appBar: AppBar(
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

    return Form(
      key: _formKey,
      child: Column(
        children: [
          Row(children: [
            SizedBox(
                height: size.shortestSide * 0.2 * 3,
                width: size.shortestSide * 0.2 * 4,
                child: report.image ?? Image.asset('assets/Hey.png')),
          ]),
          TextField(
            //Title
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
              text: getReporter(report.reporter)?.displayName ??
                  'Anonymous',
            ),
            decoration: const InputDecoration(
                border: UnderlineInputBorder(),
                labelText: '',
                icon: Icon(Icons.person)),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton(
                  onPressed: () {},
                  child: const Text("Confirm Changes")),
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
                                        .doc(report.id)
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
        ],
      ),
    );
  }
}
