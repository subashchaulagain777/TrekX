import 'dart:io';
import 'package:easytrek/Screens/RolebasedScreen.dart';
import 'package:easytrek/firebase_options.dart';
import 'package:easytrek/provider/FriendsProvider.dart';
import 'package:easytrek/provider/GearProvider.dart';
import 'package:easytrek/provider/Guide_Package_provider.dart';
import 'package:easytrek/provider/PostProvider.dart';
import 'package:easytrek/provider/TrekkerBookingsProvider.dart';
import 'package:easytrek/provider/authServiceProvider.dart';
import 'package:easytrek/provider/chatprovider.dart';
import 'package:easytrek/provider/mapProvider.dart';
import 'package:easytrek/provider/navigationProvider.dart';
import 'package:easytrek/provider/profileProvider.dart';
import 'package:easytrek/provider/trekkingpackageprovider.dart';
import 'package:easytrek/services/firestoreservices.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'Screens/MainScreen.dart';
import 'Screens/guide/guideDashboard.dart';


// --- MAIN APPLICATION ENTRY POINT ---
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const EasyTrekApp());
}


// --- THEME AND STYLING ---
class AppTheme {
  static const Color primary = Color(0xFF0B5345);
  static const Color accent = Color(0xFFF5B041);
  static const Color background = Color(0xFFF4F6F6);
  static const Color text = Color(0xFF1C2833);
  static final ThemeData themeData = ThemeData(
    primaryColor: primary,
    scaffoldBackgroundColor: background,
    colorScheme: const ColorScheme.light(primary: primary, secondary: accent),
    textTheme: GoogleFonts.poppinsTextTheme().apply(
      bodyColor: text,
      displayColor: text,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primary,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: GoogleFonts.poppins(fontWeight: FontWeight.bold),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: primary,
        textStyle: GoogleFonts.poppins(fontWeight: FontWeight.bold),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      hintStyle: GoogleFonts.poppins(color: Colors.grey.shade500),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: background,
      foregroundColor: text,
      elevation: 0,
      titleTextStyle: GoogleFonts.poppins(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: text,
      ),
    ),
  );
}

// --- ROOT WIDGET ---
class EasyTrekApp extends StatelessWidget {
  const EasyTrekApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [

        ChangeNotifierProvider(create: (_) => AuthService()),
        ChangeNotifierProvider(create: (_) => NavigationProvider()),
        ChangeNotifierProvider(create: (_) => TrekProvider()),
        ChangeNotifierProvider(create: (_) => MapProvider()),
        ChangeNotifierProxyProvider<AuthService, TrekkerBookingsProvider>(
          create: (context) => TrekkerBookingsProvider(Provider.of<AuthService>(context, listen: false)),
          update: (context, auth, previous) => TrekkerBookingsProvider(auth),
        ),
        ChangeNotifierProxyProvider<AuthService, GuidePackagesProvider>(
          create: (context) => GuidePackagesProvider(Provider.of<AuthService>(context, listen: false)),
          update: (context, auth, previous) => GuidePackagesProvider(auth),
        ),
        ChangeNotifierProxyProvider<AuthService, ChatProvider>(
          create: (context) => ChatProvider(Provider.of<AuthService>(context, listen: false)),
          update: (context, auth, previous) => ChatProvider(auth),
        ),
        ChangeNotifierProxyProvider<AuthService, FriendsProvider>(
          create: (context) => FriendsProvider(Provider.of<AuthService>(context, listen: false)),
          update: (context, auth, previous) => FriendsProvider(auth),
        ),
        ChangeNotifierProxyProvider<AuthService, ProfileProvider>(
          create: (context) => ProfileProvider(Provider.of<AuthService>(context, listen: false)),
          update: (context, auth, previous) => ProfileProvider(auth),
        ),
        ChangeNotifierProxyProvider<AuthService, PostProvider>(
          create: (context) =>
              PostProvider(Provider.of<AuthService>(context, listen: false)),
          update: (context, auth, previous) => PostProvider(auth),
        ),
        // Add the new GearProvider here
        ChangeNotifierProxyProvider<AuthService, GearProvider>(
          create: (context) =>
              GearProvider(Provider.of<AuthService>(context, listen: false)),
          update: (context, auth, previous) => GearProvider(auth),
        ),
      ],
      child: MaterialApp(
        title: 'Easy Trek',
        theme: AppTheme.themeData,
        debugShowCheckedModeBanner: false,
        home: const AuthWrapper(),
      ),
    );
  }
}

// --- AUTH WRAPPER & MAIN SCREEN ---
class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}


class _AuthWrapperState extends State<AuthWrapper> {
  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);

    if (authService.user == null) {

      return const RoleSelectionScreen();
    } else {
      return FutureBuilder<String?>(

        future: FirestoreService().getUserRole(authService.user!.uid),
        builder: (context, snapshot) {
          // While the role is being fetched, show a loading indicator.
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          if (snapshot.hasError || !snapshot.hasData) {
            return const MainScreen(); // Default for safety
          }

          final role = snapshot.data;

          // Based on the role, navigate to the correct dashboard.
          if (role == 'Guide') {
            return const GuideDashboardScreen();
          } else {
            // Default to Trekker dashboard
            return const MainScreen();
          }
        },
      );
    }
  }
}












