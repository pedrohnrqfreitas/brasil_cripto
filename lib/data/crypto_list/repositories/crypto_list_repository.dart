import '../entities/crypto_entity.dart';

abstract class CryptoListRepository {
  Future<List<CryptoEntity>> getCryptos({int page = 1});
}
