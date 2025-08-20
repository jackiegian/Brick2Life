import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../Constructors/event_item.dart';
import '../../Managers/data_manager.dart';

class NewEvent extends StatefulWidget {
  @override
  _NewEventState createState() => _NewEventState();
}

class _NewEventState extends State<NewEvent> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController subtitleController = TextEditingController();
  final TextEditingController timeController = TextEditingController();
  final TextEditingController dateController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  DateTime _selectedDate = DateTime.now();
  DateTime _selectedTime = DateTime.now();

  void createEvent(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      String title = titleController.text;
      String subtitle = subtitleController.text;
      DateTime expiration = _selectedDate;
      DateTime userChosenTime = _selectedTime;

      final dataManager = Provider.of<DataManager>(context, listen: false);

      EventItem newEvent = EventItem(
        title: title,
        subtitle: subtitle,
        expiration: expiration,
        userChosenTime: userChosenTime,
      );

      dataManager.addEventForAccountByUsername(
          dataManager.loginAccount!.username, newEvent);
      Navigator.pop(context);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Promemoria creato.')),
      );
    }
  }

  void showDatePickerDialog(BuildContext context) {
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

  void showTimePickerDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Seleziona un'ora"),
          contentPadding: EdgeInsets.all(0),
          content: SizedBox(
            width: MediaQuery.of(context).size.width * 0.6,
            height: MediaQuery.of(context).size.height * 0.3,
            child: CupertinoDatePicker(
              use24hFormat: true,
              mode: CupertinoDatePickerMode.time,
              initialDateTime: _selectedTime,
              onDateTimeChanged: (DateTime newDateTime) {
                setState(() {
                  _selectedTime = newDateTime;
                  timeController.text = DateFormat.Hm().format(newDateTime);
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
        title: Text("Nuovo promemoria",
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
                  height: 16,
                ),
                buildEventTitle(),
                SizedBox(height: 24),
                buildEventSubtitle(),
                SizedBox(height: 24),
                Row(
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
                          DateFormat.yMMMd('it_IT').format(_selectedDate),
                          style: TextStyle(
                            fontSize: 16,
                            color: Theme.of(context).colorScheme.secondary,
                            overflow: TextOverflow.ellipsis
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.all(16),
                        ),
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          Future.delayed(Duration(milliseconds: 300), () {
                            showTimePickerDialog(context);
                          });
                        },
                        icon: Icon(
                          Icons.access_time,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                        label: Text(
                          DateFormat.Hm().format(_selectedTime),
                          style: TextStyle(
                            fontSize: 16,
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.all(16),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 48),
                FilledButton(
                  onPressed: () {
                    Future.delayed(Duration(milliseconds: 300), () {
                      createEvent(context);
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.all(16),
                    width: screenWidth * 0.3,
                    child: Center(
                      child: Text(
                        'Aggiungi',
                        style: TextStyle(fontSize: 16),
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

  Widget buildEventTitle() {
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
            width: 1,
            color: Theme.of(context).colorScheme.secondary,
          ),
          borderRadius: BorderRadius.all(Radius.circular(30)),
        ),
        labelText: 'Scegli un titolo',
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
            width: 1,
            color: Theme.of(context).colorScheme.secondary,
          ),
          borderRadius: BorderRadius.all(Radius.circular(30)),
        ),
        labelText: 'Ulteriori dettagli',
      ),
    );
  }
}
