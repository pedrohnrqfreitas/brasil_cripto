import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/formatters/currency_formatter.dart';
import '../../../../data/crypto_list/entities/crypto_entity.dart';
import '../../../crypto_detail/ui/page/crypto_detail_page.dart';

class CryptoListItemWidget extends StatelessWidget {
  final CryptoEntity crypto;
  final VoidCallback onFavoriteToggle;

  const CryptoListItemWidget({
    super.key,
    required this.crypto,
    required this.onFavoriteToggle,
  });

  @override
  Widget build(BuildContext context) {
    final isPositive = crypto.priceChangePercentage24h >= 0;

    return RepaintBoundary(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () => _navigateToDetail(context),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    _buildCryptoIcon(),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildCryptoName(),
                          const SizedBox(height: 8),
                          _buildPriceInfo(isPositive),
                        ],
                      ),
                    ),
                    _buildFavoriteButton(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCryptoIcon() {
    return Hero(
      tag: 'crypto-image-${crypto.id}',
      child: Container(
        width: 48,
        height: 48,
        decoration: const BoxDecoration(
          color: AppColors.inputBackground,
          shape: BoxShape.circle,
        ),
        child: ClipOval(
          child: CachedNetworkImage(
            imageUrl: crypto.image,
            width: 48,
            height: 48,
            fit: BoxFit.cover,
            memCacheHeight: 96,
            memCacheWidth: 96,
            maxHeightDiskCache: 96,
            maxWidthDiskCache: 96,
            fadeInDuration: const Duration(milliseconds: 200),
            placeholder: (context, url) => Container(
              color: AppColors.inputBackground,
              child: const Center(
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                  ),
                ),
              ),
            ),
            errorWidget: (context, url, error) => Container(
              color: AppColors.inputBackground,
              child: const Icon(
                Icons.currency_bitcoin_rounded,
                color: AppColors.textSecondary,
                size: 24,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCryptoName() {
    return Row(
      children: [
        Flexible(
          child: Text(
            crypto.name,
            style: AppTextStyles.heading3,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: AppColors.inputBackground,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            crypto.symbol.toUpperCase(),
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPriceInfo(bool isPositive) {
    return Row(
      children: [
        Text(
          CurrencyFormatter.formatBRL(crypto.currentPrice),
          style: AppTextStyles.body.copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(width: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: isPositive
                ? AppColors.priceUp.withAlpha(10)
                : AppColors.priceDown.withAlpha(10),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isPositive
                    ? Icons.trending_up_rounded
                    : Icons.trending_down_rounded,
                size: 14,
                color: isPositive ? AppColors.priceUp : AppColors.priceDown,
              ),
              const SizedBox(width: 4),
              Text(
                '${crypto.priceChangePercentage24h.abs().toStringAsFixed(2)}%',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: isPositive ? AppColors.priceUp : AppColors.priceDown,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFavoriteButton() {
    return IconButton(
      icon: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: Icon(
          crypto.isFavorite ? Icons.star_rounded : Icons.star_outline_rounded,
          key: ValueKey(crypto.isFavorite),
          color: crypto.isFavorite ? AppColors.primary : AppColors.textTertiary,
          size: 24,
        ),
      ),
      onPressed: onFavoriteToggle,
      splashRadius: 20,
    );
  }

  void _navigateToDetail(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CryptoDetailPage(crypto: crypto),
      ),
    );
  }
}