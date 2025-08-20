import 'package:Brick2Life/Screens/shopping/shopping_list.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../Managers/data_manager.dart';
import 'new_shopping.dart';

class ShoppingScreen extends StatefulWidget {
  @override
  State<ShoppingScreen> createState() => _ShoppingScreenState();
}

class _ShoppingScreenState extends State<ShoppingScreen> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        toolbarHeight: 80,
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        title: Row(
          children: [
            SizedBox(
              width: 4,
            ),
            Text("Spesa", style: TextStyle(fontSize: 28)),
          ],
        ),
        actions: [
          PopupMenuButton<String>(
            icon: Icon(Icons.more_vert,
            color: Theme.of(context).colorScheme.primary,),
            iconSize: 28,
            offset: Offset(0, 50),
            onSelected: (value) {
              Future.delayed(Duration(milliseconds: 300), () {
                if (value == 'deleteBought') {
                  _confirmDeleteBoughtItems();
                } else if (value == 'deleteAll') {
                  _confirmDeleteAllItems();
                }
              });
            },
            itemBuilder: (context) => [
              PopupMenuItem<String>(
                value: 'deleteBought',
                child: Text(
                  'Elimina oggetti comprati',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ),
              PopupMenuItem<String>(
                value: 'deleteAll',
                child: Text(
                  'Elimina tutta la lista',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ),
            ],
            color: Theme.of(context).colorScheme.surface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          SizedBox(width: 8,)
        ],
      ),
      body: ShoppingList(),
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(11),
        child: FloatingActionButton(
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Theme.of(context).colorScheme.onPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50.0),
          ),
          heroTag: 'new_shopping_item',
          child: Icon(Icons.add),
          onPressed: () {
            showModalBottomSheet(
              isScrollControlled: true,
              backgroundColor: Theme.of(context).colorScheme.background,
              showDragHandle: true,
              context: context,
              builder: (context) {
                return Container(
                  height: screenHeight * 0.8,
                  child: NewShopping(),
                );
              },
            );
          },
        ),
      ),
    );
  }

  Future<void> _confirmDeleteBoughtItems() async {
    bool? confirm = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Conferma eliminazione"),
          content:
              Text("Sei sicuro di voler eliminare tutti gli oggetti comprati?"),
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
      final manager = Provider.of<DataManager>(context, listen: false);
      Future.delayed(Duration(milliseconds: 300), () {
        manager.removeCompletedShoppingItems();
        FocusScope.of(context).unfocus();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Oggetti comprati eliminati")),
        );
      });
    }
  }

  Future<void> _confirmDeleteAllItems() async {
    bool? confirm = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Conferma eliminazione"),
          content:
              Text("Sei sicuro di voler eliminare tutta la lista della spesa?"),
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
      final manager = Provider.of<DataManager>(context, listen: false);
      Future.delayed(Duration(milliseconds: 300), () {
        manager.clearAllShoppingLists();
        FocusScope.of(context).unfocus();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Lista della spesa eliminata")),
        );
      });
    }
  }
}
