// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/providers/cart.dart';

class CartItem extends StatelessWidget {
  final String? id;
  final String productId;
  final double price;
  final int? quantity;
  final String? title;

  CartItem(
      {this.id,
      required this.productId,
      required this.price,
      this.quantity,
      this.title});
  @override
  Widget build(BuildContext context) {
    return Dismissible(
      direction: DismissDirection.endToStart,
      key: ValueKey(id),
      background: Container(
        child: Icon(
          Icons.delete,
          color: Colors.white,
          size: 40,
        ),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20),
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
        color: Theme.of(context).errorColor,
      ),
      confirmDismiss: (direction) {
        return showDialog(
            context: context,
            builder: (ctx) {
              return AlertDialog(
                title: Text('Are You Sure?'),
                content: Text('Do You Want To Remove This Item From The Cart?'),
                actions: [
                  FlatButton(
                    onPressed: () {
                      Navigator.of(ctx).pop(false);
                    },
                    child: Text('No'),
                  ),
                  FlatButton(
                    onPressed: () {
                      Navigator.of(ctx).pop(true);
                    },
                    child: Text('Yes'),
                  ),
                ],
              );
            });
      },
      onDismissed: (direction) {
        Provider.of<Cart>(context, listen: false).removeItem(productId);
      },
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
        child: Padding(
          padding: EdgeInsets.all(8),
          child: ListTile(
            leading: CircleAvatar(
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: FittedBox(child: Text('\$$price')),
              ),
            ),
            title: Text(title!),
            subtitle: Text('Total : \$${price * quantity!}'),
            trailing: Text('${quantity} x'),
          ),
        ),
      ),
    );
  }
}
