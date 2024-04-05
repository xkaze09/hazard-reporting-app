import "package:flutter/material.dart";

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:stream_transform/stream_transform.dart';

import 'map.dart';
import 'backend/firestore.dart';
import 'data_types/users.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({
    super.key,
  });

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  late int _selectedPageIndex;
  late List<Widget> _pages;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();

    _selectedPageIndex = 0;
    _pages = [const Home(), const Maps()];

    _pageController = PageController(initialPage: _selectedPageIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: PageView(
          controller: _pageController,
          physics: const NeverScrollableScrollPhysics(),
          children: _pages,
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.map),
              label: 'Maps',
            ),
          ],
          currentIndex: _selectedPageIndex,
          onTap: (selectedPageIndex) {
            setState(() {
              _selectedPageIndex = selectedPageIndex;
              _pageController.jumpToPage(selectedPageIndex);
            });
          },
        ));
  }
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home>
    with AutomaticKeepAliveClientMixin {
  final Stream<QuerySnapshot> _reportStream = usersCollection
      .where('isResolved', isEqualTo: false)
      .snapshots();
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
        body: StreamBuilder(
      stream: _reportStream,
      builder: (context, snapshot) {
        if (snapshot.hasError) return const Text('Error');
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading");
        }
        var docs = snapshot.data!.docs;

        return ListView(children: [
          ExpansionPanelList.radio(
              children: docs
                  .map((document) {
                    ReportsRecord report =
                        ReportsRecord.fromFirestore(
                            document as DocumentSnapshot<
                                Map<String, dynamic>>,
                            SnapshotOptions());
                    debugPrint(document.toString());
                    return ExpansionPanelRadio(
                        value: report.id ?? 0,
                        headerBuilder: ((context, isExpanded) {
                          return ListTile(
                            leading: report.category?.icon,
                            title: Text(report.title ?? 'Untitled'),
                          );
                        }),
                        body: Column(
                          children: [
                            Text(report.description ?? ''),
                            SizedBox(
                                height: 500,
                                width: 500,
                                child: report.image ??
                                    Image.asset(
                                        'images/UPatrol-logo.png')),
                          ],
                        ));
                  })
                  .toList()
                  .cast())
        ]);
      },
    ));
  }

  @override
  bool get wantKeepAlive => true;
}
