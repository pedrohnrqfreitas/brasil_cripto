// lib/presentation/widgets/simple_search_bar_widget.dart
import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';


class CryptoSearchBarWidget extends StatelessWidget {
  final Function(String) onSearch;
  final String? hintText;
  final TextEditingController controller;

  const CryptoSearchBarWidget({
    super.key,
    required this.onSearch,
    required this.controller,
    this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: AppColors.inputBackground,
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        controller: controller,
        onChanged: onSearch,
        decoration: InputDecoration(
          hintText: hintText ?? 'Pesquisar...',
          hintStyle: const TextStyle(
            color: AppColors.textTertiary,
            fontSize: 16,
          ),
          prefixIcon: const Icon(
            Icons.search,
            color: AppColors.textSecondary,
          ),
          suffixIcon: controller.text.isNotEmpty
              ? IconButton(
            icon: const Icon(
              Icons.clear,
              color: AppColors.textSecondary,
              size: 20,
            ),
            onPressed: () {
              controller.clear();
              onSearch('');
            },
          )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
        ),
        textInputAction: TextInputAction.done,
        onSubmitted: (_) => FocusScope.of(context).unfocus(),
      ),
    );
  }
}