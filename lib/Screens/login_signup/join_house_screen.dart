import 'package:Brick2Life/Screens/login_signup/create_house_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../Managers/data_manager.dart';

class JoinHouseScreen extends StatefulWidget {
  @override
  _JoinHouseScreenState createState() => _JoinHouseScreenState();
}

class _JoinHouseScreenState extends State<JoinHouseScreen> {
  final TextEditingController houseIdController = TextEditingController();

  bool validateFields(BuildContext context) {
    if (houseIdController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Per favore, inserisci l\'ID della casa')),
      );
      return false;
    }
    return true;
  }

  void joinHouse(BuildContext context) {
    if (!validateFields(context)) return;

    String houseId = houseIdController.text;

    final dataManager = Provider.of<DataManager>(context, listen: false);
    final currentAccount = dataManager.loginAccount;

    if (currentAccount == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Devi essere loggato per unirti a una casa')),
      );
      return;
    }

    dataManager.addAccountToExistingHouse(houseId, currentAccount);
    dataManager.setLoginAccountFromCredentials(
        currentAccount.username, currentAccount.password);

    Navigator.pushNamedAndRemoveUntil(
      context,
      '/home',
      (route) => false,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Unito alla casa con successo!')),
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
                "Entra in una casa",
                style: TextStyle(fontSize: 30),
              ),
              SizedBox(
                height: 48,
              ),
              TextField(
                controller: houseIdController,
                decoration: InputDecoration(
                  prefixIcon: Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Icon(Icons.pin),
                  ),
                  contentPadding: EdgeInsets.fromLTRB(32, 16, 16, 16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                  ),
                  labelText: 'ID della casa',
                ),
              ),
              SizedBox(height: 48),
              FilledButton(
                onPressed: () {
                  Future.delayed(Duration(milliseconds: 300), () {
                    joinHouse(context);
                  });
                },
                child: Container(
                    padding: EdgeInsets.all(16),
                    width: screenWidth * 0.3,
                    child: Center(child: Text('Entra'))),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
