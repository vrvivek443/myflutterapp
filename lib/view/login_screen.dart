import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../controller/microsoft_login_cubit.dart';
import '../controller/microsoft_login_state.dart';



class LoginScreen extends StatelessWidget {
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
                  color: Colors.white, // ✅ white background only for logo
                  borderRadius: BorderRadius.circular(6),
                ),
                padding: const EdgeInsets.all(4), // adds breathing room
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: Image.network(
                    'https://codeenforcementapp.web.app/assets/images/SJ_color_logo.png',
                    fit: BoxFit.contain, // ✅ show full image, no crop
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
          },
          builder: (context, state) {
            if (state is AuthLoading) {
              return Center(child: CircularProgressIndicator());
            }

            if (state is AuthSuccess) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Display profile photo if available
                    
                    SizedBox(height: 10),
                    Text("Welcome, ${state.name}", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    SizedBox(height: 10),
                    Text("Email: ${state.email}", style: TextStyle(fontSize: 16)),
                    SizedBox(height: 10),
                    Text("Job Title: ${state.jobTitle}", style: TextStyle(fontSize: 16)),
                    SizedBox(height: 10),
                    Text("Office Location: ${state.officeLocation}", style: TextStyle(fontSize: 16)),
                    SizedBox(height: 10),
                    Text("Department: ${state.department}", style: TextStyle(fontSize: 16)),
                    SizedBox(height: 10),
                    Text("Mobile: ${state.mobilePhone}", style: TextStyle(fontSize: 16)),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        context.read<AuthCubit>().logout(); // Call the logout method
                      },
                      child: Text("Logout"),
                    ),
                  ],
                ),
              );
            }

            return Center(
              child: ElevatedButton(
                onPressed: () {
                  context.read<AuthCubit>().login(); // call the login method
                },
                child: Text("Login with Microsoft"),
              ),
            );
          },
        ),
      ),
    );
  }
}


