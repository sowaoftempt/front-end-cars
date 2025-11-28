// lib/config/firebase_options.dart
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb, TargetPlatform;

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
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAmKs9KdLYhwj2gGDLk3nnUQDPEtcFxo5A',
    appId: '1:575089326122:android:ab26b752a3dbd6073c2b53',
    messagingSenderId: '575089326122',
    projectId: 'pamodzi-ccc3c',
    storageBucket: 'pamodzi-ccc3c.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAmKs9KdLYhwj2gGDLk3nnUQDPEtcFxo5A',
    appId: '1:575089326122:ios:abc123def456',
    messagingSenderId: '575089326122',
    projectId: 'pamodzi-ccc3c',
    storageBucket: 'pamodzi-ccc3c.firebasestorage.app',
    iosBundleId: 'com.example.magain',
  );

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyAmKs9KdLYhwj2gGDLk3nnUQDPEtcFxo5A',
    appId: '1:575089326122:web:abc123def456',
    messagingSenderId: '575089326122',
    projectId: 'pamodzi-ccc3c',
    storageBucket: 'pamodzi-ccc3c.firebasestorage.app',
  );
}
