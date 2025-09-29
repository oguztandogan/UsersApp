# App Icons Guide for Multi-Environment Setup

## Overview
Bu rehber, farklı environment'lar için app icon'larının nasıl özelleştirileceğini açıklar.

## App Icon Sets

### 📱 Production (AppIcon)
- **Renk**: Orijinal mavi
- **Badge**: Yok
- **Kullanım**: App Store ve production kullanıcıları için

### 🔨 Development (AppIcon-Dev)
- **Renk**: Turuncu/Sarı tonları
- **Badge**: "DEV" yazısı
- **Kullanım**: Development sırasında
- **Fark**: Ana icon'un üzerine turuncu overlay ve "DEV" badge'i

### 🧪 QA (AppIcon-QA)
- **Renk**: Mor/Kırmızı tonları
- **Badge**: "QA" yazısı
- **Kullanım**: QA testing sırasında
- **Fark**: Ana icon'un üzerine mor overlay ve "QA" badge'i

## İcon Özelleştirme Önerileri

### Photoshop/Design Araçları ile:
1. Ana app icon'u aç
2. Environment-specific overlay ekle:
   - Dev: Turuncu tint (opacity %30)
   - QA: Mor tint (opacity %30)
3. Sağ üst köşeye environment badge'i ekle
4. Export et ve ilgili .appiconset klasörüne koy

### Hızlı Özelleştirme:
1. Ana icon'un rengini değiştir:
   - Dev: Hue/Saturation ile turuncu'ya kaydır
   - QA: Hue/Saturation ile mor'a kaydır
2. Küçük bir text badge ekle

## App Icon Boyutları
Her .appiconset klasöründe bu boyutlarda icon'lar olmalı:
- 1024x1024 (App Store)
- 180x180 (iPhone 3x)
- 120x120 (iPhone 2x)
- 167x167 (iPad Pro)
- 152x152 (iPad 2x)
- 76x76 (iPad 1x)

## Xcode'da Ayarlama
1. Assets.xcassets'i aç
2. AppIcon-Dev ve AppIcon-QA klasörlerine özelleştirilmiş icon'ları ekle
3. Target settings'te doğru ASSETCATALOG_COMPILER_APPICON_NAME ayarlandığından emin ol

## Test Etme
Her environment build edildiğinde:
- Home screen'de farklı icon görünmeli
- App switcher'da farklı isim görünmeli
- Aynı anda 3 app kurulabilmeli

## Örnek Icon Tasarım İpuçları
- **Base Icon**: Ana logo/tasarım
- **Dev Overlay**: Turuncu kenarlık + "DEV" text
- **QA Overlay**: Mor kenarlık + "QA" text
- **Badge Position**: Sağ üst köşe (küçük)
- **Font**: Bold, beyaz renk
- **Contrast**: Icon ile text arasında yeterli kontrast

Bu şekilde kullanıcılar ve geliştiriciler hangi environment'ın çalıştığını kolayca anlayabilir!
