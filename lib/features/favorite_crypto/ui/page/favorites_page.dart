import 'package:brasil_cripto/features/crypto_list/ui/widgets/crypto_list_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/ui/widgets/empty_state_widget.dart';
import '../controllers/favorites_controller.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage>
    with AutomaticKeepAliveClientMixin {

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      backgroundColor: AppColors.divider,
      appBar: AppBar(
        backgroundColor: AppColors.divider,
        title: const Text('Favoritos'),
        actions: [
          Consumer<FavoritesController>(
            builder: (context, provider, child) {
              if (provider.favorites.isEmpty) return const SizedBox();

              return IconButton(
                icon: const Icon(Icons.delete_sweep),
                tooltip: 'Limpar todos',
                onPressed: () => _showClearAllDialog(context, provider),
              );
            },
          ),
        ],
      ),
      body: Consumer<FavoritesController>(
        builder: (context, provider, child) {
          if (provider.favorites.isEmpty) {
            return EmptyStateWidget(
              icon: Icons.star_border,
              message: 'Nenhuma criptomoeda favorita ainda',
              action: Column(
                children: [
                  Text(
                    'Toque no ícone ⭐ para adicionar',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () {
                      DefaultTabController.of(context).animateTo(0);
                    },
                    icon: const Icon(Icons.arrow_back),
                    label: const Text('Explorar Criptomoedas'),
                  ),
                ],
              ),
            );
          }
          return RefreshIndicator(
            onRefresh: () async {},
            child: ListView.builder(
              padding: const EdgeInsets.only(bottom: 16),
              itemCount: provider.favorites.length,
              itemBuilder: (context, index) {
                final crypto = provider.favorites[index];
                return Dismissible(
                  key: Key(crypto.id),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20),
                    color: Colors.red,
                    child: const Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                  ),
                  confirmDismiss: (direction) async {
                    return await _showRemoveDialog(context, crypto.name);
                  },
                  onDismissed: (direction) {
                    provider.removeFavorite(crypto.id);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('${crypto.name} removido dos favoritos'),
                        action: SnackBarAction(
                          label: 'Desfazer',
                          onPressed: () {
                            provider.addFavorite(crypto);
                          },
                        ),
                      ),
                    );
                  },
                  child: CryptoListItemWidget(
                    crypto: crypto,
                    onFavoriteToggle: () {
                      provider.toggleFavorite(crypto);
                    },
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  Future<bool> _showRemoveDialog(BuildContext context, String cryptoName) async {
    return await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Remover dos Favoritos'),
          content: Text('Deseja remover $cryptoName dos favoritos?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: TextButton.styleFrom(
                foregroundColor: Colors.red,
              ),
              child: const Text('Remover'),
            ),
          ],
        );
      },
    ) ?? false;
  }

  void _showClearAllDialog(BuildContext context, FavoritesController provider) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Limpar Favoritos'),
          content: const Text(
            'Deseja remover todas as criptomoedas dos favoritos?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                final favorites = List.from(provider.favorites);

                for (var crypto in favorites) {
                  provider.removeFavorite(crypto.id);
                }

                Navigator.of(context).pop();

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Todos os favoritos foram removidos'),
                    action: SnackBarAction(
                      label: 'Desfazer',
                      onPressed: () {
                        for (var crypto in favorites) {
                          provider.addFavorite(crypto);
                        }
                      },
                    ),
                  ),
                );
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.red,
              ),
              child: const Text('Limpar Tudo'),
            ),
          ],
        );
      },
    );
  }
}