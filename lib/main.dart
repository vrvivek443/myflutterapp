import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'controller/microsoft_login_cubit.dart'; // Import your AuthCubit
import 'view/login_screen.dart'; // Import the LoginScreen

// Define the navigatorKey globally
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() {
  runApp(
    // Wrap your app with BlocProvider for AuthCubit
    BlocProvider<AuthCubit>(
      create: (context) => AuthCubit(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey, // Pass the navigatorKey here
      title: 'Azure SSO Login',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const LoginScreen(), // Starting screen
    );
  }
}
