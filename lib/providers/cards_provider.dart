import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:yugioh_flutter_app/models/ygo_card.dart';
import 'package:http/http.dart' as http;

class Cards with ChangeNotifier {
  static const String _baseUrl = 'http://192.168.1.3:4000';
  List<YgoCard> _cards = [];

  Future<http.Response> fetchCards({int? page, int? qSize, String? url}) async {
    return url != null ? http.get(Uri.parse(url)) : http.get(Uri.parse('$_baseUrl/cards/?page=$page&query_size=$qSize'));
  }

  Future<void> loadCards({int? page, int? qSize, String? url}) async {
    page =  page ?? 1;
    qSize = qSize ?? 20;
    
    final cards = url != null ? await fetchCards(url: url) : await fetchCards(page: page, qSize: qSize);
    final Map<String, dynamic> response =  jsonDecode(cards.body);
    _cards = [];

    for (final card in response['data']['cards']) {
      _cards.add(YgoCard.fromJson(card));
    }

    notifyListeners();
  }

  List<YgoCard> get cards {
    return [..._cards];
  }

  void addCard(YgoCard card) {
    _cards.add(card);
    notifyListeners();
  }
}