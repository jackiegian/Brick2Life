import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Constructors/account.dart';
import '../../Constructors/shopping_item.dart';
import '../../Managers/data_manager.dart';

class NewShopping extends StatefulWidget {
  @override
  State<NewShopping> createState() => _NewShoppingState();
}

class _NewShoppingState extends State<NewShopping> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController subtitleController = TextEditingController();
  String? owner;

  final _formKey = GlobalKey<FormState>();

  void CreateShopping(BuildContext context) {
    if (_formKey.currentState!.validate() && owner != null) {
      String title = titleController.text;
      String? subtitle =
          subtitleController.text.isEmpty ? null : subtitleController.text;

      final dataManager = Provider.of<DataManager>(context, listen: false);

      ShoppingItem newShopping = ShoppingItem(
        title: title,
        subtitle: subtitle,
      );

      if (owner != null) {
        dataManager.addShoppingForAccountByUsername(owner, newShopping);
      }

      Navigator.pop(context);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Oggetto aggiunto alla lista.')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Per favore, seleziona una lista')),
      );
    }
  }

  void showBuyerSelectionDialog(BuildContext context) {
    final dataManager = Provider.of<DataManager>(context, listen: false);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Seleziona una lista"),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              String? selectedList = owner;

              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    title: Text("Lista personale"),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                    selected:
                        selectedList == dataManager.loginAccount!.username,
                    selectedTileColor: Theme.of(context)
                        .colorScheme
                        .secondary
                        .withOpacity(0.1),
                    onTap: () {
                      Future.delayed(Duration(milliseconds: 300), () {
                        setState(() {
                          owner = dataManager.loginAccount!.username;
                          selectedList = owner;
                        });
                        Navigator.of(context).pop();
                      });
                    },
                  ),
                  ListTile(
                    title: Text("Lista della casa"),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                    selected: selectedList == "Casa",
                    selectedTileColor: Theme.of(context)
                        .colorScheme
                        .secondary
                        .withOpacity(0.1),
                    onTap: () {
                      Future.delayed(Duration(milliseconds: 300), () {
                        setState(() {
                          owner = "Casa";
                          selectedList = owner;
                        });
                        Navigator.of(context).pop();
                      });
                    },
                  ),
                ],
              );
            },
          ),
        );
      },
    ).then((_) {

      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Nuovo acquisto",
          style: TextStyle(fontSize: 24),),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 4,
                ),
                BuildShoppingTitle(),
                SizedBox(height: 24),
                buildEventSubtitle(),
                SizedBox(height: 24),
                Container(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () {
                      Future.delayed(Duration(milliseconds: 300), () {
                        showBuyerSelectionDialog(context);
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        _getOwnerText(),
                        style: TextStyle(
                          fontSize: 16,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 48),
                FilledButton(
                  onPressed: () {
                    Future.delayed(Duration(milliseconds: 300), () {
                      CreateShopping(context);
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.all(16),
                    width: screenWidth * 0.3,
                    child: Center(
                      child: Text(
                        'Aggiungi',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget BuildShoppingTitle() {
    return TextFormField(
      controller: titleController,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Inserisci un titolo.';
        }
        return null;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        prefixIcon: Padding(
          padding: const EdgeInsets.only(left: 4.0),
          child: Icon(Icons.abc),
        ),
        contentPadding: EdgeInsets.all(16),
        border: OutlineInputBorder(
          borderSide: BorderSide(
              width: 1, color: Theme.of(context).colorScheme.secondary),
          borderRadius: BorderRadius.all(Radius.circular(30)),
        ),
        labelText: 'Cosa devi comprare?',
      ),
    );
  }

  Widget buildEventSubtitle() {
    return TextFormField(
      controller: subtitleController,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        prefixIcon: Padding(
          padding: const EdgeInsets.only(left: 4.0),
          child: Icon(Icons.subject),
        ),
        contentPadding: EdgeInsets.all(16),
        border: OutlineInputBorder(
          borderSide: BorderSide(
              width: 1, color: Theme.of(context).colorScheme.secondary),
          borderRadius: BorderRadius.all(Radius.circular(30)),
        ),
        labelText: 'Ulteriori dettagli',
      ),
    );
  }

  String _getOwnerText() {
    if (owner == null) {
      return 'Seleziona una lista';
    } else if (owner ==
        Provider.of<DataManager>(context, listen: false)
            .loginAccount!
            .username) {
      return 'Lista personale';
    } else {
      return 'Lista della casa';
    }
  }
}
