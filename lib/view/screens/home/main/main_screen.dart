import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../core/system/fire.dart';
import '../../../widgets/components/widgets.dart';
import 'home.dart';
import 'profile.dart';

// ignore: must_be_immutable
class MainScreen extends DevExamStatefulWidget {
  int index;
  MainScreen({Key key, this.index}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends DevExamState<MainScreen> {
  int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    List<Widget> _screens = [
      Home(userID: getCurrentUserID),
      Profile(getCurrentUserID),
    ];

    return Scaffold(
      body: _screens[widget.index ?? _currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: devExam.theme.accentGreenblue,
        unselectedItemColor: Colors.grey,
        selectedFontSize: 14,
        unselectedFontSize: 11.5,
        currentIndex: widget.index ?? _currentIndex,
        backgroundColor: Colors.white,
        items: buildItems(context),
        onTap: changeScreen,
      ),
    );
  }

  List<BottomNavigationBarItem> buildItems(BuildContext context) => [
        BottomNavigationBarItem(
          icon: Icon(Icons.menu_book_rounded),
          label: devExam.intl.of(context).fmt('navbar.home'),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: devExam.intl.of(context).fmt('navbar.profile'),
        ),
      ];

  void changeScreen(int index) {
    setState(() {
      widget.index == null ? _currentIndex = index : widget.index = index;
    });
  }

  String get getCurrentUserID {
    if (firebaseAuth.currentUser.uid == null) {
      return "empty";
    } else {
      return firebaseAuth.currentUser.uid;
    }
  }
}
