📱 Modern Bütçe Takip Uygulaması
Flutter ile geliştirilmiş, modern ve kullanıcı dostu bir bütçe takip uygulaması. Günlük harcamalarınızı kaydedin, kategorilere ayırın ve aylık özetlerinizi grafiksel olarak görün.
✨ Özellikler
🏠 Ana Sayfa (Dashboard)
Özet Kartları: Toplam gelir, gider, net bakiye ve toplam işlem sayısı
İnteraktif Pasta Grafik: Harcamaların kategorilere göre dağılımı (fl_chart ile)
Son İşlemler: En son yapılan 5 işlemin listesi
Gerçek Zamanlı Güncelleme: Tüm veriler anlık olarak güncelleniyor
➕ İşlem Yönetimi
İşlem Ekleme: Gelir/gider işlemlerini kolayca ekleyin
Kategori Sistemi: 8 farklı kategori (Yemek, Fatura, Ulaşım, Maaş, vb.)
Tarih Seçici: İşlem tarihini kolayca belirleyin
Açıklama: İsteğe bağlı not ekleme
📋 İşlem Listesi
Tüm İşlemler: Tarih sırasına göre gruplandırılmış liste
Gelişmiş Filtreleme: Tarih, kategori ve tip bazında filtreleme
Arama Özelliği: İşlem başlığında arama
Swipe Gestures: Sağa kaydırarak düzenle, sola kaydırarak sil
🎨 Modern Tasarım
Material Design 3: Güncel Google tasarım dili
Responsive Layout: Tüm ekran boyutlarına uyumlu
Smooth Animasyonlar: 200ms süreyle yumuşak geçişler
Color-coded Kategoriler: Her kategori için özel renk
💾 Veri Yönetimi
SharedPreferences: Yerel veri saklama
Provider State Management: Merkezi durum yönetimi
Offline Çalışma: İnternet bağlantısı gerektirmez
Veri Temizleme: Ayarlar sayfasından tüm verileri temizleyebilme
🛠️ Teknolojiler
Flutter: 3.29.0
Dart: 3.7.0
Provider: State management
SharedPreferences: Veri saklama
fl_chart: Grafik görselleştirme
Material Design 3: UI/UX tasarım
📦 Kurulum
# Projeyi klonlayın
git clone https://github.com/kullaniciadi/butce-takip.git

# Bağımlılıkları yükleyin
cd butce-takip
flutter pub get

# Uygulamayı çalıştırın
flutter run

🎯 Kullanım
İlk Açılış: Uygulama otomatik olarak "Hoş Geldiniz!" mesajı ekler
İşlem Ekleme: Floating Action Button ile yeni işlem ekleyin
Kategori Seçimi: 3x3 grid'den uygun kategoriyi seçin
Grafik Analizi: Ana sayfada harcama dağılımını görün
Veri Yönetimi: Ayarlar sayfasından verilerinizi yönetin
🔧 Geliştirme
lib/
├── main.dart                    # Ana uygulama
├── theme/
│   └── app_theme.dart          # Tema ve renk paleti
├── models/
│   └── transaction.dart        # Veri modelleri
├── providers/
│   └── transaction_provider.dart # State management
├── services/
│   └── storage_service.dart    # Veri saklama servisi
├── widgets/
│   ├── summary_card.dart       # Özet kartları
│   ├── transaction_item.dart   # İşlem listesi öğeleri
│   ├── category_grid.dart      # Kategori seçim grid'i
│   └── expense_chart.dart      # Pasta grafik
└── pages/
    ├── dashboard_page.dart     # Ana sayfa
    ├── add_transaction_page.dart # İşlem ekleme
    ├── transactions_page.dart  # İşlem listesi
    └── settings_page.dart      # Ayarlar
🤝 Katkıda Bulunma
Fork edin
Feature branch oluşturun (git checkout -b feature/AmazingFeature)
Commit edin (git commit -m 'Add some AmazingFeature')
Push edin (git push origin feature/AmazingFeature)
Pull Request oluşturun
📄 Lisans
Bu proje MIT lisansı altında lisanslanmıştır. Detaylar için LICENSE dosyasına bakın.

🙏 Teşekkürler
Flutter ekibine harika framework için
Material Design ekibine tasarım rehberi için
fl_chart paketi geliştiricilerine
Tüm açık kaynak katkıcılarına

