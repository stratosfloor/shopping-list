import 'package:flutter/material.dart';
import 'package:grocery_list/models/grocery_item.dart';
import 'package:grocery_list/screens/new_item.dart';
import 'package:grocery_list/widgets/list_item.dart';

class GroceriesListScreen extends StatefulWidget {
  const GroceriesListScreen({super.key});

  @override
  State<GroceriesListScreen> createState() => _GroceriesListScreenState();
}

class _GroceriesListScreenState extends State<GroceriesListScreen> {
  final List<GroceryItem> _groceryItems = [];

  void _addImem() async {
    final newItem = await Navigator.of(context).push<GroceryItem>(
      MaterialPageRoute(
        builder: (ctx) => const NewItemScreen(),
      ),
    );

    if (newItem != null) {
      setState(() {
        _groceryItems.add(newItem);
      });
    }
  }

  void _removeItem(GroceryItem item) {
    setState(() {
      _groceryItems.remove(item);
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget content = _groceryItems.isEmpty
        ? const Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'No items in list',
                  style: TextStyle(fontSize: 28),
                ),
              ],
            ),
          )
        : ListView.builder(
            itemCount: _groceryItems.length,
            itemBuilder: (ctx, i) => Dismissible(
              key: ValueKey(_groceryItems[i]),
              child: ListItem(_groceryItems[i]),
              onDismissed: (direction) {
                _removeItem(_groceryItems[i]);
              },
            ),
          );

    return Scaffold(
        appBar: AppBar(
          title: const Text('Your groceries'),
          actions: [
            IconButton(
              onPressed: _addImem,
              icon: const Icon(Icons.add),
            )
          ],
        ),
        body: content);
  }
}
