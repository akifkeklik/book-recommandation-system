// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class AppLocalizationsTr extends AppLocalizations {
  AppLocalizationsTr([String locale = 'tr']) : super(locale);

  @override
  String get appTitle => 'KitapKurdu';

  @override
  String get home => 'Ana Sayfa';

  @override
  String get library => 'Kitaplık';

  @override
  String get favorites => 'Favoriler';

  @override
  String get profile => 'Profil';

  @override
  String get settings => 'Ayarlar';

  @override
  String get visuals => 'Görünüm';

  @override
  String get themeMode => 'Tema Modu';

  @override
  String get light => 'Açık';

  @override
  String get dark => 'Koyu';

  @override
  String get system => 'Sistem';

  @override
  String get accentColor => 'Vurgu Rengi';

  @override
  String get language => 'Dil';

  @override
  String get selectLanguage => 'Dil Seçin';

  @override
  String get general => 'Genel';

  @override
  String get appearance => 'Görünüm';

  @override
  String get notifications => 'Bildirimler';

  @override
  String get account => 'Hesap';

  @override
  String get signOut => 'Çıkış Yap';

  @override
  String joinedIn(String year) {
    return '$year yılında katıldı';
  }

  @override
  String get read => 'Okunan';

  @override
  String get books => 'Kitaplar';

  @override
  String get goodMorning => 'Günaydın,';

  @override
  String get findNextBook => 'Sonraki Kitabını Bul';

  @override
  String get speciallyForYou => 'Sizin İçin Özel';

  @override
  String get popularBooks => 'Popüler Kitaplar';

  @override
  String get couldNotFetchBooks =>
      'Kitaplar yüklenemedi. Lütfen daha sonra tekrar deneyin.';

  @override
  String get browseLibrary => 'Kitaplığa Göz At';

  @override
  String get searchHint => 'Başlık veya yazara göre ara...';

  @override
  String get allCategories => 'Tümü';

  @override
  String get noBooksFound => 'Kitap bulunamadı.';

  @override
  String get yourFavorites => 'Favorileriniz';

  @override
  String get noFavoritesYet => 'Henüz Favori Yok';

  @override
  String get noFavoritesHint =>
      'Buraya kaydetmek için herhangi bir kitabın üzerindeki kalbe dokunun.';

  @override
  String get couldNotLoadFavorites => 'Favorileriniz yüklenemedi.';

  @override
  String get couldNotLoadBookDetails => 'Kitap detayları yüklenemedi.';

  @override
  String get toggleFavorite => 'Favorilere Ekle/Çıkar';

  @override
  String byAuthor(String author) {
    return 'yazar: $author';
  }

  @override
  String get description => 'Açıklama';

  @override
  String get myList => 'Listem';

  @override
  String get youMightAlsoLike => 'Şunları da Beğenebilirsiniz';

  @override
  String get rating => 'Puan';

  @override
  String get popularity => 'Popülerlik';

  @override
  String get category => 'Kategori';

  @override
  String get chooseInterests => 'İlgi Alanlarınızı Seçin';

  @override
  String get chooseInterestsHint =>
      'Kişiselleştirilmiş kitap önerileri almak için en az bir kategori seçin.';

  @override
  String get continueButton => 'Devam Et';

  @override
  String get addedToFavorites => 'Favorilere Eklendi';

  @override
  String get removedFromFavorites => 'Favorilerden Çıkarıldı';

  @override
  String get markedAsRead => 'Okundu Olarak İşaretlendi';

  @override
  String get markedAsUnread => 'Okunmadı Olarak İşaretlendi';
}
