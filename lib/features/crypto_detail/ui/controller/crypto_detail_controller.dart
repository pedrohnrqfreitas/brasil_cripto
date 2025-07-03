import 'package:flutter/foundation.dart';
import '../../../../data/crypto_detail/entities/crypto_detail_entity.dart';
import '../../usecase/get_crypto_detail_usecase.dart';

enum CryptoDetailState { initial, loading, loaded, error }

class CryptoDetailController extends ChangeNotifier {
  final GetCryptoDetailUseCase _getCryptoDetailUseCase;

  CryptoDetailController({
    required GetCryptoDetailUseCase getCryptoDetailUseCase,
  }) : _getCryptoDetailUseCase = getCryptoDetailUseCase;

  CryptoDetailEntity? _cryptoDetail;
  CryptoDetailState _state = CryptoDetailState.initial;
  String _errorMessage = '';

  CryptoDetailEntity? get cryptoDetail => _cryptoDetail;
  CryptoDetailState get state => _state;
  String get errorMessage => _errorMessage;

  Future<void> loadCryptoDetail(String cryptoId) async {
    _setState(CryptoDetailState.loading);

    try {
      final result = await _getCryptoDetailUseCase.execute(cryptoId);
      _cryptoDetail = result;
      _setState(CryptoDetailState.loaded);
    } catch (e) {
      _errorMessage = e.toString();
      _setState(CryptoDetailState.error);
    }
  }

  void _setState(CryptoDetailState newState) {
    _state = newState;
    notifyListeners();
  }
}