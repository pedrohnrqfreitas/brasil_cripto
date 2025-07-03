import '../../datasource/crypt_list_remote_datasource.dart';
import '../../entities/crypto_entity.dart';
import '../../models/crypto_model.dart';
import '../crypto_list_repository.dart';



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
class CryptoListRepositoryImpl implements CryptoListRepository {
  final CryptoListRemoteDataSource _remoteDataSource;

  CryptoListRepositoryImpl({required CryptoListRemoteDataSource remoteDataSource})
      : _remoteDataSource = remoteDataSource;

  @override
  Future<List<CryptoEntity>> getCryptos({int page = 1}) async {
    try {
      // 1. Busca os dados da API (retorna List<CryptoModel>)
      final List<CryptoModel> cryptoModels = await _remoteDataSource.getCryptos(page: page);

      // 2. Converte cada Model para Entity
      // Model = representação dos dados da API
      // Entity = representação dos dados no domínio da aplicação
      return cryptoModels.map((CryptoModel model) => model.toEntity()).toList();
    } catch (e) {
      throw Exception('Erro ao buscar criptomoedas: $e');
    }
  }

}