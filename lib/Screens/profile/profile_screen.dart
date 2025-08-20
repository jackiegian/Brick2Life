import 'package:Brick2Life/Screens/home/shared_house_screen.dart';
import 'package:Brick2Life/Screens/profile/change_image_screen.dart';
import 'package:Brick2Life/Screens/profile/change_name_screen.dart';
import 'package:Brick2Life/Screens/profile/change_password_screen.dart';
import 'package:Brick2Life/Screens/profile/invite_member_screen.dart';
import 'package:Brick2Life/Screens/profile/remove_member_screeen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../Constructors/account.dart';
import '../../Managers/data_manager.dart';

class ProfileScreen extends StatefulWidget {
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Conferma Logout"),
          content: Text("Sei sicuro di voler uscire dall'app?"),
          actions: <Widget>[
            TextButton(
              child: Text("Annulla"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("Esci"),
              onPressed: () {
                Provider.of<DataManager>(context, listen: false)
                    .resetLoginAccount();
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/',
                  (Route<dynamic> route) => false,
                );
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Disconnessione avvenuta con successo.')),
                );
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return Consumer<DataManager>(
      builder: (context, manager, child) {
        return Scaffold(
          appBar: AppBar(
            scrolledUnderElevation: 0,
            backgroundColor: Theme.of(context).colorScheme.primaryContainer,
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: IconButton(
                    onPressed: () {
                      Future.delayed(Duration(milliseconds: 300), () {
                        _showLogoutDialog(context);
                      });
                    },
                    icon: Icon(
                      Icons.logout,
                      size: 36,
                      color: Theme.of(context).colorScheme.error,
                    )),
              )
            ],
          ),
          body: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                  child: Center(
                    child: Column(
                      children: [
                        Container(
                          height: 120,
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              ClipOval(
                                child: Image.asset(
                                  manager.loginAccount!.imgProfile,
                                  fit: BoxFit.fill,
                                ),
                              ),
                              Positioned(
                                right: -8,
                                bottom: -8,
                                child: IconButton.filled(
                                  icon: Icon(Icons.camera_alt,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimary),
                                  onPressed: () {
                                    Future.delayed(Duration(milliseconds: 300),
                                        () {
                                      setState(() {
                                        showModalBottomSheet(
                                          isScrollControlled: true,
                                          backgroundColor: Theme.of(context)
                                              .colorScheme
                                              .surface,
                                          showDragHandle: true,
                                          context: context,
                                          builder: (context) {
                                            return Container(
                                              height: screenHeight * 0.8,
                                              child: ChangeImageScreen(),
                                            );
                                          },
                                        );
                                      });
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        Text(
                          manager.loginAccount!.name,
                          style: TextStyle(fontSize: 28),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.fromLTRB(36, 36, 36, 0),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(30),
                        topLeft: Radius.circular(30),
                      ),
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.settings_suggest,
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                              SizedBox(width: 16),
                              Text(
                                "App",
                                style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.onSurface,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Divider(
                              height: 1,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Future.delayed(Duration(milliseconds: 300), () {
                                Provider.of<DataManager>(context, listen: false)
                                    .darkMode = !Provider.of<DataManager>(
                                        context,
                                        listen: false)
                                    .darkMode;
                              });
                            },
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.symmetric(vertical: 4),
                              minimumSize: Size(double.infinity, 48),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Row(
                                    children: [
                                      Text(
                                        "Modalità scura",
                                        style: TextStyle(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSurface,
                                            fontSize: 16),
                                      ),
                                    ],
                                  ),
                                ),
                                Transform.scale(
                                  scale: 0.8,
                                  child: Consumer<DataManager>(
                                    builder: (context, manager, child) {
                                      return Switch(
                                        value: manager.darkMode,
                                        onChanged: (value) {
                                          manager.darkMode = value;

                                        },
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Future.delayed(Duration(milliseconds: 300), () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => SharedHouseScreen(),
                                  ),
                                );
                              });
                            },
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.symmetric(vertical: 8),
                              minimumSize: Size(double.infinity, 48),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Row(
                                    children: [
                                      Text(
                                        "Impostazioni casa",
                                        style: TextStyle(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSurface,
                                            fontSize: 16),
                                      ),
                                    ],
                                  ),
                                ),
                                Icon(
                                  Icons.chevron_right,
                                  color:
                                      Theme.of(context).colorScheme.onSurface,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 24,
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.person,
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                              SizedBox(width: 16),
                              Text(
                                "Profilo",
                                style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.onSurface,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Divider(
                              height: 1,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Future.delayed(Duration(milliseconds: 300), () {
                                final manager = Provider.of<DataManager>(
                                    context,
                                    listen: false);
                                bool isOnline = manager
                                    .getAccountByUsername(
                                        manager.loginAccount!.username)!
                                    .isOnline;
                                manager.toggleOnlineStatus(
                                    manager.loginAccount!.username, !isOnline);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: isOnline == false ? Text('Sei di nuovo online!'): Text("Ora sei offline!")),
                                );
                              });
                            },
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.symmetric(vertical: 4),
                              minimumSize: Size(double.infinity, 48),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Row(
                                    children: [
                                      Text(
                                        "Modalità vacanza",
                                        style: TextStyle(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSurface,
                                            fontSize: 16),
                                      ),
                                    ],
                                  ),
                                ),
                                Transform.scale(
                                  scale: 0.8,
                                  child: Consumer<DataManager>(
                                    builder: (context, manager, child) {
                                      bool isOnline = manager
                                          .getAccountByUsername(
                                              manager.loginAccount!.username)!
                                          .isOnline;
                                      return Switch(
                                        value: !isOnline,
                                        onChanged: (value) {
                                          manager.toggleOnlineStatus(
                                              manager.loginAccount!.username,
                                              !value);
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(content: isOnline == false ? Text('Sei di nuovo online!'): Text("Ora sei offline!")),
                                          );
                                        },
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          CustomTextButton(
                            text: "Cambia nome",
                            icon: Icons.chevron_right,
                            onPressed: () {
                              Future.delayed(Duration(milliseconds: 300), () {
                                setState(() {
                                  showModalBottomSheet(
                                    isScrollControlled: true,
                                    backgroundColor: Theme.of(context).colorScheme.surface,
                                    showDragHandle: true,
                                    context: context,
                                    builder: (context) {
                                      return Container(
                                        height: screenHeight * 0.6,
                                        child: ChangeNameScreen(),
                                      );
                                    },
                                  );
                                });
                              });
                            },
                          ),
                          CustomTextButton(
                            text: "Cambia password",
                            icon: Icons.chevron_right,
                            onPressed: () {
                              Future.delayed(Duration(milliseconds: 300), () {
                                setState(() {
                                  showModalBottomSheet(
                                    isScrollControlled: true,
                                    backgroundColor: Theme.of(context).colorScheme.surface,
                                    showDragHandle: true,
                                    context: context,
                                    builder: (context) {
                                      return Container(
                                        height: screenHeight * 0.6,
                                        child: ChangePasswordScreen(),
                                      );
                                    },
                                  );
                                });
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
class CustomTextButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final VoidCallback onPressed;

  CustomTextButton({required this.text, required this.icon, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        padding: EdgeInsets.symmetric(vertical: 8),
        minimumSize: Size(double.infinity, 48),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              children: [
                Text(
                  text,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            icon,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ],
      ),
    );
  }
}
