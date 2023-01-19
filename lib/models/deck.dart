import 'dart:convert';

import 'package:yugioh_flutter_app/models/ygo_card.dart';

class Deck {
  final int id;
  final String name;
  List<YgoCard>? cards;
  List<YgoCard>? eDeck;
  List<YgoCard>? sDeck;

  Deck({required this.id, required this.name, this.cards, this.eDeck, this.sDeck});

  factory Deck.fromJson(Map<String, dynamic> json) {
    final newJson = {};

    for (var entry in json.entries) {
      final key = entry.key;
      final value = entry.value;

      if (value == 'null') {
        newJson[key] = null;
      } else {
        newJson[key] = value;
      }
    }

    final cards = newJson['cards'] != null ? List<YgoCard>.from(jsonDecode(newJson['cards']).map((x) => YgoCard.fromJson(x))) : null;
    final eDeck = newJson['eDeck'] != null ? List<YgoCard>.from(jsonDecode(newJson['eDeck']).map((x) => YgoCard.fromJson(x))) : null;
    final side = newJson['sDeck'] != null ? List<YgoCard>.from(jsonDecode(newJson['sDeck']).map((x) => YgoCard.fromJson(x))) : null;

    return Deck(
      id: newJson['id'],
      name: newJson['name'],
      cards: cards,
      eDeck: eDeck,
      sDeck: side,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'cards': cards != null ? List<dynamic>.from(cards!.map((x) => x.toJson())) : null,
      'eDeck': eDeck != null ? List<dynamic>.from(eDeck!.map((x) => x.toJson())) : null,
      'sDeck': sDeck != null ? List<dynamic>.from(sDeck!.map((x) => x.toJson())) : null,
    };
  }
}