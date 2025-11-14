import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PropertyInfoSection extends StatelessWidget {
  final GlobalKey<FormState> formKey;

  final TextEditingController apnController;
  final TextEditingController aptController;
  final TextEditingController streetNoController;
  final TextEditingController streetNameController;
  final TextEditingController districtController;
  final TextEditingController cityController;
  final TextEditingController stateController;
  final TextEditingController zipController;

  final bool isNarrow;

  const PropertyInfoSection({
    super.key,
    required this.formKey,
    required this.apnController,
    required this.aptController,
    required this.streetNoController,
    required this.streetNameController,
    required this.districtController,
    required this.cityController,
    required this.stateController,
    required this.zipController,
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
              'Property Information',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                _sizedField(controller: apnController, label: 'APN Number', width: isNarrow ? double.infinity : 220),
                _sizedField(controller: aptController, label: 'Apartment Number', width: isNarrow ? double.infinity : 180),
                _sizedField(controller: streetNoController, label: 'Street Number', width: isNarrow ? double.infinity : 140),
                _sizedField(controller: streetNameController, label: 'Street Name', width: isNarrow ? double.infinity : 220),
                _sizedField(controller: districtController, label: 'District', width: isNarrow ? double.infinity : 220),
                _sizedField(controller: cityController, label: 'City', width: isNarrow ? double.infinity : 150),
                _sizedField(controller: stateController, label: 'State', width: isNarrow ? double.infinity : 120),
                _sizedField(controller: zipController, label: 'Zip', width: isNarrow ? double.infinity : 120),
              ],
            ),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0D6EFD),
                ),
                icon: const Icon(Icons.map),
                label: const Text('View Map'),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Map view (mock)')),
                  );
                },
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
      child: Padding(padding: const EdgeInsets.all(16), child: child),
    );
  }

  Widget _sizedField({required TextEditingController controller, required String label, required double width}) {
    return SizedBox(
      width: width,
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}
