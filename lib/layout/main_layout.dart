import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../controller/microsoft_login_cubit.dart';
import '../view/login_screen.dart';
import '../view/dashboard_screen.dart';
import '../view/new_complaint_screen.dart';
import '../view/case_search_screen.dart';

class MainLayout extends StatefulWidget {
  final Widget child;
  final int selectedIndex;

  const MainLayout({
    super.key,
    required this.child,
    this.selectedIndex = 0,
  });

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int selectedIndex = 0;
  bool caseManagementExpanded = false;

  @override
  void initState() {
    super.initState();
    selectedIndex = widget.selectedIndex;
  }

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
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const NewComplaintScreen()),
        );
        break;
      case 2:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const CaseSearchScreen()),
        );
        break;
    }
  }

  Future<void> _logout() async {
    try {
      await context.read<AuthCubit>().logout();

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error logging out: $e')),
      );
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
              backgroundColor: const Color(0xFF0D6EFD),
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
          Expanded(child: widget.child),
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

            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  _buildNavItem(Icons.dashboard, "Dashboard", 0),
                  ExpansionTile(
                    collapsedIconColor: Colors.white,
                    iconColor: Colors.white,
                    leading:
                        const Icon(Icons.folder_shared, color: Colors.white),
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
                      _buildSubNavItem(
                          Icons.add_circle_outline, "New Complaint", 1),
                      _buildSubNavItem(Icons.search, "Case Search", 2),
                    ],
                  ),
                ],
              ),
            ),

            const Divider(color: Colors.white70),

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
        onPressed: _logout,
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
            Colors.white.withOpacity(0.1),
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
}

