import 'package:flutter/material.dart';
import '../services/storage_service.dart';

class StorageProvider extends ChangeNotifier {
  final StorageService _storageService = StorageService();

  List<String> favorites = [];
  List<String> vaultFiles = [];

  Future<void> loadFavorites() async {
    favorites = await _storageService.getFavorites();
    notifyListeners();
  }

  Future<void> addFavorite(String path) async {
    await _storageService.addFavorite(path);
    await loadFavorites();
  }

  Future<void> removeFavorite(String path) async {
    await _storageService.removeFavorite(path);
    await loadFavorites();
  }

  Future<void> loadVault() async {
    vaultFiles = await _storageService.getVaultFiles();
    notifyListeners();
  }

  Future<void> addToVault(String path) async {
    await _storageService.addToVault(path);
    await loadVault();
  }

  Future<void> removeFromVault(String path) async {
    await _storageService.removeFromVault(path);
    await loadVault();
  }
}