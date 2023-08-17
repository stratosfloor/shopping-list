import 'package:flutter/material.dart';
import 'package:grocery_list/models/grocery_item.dart';

class ListItem extends StatelessWidget {
  const ListItem(this.item, {super.key});

  final GroceryItem item;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(item.name),
      leading: Icon(Icons.square, color: item.category.color),
      trailing: Text(item.quantity.toString()),
    );
  }
}
