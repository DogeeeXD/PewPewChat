import 'package:PewPewChat/screens/chatrooms_screen.dart';
import 'package:PewPewChat/screens/chat_screen.dart';
import 'package:PewPewChat/screens/friends_screen.dart';
import 'package:PewPewChat/screens/messages_screen.dart';
import 'package:PewPewChat/screens/profile_screen.dart';
import 'package:PewPewChat/widgets/responsive_widget.dart';
import 'package:PewPewChat/widgets/side_drawer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final _screenOptions = [
    {
      'title': 'Messages',
      'widget': MessagesScreen(),
    },
    {
      'title': 'Friends',
      'widget': FriendsScreen(),
    },
    {
      'title': 'Profile',
      'widget': ProfileScreen(),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return ResponsiveWidget(
      largeScreen: Scaffold(
        body: Container(
          child: Row(
            children: [
              NavigationRail(
                backgroundColor: Theme.of(context).backgroundColor,
                unselectedIconTheme: Theme.of(context).iconTheme,
                selectedIconTheme: IconThemeData(
                  color: Theme.of(context).highlightColor,
                ),
                labelType: NavigationRailLabelType.all,
                selectedLabelTextStyle: TextStyle(
                  color: Theme.of(context).primaryColor,
                ),
                elevation: 5,
                destinations: [
                  NavigationRailDestination(
                    icon: Icon(Icons.chat_rounded),
                    label: Text('Messages'),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.people_alt_rounded),
                    label: Text('Friends'),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.account_circle_rounded),
                    label: Text('Profile'),
                  ),
                ],
                selectedIndex: _selectedIndex,
                onDestinationSelected: (index) {
                  setState(() {
                    _selectedIndex = index;
                  });
                },
              ),
              Expanded(
                flex: 1,
                child: Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(8),
                  //color: Theme.of(context).backgroundColor,
                  child: _screenOptions[_selectedIndex]['widget'],
                ),
              ),
              Expanded(
                flex: 2,
                child: Container(
                  alignment: Alignment.center,
                  child: _screenOptions[_selectedIndex]['widget'],
                ),
              ),
            ],
          ),
        ),
      ),
      smallScreen: Scaffold(
        appBar: AppBar(
          iconTheme: Theme.of(context).iconTheme,
          title: Text(_screenOptions[_selectedIndex]['title']),
        ),
        drawer: SideDrawer(),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
              color: Theme.of(context).backgroundColor,
              boxShadow: [
                BoxShadow(blurRadius: 5, color: Colors.black.withOpacity(.3))
              ]),
          child: SafeArea(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
              child: GNav(
                  gap: 8,
                  color: Color(0xFF717781),
                  activeColor: Theme.of(context).highlightColor,
                  backgroundColor: Theme.of(context).backgroundColor,
                  tabBackgroundColor: Theme.of(context).accentColor,
                  iconSize: 24,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  duration: Duration(milliseconds: 200),
                  curve: Curves.easeIn,
                  tabs: [
                    GButton(
                      icon: Icons.chat_rounded,
                      text: 'Messages',
                    ),
                    GButton(
                      icon: Icons.people_alt_rounded,
                      text: 'Friends',
                    ),
                    GButton(
                      icon: Icons.account_circle_rounded,
                      text: 'Profile',
                    ),
                  ],
                  selectedIndex: _selectedIndex,
                  onTabChange: (index) {
                    setState(() {
                      _selectedIndex = index;
                    });
                  }),
            ),
          ),
        ),
        body: _screenOptions[_selectedIndex]['widget'],
      ),
    );
  }
}
