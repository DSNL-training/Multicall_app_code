// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
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

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBym6JuViP1cxJ_Q4l4VyBWcb7E4_pcKa4',
    appId: '1:951881426170:android:dce774b40a63f300',
    messagingSenderId: '951881426170',
    projectId: 'multicall-40351',
    databaseURL: 'https://multicall-40351.firebaseio.com',
    storageBucket: 'multicall-40351.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCK26nJyj-BNygpCKCRWtkyGlohNIYnIKw',
    appId: '1:951881426170:ios:20d07575aa5d3514519543',
    messagingSenderId: '951881426170',
    projectId: 'multicall-40351',
    databaseURL: 'https://multicall-40351.firebaseio.com',
    storageBucket: 'multicall-40351.appspot.com',
    androidClientId: '951881426170-lrorufea658ngkl6qa5gl213ecuok507.apps.googleusercontent.com',
    iosBundleId: 'com.f22labs.multicall',
  );

}