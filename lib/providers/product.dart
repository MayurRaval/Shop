import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product(
      {@required this.id,
      @required this.title,
      @required this.description,
      @required this.price,
      this.isFavorite = false,
      @required this.imageUrl});

  void _setFavValue(bool oldSelection) {
    isFavorite = oldSelection;
    notifyListeners();
  }

  Future<void> toggleFavoriteStatus(String token, String userId) async {
    final oldSelection = isFavorite;
    isFavorite = !isFavorite;
    notifyListeners();
    print("userId = $userId");
    print("id =  $id");
    print("token =  $token");
    final url =
        'https://shop-flutter-a6b0d-default-rtdb.firebaseio.com/userFavorites/$userId/$id.json?auth=$token';
    try {
      final response = await http.put(url,
          body: json.encode(
            isFavorite,
          ));
      print("response = ${response.body}");
      if (response.statusCode >= 400) {
        _setFavValue(oldSelection);
      }
    } catch (error) {
      _setFavValue(oldSelection);
    }
  }
}
