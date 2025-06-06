import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class FavoritesLocalDataSource {
  final SharedPreferences sharedPreferences;
  static const String _favoritesKey = 'favorites_key';

  FavoritesLocalDataSource({required this.sharedPreferences});

  Future<List<String>> getFavorites() async {
    final favorites = sharedPreferences.getStringList(_favoritesKey);
    return favorites ?? [];
  }

  Future<void> toggleFavorite(String coinId) async {
    final favorites = await getFavorites();
    if (favorites.contains(coinId)) {
      favorites.remove(coinId);
    } else {
      favorites.add(coinId);
    }
    await sharedPreferences.setStringList(_favoritesKey, favorites);
  }

  Future<bool> isFavorite(String coinId) async {
    final favorites = await getFavorites();
    return favorites.contains(coinId);
  }
} 