import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../controller/microsoft_login_cubit.dart';
import '../controller/microsoft_login_state.dart';
import '../view/dashboard_screen.dart'; // ✅ Import your dashboard

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF084852),
        elevation: 0,
        title: Row(
          children: [
            Container(
              height: 36,
              width: 36,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(6),
              ),
              padding: const EdgeInsets.all(4),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: Image.network(
                  '[https://codeenforcementapp.web.app/assets/images/SJ_color_logo.png](https://codeenforcementapp.web.app/assets/images/SJ_color_logo.png)',
                  fit: BoxFit.contain,
                ),
              ),
            ),
            const SizedBox(width: 12),
            const Text(
              "Codex App",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      body: BlocProvider(
        create: (context) => AuthCubit(),
        child: BlocConsumer<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state is AuthError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Error: ${state.errorMessage}")),
              );
            }

            // ✅ When login is successful, navigate to Dashboard
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
              // ✅ We don't need to show UI here because navigation will occur
              return const SizedBox.shrink();
            }

            return Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF084852),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 14,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  context.read<AuthCubit>().login();
                },
                child: const Text(
                  "Login with Microsoft",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
