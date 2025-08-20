import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Constructors/shopping_item.dart';
import '../../Managers/data_manager.dart';

class ShoppingList extends StatefulWidget {
  @override
  State<ShoppingList> createState() => _ShoppingListState();
}

class _ShoppingListState extends State<ShoppingList> {
  List<String> filters = ['Lista personale', 'Lista casa'];
  String selectedFilter = 'Lista personale';
  String sortingOption = 'recents';
  TextEditingController searchController = TextEditingController();
  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery
        .of(context)
        .size
        .width;

    return Scaffold(
      body: Consumer<DataManager>(
        builder: (context, manager, child) {
          List<ShoppingItem> shoppings;

          if (selectedFilter == 'Lista casa') {
            shoppings = manager.getShoppingForHouse();
          } else {
            shoppings = manager.getShoppingForAccountByUsername(
                manager.loginAccount!.username);
          }

          if (searchQuery.isNotEmpty) {
            shoppings = shoppings.where((item) {
              return item.title
                  .toLowerCase()
                  .contains(searchQuery.toLowerCase());
            }).toList();
          }

          List<ShoppingItem> toBuyItems =
          shoppings.where((item) => !item.isComplete).toList();
          List<ShoppingItem> boughtItems =
          shoppings.where((item) => item.isComplete).toList();

          if (sortingOption == 'AZ') {
            toBuyItems.sort((a, b) =>
                a.title.toLowerCase().compareTo(b.title.toLowerCase()));
          }

          List<ShoppingItem> allItems = [...toBuyItems, ...boughtItems];

          int personalListCount = manager
              .getShoppingForAccountByUsername(manager.loginAccount!.username)
              .length;
          int homeListCount = manager
              .getShoppingForHouse()
              .length;

          return Container(
            color: Theme
                .of(context)
                .colorScheme
                .primaryContainer,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  color: Theme
                      .of(context)
                      .colorScheme
                      .primaryContainer,
                  padding: EdgeInsets.fromLTRB(16, 0, 16, 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextField(
                        controller: searchController,
                        decoration: InputDecoration(
                          fillColor: Theme
                              .of(context)
                              .colorScheme
                              .surface,
                          filled: true,
                          hintText: 'Cerca prodotti...',
                          prefixIcon: Icon(Icons.search),
                          contentPadding: EdgeInsets.symmetric(vertical: 8.0),
                          border: OutlineInputBorder(
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
                          Wrap(
                            spacing: 16.0,
                            children: filters.map((filter) {
                              int count = filter == 'Lista personale'
                                  ? personalListCount
                                  : homeListCount;
                              return Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  ChoiceChip(
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
                                    backgroundColor: Theme
                                        .of(context)
                                        .colorScheme
                                        .primaryContainer,
                                    selectedColor:
                                    Theme
                                        .of(context)
                                        .colorScheme
                                        .primary,
                                    labelStyle: TextStyle(
                                      color: selectedFilter == filter
                                          ? Theme
                                          .of(context)
                                          .colorScheme
                                          .onPrimary
                                          : Theme
                                          .of(context)
                                          .colorScheme
                                          .onPrimaryContainer,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    side: BorderSide(
                                      color:
                                      Theme
                                          .of(context)
                                          .colorScheme
                                          .primary,
                                      width: 1,
                                    ),
                                  ),
                                  Positioned(
                                    right: -8,
                                    top: -8,
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color:
                                        Theme
                                            .of(context)
                                            .colorScheme
                                            .error,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Center(
                                        child: Text(
                                          '$count',
                                          style: TextStyle(
                                            color: Theme
                                                .of(context)
                                                .colorScheme
                                                .onError,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            }).toList(),
                          ),
                          PopupMenuButton<String>(
                            icon: Icon(Icons.sort,
                            color: Theme.of(context).colorScheme.primary,),
                            offset: Offset(0, 50),
                            onSelected: (value) {
                              setState(() {
                                sortingOption = value;
                              });
                            },
                            itemBuilder: (context) =>
                            [
                              PopupMenuItem<String>(
                                enabled: false,
                                child: Text(
                                  'Ordina per:',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color:
                                    Theme
                                        .of(context)
                                        .colorScheme
                                        .onSurface,
                                  ),
                                ),
                              ),
                              PopupMenuItem<String>(
                                value: 'recents',
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Più recenti',
                                      style: TextStyle(
                                        color: Theme
                                            .of(context)
                                            .colorScheme
                                            .onSurface,
                                      ),
                                    ),
                                    if (sortingOption == 'recents')
                                      Icon(
                                        Icons.check,
                                        color: Theme
                                            .of(context)
                                            .colorScheme
                                            .primary,
                                      ),
                                  ],
                                ),
                              ),
                              PopupMenuItem<String>(
                                value: 'AZ',
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Ordine alfabetico',
                                      style: TextStyle(
                                        color: Theme
                                            .of(context)
                                            .colorScheme
                                            .onSurface,
                                      ),
                                    ),
                                    if (sortingOption == 'AZ')
                                      Icon(
                                        Icons.check,
                                        color: Theme
                                            .of(context)
                                            .colorScheme
                                            .primary,
                                      ),
                                  ],
                                ),
                              ),
                            ],
                            color: Theme
                                .of(context)
                                .colorScheme
                                .surface,
                            shape: RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius.circular(8),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.fromLTRB(24, 16, 24, 0),
                    decoration: BoxDecoration(
                      color: Theme
                          .of(context)
                          .colorScheme
                          .surface,
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(30),
                          topLeft: Radius.circular(30)),
                    ),
                    child: allItems.isEmpty
                        ? SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                            width: screenWidth * 0.7,
                            child: Padding(
                              padding: EdgeInsets.all(24),
                              child: Image.asset(
                                "assets/fonts/frame5.png",
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                          Text(
                            "Lista della spesa vuota, \naggiungi un prodotto cliccando sul +",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    )
                        : ListView.separated(
                      itemBuilder: (context, index) {
                        ShoppingItem item = allItems[index];
                        return Padding(
                          padding:
                          const EdgeInsets.symmetric(horizontal: 8.0),
                          child: ListTile(
                            contentPadding: EdgeInsets.all(0),
                            title: Text(
                              item.title,
                              style: TextStyle(
                                fontSize: 20,
                                color:
                                item.isComplete ? Colors.grey : null,
                                decoration: item.isComplete
                                    ? TextDecoration.lineThrough
                                    : TextDecoration.none,
                              ),
                            ),
                            trailing: IconButton(
                              padding: EdgeInsets.all(0),
                              icon: Container(
                                  padding: EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                  color: item.isComplete
                                      ? Theme.of(context)
                                      .colorScheme
                                      .error
                                      : Theme.of(context)
                                  .colorScheme
                                  .primary,
                              width: 1.5,
                            ),
                          ),
                          child: Icon(
                            item.isComplete
                                ? Icons.delete
                                : Icons.check,
                            color: item.isComplete
                                ? Theme
                                .of(context)
                                .colorScheme
                                .error
                                : Theme
                                .of(context)
                                .colorScheme
                                .primary,
                          ),
                        ),
                        onPressed: () {
                        Future.delayed(
                        Duration(milliseconds: 300), () {
                        setState(() {
                        if (item.isComplete) {
                        _confirmDeleteShopping(manager, item);
                        } else {
                        _completeShopping(manager, item);
                        }
                        });
                        });
                        },
                        ),
                        subtitle: item.isComplete
                        ? (item.subtitle?.isNotEmpty == true
                        ? Text(
                        "Note: ${item.subtitle}\nComprato da: ${item.buyer}")
                            : Text(
                        "Comprato da: ${item.buyer!.name}"))
                            : (item.subtitle?.isNotEmpty == true
                        ? Text("Note: ${item.subtitle}")
                            : null),
                        ),
                        );
                      },
                      separatorBuilder: (context, index) {
                        return Divider(
                            thickness: 1.5, color: Colors.grey[300]);
                      },
                      itemCount: allItems.length,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _completeShopping(DataManager manager, ShoppingItem item) {
    setState(() {
      manager.toggleShoppingItemCompleteById(item.id, selectedFilter);
      FocusScope.of(context).unfocus();
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Elemento comprato"),
        action: SnackBarAction(
          label: 'Annulla',
          onPressed: () {
            Future.delayed(Duration(milliseconds: 300), () {
              setState(() {
                manager.toggleShoppingItemCompleteById(item.id, selectedFilter);
                FocusScope.of(context).unfocus();
              });
            });
          },
        ),
      ),
    );
  }

  Future<void> _confirmDeleteShopping(DataManager manager,
      ShoppingItem item) async {
    bool? confirm = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Conferma eliminazione"),
          content: Text("Sei sicuro di voler eliminare questo elemento?"),
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
      Future.delayed(Duration(milliseconds: 300), () {
        setState(() {
          manager.removeShoppingItemById(item.id, selectedFilter);
          FocusScope.of(context).unfocus();
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Elemento eliminato")),
        );
      });
    }
  }
}
