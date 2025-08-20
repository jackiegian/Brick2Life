import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../Managers/data_manager.dart';
import '../../Constructors/account.dart';

class RemoveMemberScreen extends StatefulWidget {
  @override
  _RemoveMemberScreenState createState() => _RemoveMemberScreenState();
}

class _RemoveMemberScreenState extends State<RemoveMemberScreen> {
  void removeMember(BuildContext context, Account member) {
    final dataManager = Provider.of<DataManager>(context, listen: false);
    final currentHouse = dataManager.loginHouse;
    final loginAccount = dataManager.loginAccount;

    if (currentHouse == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Nessuna casa selezionata')),
      );
      return;
    }

    if (member.username == loginAccount?.username) {
      dataManager.removeHousemate(member.username);
      Navigator.pushNamedAndRemoveUntil(
        context,
        '/',
            (route) => false,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Non sei più un membro della casa')),
      );
      return;
    }

    dataManager.removeHousemate(member.username);
    setState(() {});
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${member.name} è stato rimosso dalla casa')),
    );
  }


  Future<void> showConfirmationDialog(
      BuildContext context, Account member) async {
    final dataManager = Provider.of<DataManager>(context, listen: false);
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Conferma Rimozione'),
          content: member.username == dataManager.loginAccount!.username
              ? Text(
              'Sei sicuro di volerti rimuovere dalla casa? \nVerrai inoltre disconnesso.')
              : Text("Sei sicuro di voler rimuovere ${member.name} dalla casa?"),
          actions: <Widget>[
            TextButton(
              child: Text('Annulla'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Conferma'),
              onPressed: () {
                Navigator.of(context).pop();
                removeMember(context, member);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final dataManager = Provider.of<DataManager>(context);
    final currentHouse = dataManager.loginHouse;

    if (currentHouse == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Rimuovi Membro'),
        ),
        body: Center(
          child: Text('Nessuna casa selezionata.'),
        ),
      );
    }

    List<Account> members = dataManager.getHousemates(dataManager.loginAccount!.username);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Rimuovi dalla casa",
        style: TextStyle(fontSize: 24),),
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: members.isEmpty
              ? Center(child: Text('Nessun membro trovato.'))
              : ListView.builder(
            itemCount: members.length,
            itemBuilder: (context, index) {
              Account member = members[index];
              return ListTile(
                contentPadding: EdgeInsets.symmetric(vertical: 12),
                leading: Container(
                  width: 48,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Theme.of(context).colorScheme.primary,
                      width: 2,
                    ),
                  ),
                  child: ClipOval(
                    child: Image.asset(
                      member.imgProfile,
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                title: Text(member.username ==
                    dataManager.loginAccount!.username
                    ? "Io"
                    : member.name),
                trailing: TextButton(
                  child: Text(
                    "Rimuovi",
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.error),
                  ),
                  onPressed: () {
                    setState(() {
                      Future.delayed(Duration(milliseconds: 300), () {
                        showConfirmationDialog(context, member);
                      });
                    });
                  },
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
