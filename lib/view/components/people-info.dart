import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PeopleInfoSection extends StatelessWidget {
  final GlobalKey<FormState> formKey;

  final List<dynamic> people;
  final VoidCallback onAddPerson;
  final Widget Function(dynamic person) peopleTileBuilder;
  final bool isNarrow;

  const PeopleInfoSection({
    super.key,
    required this.formKey,
    required this.people,
    required this.onAddPerson,
    required this.peopleTileBuilder,
    required this.isNarrow,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: _wrapCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'People Information',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),

            // People list
            ...people.map((p) => peopleTileBuilder(p)).toList(),

            const SizedBox(height: 8),

            Row(
              children: [
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0D6EFD),
                  ),
                  onPressed: onAddPerson,
                  icon: const Icon(Icons.person_add),
                  label: const Text('Add Person'),
                ),
                const SizedBox(width: 12),
                if (people.isNotEmpty)
                  Text(
                    '${people.length} person(s)',
                    style: GoogleFonts.poppins(),
                  ),
              ],
            ),

            const SizedBox(height: 8),

            Text(
              'Note: Add complainant or related persons',
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _wrapCard({required Widget child}) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: child,
      ),
    );
  }
}
