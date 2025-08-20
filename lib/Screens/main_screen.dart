
import 'package:Brick2Life/Screens/profile/profile_screen.dart';
import 'package:Brick2Life/Screens/shopping/shopping_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Managers/data_manager.dart';
import 'cleaning/cleaning_screen.dart';
import 'home/home_screen.dart';

class MainScreen extends StatefulWidget {
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedTabIndex = 0;

  bool _shouldShowBadge(int personalListCount, int homeListCount) {
    return personalListCount > 0 || homeListCount > 0;
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _pages = <Widget>[
      HomeScreen(),
      CleaningScreen(),
      ShoppingScreen(),
      ProfileScreen()
    ];

    return Consumer<DataManager>(builder: (context, manager, child) {
      int personalListCount = manager.getShoppingForAccountByUsername(manager.loginAccount!.username).length;
      int homeListCount = manager.getShoppingForHouse().length;

      return Scaffold(
        body: IndexedStack(
          index: _selectedTabIndex,
          children: _pages,
        ),
        bottomNavigationBar: NavigationBar(
          indicatorColor: Colors.transparent,
          selectedIndex: _selectedTabIndex,
          onDestinationSelected: (index) {
            setState(() {
              _selectedTabIndex = index;
            });
          },
          destinations: [
            NavigationDestination(
              selectedIcon: Icon(
                Icons.home,
                color: Theme.of(context).colorScheme.primary,
              ),
              icon: Icon(Icons.home_outlined),
              label: "Home",
            ),
            NavigationDestination(
              selectedIcon: Icon(
                Icons.cleaning_services,
                color: Theme.of(context).colorScheme.primary,
              ),
              icon: Icon(Icons.cleaning_services_outlined),
              label: "Pulizie",
            ),
            NavigationDestination(
              selectedIcon: Badge(
                isLabelVisible: _shouldShowBadge(personalListCount, homeListCount),
                label: Text(''),
                child: Icon(
                  Icons.shopping_cart,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              icon: Badge(
                isLabelVisible: _shouldShowBadge(personalListCount, homeListCount),
                label: Text(''),
                child: Icon(
                  Icons.shopping_cart_outlined,
                ),
              ),
              label: "Spesa",
            ),
            NavigationDestination(
              selectedIcon: Icon(
                Icons.settings,
                color: Theme.of(context).colorScheme.primary,
              ),
              icon: Icon(Icons.settings_outlined),
              label: "Impostazioni",
            ),
          ],
        ),
      );
    });
  }
}
