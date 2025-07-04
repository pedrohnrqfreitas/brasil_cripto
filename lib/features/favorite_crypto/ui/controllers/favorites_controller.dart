import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../../../../data/crypto_list/entities/crypto_entity.dart';

class FavoritesController extends ChangeNotifier {
  static const String _favoritesKey = 'favorites_cryptos';
  final SharedPreferences _prefs;

  List<String> _favoriteIds = [];
  List<CryptoEntity> _favorites = [];
  bool _isLoading = false;
  bool _isInitialized = false;

  FavoritesController({required SharedPreferences prefs}) : _prefs = prefs {
    _loadFavorites();
  }

  List<String> get favoriteIds => List.unmodifiable(_favoriteIds);
  List<CryptoEntity> get favorites => List.unmodifiable(_favorites);
  bool get isLoading => _isLoading;
  int get favoritesCount => _favorites.length;
  bool get isInitialized => _isInitialized;

  bool isFavorite(String cryptoId) {
    return _favoriteIds.contains(cryptoId);
  }

  Future<void> toggleFavorite(CryptoEntity crypto) async {
    _isLoading = true;
    notifyListeners();

    try {
      if (isFavorite(crypto.id)) {
        await removeFavorite(crypto.id);
      } else {
        await addFavorite(crypto);
      }
    } catch (e) {
      debugPrint('Erro ao atualizar favoritos: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addFavorite(CryptoEntity crypto) async {
    if (!_favoriteIds.contains(crypto.id)) {
      _favoriteIds.add(crypto.id);
      _favorites.add(crypto.copyWith(isFavorite: true));

      _favorites.sort((a, b) => a.name.compareTo(b.name));

      await _saveFavorites();
      notifyListeners();
    }
  }

  Future<void> removeFavorite(String cryptoId) async {
    _favoriteIds.remove(cryptoId);
    _favorites.removeWhere((crypto) => crypto.id == cryptoId);
    await _saveFavorites();
    notifyListeners();
  }

  Future<void> clearAllFavorites() async {
    _isLoading = true;
    notifyListeners();

    try {
      _favoriteIds.clear();
      _favorites.clear();
      await _saveFavorites();
    } catch (e) {
      debugPrint('Erro ao limpar favoritos: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void updateFavoritesList(List<CryptoEntity> allCryptos) {
    if (_favoriteIds.isEmpty || !_isInitialized) return;

    debugPrint('Atualizando lista de favoritos com ${allCryptos.length} criptomoedas');

    final updatedFavorites = <CryptoEntity>[];

    for (final cryptoId in _favoriteIds) {
      try {
        final crypto = allCryptos.firstWhere(
              (c) => c.id == cryptoId,
          orElse: () {
            return _favorites.firstWhere(
                  (f) => f.id == cryptoId,
              orElse: () => CryptoEntity(
                id: cryptoId,
                symbol: '',
                name: 'Crypto Removida',
                image: '',
                currentPrice: 0,
                priceChangePercentage24h: 0,
                marketCap: 0,
                totalVolume: 0,
                sparklineIn7d: const [],
              ),
            );
          },
        );

        if (crypto.name != 'Crypto Removida') {
          updatedFavorites.add(crypto.copyWith(isFavorite: true));
        }
      } catch (e) {
        debugPrint('Erro ao processar favorito $cryptoId: $e');
      }
    }

    _favorites = updatedFavorites;
    _favorites.sort((a, b) => a.name.compareTo(b.name));

    debugPrint('Lista de favoritos atualizada: ${_favorites.length} itens');
    notifyListeners();
  }

  Future<void> loadFavorites() async {
    await _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    try {
      final String? favoritesJson = _prefs.getString(_favoritesKey);
      if (favoritesJson != null && favoritesJson.isNotEmpty) {
        final List<dynamic> decoded = json.decode(favoritesJson);
        _favoriteIds = List<String>.from(decoded);
        debugPrint('Favoritos carregados: ${_favoriteIds.length} itens');
      }
    } catch (e) {
      debugPrint('Erro ao carregar favoritos: $e');
      _favoriteIds = [];
    } finally {
      _isInitialized = true;
    }
  }

  Future<void> _saveFavorites() async {
    try {
      await _prefs.setString(_favoritesKey, json.encode(_favoriteIds));
      debugPrint('Favoritos salvos: ${_favoriteIds.length} itens');
    } catch (e) {
      debugPrint('Erro ao salvar favoritos: $e');
    }
  }

  CryptoEntity? getFavoriteById(String cryptoId) {
    try {
      return _favorites.firstWhere((crypto) => crypto.id == cryptoId);
    } catch (e) {
      return null;
    }
  }

  @override
  void dispose() {
    _favorites.clear();
    _favoriteIds.clear();
    super.dispose();
  }
}