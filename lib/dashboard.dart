import "package:flutter/material.dart";

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:u_patrol/data_types/reporter.dart';
import 'package:u_patrol/data_types/utils.dart';

import 'components/template.dart';
import 'main.dart';

class Test extends StatelessWidget {
  const Test({super.key});

  @override
  Widget build(BuildContext context) {
    return Template(
      child: Container(),
    );
  }
}

class Dashboard extends StatelessWidget {
  const Dashboard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Template(
      child: ListView(
        children: [
          Row(
            children: [
              Container(),
            ],
          ),
          SizedBox(
              height: 800,
              width: 720,
              child: StreamBuilder<QuerySnapshot>(
                stream: reportsCollection
                    .orderBy('timestamp')
                    .limit(20)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (!snapshot.hasData) {
                    return const Center(
                      child: SizedBox(
                        width: 50,
                        height: 50,
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }
                  var docs = snapshot.data!.docs;

                  return ListView.builder(
                    itemCount: docs.length,
                    itemBuilder: (context, i) {
                      List<String> repref = '${docs[i]['reporter']}'.split('/');
                      final reporterref =
                          db.collection(repref[0]).doc(repref[1]);

                      return FutureBuilder(
                        future: reporterref.get().then((DocumentSnapshot doc) {
                          final data = doc.data() as Map<String, dynamic>;
                          return data;
                        }),
                        builder: (BuildContext context,
                            AsyncSnapshot<Map<String, dynamic>> snapshot) {
                          ReporterRecord test = ReporterRecord.fromFirestore(
                              snapshot
                                  as DocumentSnapshot<Map<String, dynamic>>,
                              null);
                          return Row(
                            children: [
                              Text(test.displayName ?? ''),
                              Text(test.email?.toString() ??
                                  const Email(name: 'temp', provider: 'temp')
                                      .toString()),
                              test.photo ??
                                  Image.asset('images/UPatrol-logo.png'),
                            ],
                          );
                        },
                      );
                    },
                  );
                },
              )),
        ],
      ),
    );
  }
}
