import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../globals/index.dart' as globals;

class BottomNavigationBarComponent extends StatefulWidget {
  @override
  _BottomNavigationBarComponentState createState() =>
      _BottomNavigationBarComponentState();
}

class _BottomNavigationBarComponentState
    extends State<BottomNavigationBarComponent> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.pushNamed(context, '/home');

        break;
      case 1:
        Navigator.pushNamed(context, '/search');
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => SearchPage(),
        //   ),
        // );
        break;
      case 2:
        break;
      case 3:
        break;
      default:
    }
  }

  BottomNavigationBarItem _navBarItem(
      {IconData icon, String route, String textName, double textSize}) {
    return (BottomNavigationBarItem(
      icon: Icon(
        icon,
        color: globals.routeName == route ? Colors.amber[800] : Colors.white,
      ),
      title: Text(
        textName,
        style: TextStyle(
          fontSize: textSize,
          color: globals.routeName == route ? Colors.amber[800] : Colors.white,
        ),
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: Colors.black54,
      // fixedColor: Colors.blue,

      items: [
        _navBarItem(icon: Icons.home, route: '/home', textName: "Home"),
        _navBarItem(
          icon: Icons.search,
          route: '/search',
          textName: "Filtrar",
          textSize: 16.5,
        ),
      ],
      currentIndex: _selectedIndex,
      onTap: _onItemTapped,
    );
  }
}
