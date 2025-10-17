# 🔥 Firebase Production Setup Guide

## 📋 **Prerequisites**
- Firebase project created
- Android app registered
- `google-services.json` downloaded and placed in `android/app/`

## 🚀 **Step-by-Step Setup**

### **1. Firebase Console Setup**

#### **1.1 Create Project**
1. Go to [Firebase Console](https://console.firebase.google.com)
2. Click "Create a project"
3. Project name: `WasteWise-Production`
4. Enable Google Analytics: ✅
5. Click "Create project"

#### **1.2 Add Android App**
1. Click "Add app" → Android icon
2. Package name: `com.example.shoppingapp`
3. App nickname: `WasteWise Android`
4. Download `google-services.json`
5. Replace file in `android/app/google-services.json`

### **2. Authentication Setup**

#### **2.1 Enable Email/Password**
1. Go to **Authentication** → **Sign-in method**
2. Enable **Email/Password** provider
3. Click **Save**

#### **2.2 Optional: Phone Authentication**
1. Enable **Phone** provider
2. Add test phone number
3. Click **Save**

### **3. Firestore Database Setup**

#### **3.1 Create Database**
1. Go to **Firestore Database**
2. Click **Create database**
3. Start in **production mode**
4. Choose location: `us-central1`
5. Click **Done**

#### **3.2 Security Rules**
Replace the rules with:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    
    // Users can read/write their own user document
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    
    // Waste pickups - authenticated users can create, read their own
    match /waste_pickups/{pickupId} {
      allow create: if request.auth != null;
      allow read, update, delete: if request.auth != null && 
        (resource.data.userId == request.auth.uid || 
         request.auth.uid == resource.data.vendorId);
    }
    
    // Products - everyone can read, authenticated users can write
    match /products/{productId} {
      allow read: if true;
      allow write: if request.auth != null;
    }
    
    // Cart - users can read/write their own cart
    match /cart/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    
    // Transactions - users can read their own transactions
    match /transactions/{transactionId} {
      allow read: if request.auth != null && 
        (resource.data.userId == request.auth.uid || 
         resource.data.vendorId == request.auth.uid);
      allow create, update: if request.auth != null;
    }
    
    // Vendors - vendors can read/write their own data
    match /vendors/{vendorId} {
      allow read, write: if request.auth != null && request.auth.uid == vendorId;
    }
  }
}
```

### **4. Firebase Storage Setup**

#### **4.1 Enable Storage**
1. Go to **Storage**
2. Click **Get started**
3. Start in **production mode**
4. Choose same location as Firestore
5. Click **Done**

#### **4.2 Storage Security Rules**
Replace the rules with:

```javascript
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    // Users can upload their own images
    match /users/{userId}/{allPaths=**} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    
    // Waste pickup images - authenticated users can upload
    match /waste_pickups/{allPaths=**} {
      allow read, write: if request.auth != null;
    }
    
    // Product images - authenticated users can upload
    match /products/{allPaths=**} {
      allow read: if true;
      allow write: if request.auth != null;
    }
  }
}
```

### **5. App Configuration**

#### **5.1 Update Constants**
Update `lib/constants/constants.dart` with your Firebase project details:

```dart
class Constants {
  // Firebase Configuration
  static const String projectId = 'wastewise-7b983';
  static const String apiKey = 'AIzaSyDlGabbjamaECTAvmBO_UPHDKFUwzXSeiY';
  static const String authDomain = 'wastewise-7b983.firebaseapp.com';
  static const String storageBucket = 'wastewise-7b983.appspot.com';
  static const String messagingSenderId = '951086348501';
  static const String appId = '1:951086348501:android:d823304e80cdae16ef8a5c';
  static const String dbName = 'wastewise_production';
}
```

#### **5.2 Test Configuration**
1. Build and run the app: `flutter run`
2. Test user registration/login
3. Test waste pickup scheduling
4. Test product browsing
5. Test transaction history

### **6. Production Deployment**

#### **6.1 Build Release APK**
```bash
flutter build apk --release
```

#### **6.2 Build App Bundle (for Play Store)**
```bash
flutter build appbundle --release
```

## 🔒 **Security Best Practices**

### **Database Security**
- ✅ Use authentication-based rules
- ✅ Validate user ownership
- ✅ Limit read/write permissions
- ❌ Never use public access in production

### **Storage Security**
- ✅ Authenticate image uploads
- ✅ Validate file types and sizes
- ✅ Use secure file paths

### **Authentication**
- ✅ Enable email verification
- ✅ Use strong password policies
- ✅ Implement rate limiting

## 🧪 **Testing Checklist**

- [ ] User registration works
- [ ] User login works
- [ ] Waste pickup scheduling saves to database
- [ ] Product images upload to storage
- [ ] Transaction history loads
- [ ] Vendor features work
- [ ] Security rules prevent unauthorized access

## 🚨 **Troubleshooting**

### **Common Issues**
1. **Permission denied**: Check Firestore rules
2. **Authentication failed**: Verify Firebase config
3. **Storage upload failed**: Check Storage rules
4. **Build errors**: Verify `google-services.json`

### **Debug Steps**
1. Check Firebase Console for errors
2. Enable debug logging in app
3. Test with Firebase emulator
4. Verify network connectivity

## 📞 **Support**

If you encounter issues:
1. Check Firebase Console logs
2. Review security rules
3. Test with Firebase emulator
4. Contact Firebase support

---

**🎉 Your WasteWise app is now ready for production!**
