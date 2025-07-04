import '../../entities/crypto_detail_entity.dart';
import '../../models/crypto_detail_model.dart';
import '../crypto_detail_repository.dart';
import '../../datasources/crypto_detail_remote_datasource.dart';

class CryptoDetailRepositoryImpl implements CryptoDetailRepository {
  final CryptoDetailRemoteDataSource _remoteDataSource;

  CryptoDetailRepositoryImpl({required CryptoDetailRemoteDataSource remoteDataSource})
      : _remoteDataSource = remoteDataSource;


  @override
  Future<CryptoDetailEntity> getCryptoDetail(String cryptoId) async {
    try {
      final CryptoDetailModel cryptoDetailModel = await _remoteDataSource.getCryptoDetail(cryptoId);

      final List<List<double>> priceChart = await _remoteDataSource.getCryptoChart(cryptoId, 7);

      return cryptoDetailModel.toEntity(priceChart);
    } catch (e) {
      throw Exception('Erro ao buscar detalhes: $e');
    }
  }
}