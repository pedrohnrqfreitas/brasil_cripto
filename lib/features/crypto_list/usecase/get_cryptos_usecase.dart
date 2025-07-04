import '../../../data/crypto_list/entities/crypto_entity.dart';
import '../../../data/crypto_list/repositories/crypto_list_repository.dart';

class GetCryptosUseCase {
  final CryptoListRepository _repository;

  GetCryptosUseCase({required CryptoListRepository repository})
      : _repository = repository;

  Future<List<CryptoEntity>> execute({int page = 1}) async {
    return await _repository.getCryptos(page: page);
  }
}