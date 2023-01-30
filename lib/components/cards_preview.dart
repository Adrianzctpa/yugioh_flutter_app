import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yugioh_flutter_app/components/deck_edit.dart';
import 'package:yugioh_flutter_app/models/deck.dart';
import 'package:yugioh_flutter_app/models/ygo_card.dart';
import 'package:yugioh_flutter_app/providers/decks_provider.dart';

class CardsPreview extends StatefulWidget {
  final Deck deck;
  final List<YgoCard> cards;

  const CardsPreview({Key? key, required this.deck, required this.cards}) : super(key: key);

  @override
  State<CardsPreview> createState() => _CardsPreviewState();
}

class _CardsPreviewState extends State<CardsPreview> {
  List<YgoCard> hand = [];

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

  get isMain {
    return widget.cards.isNotEmpty && widget.cards.length >= 40;
  }

  void showModal() {
    final prov = Provider.of<Decks>(context, listen: false);

    setState(() {
      hand = prov.testHand(widget.cards);
    });

    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          height: 200,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                for (final c in hand) Text(c.cardName),
                ElevatedButton(
                  child: const Text('Redo hand'),
                  onPressed: () {
                    setState(() {
                      hand = prov.testHand(widget.cards);
                    });

                    Navigator.pop(context);
                    showModal();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final texts = _showCardsAsTxt(widget.cards);
    return SingleChildScrollView(
      child: Column(
        children: [
          if (widget.cards.isNotEmpty) 
            Text('Cards in deck: ${widget.cards.length}')
          else 
            const Text('Cards in deck: 0'),
          Column(
            children: [
              if (isMain)
                ElevatedButton(
                  onPressed: () {
                    showModal();
                  },
                  child: const Text('Simulate hand')
                ),
              SingleChildScrollView(
                child: SizedBox(
                  height: 400, 
                  child: DeckEdit(
                    deck: widget.deck, texts: texts
                  )
                )
              ),
            ],
          )
        ]
      ),
    );
  }
}