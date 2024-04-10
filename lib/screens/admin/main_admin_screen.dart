import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_icons/line_icons.dart';
import 'package:science_expert01/screens/admin/contact_screen.dart';
import 'package:science_expert01/screens/admin/home_screen.dart';
import 'package:science_expert01/screens/admin/users_screen.dart';

class AdminMainScreen extends StatefulWidget {
  static int? selectedIndex;
  @override
  State<AdminMainScreen> createState() => _AdminMainScreenState();
}

class _AdminMainScreenState extends State<AdminMainScreen> {
  static List<Widget> _widgetOptions = <Widget>[
    AdminHomeScreen(),
    MessagesScreen(),
    UsersScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _widgetOptions.elementAt(AdminMainScreen.selectedIndex!),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              blurRadius: 20,
              color: Colors.black.withOpacity(0.1),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
            child: GNav(
              rippleColor: Colors.white,
              hoverColor: Colors.white,
              gap: 8,
              activeColor: Colors.white,
              iconSize: 24,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              duration: Duration(milliseconds: 400),
              tabBackgroundColor: Color.fromRGBO(237, 42, 110, 1),
              color: Colors.black,
              tabs: [
                GButton(
                  icon: LineIcons.plus,
                  text: 'Add',
                ),
                GButton(
                  icon: LineIcons.comment,
                  text: 'Messages',
                ),
                GButton(
                  icon: LineIcons.users,
                  text: 'Users',
                ),
              ],
              selectedIndex: AdminMainScreen.selectedIndex!,
              onTabChange: (index) {
                setState(
                  () {
                    AdminMainScreen.selectedIndex = index;
                  },
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
