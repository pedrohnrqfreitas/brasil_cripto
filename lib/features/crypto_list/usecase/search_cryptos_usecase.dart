import '../../../data/crypto_list/entities/crypto_entity.dart';

class SearchCryptosUseCase {
  List<CryptoEntity> execute(List<CryptoEntity> cryptos, String query) {
    final lowercaseQuery = query.toLowerCase();

    return cryptos.where((crypto) {
      return crypto.name.toLowerCase().contains(lowercaseQuery) ||
          crypto.symbol.toLowerCase().contains(lowercaseQuery);
    }).toList();
  }
}