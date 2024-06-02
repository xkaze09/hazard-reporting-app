import 'dart:math';

import "package:flutter/material.dart";

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hazard_reporting_app/backend/firebase_auth.dart';
import 'package:hazard_reporting_app/components/post_container.dart';
import 'package:hazard_reporting_app/data_types/globals.dart';
import 'package:hazard_reporting_app/data_types/reports.dart';
import 'package:hazard_reporting_app/data_types/utils.dart';
import 'package:hazard_reporting_app/pages/report_info.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home>
    with AutomaticKeepAliveClientMixin {
  List<ReportsRecord?> reportsList = [];

  @override
  void initState() {
    super.initState();
    reportStream = getActiveReports();
  }

  @override
  void dispose() {
    filterListener.dispose();
    reportStream.drain();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        heroTag: "Filter",
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) {
                return const FilterDialog();
              });
        },
        backgroundColor: const Color(0xFF29AB84),
        child: const Icon(Icons.filter_list, color: Colors.white),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: reportStream,
        builder: (BuildContext context,
            AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            debugPrint(snapshot.error.toString());
            return Text(snapshot.error.toString());
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return ValueListenableBuilder(
              valueListenable: filterListener,
              builder: (context, value, widget) {
                return ActiveFeed(
                  snapshot: snapshot,
                );
              });
        },
      ),
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
  void initState() {
    super.initState();
    if (currentUser?.getRole() == 'Moderator') {
      hideUnverifiedReports = false;
      hideVerifiedReports = false;
      hidePendingReports = false;
      hideResolvedReports = false;
    } else {
      hideUnverifiedReports = true;
      hideVerifiedReports = false;
      hidePendingReports = false;
      hideResolvedReports = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.snapshot.data?.size,
      itemBuilder: (context, index) {
        Map<String, dynamic>? data = widget.snapshot.data!.docs[index]
            .data() as Map<String, dynamic>;
        ReportsRecord report = ReportsRecord.fromMap(data);
        if (report.isVerified != null &&
            report.isPending != null &&
            report.isResolved != null) {
          if ((report.isVerified == true && hideVerifiedReports) ||
              (report.isResolved == true && hideResolvedReports) ||
              (report.isVerified == false && hideUnverifiedReports) ||
              (report.isPending == true && hidePendingReports) ||
              categoryFilters.contains(report.category?.name)) {
            return Container(height: 0);
          }
        }
        return GestureDetector(
          key: Key("${Random().nextDouble()}"),
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => ReportInfo(report: report)));
          },
          child: FutureBuilder(
              future: ReporterRecord.fromReference(report.reporter),
              builder: (context, snapshot) {
                // if (snapshot.data?.uid == currentUser?.uid) {
                //   Container(height: 0);
                // }
                return PostContainer(
                    report: report, reporter: snapshot.data);
              }),
        );
      },
    );
  }
}

class FilterDialog extends StatefulWidget {
  const FilterDialog({super.key});

  @override
  State<FilterDialog> createState() => _FilterDialogState();
}

class _FilterDialogState extends State<FilterDialog> {
  List<bool> filter = List.generate(categoryList.length, (index) {
    return !categoryFilters.contains(categoryList[index].name);
  });

  void refreshFilter() {
    for (int index = 0; index < filter.length; index++) {
      if (categoryFilters.contains(categoryList[index].name)) {
        filter[index] = false;
      }
    }
  }

  @override
  void initState() {
    super.initState();
    refreshFilter();
  }

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(builder: (context, setState) {
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
                activeColor: const Color(0xFF29AB84),
                title: Text(cat.category.name));
          }).toList(),
        ),
        actions: [
          TextButton(
            onPressed: () {
              categoryFilters = ['test'];
              setState(() {
                refreshFilter();
              });
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
              for (int i = 0; i < filter.length; i++) {
                if (!filter[i] &&
                    !categoryFilters.contains(categoryList[i].name)) {
                  categoryFilters.add(categoryList[i].name);
                } else if (filter[i] &&
                    categoryFilters.contains(categoryList[i].name)) {
                  categoryFilters.remove(categoryList[i].name);
                }
              }
              filterListener.value = !filterListener.value;
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF29AB84),
            ),
            child: const Text(
              'Apply Filter',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      );
    });
  }
}
