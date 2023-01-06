import 'dart:typed_data';

class Deck {
  final int id;
  final String name;
  final Uint8List cards;

  Deck({required this.id, required this.name, required this.cards});

  factory Deck.fromJson(Map<String, dynamic> json) {
    final cards = List<int>.from(json['cards']);
    final cardsUint8 = Uint8List.fromList(cards);

    return Deck(
      id: json['id'],
      name: json['name'],
      cards: cardsUint8,
    );
  }
}