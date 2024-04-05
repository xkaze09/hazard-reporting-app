import 'package:flutter/material.dart';
import 'package:u_patrol/map.dart';
import 'package:u_patrol/home.dart';

//insert query here
var reportsList = List<bool>;

class Template extends StatefulWidget {
  final Widget child;

  const Template({
    super.key,
    required this.child,
  });

  @override
  State<Template> createState() => _TemplateState();
}

class _TemplateState extends State<Template> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/home': (context) => const Template(child: Home()),
        '/map': (context) => const Template(child: Maps())
      },
      home: TemplateBody(
        title: 'Dashboard',
        child: widget.child,
      ),
    );
  }
}

class TemplateBody extends StatefulWidget {
  final Widget child;
  final String title;

  const TemplateBody({
    super.key,
    required this.title,
    required this.child,
  });

  @override
  State<TemplateBody> createState() => _TemplateBodyState();
}

class _TemplateBodyState extends State<TemplateBody> {
  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey =
        GlobalKey<ScaffoldState>();

    return MaterialApp(
        home: Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        leading: SizedBox(
          width: 40,
          height: 40,
          child: IconButton(
              onPressed: () => scaffoldKey.currentState?.openDrawer(),
              icon: const ImageIcon(
                AssetImage('images/UPatrol-logo.png'),
                size: 40,
              )),
        ),
        title: Text(widget.title),
      ),
      drawer: const Drawer(
        child: PublicDrawer(),
      ),
      body: widget.child,
    ));
  }
}

class PublicDrawer extends StatefulWidget {
  const PublicDrawer({super.key});

  @override
  State<PublicDrawer> createState() => _PublicDrawerState();
}

class _PublicDrawerState extends State<PublicDrawer> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Row(
          children: [
            Column(
              children: [
                SizedBox(
                  width: 75,
                  height: 75,
                  child: Image.asset("images/UPatrol-logo.png"),
                ),
              ],
            ),
            const Column(
              children: [
                Row(
                  children: [Text("UserName")],
                ),
                Row(
                  children: [Text("User")],
                )
              ],
            )
          ],
        ),
        const Row(
          children: [
            Icon(Icons.home_outlined, size: 48),
            Text(
              "Dashboard",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
                fontFamily: "Roboto",
              ),
            )
          ],
        ),
        const Row(
          children: [
            Icon(Icons.history, size: 48),
            Text(
              "History",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
                fontFamily: "Roboto",
              ),
            )
          ],
        ),
        const Row(
          children: [
            Icon(Icons.settings_outlined, size: 48),
            Text(
              "Settings",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
                fontFamily: "Roboto",
              ),
            )
          ],
        ),
      ],
    );
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
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
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: true,
              title: const Text("Dashboard"),
            ),
            drawer: const Drawer(child: PublicDrawer()),
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
            )));
  }
}
