import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yugioh_flutter_app/models/deck.dart';
import 'package:yugioh_flutter_app/models/ygo_card.dart';
import 'package:yugioh_flutter_app/providers/decks_provider.dart';

class DeckEdit extends StatefulWidget {
  const DeckEdit({required this.deck, required this.texts, Key? key}) : super(key: key);
  final List<Map<String, dynamic>> texts;
  final Deck deck;

  @override
  State<DeckEdit> createState() => _DeckEditState();
}

class _DeckEditState extends State<DeckEdit> {
  @override
  Widget build(BuildContext context) {
    final prov = Provider.of<Decks>(context, listen: true);
    final texts = widget.texts;
    final deck = widget.deck;
    
    return ListView.builder(
      itemBuilder: ((context, index) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed('/details', arguments: {"card": texts[index]['card'], "deck": deck});
            },
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(child: Text(texts[index]['text'])),
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () async {
                        await prov.addCardToDeck(texts[index]['card'] as YgoCard, deck);
                      }
                    ),
                    IconButton(
                      icon: const Icon(Icons.remove),
                      onPressed: () async {
                        await prov.removeCardFromDeck(texts[index]['card'] as YgoCard, deck);
                      },
                    ),
                  ]
                ),
              ),
            ),
          ),
        );
      }), 
      itemCount: texts.length, 
      shrinkWrap: true
    );
  }
}