import 'package:flutter/material.dart';

import 'package:yugioh_flutter_app/models/deck.dart';
import 'package:yugioh_flutter_app/utils/db_util.dart';


class Decks with ChangeNotifier {
  final List<Deck> _decks = [];
  bool _beenLoaded = false;

  bool get beenLoaded => _beenLoaded;

  static const int limit = 60;
  static const int min = 40;

  List<Deck> get decks => _decks;

  Future<void> loadDecks() async {
    final decks = await DBUtil().getDeckData();
    for (int i = 0; i < decks.length; i++) {
      final deck = Deck.fromJson(decks[i]);
      _decks.add(deck);
    }

    _beenLoaded = true;
    notifyListeners();
  }

  void addDeck(String name) {
    final now = DateTime.now();
    final id = now.microsecondsSinceEpoch;
    final deck = Deck(name: name, id: id, cards: null);

    if (deck.cards != null) {
      if (deck.cards!.length > limit) {
        throw Exception("Deck is too big");
      }

      if (deck.cards!.length < min) {
        throw Exception("Deck is too small");
      }
    }
    
    DBUtil().insertDeck(deck);
    _decks.add(deck);

    notifyListeners();
  }

  Future<void> updateDeck(Deck deck) async {
    await DBUtil().updateDeck(deck);

    final index = _decks.indexWhere((element) => element.id == deck.id);
    _decks[index] = deck;

    notifyListeners();
  }

  void removeDeck(Deck deck) {
    DBUtil().deleteDeck(deck.id);

    _decks.remove(deck);
    notifyListeners();
  }
}