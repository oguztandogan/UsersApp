# Xcode Multi-Target Setup Checklist

## ✅ Pre-Setup Verification
- [ ] Project açık ve backup alınmış
- [ ] Git'te tüm değişiklikler commit edilmiş
- [ ] Mevcut scheme çalışıyor

## 🎯 Step 1: Create Targets

### Create Development Target
- [ ] Project Navigator'da "UsersApp" target'ına sağ tık
- [ ] "Duplicate" seç
- [ ] "UsersApp copy" → "UsersApp-Dev" olarak rename et
- [ ] Target membership'leri kontrol et

### Create QA Target  
- [ ] "UsersApp" target'ına tekrar sağ tık
- [ ] "Duplicate" seç
- [ ] "UsersApp copy" → "UsersApp-QA" olarak rename et
- [ ] Target membership'leri kontrol et

## ⚙️ Step 2: Configure Build Settings

### UsersApp-Dev Target
- [ ] **General Tab:**
  - [ ] Display Name: "UsersApp Dev"
  - [ ] Bundle Identifier: "com.oguztandogan.usersapp.dev"
  - [ ] Version: 1.0.0
  - [ ] Build: 1

- [ ] **Build Settings Tab:**
  - [ ] Product Name: "UsersApp Dev"
  - [ ] Product Bundle Identifier: "com.oguztandogan.usersapp.dev"
  - [ ] Info.plist File: "UsersApp/Info-Dev.plist"
  - [ ] Asset Catalog App Icon Set Name: "AppIcon-Dev"

- [ ] **Build Configurations:**
  - [ ] Debug: "Development.xcconfig"
  - [ ] Release: "Development.xcconfig"

### UsersApp-QA Target
- [ ] **General Tab:**
  - [ ] Display Name: "UsersApp QA"
  - [ ] Bundle Identifier: "com.oguztandogan.usersapp.qa"
  - [ ] Version: 1.0.0
  - [ ] Build: 1

- [ ] **Build Settings Tab:**
  - [ ] Product Name: "UsersApp QA"
  - [ ] Product Bundle Identifier: "com.oguztandogan.usersapp.qa"
  - [ ] Info.plist File: "UsersApp/Info-QA.plist"
  - [ ] Asset Catalog App Icon Set Name: "AppIcon-QA"

- [ ] **Build Configurations:**
  - [ ] Debug: "QA.xcconfig"
  - [ ] Release: "QA.xcconfig"

### UsersApp (Production) Target
- [ ] **General Tab:**
  - [ ] Display Name: "UsersApp"
  - [ ] Bundle Identifier: "com.oguztandogan.usersapp"
  - [ ] Version: 1.0.0
  - [ ] Build: 1

- [ ] **Build Settings Tab:**
  - [ ] Product Name: "UsersApp"
  - [ ] Product Bundle Identifier: "com.oguztandogan.usersapp"
  - [ ] Info.plist File: "UsersApp/Info.plist"
  - [ ] Asset Catalog App Icon Set Name: "AppIcon"

- [ ] **Build Configurations:**
  - [ ] Debug: "Production.xcconfig"
  - [ ] Release: "Production.xcconfig"

## 📱 Step 3: Create Schemes

### Create Development Scheme
- [ ] Product → Scheme → Manage Schemes
- [ ] "+" butonuna tık
- [ ] Name: "UsersApp Dev"
- [ ] Target: "UsersApp-Dev"
- [ ] Shared: ✅ (team için)

### Create QA Scheme
- [ ] "+" butonuna tık
- [ ] Name: "UsersApp QA"
- [ ] Target: "UsersApp-QA"
- [ ] Shared: ✅ (team için)

### Update Production Scheme
- [ ] "UsersApp" scheme'ini seç
- [ ] Rename: "UsersApp Prod"
- [ ] Target: "UsersApp" (değişmez)
- [ ] Shared: ✅ (team için)

## 🏗️ Step 4: Project Configuration

### Link XCConfig Files
- [ ] Project settings → Info tab
- [ ] Configuration listesinde:
  - [ ] Debug → UsersApp-Dev: Development
  - [ ] Debug → UsersApp-QA: QA  
  - [ ] Debug → UsersApp: Production
  - [ ] Release → UsersApp-Dev: Development
  - [ ] Release → UsersApp-QA: QA
  - [ ] Release → UsersApp: Production

## 🎨 Step 5: App Icons Setup

### Verify App Icon Sets
- [ ] Assets.xcassets → AppIcon ✅
- [ ] Assets.xcassets → AppIcon-Dev ✅
- [ ] Assets.xcassets → AppIcon-QA ✅

### Customize Icons (Optional)
- [ ] AppIcon-Dev: Turuncu overlay + "DEV" badge
- [ ] AppIcon-QA: Mor overlay + "QA" badge
- [ ] AppIcon: Orijinal tasarım

## 🧪 Step 6: Testing

### Build Each Target
- [ ] Scheme: "UsersApp Dev" → Build ✅
- [ ] Scheme: "UsersApp QA" → Build ✅  
- [ ] Scheme: "UsersApp Prod" → Build ✅

### Install and Verify
- [ ] Tüm 3 app aynı anda kurulabiliyor ✅
- [ ] Her app farklı isimde görünüyor ✅
- [ ] Her app farklı icon'a sahip ✅
- [ ] Environment detection çalışıyor ✅

## 🔧 Step 7: Verification Commands

### Build Commands (Terminal)
```bash
# Development
xcodebuild -scheme "UsersApp Dev" -configuration Debug

# QA  
xcodebuild -scheme "UsersApp QA" -configuration Debug

# Production
xcodebuild -scheme "UsersApp Prod" -configuration Release
```

### Environment Check
Her build'de console'da şu logları görmelisiniz:
- [ ] "🚀 App launching with environment: Development"
- [ ] "🚀 App launching with environment: QA" 
- [ ] "🚀 App launching with environment: Production"

## ✅ Final Checklist
- [ ] 3 ayrı target oluşturuldu
- [ ] 3 ayrı scheme oluşturuldu
- [ ] XCConfig dosyaları bağlandı
- [ ] Info.plist dosyaları ayarlandı
- [ ] App icon'ları yapılandırıldı
- [ ] Bundle identifier'lar farklı
- [ ] Environment detection çalışıyor
- [ ] Tüm target'lar build oluyor
- [ ] Multiple app installation test edildi

## 🎉 Success!
Artık 3 farklı environment ile parallel development yapabilirsiniz!
