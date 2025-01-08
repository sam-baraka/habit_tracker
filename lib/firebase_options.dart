// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDxZx_XP1MO0etAJTsdHyap0H7GmJjJUB8',
    appId: '1:722815712691:web:1960e5135aa7cb17a85fc6',
    messagingSenderId: '722815712691',
    projectId: 'solutech-interview-sam-baraka',
    authDomain: 'solutech-interview-sam-baraka.firebaseapp.com',
    storageBucket: 'solutech-interview-sam-baraka.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyB9gOVGXZTGpc81I55gnKoa6MWqbPa0_Ag',
    appId: '1:722815712691:android:50e5cf841b9b03caa85fc6',
    messagingSenderId: '722815712691',
    projectId: 'solutech-interview-sam-baraka',
    storageBucket: 'solutech-interview-sam-baraka.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBW_jJP-8HCGm2Cm68qqNWHrgPHZjLKYYs',
    appId: '1:722815712691:ios:f7be58eee93ecb85a85fc6',
    messagingSenderId: '722815712691',
    projectId: 'solutech-interview-sam-baraka',
    storageBucket: 'solutech-interview-sam-baraka.firebasestorage.app',
    iosBundleId: 'com.solutech.interview',
  );

}