import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../../../core/constants/api_constants.dart';
import '../../../core/services/http_service.dart';
import '../../../data/crypto_list/datasource/implementation/crypto_list_remote_datasource_impl.dart';
import '../../../data/crypto_list/repositories/implementation/crypto_list_repository_impl.dart';
import '../../favorite_crypto/ui/controllers/favorites_controller.dart';
import '../ui/controller/crypto_list_controller.dart';
import '../usecase/get_cryptos_usecase.dart';
import '../usecase/search_cryptos_usecase.dart';

class CryptoListDependency {
  static Future<List<SingleChildWidget>> init() async {

    final httpService = DioHttpService(baseUrl: ApiConstants.baseUrl);

    final cryptoListRemoteDataSource = CryptoListRemoteDataSourceImpl(
      httpService: httpService,
    );

    final cryptoListRepository = CryptoListRepositoryImpl(
      remoteDataSource: cryptoListRemoteDataSource,
    );

    final getCryptosUseCase = GetCryptosUseCase(
      repository: cryptoListRepository,
    );

    final searchCryptosUseCase = SearchCryptosUseCase();

    return [
      ChangeNotifierProxyProvider<FavoritesController, CryptoListController>(
        create: (context) {
          final controller = CryptoListController(
            getCryptosUseCase: getCryptosUseCase,
            searchCryptosUseCase: searchCryptosUseCase,
          );
          return controller;
        },
        update: (context, favoritesController, cryptoListController) {
          cryptoListController?.setOnCryptosLoadedCallback((cryptos) {
            favoritesController.updateFavoritesList(cryptos);
          });
          return cryptoListController!;
        },
      ),
    ];
  }
}