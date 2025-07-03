import '../models/crypto_model.dart';

abstract class CryptoListRemoteDataSource {
  Future<List<CryptoModel>> getCryptos({int page = 1});
}