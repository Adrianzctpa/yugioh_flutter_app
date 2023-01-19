import 'package:flutter/material.dart';
import 'package:yugioh_flutter_app/constants/card_constants.dart';

import 'package:yugioh_flutter_app/models/deck.dart';
import 'package:yugioh_flutter_app/models/ygo_card.dart';
import 'package:yugioh_flutter_app/utils/db_util.dart';


class Decks with ChangeNotifier {
  final List<Deck> _decks = [];
  bool _beenLoaded = false;

  bool get beenLoaded => _beenLoaded;

  static const int limit = 60;
  static const int min = 40;

  List<Deck> get decks => _decks;

  bool extraCheck(YgoCard card) {
    const edPatterns = Constants.extraDeckSummons;
    for (final pattern in edPatterns) {
      if (card.cardType.contains(pattern)) {
        return true;
      }
    }

    return false;
  } 

  void removeCard(YgoCard card, List<YgoCard> cards) {
    for (int i = 0; i < cards.length; i++) {
      if (cards[i].cardName == card.cardName) {
        cards.removeAt(i);
        return;
      }
    }
  }

  Future<void> removeCardFromDeck(YgoCard card, Deck deck) async {
    final trueDeck = _decks.firstWhere((element) => element.id == deck.id); 

    if (extraCheck(card)) {
      removeCard(card, trueDeck.eDeck!);
    } else {
      removeCard(card, trueDeck.cards!);
    }

    await DBUtil().updateDeck(trueDeck);
    notifyListeners();
  }

  List<YgoCard> modifyDeck(List<YgoCard>? cards, YgoCard card) {
    if (cards != null) {
      if (!checkAppearences(cards, card)) return cards;

      cards.add(card);
    } else {
      cards = [card];
    }

    return cards;
  }

  bool checkAppearences(List<YgoCard> deck, YgoCard card) {
    int appearences = 0;
      
    for (final c in deck) {
      if (c.cardName == card.cardName) {
        appearences++;
      }
    }

    if (appearences >= 3) {
      return false;
    }

    return true;
  }

  Future<void> addCardToDeck(YgoCard card, Deck deck) async {
    bool isExtra = extraCheck(card);
    
    Deck trueDeck = _decks.firstWhere((element) => element.id == deck.id); 

    if (isExtra) {
      trueDeck.eDeck = modifyDeck(trueDeck.eDeck, card);
    } else {
      trueDeck.cards = modifyDeck(trueDeck.cards, card);
    }

    await DBUtil().updateDeck(trueDeck);
    notifyListeners();
  }

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
    final deck = Deck(name: name, id: id, cards: null, eDeck: null, sDeck: null);

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