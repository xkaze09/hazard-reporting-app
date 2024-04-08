import 'package:flutter/material.dart';
import 'package:u_patrol/pages/createReport.dart';
import 'package:u_patrol/pages/dashboard.dart';
import 'package:u_patrol/pages/map.dart';
import 'package:u_patrol/pages/home.dart';

//insert query here
var reportsList = List<bool>;

class Template extends StatefulWidget {
  final Widget child;
  const Template({super.key, required this.child});

  @override
  State<Template> createState() => _TemplateState();
}

class _TemplateState extends State<Template> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/home': (context) => const Template(child: Dashboard()),
        '/map': (context) => const Template(
                child: Dashboard(
              initialKey: 1,
            )),
        '/create': (context) => const Template(child: CreateReport())
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

    return Scaffold(
      key: scaffoldKey,
      appBar: PublicAppBar(scaffoldKey: scaffoldKey, widget: widget),
      drawer: const PublicDrawer(),
      body: widget.child,
    );
  }
}

class PublicAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const PublicAppBar({
    super.key,
    required this.scaffoldKey,
    required this.widget,
  });

  final GlobalKey<ScaffoldState> scaffoldKey;
  final TemplateBody widget;

  @override
  Widget build(BuildContext context) {
    return AppBar(
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
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class PublicDrawer extends StatefulWidget {
  const PublicDrawer({super.key});

  @override
  State<PublicDrawer> createState() => _PublicDrawerState();
}

class _PublicDrawerState extends State<PublicDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: const [
          ListTile(
              leading:
                  Image(image: AssetImage('images/UPatrol-logo.png')),
              title: Column(
                children: [
                  Align(
                      alignment: Alignment.centerLeft,
                      child: Text("Username")),
                  Align(
                      alignment: Alignment.centerLeft,
                      child: Text("Username"))
                ],
              )),
          DashboardTile(
              icon: Icon(Icons.house_outlined, size: 40),
              label: 'Dashboard',
              namedRoute: '/home'),
          DashboardTile(
              icon: Icon(Icons.history, size: 40),
              label: 'History',
              namedRoute: '/history'),
          DashboardTile(
              icon: Icon(Icons.settings_outlined, size: 40),
              label: 'Settings',
              namedRoute: '/settings'),
          DashboardTile(
              icon: Icon(Icons.logout_outlined, size: 40),
              label: 'Log-out',
              namedRoute: '/settings'),
        ],
      ),
    );
  }
}

class DashboardTile extends StatelessWidget {
  final Icon icon;
  final String label;
  final String namedRoute;

  const DashboardTile({
    super.key,
    required this.icon,
    required this.label,
    required this.namedRoute,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
        leading: icon,
        title: Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
            fontFamily: "Roboto",
          ),
        ),
        onTap: () {
          Navigator.of(context).pushNamed(namedRoute);
        });
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
