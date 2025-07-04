import '../../datasource/crypt_list_remote_datasource.dart';
import '../../entities/crypto_entity.dart';
import '../../models/crypto_model.dart';
import '../crypto_list_repository.dart';

class CryptoListRepositoryImpl implements CryptoListRepository {
  final CryptoListRemoteDataSource _remoteDataSource;

  CryptoListRepositoryImpl({required CryptoListRemoteDataSource remoteDataSource})
      : _remoteDataSource = remoteDataSource;

  @override
  Future<List<CryptoEntity>> getCryptos({int page = 1}) async {
    try {
      final List<CryptoModel> cryptoModels = await _remoteDataSource.getCryptos(page: page);

      return cryptoModels.map((CryptoModel model) => model.toEntity()).toList();
    } catch (e) {
      throw Exception('Erro ao buscar criptomoedas: $e');
    }
  }

}