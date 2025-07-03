
import '../models/crypto_detail_model.dart';

abstract class CryptoDetailRemoteDataSource {
  Future<CryptoDetailModel> getCryptoDetail(String cryptoId);
  Future<List<List<double>>> getCryptoChart(String cryptoId, int days);
}

