import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yugioh_flutter_app/components/cards_preview.dart';
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
  List<YgoCard>? _cards = [];
  final TextEditingController _deckNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Map<String, List<YgoCard>?> cardsMap = {};
    Deck? deck = widget.deck;
    final prov = Provider.of<Decks>(context, listen: true);
    final text = widget.text;

    if (deck != null) {
      cardsMap = {
        'main': deck.cards,
        'extra': deck.eDeck,
        'side': deck.sDeck
      };
    }

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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _cards = cardsMap['main'];
                            });
                          }, 
                          child: const Text('Main Deck')
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _cards = cardsMap['extra'];
                            });
                          }, 
                          child: const Text('Extra Deck')
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _cards = cardsMap['side'];
                            });
                          }, 
                          child: const Text('Side Deck')
                        ),
                      ),
                    ],
                  ),
                  if (_cards == null)
                    const Text('Cards in deck: 0')
                  else 
                    CardsPreview(deck: deck, cards: _cards!)
                ],
              ),
            ElevatedButton(
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
        ]
      ),
    );
  }
}