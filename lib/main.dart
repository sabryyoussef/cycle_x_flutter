import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:products_repository/products_repository.dart';
import 'package:provider/provider.dart';
import 'package:waste_wise/common_network_check/firestore_provider.dart';
import 'package:waste_wise/routes/routes.dart';
import 'package:user_repository/user_repository.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:waste_wise/constants/constants.dart' as constants;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load .env file if it exists
  try {
    await dotenv.load(fileName: ".env");
  } catch (e) {
    print("Warning: .env file not found. Using default configuration.");
  }

  // Only initialize Firebase on supported platforms (Android, iOS, Web, macOS)
  // Skip Firebase initialization on unsupported platforms like Linux and Windows desktop
  if (kIsWeb) {
    await Firebase.initializeApp(
      name: constants.dbName,
      options: FirebaseOptions(
          apiKey: constants.apiKey,
          authDomain: constants.authDomain,
          projectId: constants.projectId,
          storageBucket: constants.storageBucket,
          messagingSenderId: constants.messagingSenderId,
          appId: constants.appId),
    );
  } else if (!Platform.isLinux && !Platform.isWindows) {
    // Initialize Firebase for Android, iOS, and macOS
    await Firebase.initializeApp();
  } else {
    print(
        "Warning: Firebase is not supported on this platform (Linux/Windows). Running in demo mode.");
  }
  debugPaintSizeEnabled = false; // Optionally enable for debugging

  // Determine if we're on an unsupported platform
  final bool isUnsupportedPlatform =
      !kIsWeb && (Platform.isLinux || Platform.isWindows);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => FirestoreProvider(),
        ),
        // Use mock repositories on unsupported platforms
        if (isUnsupportedPlatform) ...[
          ChangeNotifierProvider<MockUserRepo>(
            create: (context) => MockUserRepo(),
          ),
          StreamProvider<MyUser>(
            create: (context) =>
                Provider.of<MockUserRepo>(context, listen: false).user,
            initialData: MyUser.empty,
          ),
          ChangeNotifierProvider(create: (_) => MockProductService()),
          ChangeNotifierProvider(
            create: (_) => MockCartRepo(),
          ),
        ] else ...[
          ChangeNotifierProvider<FirebaseUserRepo>(
            create: (context) => FirebaseUserRepo(),
          ),
          StreamProvider<MyUser>(
            create: (context) =>
                Provider.of<FirebaseUserRepo>(context, listen: false).user,
            initialData: MyUser.empty,
          ),
          ChangeNotifierProvider(create: (_) => ProductService()),
          ChangeNotifierProvider(
            create: (_) => FirebaseCartRepo(),
          ),
        ]
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false, // Disables the debug banner

      routes: AppRoutes.getRoutes(),
      initialRoute: '/',
      title: 'WasteWise',
    );
  }
}
