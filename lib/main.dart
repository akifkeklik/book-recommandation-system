import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:sonkitap/l10n/app_localizations.dart'; // Corrected Import
import 'app/router/app_router.dart';
import 'app/theme/app_theme.dart';
import 'features/settings/viewmodel/settings_viewmodel.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final settingsViewModel = SettingsViewModel();
  await settingsViewModel.loadSettings();

  runApp(MyApp(settingsViewModel: settingsViewModel));
}

class MyApp extends StatelessWidget {
  final SettingsViewModel settingsViewModel;

  const MyApp({super.key, required this.settingsViewModel});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: settingsViewModel,
      child: Consumer<SettingsViewModel>(
        builder: (context, settingsViewModel, child) {
          if (settingsViewModel.isLoading) {
            return const MaterialApp(
              home: Scaffold(body: Center(child: CircularProgressIndicator())),
            );
          }

          return MaterialApp.router(
            routerConfig: appRouter,
            title: 'Bookalemun', // Updated App Name
            debugShowCheckedModeBanner: false,
            // V5.0: Theme is now dynamically built based on ViewModel state
            theme: AppTheme.getLightTheme(settingsViewModel.themeColor),
            darkTheme: AppTheme.getDarkTheme(settingsViewModel.themeColor),
            themeMode: settingsViewModel.themeMode,
            locale: settingsViewModel.locale,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('en'), // English
              Locale('tr'), // Turkish
            ],
          );
        },
      ),
    );
  }
}
