import 'package:flutter/foundation.dart';

class CourseProvider extends ChangeNotifier {
  final Set<String> favorites = <String>{};

  bool isFavorite(String code) {
    return favorites.contains(code);
  }

  int get favoriteCount => favorites.length;

  void toggleFavorite(String code) {
    if (favorites.contains(code)) {
      favorites.remove(code);
    } else {
      favorites.add(code);
    }

    notifyListeners();
  }
}
