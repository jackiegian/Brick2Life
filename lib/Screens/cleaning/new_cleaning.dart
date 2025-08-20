import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../Constructors/account.dart';
import '../../Constructors/cleaning_item.dart';
import '../../Managers/data_manager.dart';

class NewCleaning extends StatefulWidget {
  @override
  State<NewCleaning> createState() => _NewCleaningState();
}

class _NewCleaningState extends State<NewCleaning> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController subtitleController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  List<String> selectedUsernames = [];

  final _formKey = GlobalKey<FormState>();

  DateTime _selectedDate = DateTime.now();

  void CreateCleaning(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      String title = titleController.text;
      String subtitle = subtitleController.text;
      DateTime expiration = _selectedDate;
      List<String> participants = selectedUsernames;

      final dataManager = Provider.of<DataManager>(context, listen: false);

      if (selectedUsernames.isNotEmpty) {
        for (String username in selectedUsernames) {
          CleaningItem newCleaning = CleaningItem(
            title: title,
            subtitle: subtitle,
            expiration: expiration,
            participants: participants,
            isDone: false,
          );

          dataManager.addCleaningForAccountByUsername(username, newCleaning);
        }
        Navigator.pop(context);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Pulizia creata.')),
        );

      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Per favore, seleziona almeno un utente')),
        );
      }
    }
  }

  void showUserSelectionDialog(BuildContext context) {
    final dataManager = Provider.of<DataManager>(context, listen: false);

    List<Account> allAccounts = dataManager.getHousemates(dataManager.loginAccount!.username);
    List<Account> offlineAccounts = allAccounts
        .where((account) => account.isOnline)
        .toList();

    FocusScope.of(context).unfocus();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        bool selectAll = selectedUsernames.length == offlineAccounts.length;
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter dialogSetState) {
            return AlertDialog(
              actionsAlignment: MainAxisAlignment.spaceBetween,
              title: Text("Seleziona chi deve pulire"),
              content: offlineAccounts.isEmpty
                  ? Text('Non ci sono utenti online.')
                  : SingleChildScrollView(
                child: Column(
                  children: offlineAccounts.map((account) {
                    String displayName = account.username == dataManager.loginAccount!.username
                        ? "Io"
                        : account.name;
                    bool isSelected = selectedUsernames.contains(account.username);
                    return ListTile(
                      title: Text(displayName),
                      trailing: Icon(
                        isSelected
                            ? Icons.check_box
                            : Icons.check_box_outline_blank,
                        color: isSelected
                            ? Theme.of(context).colorScheme.primary
                            : null,
                      ),
                      onTap: () {
                        dialogSetState(() {
                          setState(() {
                            if (isSelected) {
                              selectedUsernames.remove(account.username);
                            } else {
                              selectedUsernames.add(account.username);
                            }
                          });
                        });
                      },
                    );
                  }).toList(),
                ),
              ),
              actions: offlineAccounts.isEmpty
                  ? <Widget>[
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    child: Text('Ok'),
                    onPressed: () {
                      Future.delayed(Duration(milliseconds: 300), () {
                        Navigator.of(context).pop();
                      });
                    },
                  ),
                ),
              ]
                  : <Widget>[
                TextButton(
                  onPressed: () {
                    Future.delayed(Duration(milliseconds: 300), () {
                      dialogSetState(() {
                        setState(() {
                          selectAll = !selectAll;
                          if (selectAll) {
                            selectedUsernames = offlineAccounts
                                .map((account) => account.username)
                                .toList();
                          } else {
                            selectedUsernames.clear();
                          }
                        });
                      });
                    });
                  },
                  child:
                  Text(selectAll ? 'Deseleziona tutti' : 'Seleziona tutti'),
                ),
                TextButton(
                  child: Text('Ok'),
                  onPressed: () {
                    Future.delayed(Duration(milliseconds: 300), () {
                      Navigator.of(context).pop();
                    });
                  },
                ),
              ],

            );
          },
        );
      },
    );
  }



  String _getSelectedUsersText(DataManager dataManager) {
    if (selectedUsernames.isEmpty) {
      return "Chi pulisce?";
    } else {
      return "${selectedUsernames.length} selezionati";
    }
  }

  void showDatePickerDialog(BuildContext context) {
    FocusScope.of(context).unfocus();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Seleziona una data"),
          contentPadding: EdgeInsets.all(0),
          content: SizedBox(
            width: MediaQuery.of(context).size.width * 0.8,
            height: MediaQuery.of(context).size.height * 0.4,
            child: CupertinoDatePicker(
              mode: CupertinoDatePickerMode.date,
              initialDateTime: _selectedDate,
              onDateTimeChanged: (DateTime newDateTime) {
                setState(() {
                  _selectedDate = newDateTime;
                  dateController.text =
                      DateFormat.yMd('it_IT').format(newDateTime);
                });
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Future.delayed(Duration(milliseconds: 300), () {
                  Navigator.of(context).pop();
                });
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Nuova pulizia",
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
                BuildCleaningTitle(),
                SizedBox(height: 24),
                buildEventSubtitle(),
                SizedBox(height: 24),
                Container(
                  child: Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            Future.delayed(Duration(milliseconds: 300), () {
                              showDatePickerDialog(context);
                            });
                          },
                          icon: Icon(
                            Icons.calendar_month,
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                          label: Text(
                            overflow: TextOverflow.ellipsis,
                            DateFormat.yMMMd('it_IT').format(_selectedDate),
                            style: TextStyle(
                              fontSize: 16,
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            padding: EdgeInsets.all(
                                16),
                          ),
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            Future.delayed(Duration(milliseconds: 300), () {
                              showUserSelectionDialog(context);
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                            child: Consumer<DataManager>(
                              builder: (context, dataManager, child) {
                                return Text(
                                  overflow: TextOverflow.ellipsis,
                                  _getSelectedUsersText(dataManager),
                                  style: TextStyle(
                                    fontSize: 16,
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 48),
                FilledButton(
                  onPressed: () {
                    Future.delayed(Duration(milliseconds: 300), () {
                      CreateCleaning(context);
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
                      )),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget BuildCleaningTitle() {
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
        labelText: 'Che cosa devi fare?',
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
}
