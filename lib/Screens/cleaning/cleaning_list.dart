import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../Constructors/cleaning_item.dart';
import '../../Managers/data_manager.dart';

class CleaningList extends StatefulWidget {
  final DateTime? selectedDate;

  CleaningList({this.selectedDate});

  @override
  State<CleaningList> createState() => _CleaningListState();
}

class _CleaningListState extends State<CleaningList> {
  List<String> filters = ['Da completare', 'Completate'];
  String selectedFilter = 'Da completare';
  Map<String, bool> expandedItems = {};
  TextEditingController searchController = TextEditingController();
  String searchQuery = '';
  String selectedSortOption = 'older';

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Consumer<DataManager>(
      builder: (context, manager, child) {
        List<CleaningItem> cleanings = _getFilteredAndSortedCleanings(manager);

        return Container(
          color: Theme.of(context).colorScheme.primaryContainer,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildSearchAndFilterSection(),
              Expanded(
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.fromLTRB(24, 32, 24, 0),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(30),
                      topLeft: Radius.circular(30),
                    ),
                  ),
                  child: cleanings.isEmpty
                      ? SingleChildScrollView(
                          child: Column(
                            children: [
                              Container(
                                width: screenWidth * 0.7,
                                child: Padding(
                                  padding: EdgeInsets.all(24),
                                  child: Image.asset(
                                    "assets/fonts/frame6.png",
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                              Text(
                                "Nessuna pulizia in programma, \ncreane una cliccando sul +",
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                        )
                      : _buildCleaningList(cleanings),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSearchAndFilterSection() {
    return Container(
      color: Theme.of(context).colorScheme.primaryContainer,
      padding: EdgeInsets.fromLTRB(16, 0, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            controller: searchController,
            decoration: InputDecoration(
              fillColor: Theme.of(context).colorScheme.surface,
              filled: true,
              hintText: 'Cerca pulizie...',
              prefixIcon: Icon(Icons.search),
              contentPadding: EdgeInsets.symmetric(vertical: 8.0),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide.none,
              ),
            ),
            onChanged: (value) {
              setState(() {
                searchQuery = value;
              });
            },
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Wrap(
                  spacing: 8.0,
                  children: filters.map((filter) {
                    return ChoiceChip(
                      showCheckmark: false,
                      label: Text(
                        filter,
                        style: TextStyle(fontSize: 12),
                      ),
                      selected: selectedFilter == filter,
                      onSelected: (selected) {
                        setState(() {
                          selectedFilter = filter;
                        });
                      },
                      backgroundColor:
                          Theme.of(context).colorScheme.primaryContainer,
                      selectedColor: Theme.of(context).colorScheme.primary,
                      labelStyle: TextStyle(
                        color: selectedFilter == filter
                            ? Theme.of(context).colorScheme.onPrimary
                            : Theme.of(context).colorScheme.onPrimaryContainer,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      side: BorderSide(
                        color: Theme.of(context).colorScheme.primary,
                        width: 1,
                      ),
                    );
                  }).toList(),
                ),
              ),
              PopupMenuButton<String>(
                icon: Icon(
                  Icons.sort,
                  color: Theme.of(context).colorScheme.primary,
                ),
                offset: Offset(0, 50),
                onSelected: (value) {
                  setState(() {
                    selectedSortOption = value;
                  });
                },
                itemBuilder: (context) => [
                  PopupMenuItem<String>(
                    enabled: false,
                    child: Text(
                      'Ordina per:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  ),
                  PopupMenuItem<String>(
                    value: 'older',
                    child: Row(
                      mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Più vecchi',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                        if (selectedSortOption == 'older')
                          Icon(Icons.check,
                              color: Theme.of(context).colorScheme.primary),
                      ],
                    ),
                  ),
                  PopupMenuItem<String>(
                    value: 'younger',
                    child: Row(
                      mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Più recenti',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                        if (selectedSortOption == 'younger')
                          Icon(Icons.check,
                              color: Theme.of(context).colorScheme.primary),

                      ],
                    ),
                  ),
                ],
                color: Theme.of(context).colorScheme.surface,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
        ],
      ),
    );
  }

  List<CleaningItem> _getFilteredAndSortedCleanings(DataManager manager) {
    List<CleaningItem> cleanings =
        manager.getCleaningForAccountByUsername(manager.loginAccount!.username);

    if (widget.selectedDate != null) {
      cleanings = cleanings
          .where((cleaning) =>
              cleaning.expiration.year == widget.selectedDate!.year &&
              cleaning.expiration.month == widget.selectedDate!.month &&
              cleaning.expiration.day == widget.selectedDate!.day)
          .toList();
    }

    if (selectedFilter == 'Completate') {
      cleanings = cleanings.where((cleaning) => cleaning.isDone).toList();
    } else {
      cleanings = cleanings.where((cleaning) => !cleaning.isDone).toList();
    }

    if (searchQuery.isNotEmpty) {
      cleanings = cleanings
          .where((cleaning) =>
              cleaning.title.toLowerCase().contains(searchQuery.toLowerCase()))
          .toList();
    }

    cleanings.sort((a, b) {
      final compare = a.expiration.compareTo(b.expiration);
      return selectedSortOption == 'older' ? compare : -compare;
    });

    return cleanings;
  }

  Widget _buildCleaningList(List<CleaningItem> cleanings) {
    return Consumer<DataManager>(builder: (context, manager, child) {
      return ListView.separated(
        itemBuilder: (context, index) {
          CleaningItem item = cleanings[index];
          bool isExpanded = expandedItems[item.id] ?? false;

          return ExpansionTile(
            childrenPadding: EdgeInsets.fromLTRB(8, 0, 8, 8),
            collapsedBackgroundColor:
                Theme.of(context).colorScheme.primaryContainer,
            backgroundColor: Theme.of(context).colorScheme.primaryContainer,
            collapsedShape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            key: Key(item.id),
            title: Row(
              children: [
                SizedBox(
                  width: 8,
                ),
                Expanded(
                  child: Text(
                    item.title,
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ],
            ),
            initiallyExpanded: isExpanded,
            onExpansionChanged: (bool expanded) {
              setState(() {
                expandedItems[item.id] = expanded;
              });
            },
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(16, 8, 8, 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (item.expiration.isBefore(
                                DateTime.now().subtract(Duration(days: 1))) &&
                            !item.isDone)
                          Text(
                            "Pulizia scaduta",
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.error,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        if (item.subtitle?.isNotEmpty == true)
                          Text("Note: ${item.subtitle}"),
                        Text(
                            "Scadenza: ${DateFormat('dd/MM/yyyy').format(item.expiration)}"),
                        if (item.isDone)
                          Text(
                              "Completata il: ${DateFormat('dd/MM/yyyy').format(item.completeDate)}"),
                        if (item.participants
                            .where((participant) =>
                                participant != manager.loginAccount!.username)
                            .isNotEmpty)
                          Text(
                            "Insieme a: ${item.participants.where((participant) => participant != manager.loginAccount!.username).join(', ')}",
                          ),
                      ],
                    ),
                    if (!item.isDone)
                      Row(
                        children: [
                          IconButton(
                              padding: EdgeInsets.all(0),
                              icon: Container(
                                padding: EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Theme.of(context).colorScheme.error,
                                    width: 1.5,
                                  ),
                                ),
                                child: Icon(
                                  Icons.delete,
                                  color: Theme.of(context).colorScheme.error,
                                ),
                              ),
                              onPressed: () {
                                setState(() {
                                  Future.delayed(
                                    Duration(milliseconds: 300),
                                    () {
                                      _confirmDeleteCleaning(manager, item);
                                    },
                                  );
                                });
                              }),
                          SizedBox(width: 4),
                          IconButton(
                              padding: EdgeInsets.all(0),
                              icon: Container(
                                padding: EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    width: 1.5,
                                  ),
                                ),
                                child: Icon(
                                  Icons.check,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                              onPressed: () {
                                setState(() {
                                  Future.delayed(
                                    Duration(milliseconds: 300),
                                    () {
                                      _completeCleaning(manager, item);
                                    },
                                  );
                                });
                              })
                        ],
                      ),
                  ],
                ),
              ),
            ],
          );
        },
        separatorBuilder: (context, index) {
          return SizedBox(height: 24);
        },
        itemCount: cleanings.length,
      );
    });
  }

  void _completeCleaning(DataManager manager, CleaningItem item) {
    setState(() {
      manager.toggleCleaningItemCompleteById(item.id);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Pulizia completata"),
        action: SnackBarAction(
          label: 'Annulla',
          onPressed: () {
            setState(() {
              manager.toggleCleaningItemCompleteById(item.id);
            });
          },
        ),
      ),
    );
  }

  Future<void> _confirmDeleteCleaning(
      DataManager manager, CleaningItem item) async {
    bool? confirm = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Conferma eliminazione"),
          content: Text("Sei sicuro di voler eliminare questa pulizia?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text("Annulla"),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text("Elimina"),
            ),
          ],
        );
      },
    );

    if (confirm == true) {
      setState(() {
        manager.removeCleaningForAccountByUsername(
            manager.loginAccount!.username, item.id);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Pulizia eliminata")),
      );
    }
  }
}
