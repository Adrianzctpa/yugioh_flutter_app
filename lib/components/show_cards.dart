import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yugioh_flutter_app/providers/cards_provider.dart';

class ShowCards extends StatelessWidget {
  const ShowCards({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cards = Provider.of<Cards>(context).cards;
    return ListView.builder(
      itemCount: cards.length,
      itemBuilder: (context, index) {
        return Card(
          child: ListTile(
            title: Text(cards[index].cardName),
            subtitle: Text(cards[index].description),
          ),
        );
      },
    );
  }
}