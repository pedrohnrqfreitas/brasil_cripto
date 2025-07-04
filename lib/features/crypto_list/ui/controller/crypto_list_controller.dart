import 'dart:async';
import 'package:flutter/foundation.dart';
import '../../../../data/crypto_list/entities/crypto_entity.dart';
import '../../usecase/get_cryptos_usecase.dart';
import '../../usecase/search_cryptos_usecase.dart';

List<CryptoEntity> _runSearch(Map<String, dynamic> params) {
  final list = params['list'] as List<CryptoEntity>;
  final query = params['query'] as String;
  return list.where((crypto) {
    return crypto.name.toLowerCase().contains(query.toLowerCase()) ||
        crypto.symbol.toLowerCase().contains(query.toLowerCase());
  }).toList();
}

enum CryptoListState { initial, loading, loaded, error }

class CryptoListController extends ChangeNotifier {
  final GetCryptosUseCase _getCryptosUseCase;
  final SearchCryptosUseCase _searchCryptosUseCase;

  Function(List<CryptoEntity>)? _onCryptosLoaded;

  DateTime? _lastFetchTime;
  static const Duration _cacheValidity = Duration(minutes: 5);

  CryptoListController({
    required GetCryptosUseCase getCryptosUseCase,
    required SearchCryptosUseCase searchCryptosUseCase,
  })  : _getCryptosUseCase = getCryptosUseCase,
        _searchCryptosUseCase = searchCryptosUseCase;

  List<CryptoEntity> _allCryptos = [];
  List<CryptoEntity> _searchResults = [];
  CryptoListState _state = CryptoListState.initial;
  String _errorMessage = '';
  String _searchQuery = '';
  bool _isRefreshing = false;

  List<CryptoEntity> get cryptos => _searchQuery.isEmpty ? _allCryptos : _searchResults;
  CryptoListState get state => _state;
  String get errorMessage => _errorMessage;
  String get searchQuery => _searchQuery;
  bool get isRefreshing => _isRefreshing;

  void setOnCryptosLoadedCallback(Function(List<CryptoEntity>) callback) {
    _onCryptosLoaded = callback;
  }

  Future<void> loadCryptos({bool isRefresh = false}) async {
    if (!isRefresh &&
        _state == CryptoListState.loaded &&
        _allCryptos.isNotEmpty &&
        _lastFetchTime != null) {

      final timeSinceLastFetch = DateTime.now().difference(_lastFetchTime!);
      if (timeSinceLastFetch < _cacheValidity) {
        debugPrint('Usando dados do cache (${timeSinceLastFetch.inSeconds}s desde última busca)');
        return;
      }
    }

    if (isRefresh) {
      _isRefreshing = true;
      notifyListeners();
    } else {
      _setState(CryptoListState.loading);
    }

    try {
      final result = await _getCryptosUseCase.execute();
      _allCryptos = result;
      _lastFetchTime = DateTime.now();

      _onCryptosLoaded?.call(_allCryptos);

      _setState(CryptoListState.loaded);

      debugPrint('Criptomoedas carregadas: ${_allCryptos.length} itens');
    } catch (e) {
      _errorMessage = _getErrorMessage(e);
      _setState(CryptoListState.error);
    } finally {
      _isRefreshing = false;
      notifyListeners();
    }
  }

  Future<void> searchCryptos(String query) async {
    _searchQuery = query;

    if (query.isEmpty) {
      _searchResults = [];
      notifyListeners();
      return;
    }

    try {
      if (kIsWeb) {
        _searchResults = _searchCryptosUseCase.execute(_allCryptos, query);
      } else {
        _searchResults = await compute(
            _runSearch,
            {'list': _allCryptos, 'query': query}
        );
      }
      notifyListeners();
    } catch (e) {
      _searchResults = [];
      notifyListeners();
    }
  }

  void clearSearch() {
    _searchQuery = '';
    _searchResults = [];
    notifyListeners();
  }

  Future<void> refresh() async {
    await loadCryptos(isRefresh: true);
  }

  String _getErrorMessage(dynamic error) {
    final errorString = error.toString();

    if (errorString.contains('SocketException')) {
      return 'Sem conexão com a internet';
    } else if (errorString.contains('TimeoutException')) {
      return 'Tempo de conexão esgotado';
    } else if (errorString.contains('FormatException')) {
      return 'Erro ao processar dados';
    } else {
      return 'Erro ao carregar criptomoedas. Tente novamente.';
    }
  }

  void _setState(CryptoListState newState) {
    _state = newState;
    notifyListeners();
  }

  @override
  void dispose() {
    _allCryptos.clear();
    _searchResults.clear();
    _onCryptosLoaded = null;
    super.dispose();
  }
}