import 'package:flutter/material.dart';
import 'package:yugioh_flutter_app/constants/card_constants.dart';

import 'package:yugioh_flutter_app/models/deck.dart';
import 'package:yugioh_flutter_app/models/ygo_card.dart';
import 'package:yugioh_flutter_app/utils/db_util.dart';


class Decks with ChangeNotifier {
  final List<Deck> _decks = [];
  bool _beenLoaded = false;

  bool get beenLoaded => _beenLoaded;

  static const int _limit = 60;
  static const int _min = 40;

  static const int _extraAndSideLimit = 15;
  static const int _extraAndSideMin = 0;

  List<Deck> get decks => _decks;
  int get limit => _limit;
  int get min => _min;

  int get extraAndSideLimit => _extraAndSideLimit;
  int get extraAndSideMin => _extraAndSideMin;

  List<YgoCard> testHand(List<YgoCard> cards) {
    final temp = [...cards];
    final shuffledDeck = temp..shuffle();
    final hand = <YgoCard>[];

    for (int i = 0; i < 5; i++) {
      hand.add(shuffledDeck[i]);
    }
    
    for (var element in hand) { 
      print(element.cardName);
    }

    return hand;
  }

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
      if (trueDeck.sDeck != null && trueDeck.sDeck!.contains(card)) {
        removeCard(card, trueDeck.sDeck!);
      } else {
        removeCard(card, trueDeck.cards!);
      }
    }

    await DBUtil().updateDeck(trueDeck);
    notifyListeners();
  }

  List<YgoCard> modifyDeck(List<YgoCard>? cards, YgoCard card, [bool isSide = false, int mainApps = 0]) {
    final isExtra = extraCheck(card);
    if (cards != null) {
      int sideApps = isSide ? checkAppearences(cards, card) : 0;
      int apps = isSide ? mainApps + sideApps : checkAppearences(cards, card);

      // If it is extra or side, check by limit and return
      if (isExtra && cards.length >= _extraAndSideLimit || isSide && cards.length >= _extraAndSideLimit) return cards;

      if (!isExtra && !isSide && cards.length >= _limit) return cards;

      if (apps == 3 || (apps + 1) > 3) return cards;

      cards.add(card);
    } else {
      cards = [card];
    }

    return cards;
  }

  int checkAppearences(List<YgoCard> deck, YgoCard card) {
    int appearences = 0;
      
    for (final c in deck) {
      if (c.cardName == card.cardName) {
        appearences++;
      }
    }

    if (appearences >= 3) {
      return 3;
    }

    return appearences;
  }

  Future<void> addCardToDeck(YgoCard card, Deck deck) async {
    bool isExtra = extraCheck(card);
    
    Deck trueDeck = _decks.firstWhere((element) => element.id == deck.id); 

    if (isExtra) {
      trueDeck.eDeck = modifyDeck(trueDeck.eDeck, card);
    } else {
      final isSide = trueDeck.cards!.length >= _limit && checkAppearences(trueDeck.cards!, card) < 3;
      
      if (isSide) {
        int apps = checkAppearences(trueDeck.cards!, card);
        trueDeck.sDeck = modifyDeck(trueDeck.sDeck, card, true, apps);
      } else {
        trueDeck.cards = modifyDeck(trueDeck.cards, card);
      }
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