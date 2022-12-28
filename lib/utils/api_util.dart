import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class APIUtil {
  static const String _baseUrl = 'http://192.168.1.3:4000';
  
  Future<http.Response> fetchCards({int? page, int? qSize, String? url}) async {
    return url != null ? http.get(Uri.parse('$_baseUrl$url')) : http.get(Uri.parse('$_baseUrl/cards/?page=$page&query_size=$qSize'));
  }

  String generateFilterString(Map<String, TextEditingController> map) {
    String url = '/cards/filter/?page=1&query_size=20&';
    map.forEach((key, value) {
      if (value.text.isNotEmpty) {
        url += '$key=${value.text}&';
      }
    });
    return url;
  }
}