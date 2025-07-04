import 'package:brasil_cripto/features/favorite_crypto/ui/controllers/favorites_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import '../../../../core/utils/ui/widgets/error_widget.dart';
import '../../../../core/utils/ui/widgets/loading_widget.dart';
import '../../../../data/crypto_list/entities/crypto_entity.dart';
import '../controller/crypto_detail_controller.dart';
import '../widgets/price_chart_widget.dart';

class CryptoDetailPage extends StatefulWidget {
  final CryptoEntity crypto;

  const CryptoDetailPage({
    super.key,
    required this.crypto,
  });

  @override
  State<CryptoDetailPage> createState() => _CryptoDetailPageState();
}

class _CryptoDetailPageState extends State<CryptoDetailPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CryptoDetailController>().loadCryptoDetail(widget.crypto.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final currencyFormatter = NumberFormat.currency(
      locale: 'pt_BR',
      symbol: r'R$',
      decimalDigits: 2,
    );

    final numberFormatter = NumberFormat.compact(locale: 'pt_BR');

    return Scaffold(
      body: Consumer2<CryptoDetailController, FavoritesController>(
        builder: (context, detailProvider, favoritesProvider, child) {
          final isFavorite = favoritesProvider.isFavorite(widget.crypto.id);

          return CustomScrollView(
            slivers: [
              // App Bar customizada
              SliverAppBar(
                expandedHeight: 200,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  centerTitle: true,
                  title: Text(
                    widget.crypto.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  background: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Theme.of(context).primaryColor.withAlpha(80),
                          Theme.of(context).primaryColor,
                        ],
                      ),
                    ),
                    child: Center(
                      child: Hero(
                        tag: 'crypto-image-${widget.crypto.id}',
                        child: CachedNetworkImage(
                          imageUrl: widget.crypto.image,
                          width: 80,
                          height: 80,
                          errorWidget: (context, url, error) =>
                          const Icon(Icons.error, size: 80, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ),
                actions: [
                  IconButton(
                    icon: Icon(
                      isFavorite ? Icons.star : Icons.star_border,
                      color: isFavorite ? Colors.amber : null,
                    ),
                    onPressed: () {
                      favoritesProvider.toggleFavorite(widget.crypto);
                    },
                  ),
                ],
              ),
              SliverToBoxAdapter(
                child: _buildContent(context, detailProvider, currencyFormatter, numberFormatter),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildContent(
      BuildContext context,
      CryptoDetailController provider,
      NumberFormat currencyFormatter,
      NumberFormat numberFormatter,
      ) {
    switch (provider.state) {
      case CryptoDetailState.initial:
      case CryptoDetailState.loading:
        return const SizedBox(
          height: 400,
          child: LoadingWidget(message: 'Carregando detalhes...'),
        );
      case CryptoDetailState.error:
        return SizedBox(
          height: 400,
          child: CustomErrorWidget(
            message: provider.errorMessage,
            onRetry: () {
              provider.loadCryptoDetail(widget.crypto.id);
            },
          ),
        );
      case CryptoDetailState.loaded:
        final detail = provider.cryptoDetail!;
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildPriceCard(context, detail, currencyFormatter),
              const SizedBox(height: 16),
              _buildChartSection(context, detail),
              const SizedBox(height: 16),
              _buildStatsSection(context, detail, currencyFormatter, numberFormatter),
              const SizedBox(height: 16),
              if (detail.description.isNotEmpty) ...[
                _buildDescriptionSection(context, detail),
              ],
            ],
          ),
        );
    }
  }

  Widget _buildPriceCard(
      BuildContext context,
      dynamic detail,
      NumberFormat currencyFormatter,
      ) {
    final isPositive = detail.priceChangePercentage24h >= 0;
    final changeColor = isPositive ? Colors.green : Colors.red;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              currencyFormatter.format(detail.currentPrice),
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  isPositive ? Icons.arrow_upward : Icons.arrow_downward,
                  color: changeColor,
                  size: 20,
                ),
                Text(
                  '${detail.priceChangePercentage24h.abs().toStringAsFixed(2)}%',
                  style: TextStyle(
                    color: changeColor,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  ' (24h)',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChartSection(BuildContext context, dynamic detail) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Gráfico de Preços (7 dias)',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: PriceChartWidget(
                prices: detail.priceChart,
                isPositive: detail.priceChangePercentage7d >= 0,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsSection(
      BuildContext context,
      dynamic detail,
      NumberFormat currencyFormatter,
      NumberFormat numberFormatter,
      ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Estatísticas de Mercado',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildStatRow(
              'Cap. de Mercado',
              currencyFormatter.format(detail.marketCap),
              context,
            ),
            _buildStatRow(
              'Volume (24h)',
              currencyFormatter.format(detail.totalVolume),
              context,
            ),
            _buildStatRow(
              'Máxima (24h)',
              currencyFormatter.format(detail.high24h),
              context,
            ),
            _buildStatRow(
              'Mínima (24h)',
              currencyFormatter.format(detail.low24h),
              context,
            ),
            _buildStatRow(
              'Fornecimento Circulante',
              numberFormatter.format(detail.circulatingSupply),
              context,
            ),
            if (detail.totalSupply != null)
              _buildStatRow(
                'Fornecimento Total',
                numberFormatter.format(detail.totalSupply),
                context,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatRow(String label, String value, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDescriptionSection(BuildContext context, dynamic detail) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Sobre ${detail.name}',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              detail.description,
              style: TextStyle(
                color: Colors.grey[700],
                height: 1.5,
              ),
              maxLines: 5,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}