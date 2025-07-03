import '../../../../core/constants/api_constants.dart';
import '../../../../core/services/http_service.dart';
import '../../models/crypto_model.dart';
import '../crypt_list_remote_datasource.dart';

class CryptoListRemoteDataSourceImpl implements CryptoListRemoteDataSource {
  final HttpService _httpService;

  CryptoListRemoteDataSourceImpl({required HttpService httpService})
      : _httpService = httpService;

  @override
  Future<List<CryptoModel>> getCryptos({int page = 1}) async {
    try {
      final response = await _httpService.get(
        ApiConstants.coinsList,
        queryParameters: {
          'vs_currency': ApiConstants.vsCurrency,
          'order': ApiConstants.order,
          'per_page': ApiConstants.perPage,
          'page': page,
          'sparkline': ApiConstants.sparkline,
          'price_change_percentage': ApiConstants.priceChangePercentage,
        },
      );

      if (response.data is List) {
        return (response.data as List)
            .map((json) => CryptoModel.fromJson(json))
            .toList();
      }
      throw Exception('Formato de resposta inválido');
    } catch (e) {
      throw Exception('Erro ao buscar criptomoedas: $e');
    }
  }

}