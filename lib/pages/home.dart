import "package:flutter/material.dart";

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hazard_reporting_app/backend/firebase_auth.dart';
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
          return const Text('Error');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading");
        }

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
    return SingleChildScrollView(
        child: Container(
      child: _renderTile(widget.snapshot),
    ));
  }

  Widget _renderTile(AsyncSnapshot<QuerySnapshot> snapshot) {
    return ExpansionPanelList.radio(
        children: snapshot.data!.docs
            .map((DocumentSnapshot document) {
              ReportsRecord report = ReportsRecord.fromFirestore(
                  document as DocumentSnapshot<Map<String, dynamic>>,
                  SnapshotOptions());
              return _reportTile(report);
            })
            .toList()
            .cast());
  }

  ExpansionPanelRadio _reportTile(ReportsRecord report) {
    return ExpansionPanelRadio(
        headerBuilder: (context, isExpanded) {
          return ListTile(
            leading: Column(
              children: [
                report.category?.icon as Icon,
                Text(report.category?.name ?? '')
              ],
            ),
            title: Text(report.title ?? ''),
            trailing: const SizedBox(),
          );
        },
        body: ListTile(
          title: _expansion(report),
          trailing: const SizedBox(),
        ),
        value: report.id ?? 0);
  }

  Widget _expansion(ReportsRecord report) {
    if (report.landscape ?? false) {
      return Column(
        children: [
          Text(report.description ?? 'No Description'),
          Image(
            image: NetworkImage(report.imageURL ?? ''),
            height: 360,
            width: 640,
            fit: BoxFit.contain,
          )
        ],
      );
    } else {
      return Row(
        children: [
          Text(report.description ?? 'No Description'),
          Image(
            image: NetworkImage(report.imageURL ?? ''),
            height: 360,
            width: 640,
            fit: BoxFit.contain,
          )
        ],
      );
    }
  }
}
