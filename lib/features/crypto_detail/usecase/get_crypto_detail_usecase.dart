import '../../../data/crypto_detail/entities/crypto_detail_entity.dart';
import '../../../data/crypto_detail/repositories/crypto_detail_repository.dart';

class GetCryptoDetailUseCase {
  final CryptoDetailRepository _repository;

  GetCryptoDetailUseCase({required CryptoDetailRepository repository})
      : _repository = repository;

  Future<CryptoDetailEntity> execute(String cryptoId) async {
    return await _repository.getCryptoDetail(cryptoId);
  }
}