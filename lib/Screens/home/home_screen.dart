import 'package:Brick2Life/Screens/home/shared_house_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../Constructors/cleaning_item.dart';
import '../../Constructors/event_item.dart';
import '../../Managers/data_manager.dart';
import '../cleaning/cleaning_screen.dart';
import 'new_event.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  CalendarFormat _calendarFormat = CalendarFormat.week;
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();

  @override
  void initState() {
    super.initState();
    _checkUserStatus();
  }

  void _checkUserStatus() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final manager = Provider.of<DataManager>(context, listen: false);
      final isOnline = manager
              .getAccountByUsername(manager.loginAccount!.username)
              ?.isOnline ??
          false;

      if (!isOnline) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Modalità vacanza attiva'),
              content: Text(
                  'Alcune funzionalità potrebbero non essere disponibili. \n\nPer disattivare la modalità vacanza vai su: Impostazioni > Modalità vacanza.'),
              actions: [
                TextButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }
    });
  }

  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Consumer<DataManager>(builder: (context, manager, child) {
      final username = manager.loginAccount?.username ?? '';

      final cleanings = manager
          .getCleaningForAccountByUsername(username)
          .where((cleaning) => !cleaning.isDone);

      List<CleaningItem> getCleaningsForDay(DateTime day) {
        return cleanings
            .where((cleaning) =>
                cleaning.expiration.year == day.year &&
                cleaning.expiration.month == day.month &&
                cleaning.expiration.day == day.day)
            .toList();
      }

      List<EventItem> getEventsForDay(DateTime day) {
        return manager
            .getEventsForAccountByUsername(username)
            .where((event) =>
                event.expiration.year == day.year &&
                event.expiration.month == day.month &&
                event.expiration.day == day.day)
            .toList();
      }

      final selectedDayCleanings = getCleaningsForDay(_selectedDay);
      final selectedDayEvents = getEventsForDay(_selectedDay)
        ..sort((a, b) => a.userChosenTime.compareTo(b.userChosenTime));

      return Scaffold(
        appBar: AppBar(
          scrolledUnderElevation: 0,
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          toolbarHeight: 80,
          title: Row(
            children: [
              Container(
                width: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Theme.of(context).colorScheme.primary,
                    width: 2,
                  ),
                ),
                child: ClipOval(
                  child: Image.asset(
                    manager.loginAccount!.imgProfile,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              SizedBox(width: 16),
              Text(manager.loginAccount!.name, style: TextStyle(fontSize: 28)),
            ],
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: IconButton(
                  onPressed: () {
                    Future.delayed(Duration(milliseconds: 300), () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => SharedHouseScreen(),
                        ),
                      );
                    });
                  },
                  icon: Icon(Icons.other_houses,
                  color: Theme.of(context).colorScheme.primary,)),
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
                padding: EdgeInsets.only(bottom: 16),
                child: TableCalendar(
                  availableCalendarFormats: const {
                    CalendarFormat.month: 'Comprimi',
                    CalendarFormat.week: 'Espandi',
                  },
                  daysOfWeekHeight: 24,
                  daysOfWeekStyle: DaysOfWeekStyle(
                    weekdayStyle: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                    weekendStyle: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  startingDayOfWeek: StartingDayOfWeek.monday,
                  locale: 'it_IT',
                  firstDay: DateTime.utc(2020, 1, 1),
                  lastDay: DateTime.utc(2030, 12, 31),
                  focusedDay: _focusedDay,
                  selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                  onDaySelected: (selectedDay, focusedDay) {
                    setState(() {
                      _selectedDay = selectedDay;
                      _focusedDay = focusedDay;
                    });
                  },
                  eventLoader: (day) => getEventsForDay(day),
                  calendarFormat: _calendarFormat,
                  onFormatChanged: (format) {
                    setState(() {
                      _calendarFormat = format;
                    });
                  },
                  pageJumpingEnabled: true,
                  calendarStyle: CalendarStyle(
                    markersMaxCount: 1,
                    todayDecoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.secondary,
                      shape: BoxShape.circle,
                    ),
                    selectedDecoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      shape: BoxShape.circle,
                    ),
                    todayTextStyle: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                    selectedTextStyle: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                    defaultTextStyle: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                    weekendTextStyle: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  headerStyle: HeaderStyle(
                    leftChevronVisible: false,
                    rightChevronVisible: false,
                    formatButtonShowsNext: false,
                    formatButtonDecoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                      border: Border.all(
                        color: Theme.of(context).colorScheme.primary,
                        width: 1,
                      ),
                    ),
                    formatButtonTextStyle: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    headerMargin: EdgeInsets.only(bottom: 8),
                    headerPadding: EdgeInsets.fromLTRB(16, 0, 16, 16),
                    titleTextStyle: TextStyle(fontSize: 24),
                  ),
                  calendarBuilders: CalendarBuilders(
                    markerBuilder: (context, date, events) {
                      if (events.isNotEmpty) {
                        return Positioned(
                          right: 6,
                          top: -2,
                          child: Container(
                            padding: EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Theme.of(context).colorScheme.error
                            ),
                            child: Text(
                              '${events.length}',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        );
                      }
                      return SizedBox();
                    },
                    defaultBuilder: (context, date, _) {
                      final events = getEventsForDay(date);
                      final hasEvents = events.isNotEmpty;

                      return Container(
                        margin: const EdgeInsets.all(6.0),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: hasEvents
                              ? Border.all(
                            color: Theme.of(context).colorScheme.primary,
                            width: 2.0,
                          )
                              : null,
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          '${date.day}',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurface,
                            fontWeight: hasEvents ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                      );
                    },
                  ),
                ),


              ),
              Expanded(
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.fromLTRB(24, 24, 24, 0),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(30),
                      topLeft: Radius.circular(30),
                    ),
                  ),
                  child: ListView(
                    children: [
                      selectedDayCleanings.isEmpty
                          ? Container()
                          : Padding(
                              padding: const EdgeInsets.fromLTRB(0, 8, 0, 24),
                              child: FilledButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Theme.of(context)
                                      .colorScheme
                                      .primaryContainer,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        30),
                                  ),
                                  padding: EdgeInsets.all(
                                      16),
                                ),
                                onPressed: () {
                                  Future.delayed(Duration(milliseconds: 300),
                                      () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => CleaningScreen(
                                          selectedDate: DateTime.now(),
                                        ),
                                      ),
                                    );
                                  });
                                },
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Row(
                                        children: [
                                          SizedBox(width: 8),
                                          Icon(
                                            Icons.cleaning_services,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onPrimaryContainer,
                                          ),
                                          SizedBox(width: 16),
                                          Text(
                                            "Pulizie in programma",
                                            overflow: TextOverflow.ellipsis,
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleLarge,
                                          ),
                                        ],
                                      ),
                                    ),
                                    Icon(
                                      Icons.arrow_forward,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimaryContainer,
                                    ),
                                  ],
                                ),
                              ),
                            ),

                      selectedDayEvents.isEmpty
                          ? Column(
                              children: [
                                Container(
                                  width: screenWidth * 0.7,
                                  child: Padding(
                                    padding: EdgeInsets.all(
                                        selectedDayCleanings.isEmpty ? 24 : 0),
                                    child: Image.asset(
                                      "assets/fonts/frame7.png",
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),
                                Text(
                                  "Non ci sono ancora promemoria, \ncreane uno cliccando sul +",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 16),
                                ),
                              ],
                            )
                          :
                          Text("Promemoria", style: TextStyle(fontSize: 28)),
                      SizedBox(height: 8),
                      selectedDayEvents.isEmpty
                          ? Container()
                          : Container(
                              width: double.infinity,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: selectedDayEvents.map((event) {
                                    return ListTile(
                                      contentPadding: EdgeInsets.all(0),
                                      leading: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(DateFormat.Hm()
                                              .format(event.userChosenTime)),
                                          SizedBox(width: 16),
                                          Container(
                                            width: 48,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primaryContainer,
                                            ),
                                            child: Center(
                                              child: Icon(
                                                Icons.event_note,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .onSurface,
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                      title: Text(
                                        event.title,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            fontWeight: FontWeight.w700),
                                      ),
                                      subtitle: event.subtitle != null &&
                                              event.subtitle!.isNotEmpty
                                          ? Text(event.subtitle!,
                                              overflow: TextOverflow.ellipsis)
                                          : null,
                                      trailing: IconButton(
                                        padding: EdgeInsets.all(0),
                                        icon: Container(
                                          padding: EdgeInsets.all(4),
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary,
                                              width: 1.5,
                                            ),
                                          ),
                                          child: Icon(
                                            Icons.check,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                          ),
                                        ),
                                        onPressed: () {
                                          final removedEvent = event;

                                          setState(() {
                                            Future.delayed(
                                                Duration(milliseconds: 300),
                                                () {
                                              manager
                                                  .removeEventForAccountByUsername(
                                                      username,
                                                      removedEvent.id);
                                            });
                                          });

                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content:
                                                  Text('Evento completato'),
                                              action: SnackBarAction(
                                                label: 'Annulla',
                                                onPressed: () {
                                                  setState(() {
                                                    manager
                                                        .addEventForAccountByUsername(
                                                            username,
                                                            removedEvent);
                                                  });
                                                },
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: Padding(
          padding: const EdgeInsets.all(11),
          child: FloatingActionButton(
            backgroundColor: Theme.of(context).colorScheme.primary,
            foregroundColor: Theme.of(context).colorScheme.onPrimary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50.0),
            ),
            heroTag: 'new_event_item',
            onPressed: () {
              showModalBottomSheet(
                isScrollControlled: true,
                backgroundColor: Theme.of(context).colorScheme.surface,
                showDragHandle: true,
                context: context,
                builder: (context) {
                  return Container(
                    height: screenHeight * 0.8,
                    child: NewEvent(),
                  );
                },
              );
            },
            child: Icon(Icons.add),
          ),
        ),
      );
    });
  }
}
