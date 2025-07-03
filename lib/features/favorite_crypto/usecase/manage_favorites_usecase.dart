import '../../../data/crypto_list/entities/crypto_entity.dart';

class ManageFavoritesUseCase {
  List<CryptoEntity> filterFavorites(
      List<CryptoEntity> allCryptos,
      List<String> favoriteIds,
      ) {
    return allCryptos
        .where((crypto) => favoriteIds.contains(crypto.id))
        .map((crypto) => crypto.copyWith(isFavorite: true))
        .toList();
  }

  CryptoEntity toggleFavorite(CryptoEntity crypto) {
    return crypto.copyWith(isFavorite: !crypto.isFavorite);
  }
}