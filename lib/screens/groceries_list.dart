import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:grocery_list/data/categories.dart';
import 'package:http/http.dart' as http;

import 'package:grocery_list/models/grocery_item.dart';
import 'package:grocery_list/screens/new_item.dart';
import 'package:grocery_list/widgets/list_item.dart';

class GroceriesListScreen extends StatefulWidget {
  const GroceriesListScreen({super.key});

  @override
  State<GroceriesListScreen> createState() => _GroceriesListScreenState();
}

class _GroceriesListScreenState extends State<GroceriesListScreen> {
  List<GroceryItem> _groceryItems = [];

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  void _loadItems() async {
    final url = Uri.https(dotenv.env['FIREBASE_URI']!, 'shopping-list.json');
    final response = await http.get(url);
    final Map<String, dynamic> listData = json.decode(response.body);

    final List<GroceryItem> loadedItems = [];
    for (final item in listData.entries) {
      loadedItems.add(
        GroceryItem(
          id: item.key,
          name: item.value['name'],
          quantity: item.value['quantity'],
          category: (categories.entries
              .firstWhere((cat) => cat.value.title == item.value['category'])
              .value),
        ),
      );
    }

    setState(() {
      _groceryItems = loadedItems;
    });
  }

  void _addImem() async {
    await Navigator.of(context).push<GroceryItem>(
      MaterialPageRoute(
        builder: (ctx) => const NewItemScreen(),
      ),
    );

    _loadItems();
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
