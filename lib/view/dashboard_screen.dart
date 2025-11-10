import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controller/microsoft_login_cubit.dart';
import '../view/login_screen.dart';
import '../services/api.dart';
import 'package:dio/dio.dart';
import 'package:myflutterapp/view/new_complaint_screen.dart';
import 'package:myflutterapp/view/case_search_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  bool caseManagementExpanded = false;
  int selectedIndex = 0;

  void _navigateTo(int index) {
    setState(() => selectedIndex = index);

    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const DashboardScreen()),
        );
        break;
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const NewComplaintScreen()),
        );
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const CaseSearchScreen()),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 700;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FF),
      appBar: isMobile
          ? AppBar(
              backgroundColor:const Color(0xFF0D6EFD),
              iconTheme: const IconThemeData(color: Colors.white),
              title: Text(
                'City Staff',
                style: GoogleFonts.poppins(color: Colors.white),
              ),
            )
          : null,
      drawer: isMobile
          ? Drawer(
              backgroundColor: Colors.white,
              child: _buildSideNav(),
            )
          : null,
      body: Row(
        children: [
          if (!isMobile)
            Container(
              width: 250,
              color: const Color(0xFF0D6EFD),
              child: _buildSideNav(),
            ),
          Expanded(child: _buildDashboardContent()),
        ],
      ),
    );
  }

  Widget _buildSideNav() {
  return Container(
    color: const Color(0xFF0D6EFD),
    child: SafeArea(
      child: Column(
        children: [
          // Drawer Header
          DrawerHeader(
            decoration: const BoxDecoration(color: Color(0xFF0D6EFD)),
            child: Row(
              children: [
                const Icon(Icons.business, color: Colors.white, size: 36),
                const SizedBox(width: 10),
                Text(
                  "City Staff",
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),

          // Navigation Items (scrollable)
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildNavItem(Icons.dashboard, "Dashboard", 0),
                ExpansionTile(
                  collapsedIconColor: Colors.white,
                  iconColor: Colors.white,
                  leading: const Icon(Icons.folder_shared, color: Colors.white),
                  title: Text(
                    "Case Management",
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  initiallyExpanded: caseManagementExpanded,
                  onExpansionChanged: (expanded) {
                    setState(() => caseManagementExpanded = expanded);
                  },
                  children: [
                    _buildSubNavItem(Icons.add_circle_outline, "New Complaint", 1),
                    _buildSubNavItem(Icons.search, "Case Search", 2),
                  ],
                ),
              ],
            ),
          ),

          const Divider(color: Colors.white70),

          // Logout button at bottom
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: _buildLogoutButton(),
            ),
          ),
        ],
      ),
    ),
  );
}

  Widget _buildLogoutButton() {
  return Padding(
    padding: const EdgeInsets.only(top: 16, bottom: 20),
    child: TextButton.icon(
      onPressed: _logout, // Call logout function
      icon: const Icon(Icons.logout, color: Colors.white),
      label: const Text(
        "Logout",
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w500,
        ),
      ),
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all(Colors.transparent),
        overlayColor: WidgetStateProperty.all(
          Colors.white.withOpacity(0.1), // soft hover ripple
        ),
        padding: WidgetStateProperty.all(
          const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        ),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    ),
  );
}


  Future<void> _logout() async {
    try {
      // Call the logout function from the AuthCubit to handle Microsoft OAuth logout
      await context.read<AuthCubit>().logout(); // This handles the Microsoft OAuth logout

      // Navigate to Login Screen after logout
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()), // Navigate to the login screen
      );
    } catch (e) {
      // Handle any errors that occur during the logout process
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error logging out: $e')),
      );
    }
  }


  Widget _buildNavItem(IconData icon, String title, int index) {
    final isSelected = selectedIndex == index;
    return ListTile(
      leading: Icon(icon, color: isSelected ? Colors.amber : Colors.white),
      title: Text(
        title,
        style: GoogleFonts.poppins(
          color: isSelected ? Colors.amber : Colors.white,
          fontWeight: FontWeight.w500,
        ),
      ),
      tileColor: isSelected ? Colors.black26 : Colors.transparent,
      onTap: () => _navigateTo(index),
    );
  }

  Widget _buildSubNavItem(IconData icon, String title, int index) {
    final isSelected = selectedIndex == index;
    return ListTile(
      leading: Icon(icon, color: Colors.white, size: 20),
      title: Text(
        title,
        style: GoogleFonts.poppins(
          color: isSelected ? Colors.amber : Colors.white,
          fontWeight: FontWeight.w400,
        ),
      ),
      tileColor: isSelected ? Colors.black26 : Colors.transparent,
      contentPadding: const EdgeInsets.only(left: 40, right: 8),
      onTap: () => _navigateTo(index),
    );
  }

  Widget _buildDashboardContent() {
  return FutureBuilder<Response>(
    future: API().getDashboardData(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(child: CircularProgressIndicator());
      }

      if (snapshot.hasError) {
        return Center(
          child: Text(
            'Error loading dashboard data: ${snapshot.error}',
            style: GoogleFonts.poppins(color: Colors.redAccent),
          ),
        );
      }

      if (!snapshot.hasData || snapshot.data?.data == null) {
        return Center(
          child: Text(
            'No data available',
            style: GoogleFonts.poppins(color: Colors.grey[600]),
          ),
        );
      }

      final rawData = snapshot.data!.data;
      print("📊 Dashboard API Raw Response: $rawData");

      final widgets = rawData['dashboard']?['widgets'];
      if (widgets == null || widgets is! List) {
        return Center(
          child: Text(
            'No widgets found in dashboard data.',
            style: GoogleFonts.poppins(color: Colors.grey[600]),
          ),
        );
      }

      final colorPalette = [
        Colors.pinkAccent,
        Colors.blueAccent,
        Colors.orangeAccent,
        Colors.teal,
        Colors.purpleAccent,
        Colors.green,
      ];

      return SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LayoutBuilder(
              builder: (context, constraints) {
                int columns = constraints.maxWidth > 400 ? 2 : 1;
                double cardWidth =
                    (constraints.maxWidth - (12 * (columns - 1))) / columns;

                return Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: List.generate(widgets.length, (index) {
                    final item = widgets[index];
                    final color = colorPalette[index % colorPalette.length];

                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 400),
                      curve: Curves.easeOutCubic,
                      width: cardWidth,
                      child: _buildStatCard(
                        item['displaytext'] ?? 'Unknown',
                        item['displaycount'].toString(),
                        '+0% from last week',
                        color,
                      ),
                    );
                  }),
                );
              },
            ),
            const SizedBox(height: 20),
            _buildSectionCard(
              title: 'Open/Close Case by Program',
              child: Center(
                child: Text(
                  'No data available',
                  style: GoogleFonts.poppins(color: Colors.grey[600]),
                ),
              ),
            ),
            const SizedBox(height: 16),
            _buildSectionCard(
              title: 'Priority Case',
              child: Center(
                child: Text(
                  'No priority case found',
                  style: GoogleFonts.poppins(color: Colors.grey[600]),
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}



  Widget _buildStatCard(
    String title,
    String value,
    String subtitle,
    Color color,
  ) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.poppins(
              color: Colors.black87,
              fontWeight: FontWeight.w500,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: GoogleFonts.poppins(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 22,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: GoogleFonts.poppins(
              color: Colors.black45,
              fontWeight: FontWeight.w400,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required Widget child,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: GoogleFonts.poppins(
                color: Colors.black87,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 12),
            child,
          ],
        ),
      ),
    );
  }
}
