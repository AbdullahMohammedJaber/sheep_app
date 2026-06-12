// import 'dart:developer';

// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/services.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:sign_in_with_apple/sign_in_with_apple.dart';

// class SochialGoogleAppleLogin {
//   SochialGoogleAppleLogin._();

//  static Future<UserCredential?> signInWithGoogle() async {
//     try {
//       final GoogleSignIn googleSignIn = GoogleSignIn(scopes: ['email']);

//       await googleSignIn.signOut();

//       final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

//       if (googleUser == null) {
//         return null;
//       }

//       final GoogleSignInAuthentication googleAuth =
//           await googleUser.authentication;

//       if (googleAuth.idToken == null) {
//         return null;
//       }

//       final OAuthCredential credential = GoogleAuthProvider.credential(
//         idToken: googleAuth.idToken,
//         accessToken: googleAuth.accessToken,
//       );

//       final UserCredential userCredential = await FirebaseAuth.instance
//           .signInWithCredential(credential);

//       return userCredential;
//     } on FirebaseAuthException catch (e) {
//       log(e.toString());
//       return null;
//     } on PlatformException catch (e) {
//       log(e.toString());
//       return null;
//     } catch (e, s) {
//       log(s.toString());
//       return null;
//     }
//   }
//   static Future<UserCredential?> signInWithApple() async {
//     try {
//       final appleCredential = await SignInWithApple.getAppleIDCredential(
//         scopes: [
//           AppleIDAuthorizationScopes.email,
//           AppleIDAuthorizationScopes.fullName,
//         ],
//       );

//       final oauthCredential = OAuthProvider("apple.com").credential(
//         idToken: appleCredential.identityToken,
//         accessToken: appleCredential.authorizationCode,
//       );

//       final UserCredential userCredential =
//           await FirebaseAuth.instance.signInWithCredential(oauthCredential);

//       return userCredential;
//     } on FirebaseAuthException catch (e) {
//       log('Apple Auth Error: $e');
//       return null;
//     } on PlatformException catch (e) {
//       log('Platform Error: $e');
//       return null;
//     } catch (e, s) {
//       log('Unknown Error: $s');
//       return null;
//     }
//   }
// }
