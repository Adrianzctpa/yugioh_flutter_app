import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yugioh_flutter_app/components/deck_edit.dart';
import 'package:yugioh_flutter_app/models/deck.dart';
import 'package:yugioh_flutter_app/models/ygo_card.dart';
import 'package:yugioh_flutter_app/providers/decks_provider.dart';

class DeckForm extends StatefulWidget {
  const DeckForm({required this.text, this.deck, Key? key}) : super(key: key);
  final String text;
  final Deck? deck;

  @override
  State<DeckForm> createState() => _DeckFormState();
}

class _DeckFormState extends State<DeckForm> {
  final TextEditingController _deckNameController = TextEditingController();

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
    final prov = Provider.of<Decks>(context, listen: true);
    final text = widget.text;
    Deck? deck = widget.deck;

    final List<Map<String, dynamic>> texts = deck != null ? _showCardsAsTxt(deck.cards!) : [];

    return SingleChildScrollView(
      child: Column(
        children: [
           Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Deck Name',
                ),
                controller: _deckNameController,
              ),
            ),
            if (deck != null)
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed('/cards', arguments: deck);
                      }, 
                      child: const Text('Add cards')
                    ),
                  ),
                  SingleChildScrollView(
                    child: SizedBox(
                      height: 400, 
                      child: DeckEdit(
                        deck: deck, texts: texts
                      )
                    )
                  )
                ],
              ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () {
                  if (deck != null) {
                    final provDeck = Deck(id: deck.id, name: _deckNameController.text, cards: deck.cards); 
                    prov.updateDeck(provDeck);
                  } else {
                    prov.addDeck(_deckNameController.text);
                  }
                  Navigator.of(context).pop();
                }, 
                child: Text(text)
              ),
            ),
        ]
      ),
    );
  }
}