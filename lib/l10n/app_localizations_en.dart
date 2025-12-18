// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Bookworm';

  @override
  String get home => 'Home';

  @override
  String get library => 'Library';

  @override
  String get favorites => 'Favorites';

  @override
  String get profile => 'Profile';

  @override
  String get settings => 'Settings';

  @override
  String get visuals => 'Visuals';

  @override
  String get themeMode => 'Theme Mode';

  @override
  String get light => 'Light';

  @override
  String get dark => 'Dark';

  @override
  String get system => 'System';

  @override
  String get accentColor => 'Accent Color';

  @override
  String get language => 'Language';

  @override
  String get selectLanguage => 'Select Language';

  @override
  String get general => 'General';

  @override
  String get appearance => 'Appearance';

  @override
  String get notifications => 'Notifications';

  @override
  String get account => 'Account';

  @override
  String get signOut => 'Sign Out';

  @override
  String joinedIn(String year) {
    return 'Joined in $year';
  }

  @override
  String get read => 'Read';

  @override
  String get books => 'Books';

  @override
  String get goodMorning => 'Good Morning,';

  @override
  String get findNextBook => 'Find Your Next Book';

  @override
  String get speciallyForYou => 'Specially For You';

  @override
  String get popularBooks => 'Popular Books';

  @override
  String get couldNotFetchBooks =>
      'Could not fetch books. Please try again later.';

  @override
  String get browseLibrary => 'Browse Library';

  @override
  String get searchHint => 'Search by title or author...';

  @override
  String get allCategories => 'All';

  @override
  String get noBooksFound => 'No books found.';

  @override
  String get yourFavorites => 'Your Favorites';

  @override
  String get noFavoritesYet => 'No Favorites Yet';

  @override
  String get noFavoritesHint => 'Tap the heart on any book to save it here.';

  @override
  String get couldNotLoadFavorites => 'Could not load your favorites.';

  @override
  String get couldNotLoadBookDetails => 'Could not load book details.';

  @override
  String get toggleFavorite => 'Toggle Favorite';

  @override
  String byAuthor(String author) {
    return 'by $author';
  }

  @override
  String get description => 'Description';

  @override
  String get myList => 'My List';

  @override
  String get youMightAlsoLike => 'You Might Also Like';

  @override
  String get rating => 'Rating';

  @override
  String get popularity => 'Popularity';

  @override
  String get category => 'Category';

  @override
  String get chooseInterests => 'Choose Your Interests';

  @override
  String get chooseInterestsHint =>
      'Select at least one category to get personalized book recommendations.';

  @override
  String get continueButton => 'Continue';
}
