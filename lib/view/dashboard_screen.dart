import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FF),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: Text(
          'City Staff Dashboard',
          style: GoogleFonts.poppins(
            color: Colors.black87,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.notifications_none,
              color: Colors.blueAccent,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: CircleAvatar(
              backgroundColor: Colors.blue.shade100,
              child: const Text(
                'V',
                style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),  
          ),
        ],
      ),
      body: SingleChildScrollView(
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
                    final List<dynamic> stat = s; // safely cast each list
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
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 500),
                  opacity: 1,
                  child: Text(
                    'No data available',
                    style: GoogleFonts.poppins(color: Colors.grey[600]),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            _buildSectionCard(
              title: 'Priority Case',
              child: Center(
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 600),
                  opacity: 1,
                  child: Text(
                    'No priority case found',
                    style: GoogleFonts.poppins(color: Colors.grey[600]),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            _buildSectionCard(
              title: 'My Cases',
              child: Column(
                children: [
                  _buildCaseTile(
                    '001',
                    '123 Main St',
                    'Zoning',
                    'High',
                    'Noise complaint',
                  ),
                  _buildCaseTile(
                    '002',
                    '45 Lake Rd',
                    'Safety',
                    'Medium',
                    'Unsafe structure',
                  ),
                  _buildCaseTile(
                    '003',
                    '99 Hill Ave',
                    'Health',
                    'Low',
                    'Debris issue',
                  ),
                ],
              ),
            ),
          ],
        ),
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
          AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 400),
            style: GoogleFonts.poppins(
              color: color,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
            child: Text(value),
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
    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOut,
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

  Widget _buildCaseTile(
    String caseNo,
    String address,
    String program,
    String priority,
    String description,
  ) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 350),
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: ListTile(
        title: Text(
          '#$caseNo • $program',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
        ),
        subtitle: Text(
          '$address\n$description',
          style: GoogleFonts.poppins(color: Colors.grey[600], fontSize: 12),
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: priority == 'High'
                ? Colors.redAccent.withOpacity(0.2)
                : priority == 'Medium'
                ? Colors.orangeAccent.withOpacity(0.2)
                : Colors.greenAccent.withOpacity(0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            priority,
            style: GoogleFonts.poppins(
              color: priority == 'High'
                  ? Colors.redAccent
                  : priority == 'Medium'
                  ? Colors.orange
                  : Colors.green,
              fontWeight: FontWeight.w500,
              fontSize: 12,
            ),
          ),
        ),
      ),
    );
  }
}
