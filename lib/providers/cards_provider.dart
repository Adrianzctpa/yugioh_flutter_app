import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:yugioh_flutter_app/models/card_image.dart';
import 'package:yugioh_flutter_app/models/ygo_card.dart';
import 'package:http/http.dart' as http;
import 'package:yugioh_flutter_app/utils/db_util.dart';
import 'package:yugioh_flutter_app/utils/api_util.dart';

class Cards with ChangeNotifier {
  List<YgoCard> _cards = [];

  String? _next;
  String? _prev;

  String? get next => _next;
  String? get prev => _prev;

  bool _isFetching = false;

  bool get isFetching => _isFetching;

  void setFetching(bool value) {
    _isFetching = value;
    notifyListeners();
  }

  Future<Map<String, List<String>>> addingToDB(Map<String, dynamic> json) async {
    final img = CardImage.fromJson(json);
    List<String> imageUrl = [];
    List<String> imageUrlSmall = []; 

    for (int i = 0; i < img.imageUrl.length; i++) {
      final resp = await http.get(Uri.parse(img.imageUrl[i]));
      final respSmall = await http.get(Uri.parse(img.imageUrlSmall[i]));

      Directory appDocDir = await getApplicationDocumentsDirectory();
      String pathName = i > 0 ? '${appDocDir.path}/${json['id']}_variant_$i}.png' : '${appDocDir.path}/${json['id']}.png';
      String pathNameSmall = i > 0 ? '${appDocDir.path}/${json['id']}_small_variant_$i.png' : '${appDocDir.path}/${json['id']}_small.png';

      imageUrl.add(pathName);
      imageUrlSmall.add(pathNameSmall);

      File file = File(pathName);
      File smallFile = File(pathNameSmall);

      await file.writeAsBytes(resp.bodyBytes);
      await smallFile.writeAsBytes(respSmall.bodyBytes);
    }

    await DBUtil().insertImage(CardImage(
      id: json['id'],
      imageUrl: imageUrl,
      imageUrlSmall: imageUrlSmall,
    ));

    return {
      "imageUrl": imageUrl,
      "imageUrlSmall": imageUrlSmall,
    };
  }

  Future<void> loadCards({int? page, int? qSize, String? url}) async {
    _prev = null;
    _next = null;
    
    page =  page ?? 1;
    qSize = qSize ?? 20;
    
    final cards = url != null ? await APIUtil().fetchCards(url: url) : await APIUtil().fetchCards(page: page, qSize: qSize);
    final Map<String, dynamic> response = await jsonDecode(cards.body);
    _cards = [];

    for (final card in response['data']['cards']) {  
      final check = await DBUtil().getCardImage(card['id']);

      if (check.isEmpty) {
        final json = {
          'id': card['id'],
          'image_url': card['image_url'],
          'image_url_small': card['image_url_small'],
        };

        final mapOfLists = await addingToDB(json);
        card['image_url'] = mapOfLists['imageUrl'];
        card['image_url_small'] = mapOfLists['imageUrlSmall'];
      } else {
        // Filtering to obtain a clean List of Strings
        final img = check.first['image_url'] as String;
        final imgSmall = check.first['image_url_small'] as String;

        final matches = matchStringsToList(img);
        final matchesSmall = matchStringsToList(imgSmall);
       
        card['image_url'] = matches;
        card['image_url_small'] = matchesSmall;
      }

      _cards.add(YgoCard.fromJson(card));

      notifyListeners();
    }

    _next = response["data"]["next"];
    _prev = response["data"]["prev"];

    notifyListeners();
  }

  List<YgoCard> get cards {
    return [..._cards];
  }

  List<String?> matchStringsToList(String str) {
    RegExp exp = RegExp(r"[.*\/_A-Za-z0-9]*.png");
        
    final matches = exp.allMatches(str)
      .map((e) => e.group(0))
      .toList();

    return matches;
  }
}