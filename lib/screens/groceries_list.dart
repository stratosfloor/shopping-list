import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:grocery_list/data/categories.dart';
import 'package:grocery_list/widgets/center_text.dart';
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
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  void _loadItems() async {
    final url = Uri.https(dotenv.env['FIREBASE_URI']!, 'shopping-list.json');
    final response = await http.get(url);

    if (response.statusCode >= 400) {
      setState(() {
        _error = 'Failed to fetch data.';
      });
    }

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
      _isLoading = false;
    });
  }

  void _addItem() async {
    final newItem = await Navigator.of(context).push<GroceryItem>(
      MaterialPageRoute(
        builder: (ctx) => const NewItemScreen(),
      ),
    );

    if (newItem == null) {
      return;
    }

    setState(() {
      _groceryItems.add(newItem);
    });
  }

  void _removeItem(GroceryItem item) {
    setState(() {
      _groceryItems.remove(item);
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget content = _isLoading
        ? const Center(child: CircularProgressIndicator())
        : _groceryItems.isEmpty
            ? const CenterText(text: 'No items in list', fontSize: 26)
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

    if (_error != null) {
      content = CenterText(text: _error!, fontSize: 26);
    }

    return Scaffold(
        appBar: AppBar(
          title: const Text('Your groceries'),
          actions: [
            IconButton(
              onPressed: _addItem,
              icon: const Icon(Icons.add),
            )
          ],
        ),
        body: content);
  }
}
