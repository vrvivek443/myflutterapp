
// import 'dart:convert';
// import 'dart:typed_data';

// import 'package:aad_oauth/aad_oauth.dart';
// import 'package:aad_oauth/model/config.dart';
// import 'package:dio/dio.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// import '../main.dart';
// import '../services/api.dart';
// import 'microsoft_login_state.dart';


// class AuthCubit extends Cubit<AuthState> {
//   late AadOAuth oauth;

//   AuthCubit() : super(AuthInitial()) {
//     final Config config = Config(
//       tenant: "4414c298-bd53-489e-a563-86fad2336547",
//       clientId: "bd25ac3c-a023-4118-a45c-1ca7302f97fe",
//       scope: "openid profile offline_access User.Read",
//       redirectUri: "https://localhost:4200/",
//       navigatorKey: navigatorKey,
//     );
//     oauth = AadOAuth(config);
//   }

//   Future<void> login() async {
//     emit(AuthLoading());
//     try {
//       // Initiate login
//       await oauth.login();
//       final accessToken = await oauth.getAccessToken();

//       if (accessToken == null) {
//         emit(AuthError("Access token is null. Login failed."));
//         return;
//       }

//       print("Access Token: $accessToken");

//       try {
//         // Fetch user details
//         Response jsonResponse = await API().getUserDetails(token: accessToken);
//         print("================================");
//         print("User Details: ${jsonResponse.data}");
//         print("================================");

//         // Parse user details
//         final Map<String, dynamic> userData = jsonResponse.data;
//         final String name = userData['displayName'] ?? 'Not Available';
//         final String email = userData['mail'] ?? 'Not Available';
//         final String mobilePhone = userData['mobilePhone'] ?? 'Not Available';
//         final String jobTitle = userData['jobTitle'] ?? 'Not Available';
//         final String officeLocation = userData['officeLocation'] ?? 'Not Available';
//         final String department = userData['department'] ?? 'Not Available';

//         // Fetch profile photo
//         Response photoResponse = await API().getProfileImage(token: accessToken);
//         print("--------------------------------");
//         print(photoResponse.data);
//         print("--------------------------------");

//           // Convert binary data to Uint8List for display
//           Uint8List? photo;
//           if (photoResponse.data != null && photoResponse.data is List<int>) {
//             photo = Uint8List.fromList(photoResponse.data);  // Convert byte data to Uint8List
//           }

//           // Emit success with user details and profile photo
//           emit(AuthSuccess(photo, name, email, mobilePhone, jobTitle, officeLocation, department));


//       } catch (apiError) {
//         print("Error fetching user details or photo: $apiError");
//         emit(AuthError("Failed to fetch user details or profile photo."));
//       }
//     } catch (e) {
//       print("Login Error: $e");
//       emit(AuthError("Login failed. Please try again."));
//     }
//   }

//   Future<void> logout() async {
//     try {
//       await oauth.logout();  // Logout from Azure OAuth
//       emit(AuthInitial());   // Reset state to initial
//     } catch (e) {
//       emit(AuthError("Logout failed. Please try again."));
//     }
//   }

// }

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
      redirectUri: "https://localhost:4200/",
      navigatorKey: navigatorKey,
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
        // Fetch user details
        Response jsonResponse = await API().getUserDetails(token: accessToken);
        print("================================");
        print("User Details: ${jsonResponse.data}");
        print("================================");

        // Parse user details
        final Map<String, dynamic> userData = jsonResponse.data;
        final String name = userData['displayName'] ?? 'Not Available';
        final String email = userData['mail'] ?? 'Not Available';
        final String mobilePhone = userData['mobilePhone'] ?? 'Not Available';
        final String jobTitle = userData['jobTitle'] ?? 'Not Available';
        final String officeLocation = userData['officeLocation'] ?? 'Not Available';
        final String department = userData['department'] ?? 'Not Available';

        // Emit success with user details (without profile photo)
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
