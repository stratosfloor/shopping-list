import 'package:flutter/material.dart';
import 'package:grocery_list/data/dummy_items.dart';
import 'package:grocery_list/widgets/list_item.dart';

class GroceriesListScreen extends StatelessWidget {
  const GroceriesListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your groceries'),
      ),
      body: ListView(
        children: [...groceryItems.map((item) => ListItem(item))],
      ),
    );
  }
}
