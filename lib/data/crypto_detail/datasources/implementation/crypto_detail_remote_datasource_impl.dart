import '../../../../core/constants/api_constants.dart';
import '../../../../core/services/http_service.dart';
import '../../models/crypto_detail_model.dart';
import '../crypto_detail_remote_datasource.dart';

class CryptoDetailRemoteDataSourceImpl implements CryptoDetailRemoteDataSource {
  final HttpService _httpService;

  CryptoDetailRemoteDataSourceImpl({required HttpService httpService})
      : _httpService = httpService;

  @override
  Future<CryptoDetailModel> getCryptoDetail(String cryptoId) async {
    try {
      final response = await _httpService.get(
        '${ApiConstants.coinDetail}/$cryptoId',
        queryParameters: {
          'localization': false,
          'tickers': false,
          'market_data': true,
          'community_data': false,
          'developer_data': false,
        },
      );

      return CryptoDetailModel.fromJson(response.data);
    } catch (e) {
      throw Exception('Erro ao buscar detalhes da criptomoeda: $e');
    }
  }

  @override
  Future<List<List<double>>> getCryptoChart(String cryptoId, int days) async {
    try {
      final response = await _httpService.get(
        '${ApiConstants.coinDetail}/$cryptoId${ApiConstants.marketChart}',
        queryParameters: {
          'vs_currency': ApiConstants.vsCurrency,
          'days': days,
        },
      );

      if (response.data['prices'] is List) {
        return (response.data['prices'] as List)
            .map((price) => [
          (price[0] as num).toDouble(),
          (price[1] as num).toDouble(),
        ])
            .toList();
      }
      throw Exception('Formato de resposta inválido');
    } catch (e) {
      throw Exception('Erro ao buscar gráfico: $e');
    }
  }
}