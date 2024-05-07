import "package:flutter/material.dart";

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hazard_reporting_app/backend/firebase_auth.dart';
import 'package:hazard_reporting_app/backend/firestore.dart';
import 'package:hazard_reporting_app/components/post_container.dart';
import 'package:hazard_reporting_app/data_types/utils.dart';
import '../data_types/reports.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return StreamBuilder<QuerySnapshot>(
      stream: getActiveReports(),
      builder: (BuildContext context,
          AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          debugPrint(snapshot.error.toString());
          return Text(snapshot.error.toString());
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading");
        }

        // return ListView(
        //   children: snapshot.data!.docs
        //       .map((DocumentSnapshot document) {
        //         Map<String, dynamic> data =
        //             document.data()! as Map<String, dynamic>;
        //         return ListTile(
        //           title: Text(data['title'] ?? "Untitled"),
        //           subtitle: Text(data['address'] ?? "IDK"),
        //         );
        //       })
        //       .toList()
        //       .cast(),
        // );

        return ActiveFeed(
          snapshot: snapshot,
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class ActiveFeed extends StatefulWidget {
  final AsyncSnapshot<QuerySnapshot> snapshot;
  const ActiveFeed({super.key, required this.snapshot});

  @override
  State<ActiveFeed> createState() => _ActiveFeedState();
}

class _ActiveFeedState extends State<ActiveFeed> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.snapshot.data?.size,
      itemBuilder: (context, index) {
        Map<String, dynamic> data = widget.snapshot.data!.docs[index]
            .data()! as Map<String, dynamic>;
        return PostContainer(
          displayName: "Anonymous",
          location: data['address'] ?? "Location Unknown",
          title: data['title'] ?? "Untitled Report",
          category: Category.fromString(data['category']),
        );
        // ReportsRecord report = ReportsRecord.fromFirestore(
        //     widget.snapshot.data!.docs[index]
        //         as DocumentSnapshot<Map<String, dynamic>>?,
        //     SnapshotOptions());
        // return FutureBuilder(
        //     future: report.reporter!.get(),
        //     builder: (context, snapshot) {
        //       ReporterRecord reporter = ReporterRecord.fromFirestore(
        //           snapshot as DocumentSnapshot<Map<String, dynamic>>,
        //           SnapshotOptions());
        //       debugPrint(reporter.toString());
        //       return PostContainer(
        //         displayName: reporter.displayName ?? "Anonymous",
        //         location: report.address ?? "Location Unknown",
        //         title: report.title ?? "Untitled Report",
        //         category: report.category?.name ??
        //             Categories.miscellaneous.name,
        //       );
        //     });
      },
    );
    // return _renderTile(widget.snapshot);
  }

  // Widget _renderTile(AsyncSnapshot<QuerySnapshot> snapshot) {
  //   return ListView.builder(
  //       itemCount: snapshot.data?.docs.length,
  //       itemBuilder: (context, index) {
  //         debugPrint(snapshot.data?.docs[index].toString());
  //         ReportsRecord report = ReportsRecord.fromFirestore(
  //             snapshot.data?.docs[index]
  //                 as DocumentSnapshot<Map<String, dynamic>>,
  //             SnapshotOptions());
  //         return FutureBuilder(
  //             future: report.reporter!.get(),
  //             builder: (context, snapshot) {
  //               ReporterRecord reporter =
  //                   ReporterRecord.fromFirestore(
  //                       snapshot
  //                           as DocumentSnapshot<Map<String, dynamic>>,
  //                       SnapshotOptions());
  //               debugPrint(reporter.toString());
  //               return PostContainer(
  //                 displayName: reporter.displayName ?? "Anonymous",
  //                 location: report.address ?? "Location Unknown",
  //                 title: report.title ?? "Untitled Report",
  //                 category: report.category?.name ??
  //                     Categories.miscellaneous.name,
  //               );
  //             });
  //       });
  // }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: 15,
                itemBuilder: (BuildContext context, int index) {
                  return PostContainer(
                    displayName: '[Display Name]',
                    location: '[Location]',
                    title: '[Title]',
                    category: categoryList[9],
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) {
                return const FilterDialog();
              });
        },
        backgroundColor: const Color(0xFF29AB84),
        child: const Icon(Icons.filter_list),
      ),
    );
  }
}

class FilterDialog extends StatefulWidget {
  const FilterDialog({super.key});

  @override
  State<FilterDialog> createState() => _FilterDialogState();
}

class _FilterDialogState extends State<FilterDialog> {
  List<bool> filter = List.filled(Categories.values.length, false);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text('Filter'),
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.close),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        //Magic
        children: Categories.values.map((Categories cat) {
          return CheckboxListTile(
              value: filter[cat.index],
              dense: true,
              controlAffinity: ListTileControlAffinity.leading,
              onChanged: (bool? val) {
                setState(() {
                  filter[cat.index] = val ?? false;
                });
              },
              title: Text(cat.category.name));
        }).toList(),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text(
            'Reset',
            style: TextStyle(color: Colors.black),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            // implement apply filter
            Navigator.pop(context);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF29AB84),
          ),
          child: const Text(
            'Apply Filter',
            style: TextStyle(color: Colors.black),
          ),
        ),
      ],
    );
  }
}
