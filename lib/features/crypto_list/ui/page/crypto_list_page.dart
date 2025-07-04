import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/ui/widgets/empty_state_widget.dart';
import '../../../../core/utils/ui/widgets/error_widget.dart';
import '../../../../core/utils/ui/widgets/loading_widget.dart';
import '../controller/crypto_list_controller.dart';
import '../../../favorite_crypto/ui/controllers/favorites_controller.dart';
import '../widgets/crypto_list_item_widget.dart';

class CryptoListPage extends StatefulWidget {
  const CryptoListPage({super.key});

  @override
  State<CryptoListPage> createState() => _CryptoListPageState();
}

class _CryptoListPageState extends State<CryptoListPage>
    with AutomaticKeepAliveClientMixin {
  final TextEditingController _searchController = TextEditingController();

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CryptoListController>().loadCryptos();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      backgroundColor: AppColors.divider,
      body: SafeArea(
        child: Consumer2<CryptoListController, FavoritesController>(
          builder: (context, cryptoController, favoritesController, child) {
            final showSearchBar = cryptoController.state == CryptoListState.loaded ||
                cryptoController.state == CryptoListState.error;

            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: const BoxDecoration(
                          gradient: AppColors.primaryGradient,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.currency_bitcoin_rounded,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'BrasilCripto',
                            style: AppTextStyles.heading2,
                          ),
                          Text(
                            'Acompanhe o mercado crypto',
                            style: AppTextStyles.bodySmall,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  height: showSearchBar ? 66 : 0,
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 200),
                    opacity: showSearchBar ? 1.0 : 0.0,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            const SizedBox(width: 16),
                            const Icon(Icons.search, color: Colors.grey),
                            const SizedBox(width: 12),
                            Expanded(
                              child: TextField(
                                controller: _searchController,
                                enabled: showSearchBar,
                                decoration: const InputDecoration(
                                  hintText: 'Pesquisar criptomoedas...',
                                  border: InputBorder.none,
                                ),
                                onChanged: (value) {
                                  if (showSearchBar) {
                                    context.read<CryptoListController>().searchCryptos(value);
                                  }
                                },
                                textInputAction: TextInputAction.done,
                                onSubmitted: (_) => FocusScope.of(context).unfocus(),
                              ),
                            ),
                            if (_searchController.text.isNotEmpty && showSearchBar)
                              IconButton(
                                icon: const Icon(Icons.clear, size: 20),
                                onPressed: () {
                                  _searchController.clear();
                                  context.read<CryptoListController>().searchCryptos('');
                                  FocusScope.of(context).unfocus();
                                },
                              ),
                            const SizedBox(width: 8),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: _buildContent(cryptoController, favoritesController),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildContent(
      CryptoListController cryptoController,
      FavoritesController favoritesController,
      ) {
    switch (cryptoController.state) {
      case CryptoListState.initial:
      case CryptoListState.loading:
        return const LoadingWidget(
          message: 'Carregando criptomoedas...',
        );

      case CryptoListState.error:
        return CustomErrorWidget(
          message: cryptoController.errorMessage,
          onRetry: () => cryptoController.loadCryptos(),
        );

      case CryptoListState.loaded:
        if (cryptoController.cryptos.isEmpty) {
          return EmptyStateWidget(
            message: cryptoController.searchQuery.isNotEmpty
                ? 'Nenhuma criptomoeda encontrada'
                : 'Nenhuma criptomoeda disponível',
            icon: Icons.search_off_rounded,
          );
        }

        return RefreshIndicator(
          onRefresh: () => cryptoController.refresh(),
          color: AppColors.primary,
          child: ListView.builder(
            physics: const BouncingScrollPhysics(),
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            itemCount: cryptoController.cryptos.length,
            itemBuilder: (context, index) {
              final crypto = cryptoController.cryptos[index];
              return Selector<FavoritesController, bool>(
                selector: (_, controller) => controller.isFavorite(crypto.id),
                builder: (_, isFavorite, __) => CryptoListItemWidget(
                  key: ValueKey(crypto.id),
                  crypto: crypto.copyWith(isFavorite: isFavorite),
                  onFavoriteToggle: () => favoritesController.toggleFavorite(crypto),
                ),
              );
            },
          ),
        );
    }
  }
}