import 'dart:convert';

import 'package:yugioh_flutter_app/models/ygo_card.dart';

class Deck {
  final int id;
  final String name;
  List<YgoCard>? cards;

  Deck({required this.id, required this.name, this.cards});

  factory Deck.fromJson(Map<String, dynamic> json) {
    final cards = json['cards'] != null ? List<YgoCard>.from(jsonDecode(json['cards']).map((x) => YgoCard.fromJson(x))) : null;
    return Deck(
      id: json['id'],
      name: json['name'],
      cards: cards,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'cards': cards != null ? List<dynamic>.from(cards!.map((x) => x.toJson())) : null,
    };
  }
}