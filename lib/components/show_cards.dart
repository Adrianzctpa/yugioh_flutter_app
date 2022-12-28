import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yugioh_flutter_app/providers/cards_provider.dart';

class ShowCards extends StatelessWidget {
  const ShowCards({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cards = Provider.of<Cards>(context, listen: true).cards;
    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      children: [
        for (var card in cards)
          GestureDetector(
            onTap: () => Navigator.of(context).pushNamed('/details', arguments: card),
            child: Image.file(File(card.imageUrlSmall[0]))
          )
      ],
    );
  }
}