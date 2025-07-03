import '../entities/crypto_detail_entity.dart';

abstract class CryptoDetailRepository {
  Future<CryptoDetailEntity> getCryptoDetail(String cryptoId);
}
