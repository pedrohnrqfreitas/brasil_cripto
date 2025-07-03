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

class _CryptoListPageState extends State<CryptoListPage> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CryptoListController>().loadCryptos();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onScroll() {
    FocusScope.of(context).unfocus();
    if (_isLoadingMore) return;

    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;

    if (currentScroll >= maxScroll * 0.8) {
      _loadMore();
    }
  }

  Future<void> _loadMore() async {
    if (_isLoadingMore) return;
    setState(() => _isLoadingMore = true);
    await context.read<CryptoListController>().loadMoreCryptos();
    setState(() => _isLoadingMore = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.divider,
      body: SafeArea(
        child: Column(
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
            Padding(
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
                        decoration: const InputDecoration(
                          hintText: 'Pesquisar criptomoedas...',
                          border: InputBorder.none,
                        ),
                        onChanged: (value) {
                          context.read<CryptoListController>().searchCryptos(value);
                        },
                        textInputAction: TextInputAction.done,
                        onSubmitted: (_) => FocusScope.of(context).unfocus(),
                      ),
                    ),
                    if (_searchController.text.isNotEmpty)
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
            const SizedBox(height: 16),
            Expanded(
              child: Consumer2<CryptoListController, FavoritesController>(
                builder: (context, cryptoController, favoritesController, child) {
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
                        child: CustomScrollView(
                          controller: _scrollController,
                          physics: const BouncingScrollPhysics(),
                          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                          cacheExtent: 500,
                          slivers: [
                            SliverList(
                              delegate: SliverChildBuilderDelegate(
                                    (context, index) {
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
                                childCount: cryptoController.cryptos.length,
                              ),
                            ),
                            if (_isLoadingMore)
                              const SliverToBoxAdapter(
                                child: Padding(
                                  padding: EdgeInsets.all(20),
                                  child: Center(
                                    child: CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}