import 'package:flutter/material.dart';
import 'package:grocery_list/models/grocery_item.dart';

class ListItem extends StatelessWidget {
  const ListItem(this.item, {super.key});

  final GroceryItem item;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(Icons.square, color: item.category.color),
              const SizedBox(width: 15),
              Text(item.name),
            ],
          ),
          Text(item.quantity.toString()),
        ],
      ),
    );
  }
}
