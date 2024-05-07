import 'package:flutter/material.dart';
import 'package:hazard_reporting_app/data_types/globals.dart';
import 'package:hazard_reporting_app/pages/create_report.dart';
import '../pages/home.dart';
import '../pages/map.dart';

class Dashboard extends StatefulWidget {
  final int? initialKey;

  const Dashboard({
    super.key,
    this.initialKey,
  });

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  late int _selectedPageIndex;
  late List<Widget> _pages;
  late PageController _pageController;
  late Size size = MediaQuery.of(context).size;

  @override
  void initState() {
    super.initState();

    _selectedPageIndex = widget.initialKey ?? 0;
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
        floatingActionButtonLocation:
            FloatingActionButtonLocation.centerDocked,
        floatingActionButton: SizedBox(
          width: size.width * 0.2,
          height: size.width * 0.2,
          child: FloatingActionButton(
            backgroundColor: Colors.white,
            shape: const CircleBorder(),
            // elevation: 0,
            child: Image.asset(
              "images/logo-notext.png",
            ),
            onPressed: () {
              navigatorKey.currentState?.push(MaterialPageRoute(
                  builder: (context) => const CreateReport()));
            },
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          shape: CircularNotchedRectangle(),
          padding: EdgeInsets.zero,
          child: BottomNavigationBar(
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
          ),
        ));
  }
}
