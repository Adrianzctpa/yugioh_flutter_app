import 'package:flutter/material.dart';
import 'package:yugioh_flutter_app/components/deck_edit.dart';
import 'package:yugioh_flutter_app/models/deck.dart';
import 'package:yugioh_flutter_app/models/ygo_card.dart';

class CardsPreview extends StatefulWidget {
  final Deck deck;
  final List<YgoCard> cards;

  const CardsPreview({Key? key, required this.deck, required this.cards}) : super(key: key);

  @override
  State<CardsPreview> createState() => _CardsPreviewState();
}

class _CardsPreviewState extends State<CardsPreview> {

  List<Map<String, dynamic>> _showCardsAsTxt(List<YgoCard> cards) {
    Map<String, int> cardMap = {};

    for (final c in cards) {
      if (cardMap.containsKey(c.cardName)) {
        cardMap[c.cardName] = cardMap[c.cardName]! + 1;
      } else {
        cardMap[c.cardName] = 1;
      }
    }

    List<Map<String, dynamic>> cardWidgets = [];

    cardMap.forEach((key, value) {
      cardWidgets.add({'card': cards.firstWhere((element) => element.cardName == key), 'text': '$key: ${value}x'});
    });

    return cardWidgets;
  }

  @override
  Widget build(BuildContext context) {
    final texts = _showCardsAsTxt(widget.cards);
    return Column(
      children: [
        if (widget.cards.isNotEmpty || widget.deck.cards != null) 
          Text('Cards in deck: ${widget.cards.length}')
        else 
          const Text('Cards in deck: 0'),
        SingleChildScrollView(
          child: SizedBox(
            height: 400, 
            child: DeckEdit(
              deck: widget.deck, texts: texts
            )
          )
        )
      ]
    );
  }
}