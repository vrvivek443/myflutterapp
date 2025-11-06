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
    // Step 1: Microsoft OAuth login
    await oauth.login();
    final accessToken = await oauth.getAccessToken();

    if (accessToken == null) {
      emit(AuthError("Access token is null. Login failed."));
      return;
    }

    print("Access Token: $accessToken");

    // Step 2: Get Graph user to find username
    Response jsonResponse = await API().getUserDetails(token: accessToken);
    print("================================");
    print("User Details (Graph): ${jsonResponse.data}");
    print("================================");

    final Map<String, dynamic> graphData = jsonResponse.data;
    final String username = graphData['userPrincipalName'] ?? 'Not Available';

    // Step 3: Get user details from second API
    Response secondApiResponse = await API().getUserByUsername(username);
    print("Second API Response: ${secondApiResponse.data}");

    // Example structure: { data: [ { id: 46, name: ..., email: ..., phone: ..., role: {...}, userProfiles: [...] } ] }
    final List<dynamic> dataList = secondApiResponse.data['data'] ?? [];
    if (dataList.isEmpty) {
      emit(AuthError("No user data found in second API response."));
      return;
    }

    final Map<String, dynamic> user = dataList[0];
    final String name = user['name'] ?? 'Not Available';
    final String email = user['email'] ?? 'Not Available';
    final String? phone = user['phone'];
    final String? roleName = user['role']?['rolename'];
    final dynamic userProfiles = user['userProfiles'];

    emit(AuthSuccess(
      name: name,
      email: email,
      phone: phone,
      roleName: roleName,
      userProfiles: userProfiles,
      jobTitle: graphData['jobTitle'],
      officeLocation: graphData['officeLocation'],
      department: graphData['department'],
    ));
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
