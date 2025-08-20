import 'package:Brick2Life/Screens/profile/change_house_name_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../Constructors/account.dart';
import '../../Managers/data_manager.dart';
import '../profile/invite_member_screen.dart';
import '../profile/remove_member_screeen.dart';

class SharedHouseScreen extends StatefulWidget {
  @override
  State<SharedHouseScreen> createState() => _SharedHouseScreenState();
}

class _SharedHouseScreenState extends State<SharedHouseScreen> {
  late TextEditingController _notesController;

  @override
  void initState() {
    super.initState();
    final manager = Provider.of<DataManager>(context, listen: false);
    _notesController = TextEditingController(
      text: manager.getHouseForAccount(manager.loginAccount!)?.sharedNotes ?? '',
    );
  }


  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Consumer<DataManager>(
      builder: (context, manager, child) {
        List<Account> orderedAccounts =
        manager.getHousemates(manager.loginAccount!.username);
        return Scaffold(
          appBar: AppBar(
            scrolledUnderElevation: 0,
            toolbarHeight: 80,
            title: Text(manager.loginHouse!.title, style: TextStyle(fontSize: 28)),
            centerTitle: true,
            backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          ),
          body: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
            ),
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(16),
                  height: 160,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return SizedBox(
                        width: screenWidth * 0.2,
                        child: Column(
                          children: [
                            Stack(
                              clipBehavior: Clip.none,
                              children: [
                                ClipOval(
                                  child: Image.asset(
                                    orderedAccounts[index].imgProfile,
                                    fit: BoxFit.fill,
                                  ),
                                ),
                                Positioned(
                                  right: -4,
                                  bottom: -4,
                                  child: Container(
                                    height: 32,
                                    width: 32,
                                    decoration: BoxDecoration(
                                      color: orderedAccounts[index].isOnline ? Colors.green : Colors.red,
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(30),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 4),
                            Text(
                              index == 0 ? "Tu" : orderedAccounts[index].name,
                              style: TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      );
                    },
                    separatorBuilder: (context, index) => SizedBox(width: 16),
                    itemCount: manager.getHousemates(manager.loginAccount!.username).length,
                  ),
                ),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(36),
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
                              Icon(Icons.sticky_note_2, color: Theme.of(context).colorScheme.onSurface),
                              SizedBox(width: 16),
                              Text(
                                "Note condivise",
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.onSurface,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 8, 0, 24),
                            child: Divider(
                              height: 1,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                          Container(
                            width: double.infinity,
                            child: LongTextInput(
                              controller: _notesController,
                              manager: manager,
                            ),
                          ),
                          SizedBox(height: 24),
                          Row(
                            children: [
                              Icon(Icons.people, color: Theme.of(context).colorScheme.onSurface),
                              SizedBox(width: 16),
                              Text(
                                "Impostazioni casa",
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.onSurface,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
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
                                        height: screenHeight * 0.7,
                                        child: ChangeHouseNameScreen(),
                                      );
                                    },
                                  );
                                });
                              });
                            },
                          ),
                          CustomTextButton(
                            text: "Invita nella casa",
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
                                        height: screenHeight * 0.5,
                                        child: InviteMemberScreen(),
                                      );
                                    },
                                  );
                                });
                              });
                            },
                          ),
                          CustomTextButton(
                            text: "Rimuovi dalla casa",
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
                                        child: RemoveMemberScreen(),
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

class LongTextInput extends StatelessWidget {
  final TextEditingController controller;
  final DataManager manager;

  LongTextInput({required this.controller, required this.manager});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      maxLines: null,
      keyboardType: TextInputType.multiline,
      decoration: InputDecoration(
        hintText: 'Scrivi qui...',
        contentPadding: EdgeInsets.all(16),
        border: OutlineInputBorder(
          borderSide: BorderSide(
            width: 1,
            color: Theme.of(context).colorScheme.secondary,
          ),
          borderRadius: BorderRadius.all(Radius.circular(30)),
        ),
      ),
      onChanged: (text) {
        var house = manager.getHouseForAccount(manager.loginAccount!);
        if (house != null) {
          house.sharedNotes = text;
          manager.notifyListeners();
        }
      },
    );
  }
}

