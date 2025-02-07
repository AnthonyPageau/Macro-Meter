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
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
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
        return windows;
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

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBAbl2_WW1NuWJn5nHEXbZqwEbjNYx0LXo',
    appId: '1:1000455477510:android:0482e56d8978424e09e687',
    messagingSenderId: '1000455477510',
    projectId: 'macro-meter',
    storageBucket: 'macro-meter.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCbtsMperMe4OmiPQzsXBYqnUkkWS9HU78',
    appId: '1:1000455477510:ios:a06aacf621dd59eb09e687',
    messagingSenderId: '1000455477510',
    projectId: 'macro-meter',
    storageBucket: 'macro-meter.firebasestorage.app',
    iosBundleId: 'com.example.macroMeter',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyAewf3n9Ug_zlKrFpDKBMpqunVAJLJJBWY',
    appId: '1:1000455477510:web:ec7856032117b7b809e687',
    messagingSenderId: '1000455477510',
    projectId: 'macro-meter',
    authDomain: 'macro-meter.firebaseapp.com',
    storageBucket: 'macro-meter.firebasestorage.app',
  );

}