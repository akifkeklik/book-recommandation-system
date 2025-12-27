# 📚 Bookalemun

**Bookalemun**, yapay zeka destekli, kişiselleştirilmiş kitap önerileri sunan modern bir mobil uygulamadır. **Flutter** (UI) ve **Python Flask** (ML Backend) teknolojilerini birleştirerek kullanıcının okuma zevkine en uygun kitapları sunar.

---

## 📱 Uygulama Arayüzü / App Interface

<table>
  <tr>
    <td align="center"><b>Dark Mode</b></td>
    <td align="center"><b>Light Mode</b></td>
  </tr>
  <tr>
    <td align="center">
      <img src="assets/dark-mode.png" width="300" alt="Dark Mode Screenshot">
    </td>
    <td align="center">
      <img src="assets/light-mode.png" width="300" alt="Light Mode Screenshot">
    </td>
  </tr>
</table>

---

## 🚀 Öne Çıkan Özellikler

### 📱 Mobil (Flutter)
*   **Modern Tasarım:** Netflix tarzı sinematik arayüz, akıcı animasyonlar ve "Koyu Mod".
*   **MVVM Mimarisi:** Provider ile temiz, modüler ve test edilebilir kod yapısı.
*   **Gelişmiş Navigasyon:** `GoRouter` ile güvenli sayfa ve derin link yönetimi.
*   **Çoklu Dil:** Tam kapsamlı Türkçe ve İngilizce desteği.
*   **Offline Mod:** Sunucu bağlantısı olmasa bile çalışan yedekleme mekanizması.

### 🧠 Backend (Python & AI)
*   **Akıllı Öneri Sistemi:** Kullanıcının sevdiği kitapları analiz ederek nokta atışı öneriler sunar.
*   **İçerik Analizi:** TF-IDF ve Cosine Similarity algoritmalarıyla metin tabanlı benzerlik hesabı.
*   **Performanslı API:** Flask ve SQLAlchemy ile hızlı veri servis etme.

---

## 🛠️ Teknoloji Yığını

| Alan | Teknolojiler |
|---|---|
| **Mobil** | Flutter, Dart, Provider, GoRouter |
| **Backend** | Python, Flask, SQLAlchemy |
| **Yapay Zeka** | Scikit-Learn, NumPy, TF-IDF |
| **Veritabanı** | SQLite |

---

## ⚙️ Hızlı Kurulum

Projenin çalışması için backend sunucusunun açık olması gerekir.

### 1. Backend (Python)

```bash
cd backend
python -m venv venv
# Windows: .\venv\Scripts\activate | Mac/Linux: source venv/bin/activate

pip install -r requirements.txt

# Veritabanını kur ve örnek verileri yükle
python -c "from app import create_app; from database import init_db; from seed import seed_data; app=create_app(); app.app_context().push(); init_db(); seed_data()"

# Sunucuyu başlat (http://127.0.0.1:5000)
python app.py
```

### 2. Mobil (Flutter)

```bash
cd ..
flutter pub get
flutter run
```

---

## 🧠 Nasıl Çalışır?

Uygulama, **İçerik Tabanlı Filtreleme (Content-Based Filtering)** yöntemini kullanır:

1.  **Vektörleştirme:** Kitapların konuları ve açıklamaları **TF-IDF** ile matematiksel vektörlere dönüştürülür.
2.  **Benzerlik Hesabı:** Kullanıcının beğendiği kitap vektörleri ile diğer kitaplar arasındaki açı (**Cosine Similarity**) hesaplanır.
3.  **Öneri:** En yakın açıya sahip (en benzer) kitaplar sıralanarak kullanıcıya sunulur.

---

## 📂 Proje Yapısı

```
sonKitap/
├── backend/            # Python API & ML Motoru
├── lib/                # Flutter Kaynak Kodları
│   ├── features/       # Özellik modülleri (Home, Detail vb.)
│   ├── core/           # Ortak servisler ve modeller
│   └── app/            # Tema ve Router ayarları
└── android/            # Native Android dosyaları
```

---

## 🤝 Katkı ve Lisans

Katkılarınızı bekliyoruz! Pull Request göndermekten çekinmeyin.
Bu proje **MIT Lisansı** ile sunulmuştur.
