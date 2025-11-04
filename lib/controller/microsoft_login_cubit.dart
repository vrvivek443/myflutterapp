// microsoft_login_cubit.dart
import 'dart:convert';
import 'package:aad_oauth/aad_oauth.dart';
import 'package:aad_oauth/model/config.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../main.dart';
import '../services/api.dart';
import 'microsoft_login_state.dart';

class AuthCubit extends Cubit<AuthState> {
  late AadOAuth oauth;

  AuthCubit() : super(AuthInitial()) {
    final Config config = Config(
      tenant: "4414c298-bd53-489e-a563-86fad2336547",
      clientId: "bd25ac3c-a023-4118-a45c-1ca7302f97fe",
      scope: "openid profile offline_access User.Read",
      redirectUri: "com.example.myflutterapp://auth",
      navigatorKey: navigatorKey,
      responseType: "code",
    );
    oauth = AadOAuth(config);
  }

  Future<void> login() async {
    emit(AuthLoading());
    try {
      // Initiate login
      await oauth.login();
      final accessToken = await oauth.getAccessToken();

      if (accessToken == null) {
        emit(AuthError("Access token is null. Login failed."));
        return;
      }

      print("Access Token: $accessToken");

      try {
        // Fetch user details from Microsoft Graph
        Response jsonResponse = await API().getUserDetails(token: accessToken);
        print("================================");
        print("User Details: ${jsonResponse.data}");
        print("================================");

        // Parse user details from the Graph API response
        final Map<String, dynamic> userData = jsonResponse.data;
        final String username = userData['userPrincipalName'] ?? 'Not Available'; // or 'displayName'
        final String name = userData['displayName'] ?? 'Not Available';
        final String email = userData['mail'] ?? 'Not Available';
        final String mobilePhone = userData['mobilePhone'] ?? 'Not Available';
        final String jobTitle = userData['jobTitle'] ?? 'Not Available';
        final String officeLocation = userData['officeLocation'] ?? 'Not Available';
        final String department = userData['department'] ?? 'Not Available';

        // Now fetch additional user data from another API
        Response secondApiResponse = await API().getUserByUsername(username);
        print("Second API Response: ${secondApiResponse.data}");

        // Assuming the second API returns additional details like role or profile info
        final Map<String, dynamic> secondApiData = secondApiResponse.data;
        final String role = secondApiData['role'] ?? 'Not Available'; // Example from second API

        // Emit success with combined user details from both APIs
        emit(AuthSuccess(name, email, mobilePhone, jobTitle, officeLocation, department));

      } catch (apiError) {
        print("Error fetching user details: $apiError");
        emit(AuthError("Failed to fetch user details."));
      }
    } catch (e) {
      print("Login Error: $e");
      emit(AuthError("Login failed. Please try again."));
    }
  }

  Future<void> logout() async {
    try {
      await oauth.logout();  // Logout from Azure OAuth
      emit(AuthInitial());   // Reset state to initial
    } catch (e) {
      emit(AuthError("Logout failed. Please try again."));
    }
  }
}
