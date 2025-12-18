import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sonkitap/main.dart';
import 'package:sonkitap/features/settings/viewmodel/settings_viewmodel.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('App Smoke Test: SplashScreen should be visible', (WidgetTester tester) async {
    // ARRANGE: Set up SharedPreferences mock values.
    SharedPreferences.setMockInitialValues({});
    
    // Create and load the necessary ViewModel, just like the real main.dart
    final settingsViewModel = SettingsViewModel();
    await settingsViewModel.loadSettings();

    // ACT: Build our app and trigger a frame, providing the required viewModel.
    await tester.pumpWidget(MyApp(settingsViewModel: settingsViewModel));
    
    // Trigger frame to ensure splash screen logic runs.
    await tester.pump();

    // ASSERT: Verify that the SplashScreen is shown correctly.
    // Note: Splash screen text might be 'Bookworm' (from app title default) or 'BookRec' depending on localization loading state.
    // Using a more robust check for the CircularProgressIndicator which is always present.
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
}
