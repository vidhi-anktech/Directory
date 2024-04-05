import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_directory_app/main.dart';
import 'package:flutter_directory_app/resources.dart';
import 'package:flutter_directory_app/screens/login_page.dart';
import 'package:flutter_directory_app/screens/profile.dart';
import 'package:flutter_directory_app/screens/register_details_page.dart';
import 'package:flutter_directory_app/screens/show_data.dart';
import 'package:flutter_directory_app/screens/Sponsor/sponsors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  late int _lastTappedIndex = 0;

  @override
  void initState() {
    super.initState();
    // _getLastTappedIndex();
    check();
  }

  // Future<void> _getLastTappedIndex() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   _lastTappedIndex = prefs.getInt(MyAppState.LASTINDEX) ?? 0 ;
  // }

  // Future<void> _setLastTappedIndex(int index) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   await prefs.setInt(MyAppState.LASTINDEX, index);
  // }

  Future<void> check() async {
    var sharedPref = await SharedPreferences.getInstance();
    var isLoggedIn = sharedPref.getBool(MyAppState.KEYLOGIN);
    if (isLoggedIn != null) {
      if (isLoggedIn) {
        setState(() {
          _children[1] = RegistrationPage();
        });
      } else {
        setState(() {
          _children[1] = const LoginPage();
        });
      }
    } else {
      setState(() {
        _children[1] = const LoginPage();
      });
    }
  }

  late final List<Widget> _children = [
    const ShowData(),
    RegistrationPage(),
    const Sponsors(),
    const MyProfile(),
  ];

  _onItemTapped(index) async {
    setState(() {
      _currentIndex = index;
      _lastTappedIndex = index;
    });
    // await _setLastTappedIndex(index);
  }

  @override
  Widget build(BuildContext context) {
    print("VALUE OF BUILD CONTEXT CURRENT INDEX : $_currentIndex");
    print("VALUE OF BUILD CONTEXT LAST TAPPED INDEX : $_lastTappedIndex");
    return Scaffold(
      body: WillPopScope(
        onWillPop: () async {
          int index = 0;
          if (_lastTappedIndex != 0) {
            setState(() {
              _currentIndex = 0;
              _lastTappedIndex = 0;
              // _setLastTappedIndex(index);
            });
         
            return false;
          }
          SystemNavigator.pop();
          return true;
        },
        child: IndexedStack(index: _currentIndex, children: _children),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: AppTextStyles.selectedLabel,
        unselectedLabelStyle: AppTextStyles.unselectedLabel,
        items: [
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage(Assets.homeIcon)),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage(Assets.addIcon)),
            label: 'Add',
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage(Assets.sponsorIcon)),
            label: 'Sponsors',
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage(Assets.moreIcon)),
            label: 'About',
          )
        ],
        onTap: _onItemTapped,
      ),
    );
  }
}
