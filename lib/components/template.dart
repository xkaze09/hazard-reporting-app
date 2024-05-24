import 'package:flutter/material.dart';
import 'package:hazard_reporting_app/backend/firebase_auth.dart';
import 'package:hazard_reporting_app/landing_page.dart';
import 'package:hazard_reporting_app/pages/history.dart';
import '../pages/create_report.dart';
import '/pages/dashboard.dart';
import '/pages/map.dart';
import '/pages/home.dart';
import 'package:hazard_reporting_app/data_types/globals.dart';

//insert query here
var reportsList = List<bool>;
final GlobalKey<ScaffoldMessengerState> rootScaffoldKey =
    GlobalKey<ScaffoldMessengerState>();

class Template extends StatefulWidget {
  final Widget child;
  final String title;
  const Template(
      {super.key, required this.child, required this.title});

  @override
  State<Template> createState() => _TemplateState();
}

class _TemplateState extends State<Template> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,
      scaffoldMessengerKey: rootScaffoldMessengerKey,
      routes: {
        '/home': (context) => const TemplateBody(
            title: "Dashboard", child: Dashboard()),
        '/map': (context) => const TemplateBody(
            title: "Dashboard",
            child: Dashboard(
              initialKey: 1,
            )),
        '/create': (context) => const TemplateBody(
              title: "Create Report",
              child: CreateReport(),
            ),
        '/history': (context) => const TemplateBody(
              title: "History",
              child: History(),
            )
      },
      home: TemplateBody(
        title: widget.title,
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
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PublicAppBar(widget: widget),
      drawer: const PublicDrawer(),
      body: widget.child,
    );
  }
}

class PublicAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const PublicAppBar({
    super.key,
    required this.widget,
  });
  final TemplateBody widget;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: true,
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
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          ListTile(
              leading: currentUser?.photo,
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                          currentUser?.displayName ?? "No Name")),
                  Align(
                      alignment: Alignment.centerLeft,
                      child: Text(currentUser?.getRole() ?? "User"))
                ],
              )),
          const DashboardTile(
              icon: Icon(Icons.house_outlined, size: 40),
              label: 'Dashboard',
              namedRoute: '/home'),
          const DashboardTile(
              icon: Icon(Icons.history, size: 40),
              label: 'History',
              namedRoute: '/history'),
          const DashboardTile(
              icon: Icon(Icons.settings_outlined, size: 40),
              label: 'Settings',
              namedRoute: '/settings'),
          ListTile(
            leading: const Icon(Icons.logout, size: 40),
            title: const Text(
              "Log-Out",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
                fontFamily: "Roboto",
              ),
            ),
            onTap: () {
              logOut();
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) {
                return const LandingPage();
              }));
            },
          )
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
          Navigator.of(context).popAndPushNamed(namedRoute);
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
  final GlobalKey<ScaffoldState> _scaffoldKey =
      GlobalKey<ScaffoldState>();

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
            key: _scaffoldKey,
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
