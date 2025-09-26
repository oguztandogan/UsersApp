#!/bin/bash

# Target and Scheme Setup Script for UsersApp
# This script provides instructions for creating multiple targets and schemes

echo "🎯 Setting up Multiple Targets and Schemes for UsersApp"
echo "============================================================="
echo ""

echo "📋 STEP 1: Create Targets in Xcode"
echo "-----------------------------------"
echo "1. Open UsersApp.xcodeproj in Xcode"
echo "2. Select the project in Navigator"
echo "3. Right-click on 'UsersApp' target → Duplicate"
echo "4. Rename to 'UsersApp-Dev'"
echo "5. Repeat and create 'UsersApp-QA'"
echo "6. Keep original as 'UsersApp' (Production)"
echo ""

echo "🔧 STEP 2: Configure Target Settings"
echo "------------------------------------"
echo "For each target, update:"
echo ""
echo "UsersApp-Dev:"
echo "  - Product Name: UsersApp Dev"
echo "  - Bundle Identifier: com.oguztandogan.usersapp.dev"
echo "  - App Icon Source: AppIcon-Dev"
echo "  - Configuration: Use Development.xcconfig"
echo ""
echo "UsersApp-QA:"
echo "  - Product Name: UsersApp QA"
echo "  - Bundle Identifier: com.oguztandogan.usersapp.qa"
echo "  - App Icon Source: AppIcon-QA"
echo "  - Configuration: Use QA.xcconfig"
echo ""
echo "UsersApp:"
echo "  - Product Name: UsersApp"
echo "  - Bundle Identifier: com.oguztandogan.usersapp"
echo "  - App Icon Source: AppIcon"
echo "  - Configuration: Use Production.xcconfig"
echo ""

echo "📱 STEP 3: Create Schemes"
echo "-------------------------"
echo "1. Product → Scheme → Manage Schemes"
echo "2. Duplicate 'UsersApp' scheme"
echo "3. Rename to 'UsersApp Dev' and set target to 'UsersApp-Dev'"
echo "4. Repeat for 'UsersApp QA' with 'UsersApp-QA' target"
echo "5. Keep original as 'UsersApp Prod'"
echo ""

echo "⚙️ STEP 4: Build Configuration Assignment"
echo "------------------------------------------"
echo "In project settings, assign xcconfig files:"
echo ""
echo "Debug Configuration:"
echo "  - UsersApp-Dev: Development.xcconfig"
echo "  - UsersApp-QA: QA.xcconfig"
echo "  - UsersApp: Production.xcconfig"
echo ""
echo "Release Configuration:"
echo "  - UsersApp-Dev: Development.xcconfig"
echo "  - UsersApp-QA: QA.xcconfig"
echo "  - UsersApp: Production.xcconfig"
echo ""

echo "🎨 STEP 5: App Icon Configuration"
echo "---------------------------------"
echo "In each target's Build Settings:"
echo "  - UsersApp-Dev: ASSETCATALOG_COMPILER_APPICON_NAME = AppIcon-Dev"
echo "  - UsersApp-QA: ASSETCATALOG_COMPILER_APPICON_NAME = AppIcon-QA"
echo "  - UsersApp: ASSETCATALOG_COMPILER_APPICON_NAME = AppIcon"
echo ""

echo "🚀 STEP 6: Build Verification"
echo "-----------------------------"
echo "Test each scheme:"
echo "1. Select 'UsersApp Dev' scheme → Build & Run"
echo "2. Select 'UsersApp QA' scheme → Build & Run"
echo "3. Select 'UsersApp Prod' scheme → Build & Run"
echo ""
echo "Each should install as separate apps with different names and icons!"
echo ""

echo "✅ Setup Complete!"
echo "=================="
echo "After following these steps, you'll have:"
echo "- 3 separate targets (Dev, QA, Prod)"
echo "- 3 separate schemes for easy switching"
echo "- 3 separate apps that can be installed simultaneously"
echo "- Environment-specific configurations"
echo ""

# Create target-specific Info.plist files
echo "📄 Creating target-specific Info.plist templates..."

