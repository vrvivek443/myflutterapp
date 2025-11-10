import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../controller/microsoft_login_cubit.dart';
import '../controller/microsoft_login_state.dart';
import 'dashboard_screen.dart'; // Import the DashboardScreen

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D6EFD),  // Set the background color to 0xFF084852
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D6EFD),
        elevation: 0,
        title: Row(
          children: const [
            SizedBox(width: 12), // Adding some space to the left
          ],
        ),
      ),
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Error: ${state.errorMessage}")),
            );
          }

          // Navigate to DashboardScreen if login is successful
          if (state is AuthSuccess) {
            Future.microtask(() {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const DashboardScreen()),
              );
            });
          }
        },
        builder: (context, state) {
          if (state is AuthLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is AuthSuccess) {
            return const SizedBox.shrink(); // No UI while navigating
          }

          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0), // Add padding around the screen's content
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center, // Center the content vertically
                crossAxisAlignment: CrossAxisAlignment.center, // Center the content horizontally
                children: [
                  // Logo
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: Image.network(
                      'https://codeenforcementapp.web.app/assets/images/SJ_color_logo.png',
                      height: 100, // Set the height of the logo
                      fit: BoxFit.contain,
                    ),
                  ),

                  const SizedBox(height: 20), // Space between the logo and the text

                  // Codex App Text (centered at the top)
                  const Text(
                    "Codex App",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 30, // Make the title big and bold
                    ),
                  ),

                  const SizedBox(height: 30), // Space between the title and the button

                  // Login with Microsoft Button
                  TextButton(
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 14,
                      ),
                      foregroundColor: Colors.white, // Default text color (white)
                      textStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold, // Bold text
                      ),
                    ).copyWith(
                      // Set the hover and pressed states for the button
                      overlayColor: WidgetStateProperty.all(Colors.transparent), // Remove the default overlay color
                      backgroundColor: WidgetStateProperty.all(Colors.transparent), // Make sure the button stays transparent
                      textStyle: WidgetStateProperty.resolveWith<TextStyle>((states) {
                        if (states.contains(WidgetState.hovered)) {
                          return const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0D6EFD),  // Blue color when hovered
                          );
                        }
                        return const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,  // Default text color is white
                        );
                      }),
                    ),
                    onPressed: () {
                      context.read<AuthCubit>().login(); // Trigger login on press
                    },
                    child: const Text(
                      "Login with Microsoft",
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
