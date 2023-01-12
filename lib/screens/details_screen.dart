import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yugioh_flutter_app/models/deck.dart';
import 'package:yugioh_flutter_app/models/ygo_card.dart';
import 'package:yugioh_flutter_app/providers/decks_provider.dart';

class DetailsScreen extends StatefulWidget {
  const DetailsScreen({Key? key}) : super(key: key);

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {  

  List<String> _buildInfo(YgoCard card) {
    final info = <String>[];
    if (!card.cardType.contains('Monster')) return info;

    info.add(card.attribute.toString());

    if (card.cardType.contains('Link')) {
      info.add('Link Markers: ${card.linkmarkers.toString()}');
      info.add('ATK: ${card.atk.toString()}');
      info.add('Link Value: ${card.linkval.toString()}');

      return info;
    } 

    if (card.cardType.contains('XYZ')) {
      info.add('Rank: ${card.cardLevel.toString()}');
    } else {
      info.add('Level: ${card.cardLevel.toString()}');
    }

    info.add('ATK: ${card.atk.toString()}');
    info.add('DEF: ${card.def.toString()}');

    if (card.cardType.contains('Pendulum')) {
      info.add('Scale: ${card.cardScale.toString()}');
    }

    return info;
  }

  @override
  Widget build(BuildContext context) {
    final prov = Provider.of<Decks>(context, listen: false);
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final card = args['card'] as YgoCard;
    Deck? deck;

    if (args['deck'] != null) { 
      deck = args['deck'] as Deck;
    }
   
    return Scaffold(
      appBar: AppBar(
        title: Text(card.cardName),
      ),
      body: Padding(
        padding: const EdgeInsets.all(5.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Center(
                child: SizedBox(
                  height: 400,
                  child: Image.file(File(card.imageUrl[0]))
                ),
              ),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Text(card.cardName),
                      Text(card.cardType),
                      Text(card.race),
                      for (final info in _buildInfo(card)) 
                        Text(info),
                      Text(card.description),
                      if (deck != null)
                        TextButton(
                          onPressed: () async {           
                            if (deck!.cards == null) {
                              deck.cards = [card];
                            } else {
                              int appearences = 0;
                              
                              for (final c in deck.cards!) {
                                if (c.cardName == card.cardName) {
                                  appearences++;
                                }
                              }

                              if (appearences >= 3) {
                                return;
                              }
                              

                              deck.cards!.add(card);
                            }
                            await prov.updateDeck(deck);
                          },
                          child: const Text('Add to Deck')
                        )
                    ]
                  ),
                ),
              ),
            ]
          ),
        ),
      )
    );
  }
}