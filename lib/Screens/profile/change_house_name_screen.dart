import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../Managers/data_manager.dart';

class ChangeHouseNameScreen extends StatefulWidget {
  @override
  _ChangeHouseNameScreenState createState() => _ChangeHouseNameScreenState();
}

class _ChangeHouseNameScreenState extends State<ChangeHouseNameScreen> {
  final TextEditingController nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final dataManager = Provider.of<DataManager>(context, listen: false);
    final currentAccount = dataManager.loginAccount;

    if (currentAccount != null) {
      final currentHouse = dataManager.getHouseForAccount(currentAccount);
      if (currentHouse != null) {
        nameController.text = currentHouse.title;
      }
    }
  }

  bool validateFields(BuildContext context) {
    if (nameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Per favore, inserisci il nuovo nome')),
      );
      return false;
    }
    return true;
  }

  void changeName(BuildContext context) {
    if (!validateFields(context)) return;

    String newName = nameController.text;

    final dataManager = Provider.of<DataManager>(context, listen: false);
    final currentAccount = dataManager.loginAccount;

    if (currentAccount == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Errore: nessun account corrente trovato')),
      );
      return;
    }

    dataManager.changeHouseName(currentAccount.username, newName);

    Navigator.pop(context);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Nome della casa cambiato con successo!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Cambia nome della casa",
          style: TextStyle(fontSize: 24),),
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    prefixIcon: Padding(
                      padding: const EdgeInsets.only(left: 4.0),
                      child: Icon(Icons.abc),
                    ),
                    contentPadding: EdgeInsets.all(16),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                    ),
                    labelText: 'Nuovo nome',
                  ),
                ),
                SizedBox(height: 48),
                FilledButton(
                  onPressed: () {
                    changeName(context);
                  },
                  child: Container(
                      padding: EdgeInsets.all(16),
                      width: screenWidth * 0.3,
                      child: Center(child: Text('Cambia'))),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
