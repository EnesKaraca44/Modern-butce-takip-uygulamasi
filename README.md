# 📱 Modern Bütçe Takip Uygulaması

Flutter ile geliştirilmiş, modern ve kullanıcı dostu bir bütçe takip uygulaması. Günlük harcamalarınızı kaydedin, kategorilere ayırın ve aylık özetlerinizi grafiksel olarak görün.

---

## ✨ Özellikler

### 🏠 Ana Sayfa (Dashboard)
- **Özet Kartları:** Toplam gelir, gider, net bakiye ve toplam işlem sayısı
- **İnteraktif Pasta Grafik:** Harcamaların kategorilere göre dağılımı (`fl_chart` ile)
- **Son İşlemler:** En son yapılan 5 işlemin listesi
- **Gerçek Zamanlı Güncelleme:** Tüm veriler anlık olarak güncelleniyor

### ➕ İşlem Yönetimi
- **İşlem Ekleme:** Gelir/gider işlemlerini kolayca ekleyin
- **Kategori Sistemi:** 8 farklı kategori (Yemek, Fatura, Ulaşım, Maaş, vb.)
- **Tarih Seçici:** İşlem tarihini kolayca belirleyin
- **Açıklama:** İsteğe bağlı not ekleme

### 📋 İşlem Listesi
- **Tüm İşlemler:** Tarih sırasına göre gruplandırılmış liste
- **Gelişmiş Filtreleme:** Tarih, kategori ve tip (gelir/gider) bazında filtreleme
- **Arama Özelliği:** İşlem başlığında arama
- **Swipe Gestures:** Sağa kaydırarak düzenle, sola kaydırarak sil

### 🎨 Modern Tasarım
- **Material Design 3:** Güncel Google tasarım dili
- **Responsive Layout:** Tüm ekran boyutlarına uyumlu
- **Smooth Animasyonlar:** 200ms süreyle yumuşak geçişler
- **Color-coded Kategoriler:** Her kategori için özel renk

### 💾 Veri Yönetimi
- **SharedPreferences:** Yerel veri saklama
- **Provider State Management:** Merkezi durum yönetimi
- **Offline Çalışma:** İnternet bağlantısı gerektirmez
- **Veri Temizleme:** Ayarlar sayfasından tüm verileri temizleyebilme

---

## 🛠️ Teknolojiler

- **Flutter:** 3.29.0
- **Dart:** 3.7.0
- **Provider:** State management
- **SharedPreferences:** Veri saklama
- **fl_chart:** Grafik görselleştirme
- **Material Design 3:** UI/UX tasarım

---

## 📦 Kurulum

1.  **Projeyi klonlayın**
    ```bash
    git clone https://github.com/kullaniciadi/butce-takip.git
    ```

2.  **Bağımlılıkları yükleyin**
    ```bash
    cd butce-takip
    flutter pub get
    ```

3.  **Uygulamayı çalıştırın**
    ```bash
    flutter run
    ```

---

## 🎯 Kullanım

1.  **İlk Açılış:** Uygulama otomatik olarak "Hoş Geldiniz!" mesajı ekler.
2.  **İşlem Ekleme:** Ana sayfadaki Floating Action Button (FAB) ile yeni bir gelir veya gider işlemi ekleyin.
3.  **Kategori Seçimi:** İşlem ekleme sayfasında 3x3 grid yapısındaki kategorilerden birini seçin.
4.  **Grafik Analizi:** Ana sayfadaki interaktif pasta grafik ile harcamalarınızın dağılımını görselleştirin.
5.  **Veri Yönetimi:** Ayarlar sayfasından tüm verilerinizi sıfırlayabilirsiniz.

---

## 🔧 Proje Yapısı
lib/
├── main.dart # Ana uygulama giriş noktası
├── theme/
│ └── app_theme.dart # Tema ve renk paleti
├── models/
│ └── transaction.dart # İşlem veri modeli
├── providers/
│ └── transaction_provider.dart # State management (Provider)
├── services/
│ └── storage_service.dart # SharedPreferences servisi
├── widgets/
│ ├── summary_card.dart # Özet kartları
│ ├── transaction_item.dart # İşlem listesi öğeleri
│ ├── category_grid.dart # Kategori seçim grid'i
│ └── expense_chart.dart # Pasta grafik bileşeni
└── pages/
├── dashboard_page.dart # Ana sayfa
├── add_transaction_page.dart # İşlem ekleme sayfası
├── transactions_page.dart # Tüm işlemler listesi sayfası
└── settings_page.dart # Ayarlar sayfası

---

## 🤝 Katkıda Bulunma

Katkılarınız bizim için değerli! Katkıda bulunmak için lütfen aşağıdaki adımları izleyin:

1. Projeyi fork edin.
2. Yeni bir özellik branch'i oluşturun (`git checkout -b feature/HarikaBirOzellik`).
3. Değişikliklerinizi commit edin (`git commit -m 'Harika bir özellik ekle'`).
4. Branch'inizi push edin (`git push origin feature/HarikaBirOzellik`).
5. Bir Pull Request oluşturun.

---

## 📄 Lisans

Bu proje MIT lisansı altında lisanslanmıştır. Detaylar için [LICENSE](LICENSE) dosyasına bakın.

---

## 🙏 Teşekkürler

- **Flutter ekibine** harika bir framework sundukları için.
- **Material Design ekibine** kapsamlı tasarım rehberi için.
- **`fl_chart`** paketi geliştiricilerine.
- Tüm açık kaynak topluluğuna ve katkıcılarına.
