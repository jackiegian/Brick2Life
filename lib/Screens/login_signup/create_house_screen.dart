import 'package:Brick2Life/Screens/login_signup/join_house_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../Managers/data_manager.dart';

class CreateHouseScreen extends StatefulWidget {
  @override
  State<CreateHouseScreen> createState() => _CreateHouseScreenState();
}

class _CreateHouseScreenState extends State<CreateHouseScreen> {
  final TextEditingController houseNameController = TextEditingController(text: 'La mia casa');

  bool validateFields(BuildContext context) {
    if (houseNameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Per favore, inserisci il nome della casa')),
      );
      return false;
    }
    return true;
  }

  void createHouse(BuildContext context) {
    if (!validateFields(context)) return;

    String houseName = houseNameController.text;

    final dataManager = Provider.of<DataManager>(context, listen: false);
    final currentAccount = dataManager.loginAccount;

    if (currentAccount == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Devi essere loggato per creare una casa')),
      );
      return;
    }

    dataManager.createHouseWithAccount(houseName, currentAccount);
    dataManager.setLoginAccountFromCredentials(
        currentAccount.username, currentAccount.password);

    Navigator.pushNamedAndRemoveUntil(
      context,
      '/home',
          (route) => false,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Casa creata con successo!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        centerTitle: true,
        title: Text(
          "Brick2Life",
          style: TextStyle(
            fontSize: 45,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              Text(
                'Crea una nuova casa',
                style: TextStyle(fontSize: 30),
              ),
              SizedBox(
                height: 48,
              ),
              TextField(
                controller: houseNameController,
                decoration: InputDecoration(
                  prefixIcon: Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Icon(Icons.abc),
                  ),
                  contentPadding: EdgeInsets.fromLTRB(32, 16, 16, 16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                  ),
                  labelText: 'Nome della casa',
                ),
              ),
              SizedBox(height: 48),
              FilledButton(
                onPressed: () {
                  Future.delayed(Duration(milliseconds: 300), () {
                    createHouse(context);
                  });
                },
                child: Container(
                    padding: EdgeInsets.all(16),
                    width: screenWidth * 0.3,
                    child: Center(child: Text('Crea'))),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