# Info.plist for Dev
cat > "../UsersApp/Info-Dev.plist" << 'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>CFBundleDevelopmentRegion</key>
    <string>$(DEVELOPMENT_LANGUAGE)</string>
    <key>CFBundleDisplayName</key>
    <string>$(APP_NAME)</string>
    <key>CFBundleExecutable</key>
    <string>$(EXECUTABLE_NAME)</string>
    <key>CFBundleIdentifier</key>
    <string>$(PRODUCT_BUNDLE_IDENTIFIER)</string>
    <key>CFBundleInfoDictionaryVersion</key>
    <string>6.0</string>
    <key>CFBundleName</key>
    <string>$(PRODUCT_NAME)</string>
    <key>CFBundlePackageType</key>
    <string>$(PRODUCT_BUNDLE_PACKAGE_TYPE)</string>
    <key>CFBundleShortVersionString</key>
    <string>$(MARKETING_VERSION)</string>
    <key>CFBundleVersion</key>
    <string>$(CURRENT_PROJECT_VERSION)</string>
    <key>LSRequiresIPhoneOS</key>
    <true/>
    <key>UIApplicationSceneManifest</key>
    <dict>
        <key>UIApplicationSupportsMultipleScenes</key>
        <false/>
    </dict>
    <key>UIApplicationSupportsIndirectInputEvents</key>
    <true/>
    <key>UILaunchStoryboardName</key>
    <string>LaunchScreen</string>
    <key>UIRequiredDeviceCapabilities</key>
    <array>
        <string>armv7</string>
    </array>
    <key>UISupportedInterfaceOrientations</key>
    <array>
        <string>UIInterfaceOrientationPortrait</string>
        <string>UIInterfaceOrientationLandscapeLeft</string>
        <string>UIInterfaceOrientationLandscapeRight</string>
    </array>
    <key>UISupportedInterfaceOrientations~ipad</key>
    <array>
        <string>UIInterfaceOrientationPortrait</string>
        <string>UIInterfaceOrientationPortraitUpsideDown</string>
        <string>UIInterfaceOrientationLandscapeLeft</string>
        <string>UIInterfaceOrientationLandscapeRight</string>
    </array>
    <key>EnvironmentType</key>
    <string>Development</string>
</dict>
</plist>
EOF

# Info.plist for QA
cat > "../UsersApp/Info-QA.plist" << 'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>CFBundleDevelopmentRegion</key>
    <string>$(DEVELOPMENT_LANGUAGE)</string>
    <key>CFBundleDisplayName</key>
    <string>$(APP_NAME)</string>
    <key>CFBundleExecutable</key>
    <string>$(EXECUTABLE_NAME)</string>
    <key>CFBundleIdentifier</key>
    <string>$(PRODUCT_BUNDLE_IDENTIFIER)</string>
    <key>CFBundleInfoDictionaryVersion</key>
    <string>6.0</string>
    <key>CFBundleName</key>
    <string>$(PRODUCT_NAME)</string>
    <key>CFBundlePackageType</key>
    <string>$(PRODUCT_BUNDLE_PACKAGE_TYPE)</string>
    <key>CFBundleShortVersionString</key>
    <string>$(MARKETING_VERSION)</string>
    <key>CFBundleVersion</key>
    <string>$(CURRENT_PROJECT_VERSION)</string>
    <key>LSRequiresIPhoneOS</key>
    <true/>
    <key>UIApplicationSceneManifest</key>
    <dict>
        <key>UIApplicationSupportsMultipleScenes</key>
        <false/>
    </dict>
    <key>UIApplicationSupportsIndirectInputEvents</key>
    <true/>
    <key>UILaunchStoryboardName</key>
    <string>LaunchScreen</string>
    <key>UIRequiredDeviceCapabilities</key>
    <array>
        <string>armv7</string>
    </array>
    <key>UISupportedInterfaceOrientations</key>
    <array>
        <string>UIInterfaceOrientationPortrait</string>
        <string>UIInterfaceOrientationLandscapeLeft</string>
        <string>UIInterfaceOrientationLandscapeRight</string>
    </array>
    <key>UISupportedInterfaceOrientations~ipad</key>
    <array>
        <string>UIInterfaceOrientationPortrait</string>
        <string>UIInterfaceOrientationPortraitUpsideDown</string>
        <string>UIInterfaceOrientationLandscapeLeft</string>
        <string>UIInterfaceOrientationLandscapeRight</string>
    </array>
    <key>EnvironmentType</key>
    <string>QA</string>
</dict>
</plist>
EOF

echo "✅ Created Info-Dev.plist and Info-QA.plist templates"
echo ""
echo "💡 Next: Follow the Xcode steps above to complete the setup!"
