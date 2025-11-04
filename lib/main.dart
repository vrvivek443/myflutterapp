// import 'package:flutter/material.dart';

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(
//           backgroundColor: const Color(0xFF084852),
//           elevation: 0,
//           title: Row(
//             children: [
//               Container(
//                 height: 36,
//                 width: 36,
//                 decoration: BoxDecoration(
//                   color: Colors.white, // ✅ white background only for logo
//                   borderRadius: BorderRadius.circular(6),
//                 ),
//                 padding: const EdgeInsets.all(4), // adds breathing room
//                 child: ClipRRect(
//                   borderRadius: BorderRadius.circular(6),
//                   child: Image.network(
//                     'https://codeenforcementapp.web.app/assets/images/SJ_color_logo.png',
//                     fit: BoxFit.contain, // ✅ show full image, no crop
//                   ),
//                 ),
//               ),
//               const SizedBox(width: 12),
//               const Text(
//                 "Codex",
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ],
//           ),
//         ),
//         body: const Center(
//           child: Text(
//             "Welcome to Codex 💻",
//             style: TextStyle(
//               fontSize: 24,
//               fontWeight: FontWeight.w500,
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:myflutterapp/view/login_screen.dart';


void main() {
  runApp(MyApp());
}


final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,
      title: 'Azure SSO Login',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: LoginScreen(),
    );
  }
}

