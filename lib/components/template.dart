import 'package:flutter/material.dart';
import 'package:u_patrol/map.dart';
import 'package:u_patrol/dashboard.dart';

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
  int _selectedNavBar = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedNavBar = index;
      if (index == 0) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const Dashboard()),
        );
      }
      if (index == 1) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const Map()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

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
        title: const Text("Dashboard"),
      ),
      drawer: const Drawer(
        child: PublicDrawer(),
      ),
      body: widget.child,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedNavBar,
        onTap: _onItemTapped,
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
      ),
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
