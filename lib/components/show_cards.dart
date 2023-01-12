import 'dart:io';

import 'package:flutter/material.dart';
import 'package:yugioh_flutter_app/models/deck.dart';
import 'package:yugioh_flutter_app/models/ygo_card.dart';

class ShowCards extends StatelessWidget {
  const ShowCards({required this.cards, this.deck, Key? key}) : super(key: key);
  final Deck? deck;
  final List<YgoCard> cards;

  @override
  Widget build(BuildContext context) {  
    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      children: [
        for (var card in cards)
          GestureDetector(
            onTap: () => Navigator.of(context).pushNamed('/details', arguments: {"card": card, "deck": deck}),
            child: Image.file(File(card.imageUrlSmall[0]))
          )
      ],
    );
  }
}