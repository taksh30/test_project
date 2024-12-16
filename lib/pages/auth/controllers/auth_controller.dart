import 'dart:convert';

import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:test_project/services/shared_preferences.dart';
import 'package:http/http.dart' as http;

class AuthController extends GetxController {
  String? userToken;

  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email'],
  );

  // sign in with Google
  Future<String?> signInWithGoogle() async {
    try {
      // call the google sign in
      final GoogleSignInAccount? account = await _googleSignIn.signIn();

      if (account == null) {
        print('Acccount is null');
        return null;
      }

      // get the authentication access token
      final GoogleSignInAuthentication authentication =
          await account.authentication;

          print(authentication.accessToken);

      return authentication.accessToken;
      
    } catch (error) {
      print("Error signing in with Google: $error");
      return null;
    }
  }

  // on social login
  Future<void> onSocialLogin(String socialAuthToken) async {
    const String url =
        "https://aaloo-dev-api.scaleupdevops.in/v1/api/auth/social-login";

    final body = jsonEncode({
      "signupMethod": "google",
      "socialAuthToken": socialAuthToken,
      "deviceInfo": {"device": "android"},
    });

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: body,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['data'] != null && data['data']['token'] != null) {
          // get the token
          final String token = data['data']['token'];

          userToken = token;

          // save the token locally
          await saveToken(token);

          print("Login successful. Token: $token");
        } else {
          print("Login failed. Token not found.");
        }
      } else {
        print("Error: ${response.statusCode} - ${response.body}");
      }
    } catch (error) {
      print("Error calling social login API: $error");
    }
  }

  // login with auth token
  Future<void> loginWithAuthToken() async {
    final socialAuthToken = await signInWithGoogle();
    // check if the token is not null
    if (socialAuthToken != null) {
      await onSocialLogin(socialAuthToken);
    } else {
      print("Google sign-in failed.");
    }
  }
}
