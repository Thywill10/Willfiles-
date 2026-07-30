import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const String favoritesKey = "favorites";
  static const String vaultKey = "vault";

  Future<List<String>> getFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(favoritesKey) ?? [];
  }

  Future<void> addFavorite(String path) async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = prefs.getStringList(favoritesKey) ?? [];

    if (!favorites.contains(path)) {
      favorites.add(path);
      await prefs.setStringList(favoritesKey, favorites);
    }
  }

  Future<void> removeFavorite(String path) async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = prefs.getStringList(favoritesKey) ?? [];

    favorites.remove(path);
    await prefs.setStringList(favoritesKey, favorites);
  }

  Future<List<String>> getVaultFiles() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(vaultKey) ?? [];
  }

  Future<void> addToVault(String path) async {
    final prefs = await SharedPreferences.getInstance();
    final vault = prefs.getStringList(vaultKey) ?? [];

    if (!vault.contains(path)) {
      vault.add(path);
      await prefs.setStringList(vaultKey, vault);
    }
  }

  Future<void> removeFromVault(String path) async {
    final prefs = await SharedPreferences.getInstance();
    final vault = prefs.getStringList(vaultKey) ?? [];

    vault.remove(path);
    await prefs.setStringList(vaultKey, vault);
  }
}