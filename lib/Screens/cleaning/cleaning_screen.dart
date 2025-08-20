import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'cleaning_list.dart';
import 'new_cleaning.dart';

class CleaningScreen extends StatefulWidget {
  final DateTime? selectedDate;

  CleaningScreen({this.selectedDate});

  @override
  State<CleaningScreen> createState() => _CleaningScreenState();
}

class _CleaningScreenState extends State<CleaningScreen> {
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        toolbarHeight: 80,
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                SizedBox(width: 4),
                Text(
                    widget.selectedDate == null ? "Pulizie" : "Pulizie di oggi",
                    style: TextStyle(fontSize: 28)),
              ],
            ),
            Container(
              padding: EdgeInsets.only(right: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "Oggi",
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 14),
                  ),
                  Text(
                    DateFormat('dd/MM/yyyy')
                        .format(widget.selectedDate ?? DateTime.now()),
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 14),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
      body: CleaningList(selectedDate: widget.selectedDate),
      floatingActionButton: widget.selectedDate == null
          ? Padding(
              padding: const EdgeInsets.all(11),
              child: FloatingActionButton(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Theme.of(context).colorScheme.onPrimary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50.0),
                ),
                heroTag: 'new_cleaning',
                child: Icon(Icons.add),
                onPressed: () {
                  showModalBottomSheet(
                    isScrollControlled: true,
                    backgroundColor: Theme.of(context).colorScheme.surface,
                    showDragHandle: true,
                    context: context,
                    builder: (context) {
                      return Container(
                        height: screenHeight * 0.8,
                        child: NewCleaning(),
                      );
                    },
                  );
                },
              ),
            )
          : null,
    );
  }
}
