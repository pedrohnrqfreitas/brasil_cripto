import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import '../../../core/constants/api_constants.dart';
import '../../../core/services/http_service.dart';
import '../../../data/crypto_detail/datasources/implementation/crypto_detail_remote_datasource_impl.dart';
import '../../../data/crypto_detail/repositories/implementation/crypto_detail_repository_impl.dart';
import '../ui/controller/crypto_detail_controller.dart';
import '../usecase/get_crypto_detail_usecase.dart';


class CryptoDetailDependency {
  static Future<List<SingleChildWidget>> init() async {
    // External Dependencies

    // Core Services
    final httpService = DioHttpService(baseUrl: ApiConstants.baseUrl);

    // Data Sources
    final cryptoDetailRemoteDataSource = CryptoDetailRemoteDataSourceImpl(
      httpService: httpService,
    );

    // Repositories
    final cryptoRepository = CryptoDetailRepositoryImpl(
      remoteDataSource: cryptoDetailRemoteDataSource,
    );

    final getCryptoDetailUseCase = GetCryptoDetailUseCase(
      repository: cryptoRepository,
    );


    // Controllers (anteriormente Providers)
    return [
      ChangeNotifierProvider(
        create: (_) => CryptoDetailController(
          getCryptoDetailUseCase: getCryptoDetailUseCase,
        ),
      ),
    ];
  }
}