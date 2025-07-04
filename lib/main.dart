import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/theme/app_theme.dart';
import 'features/crypto_detail/dependency_injection/crypto_detail_dependency.dart';
import 'features/crypto_list/dependency_injection/crypto_list_dependency.dart';
import 'features/favorite_crypto/dependency_injection/favorite_dependency.dart';
import 'features/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  final sharedPreferences = await SharedPreferences.getInstance();

  final favoritesProviders = await FavoriteDependency.init(sharedPreferences);
  final cryptoListProviders = await CryptoListDependency.init();
  final cryptoDetailProviders = await CryptoDetailDependency.init();

  final allProviders = [
    ...favoritesProviders,
    ...cryptoListProviders,
    ...cryptoDetailProviders,
  ];

  runApp(
    MultiProvider(
      providers: allProviders,
      child: const BrasilCriptoApp(),
    ),
  );
}

class BrasilCriptoApp extends StatelessWidget {
  const BrasilCriptoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BrasilCripto',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.light,
      home: const HomePage(),
    );
  }
}