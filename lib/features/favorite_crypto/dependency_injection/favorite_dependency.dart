import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../ui/controllers/favorites_controller.dart';

class FavoriteDependency {
  static Future<List<SingleChildWidget>> init(SharedPreferences sharedPreferences) async {
    return [
      ChangeNotifierProvider(
        create: (_) => FavoritesController(
          prefs: sharedPreferences,
        ),
      ),
    ];
  }
}