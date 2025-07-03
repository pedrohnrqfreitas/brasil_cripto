import '../../entities/crypto_detail_entity.dart';
import '../../models/crypto_detail_model.dart';
import '../crypto_detail_repository.dart';
import '../../datasources/crypto_detail_remote_datasource.dart';

/// Implementação concreta do repositório de criptomoedas
///
/// Esta classe é responsável por:
/// - Coordenar as chamadas aos data sources
/// - Converter models (data layer) para entities (domain layer)
/// - Tratar erros e exceções
///
/// Por que usar Repository Pattern?
/// - Abstrai a fonte de dados da camada de domínio
/// - Facilita testes (pode mockar o repository)
/// - Permite trocar a fonte de dados sem afetar o domínio
class CryptoDetailRepositoryImpl implements CryptoDetailRepository {
  final CryptoDetailRemoteDataSource _remoteDataSource;

  CryptoDetailRepositoryImpl({required CryptoDetailRemoteDataSource remoteDataSource})
      : _remoteDataSource = remoteDataSource;


  @override
  Future<CryptoDetailEntity> getCryptoDetail(String cryptoId) async {
    try {
      // 1. Busca detalhes básicos da crypto
      final CryptoDetailModel cryptoDetailModel = await _remoteDataSource.getCryptoDetail(cryptoId);

      // 2. Busca dados do gráfico (últimos 7 dias)
      final List<List<double>> priceChart = await _remoteDataSource.getCryptoChart(cryptoId, 7);

      // 3. Combina os dados e converte para Entity
      return cryptoDetailModel.toEntity(priceChart);
    } catch (e) {
      throw Exception('Erro ao buscar detalhes: $e');
    }
  }
}