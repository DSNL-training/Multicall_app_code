import 'dart:developer';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:multicall_mobile/models/auth_user.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class AuthHandler {
  //Default definition
  final storage = const FlutterSecureStorage();

  Future<AuthUser> appleSignIn() async {
    try {
      if (!Platform.isIOS) {
        throw "Platform not supported";
      }
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      if (credential.givenName != null && credential.familyName != null) {
        await storage.write(
            key: 'username',
            value: '${credential.givenName} ${credential.familyName}');
      } else if (credential.givenName != null &&
          credential.familyName == null) {
        await storage.write(
          key: 'username',
          value: credential.givenName,
        );
      } else if (credential.givenName == null &&
          credential.familyName != null) {
        await storage.write(
          key: 'username',
          value: credential.familyName,
        );
      }

      if (credential.email != null) {
        await storage.write(
          key: 'email',
          value: credential.email,
        );
      }

      String? username = await storage.read(key: 'username');
      String? email = await storage.read(key: 'email');

      return AuthUser(
        email: email ?? "",
        name: username ?? "",
        telephone: 'telephone',
      );
    } catch (e) {
      log(e.toString());
      throw "Error during SSO";
    }
  }

  Future<AuthUser> googleSignIn() async {
    const scopes = [
      'email',
      'profile',
      'https://www.googleapis.com/auth/userinfo.email',
      'https://www.googleapis.com/auth/userinfo.profile',
    ];
    try {
      GoogleSignIn googleSignIn = GoogleSignIn(
        scopes: scopes,
      );

//If current device is Web or Android, do not use any parameters except from scopes.
      if (kIsWeb || Platform.isAndroid) {
        googleSignIn = GoogleSignIn(
          scopes: scopes,
        );
      }

//If current device IOS or MacOS, We have to declare clientID
//Please, look STEP 2 for how to get Client ID for IOS
      if (Platform.isIOS || Platform.isMacOS) {
        googleSignIn = GoogleSignIn(
          clientId:
              "299299987756-l1qpiaktj1b0jmr0sn6n1oqjbmlfhjfa.apps.googleusercontent.com",
          scopes: scopes,
        );
      }

      // Sign out the current user, if any, to reset the handler
      await googleSignIn.signOut();

      final GoogleSignInAccount? googleAccount = await googleSignIn.signIn();

// //If you want further information about Google accounts, such as authentication, use this.
      final GoogleSignInAuthentication googleAuthentication =
          await googleAccount!.authentication;

      debugPrint(googleAuthentication.accessToken);
      return AuthUser(
          email: googleAccount.email,
          name: googleAccount.displayName ?? "",
          telephone: "");
    } catch (e) {
      log(e.toString());
      throw "Error during SSO";
    }
  }
}
