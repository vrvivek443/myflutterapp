import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../view/new_complaint_screen.dart';
import '../view/case_search_screen.dart';

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
              backgroundColor: const Color(0xFF084852),
              title: Text(
                'City Staff',
                style: GoogleFonts.poppins(color: Colors.white),
              ),
            )
          : null,
      drawer: isMobile ? Drawer(child: _buildSideNav()) : null,
      body: Row(
        children: [
          if (!isMobile)
            Container(
              width: 250,
              color: const Color(0xFF084852),
              child: _buildSideNav(),
            ),
          Expanded(child: _buildDashboardContent()),
        ],
      ),
    );
  }

  Widget _buildSideNav() {
    return Container(
      color: const Color(0xFF084852),
      child: ListView(
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(color: Color(0xFF084852)),
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

  Widget _buildDashboardContent() {
    final screenWidth = MediaQuery.of(context).size.width;
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

              final stats = [
                [
                  'My Open Cases',
                  '3',
                  '+8.4% from last week',
                  Colors.pinkAccent,
                ],
                [
                  'My New Cases',
                  '0',
                  '+8.4% from last week',
                  Colors.blueAccent,
                ],
                [
                  'Priority Cases',
                  '1',
                  '+8.4% from last week',
                  Colors.orangeAccent,
                ],
                ['Closing Today', '0', '+8.4% from last week', Colors.teal],
                [
                  'Closing This Week',
                  '0',
                  '+8.4% from last week',
                  Colors.purpleAccent,
                ],
              ];

              return Wrap(
                spacing: 12,
                runSpacing: 12,
                children: stats.map((s) {
                  final List<dynamic> stat = s;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 400),
                    curve: Curves.easeOutCubic,
                    width: cardWidth,
                    child: _buildStatCard(
                      stat[0] as String,
                      stat[1] as String,
                      stat[2] as String,
                      stat[3] as Color,
                    ),
                  );
                }).toList(),
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
          const SizedBox(height: 8),
          Text(
            value,
            style: GoogleFonts.poppins(
              color: color,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            subtitle,
            style: GoogleFonts.poppins(
              color: Colors.grey,
              fontSize: 11,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionCard({required String title, required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
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
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
          const Divider(),
          const SizedBox(height: 8),
          child,
        ],
      ),
    );
  }
}
