import 'package:flutter/material.dart';

import 'package:yugioh_flutter_app/models/deck.dart';
import 'package:yugioh_flutter_app/utils/db_util.dart';


class Decks with ChangeNotifier {
  List<Deck> _decks = [];
  bool _beenLoaded = false;

  bool get beenLoaded => _beenLoaded;

  static const int limit = 60;
  static const int min = 40;

  List<Deck> get decks => _decks;

  Future<void> loadDecks() async {
    final decks = await DBUtil().getDeckData();
    for (int i = 0; i < decks.length; i++) {
      _decks.add(Deck.fromJson(decks[i]));
    }

    _beenLoaded = true;
    notifyListeners();
  }

  void addDeck(Deck deck) {
    if (deck.cards.length > limit) {
      throw Exception("Deck is too big");
    }

    if (deck.cards.length < min) {
      throw Exception("Deck is too small");
    }

    DBUtil().insertDeck(deck);
    _decks.add(deck);

    notifyListeners();
  }

  void removeDeck(Deck deck) {
    DBUtil().deleteDeck(deck.id);

    _decks.remove(deck);
    notifyListeners();
  }
}