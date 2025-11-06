// new_complaint_screen.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NewComplaintScreen extends StatefulWidget {
  const NewComplaintScreen({super.key});

  @override
  State<NewComplaintScreen> createState() => _NewComplaintScreenState();
}

class _NewComplaintScreenState extends State<NewComplaintScreen> {
  int _currentStep = 0;

  // Forms & controllers
  final _propertyFormKey = GlobalKey<FormState>();
  final _peopleFormKey = GlobalKey<FormState>();
  final _caseFormKey = GlobalKey<FormState>();
  final _inspectorFormKey = GlobalKey<FormState>();
  final _violationsFormKey = GlobalKey<FormState>();
  final _actionFormKey = GlobalKey<FormState>();

  // Property controllers
  final TextEditingController apnController = TextEditingController();
  final TextEditingController aptController = TextEditingController();
  final TextEditingController streetNoController = TextEditingController();
  final TextEditingController streetNameController = TextEditingController();
  final TextEditingController districtController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController stateController = TextEditingController();
  final TextEditingController zipController = TextEditingController();

  // Case details controllers
  final TextEditingController caseTitleController = TextEditingController();
  final TextEditingController caseDescController = TextEditingController();
  String casePriority = 'Medium';
  String caseCategory = 'Zoning';
  DateTime? reportedDate;

  // Inspector controllers
  String inspectorName = 'Unassigned';
  String inspectorDepartment = '';
  DateTime? assignedDate;
  String inspectorStatus = 'Assigned';

  // Dynamic lists
  final List<Person> people = [];
  final List<Violation> violations = [];
  final List<ActionLog> actionLogs = [];

  // helper lists
  final List<String> priorities = ['Low', 'Medium', 'High'];
  final List<String> categories = ['Zoning', 'Health', 'Safety', 'Other'];

  @override
  void dispose() {
    apnController.dispose();
    aptController.dispose();
    streetNoController.dispose();
    streetNameController.dispose();
    districtController.dispose();
    cityController.dispose();
    stateController.dispose();
    zipController.dispose();

    caseTitleController.dispose();
    caseDescController.dispose();

    super.dispose();
  }

  final steps = [
    "Property Info",
    "People Info",
    "Case Details",
    "Case Inspector",
    "Violations",
    "Action Log",
  ];

  void _nextStep() {
    if (_currentStep == 0 && !_propertyFormKey.currentState!.validate()) return;
    if (_currentStep == 1 && !_peopleFormKey.currentState!.validate()) return;
    if (_currentStep == 2 && !_caseFormKey.currentState!.validate()) return;
    if (_currentStep == 3 && !_inspectorFormKey.currentState!.validate())
      return;
    if (_currentStep == 4 && !_violationsFormKey.currentState!.validate())
      return;
    if (_currentStep < steps.length - 1) {
      setState(() => _currentStep++);
    } else {
      _submit();
    }
  }

  void _prevStep() {
    if (_currentStep > 0) setState(() => _currentStep--);
  }

  void _submit() {
    // Mock submit — you can replace this with real API call
    final snack = SnackBar(
      content: const Text('New Complaint submitted (mock)'),
      duration: const Duration(seconds: 2),
    );
    ScaffoldMessenger.of(context).showSnackBar(snack);
  }

  Future<DateTime?> _pickDate(BuildContext ctx, DateTime? initial) async {
    final now = DateTime.now();
    final res = await showDatePicker(
      context: ctx,
      initialDate: initial ?? now,
      firstDate: DateTime(now.year - 5),
      lastDate: DateTime(now.year + 5),
    );
    return res;
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isNarrow = width < 700;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FF),
      appBar: AppBar(
        title: Text('New Complaint', style: GoogleFonts.poppins()),
        backgroundColor: const Color(0xFF084852),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildStepperHeader(isNarrow),
            const SizedBox(height: 16),
            _buildStepContent(isNarrow),
            const SizedBox(height: 20),
            _buildControls(),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildStepperHeader(bool isNarrow) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(steps.length, (index) {
          final isActive = _currentStep == index;
          final isCompleted = index < _currentStep;
          return Row(
            children: [
              GestureDetector(
                onTap: () => setState(() => _currentStep = index),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: isActive ? 18 : 16,
                      backgroundColor: isActive
                          ? const Color(0xFF084852)
                          : isCompleted
                          ? Colors.teal
                          : Colors.grey.shade300,
                      child: Text(
                        '${index + 1}',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    SizedBox(
                      width: isNarrow ? 86 : 120,
                      child: Text(
                        steps[index],
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: isActive
                              ? const Color(0xFF084852)
                              : Colors.black54,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              if (index < steps.length - 1)
                Container(
                  width: 36,
                  height: 2,
                  color: Colors.grey.shade300,
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                ),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildStepContent(bool isNarrow) {
    switch (_currentStep) {
      case 0:
        return _buildPropertyInfo(isNarrow);
      case 1:
        return _buildPeopleInfo(isNarrow);
      case 2:
        return _buildCaseDetails(isNarrow);
      case 3:
        return _buildCaseInspector(isNarrow);
      case 4:
        return _buildViolations(isNarrow);
      case 5:
        return _buildActionLog(isNarrow);
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _wrapCard({required Widget child}) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(padding: const EdgeInsets.all(16), child: child),
    );
  }

  // -----------------------
  // 1. Property Info UI
  // -----------------------
  Widget _buildPropertyInfo(bool isNarrow) {
    return Form(
      key: _propertyFormKey,
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
                _sizedField(
                  controller: apnController,
                  label: 'APN Number',
                  width: isNarrow ? double.infinity : 220,
                ),
                _sizedField(
                  controller: aptController,
                  label: 'Apartment Number',
                  width: isNarrow ? double.infinity : 180,
                ),
                _sizedField(
                  controller: streetNoController,
                  label: 'Street Number',
                  width: isNarrow ? double.infinity : 140,
                ),
                _sizedField(
                  controller: streetNameController,
                  label: 'Street Name',
                  width: isNarrow ? double.infinity : 220,
                ),
                _sizedField(
                  controller: districtController,
                  label: 'District',
                  width: isNarrow ? double.infinity : 220,
                ),
                _sizedField(
                  controller: cityController,
                  label: 'City',
                  width: isNarrow ? double.infinity : 150,
                ),
                _sizedField(
                  controller: stateController,
                  label: 'State',
                  width: isNarrow ? double.infinity : 120,
                ),
                _sizedField(
                  controller: zipController,
                  label: 'Zip',
                  width: isNarrow ? double.infinity : 120,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF084852),
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

  // -----------------------
  // 2. People Info UI
  // -----------------------
  Widget _buildPeopleInfo(bool isNarrow) {
    return Form(
      key: _peopleFormKey,
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
            ...people.map((p) => _peopleTile(p)).toList(),
            const SizedBox(height: 8),
            Row(
              children: [
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF084852),
                  ),
                  onPressed: () => _showAddPersonDialog(),
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
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _peopleTile(Person p) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 2),
      title: Text(
        p.name,
        style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
      ),
      subtitle: Text(
        '${p.phone ?? '-'} • ${p.email ?? '-'}',
        style: GoogleFonts.poppins(),
      ),
      trailing: IconButton(
        icon: const Icon(Icons.delete_outline, color: Colors.red),
        onPressed: () => setState(() => people.remove(p)),
      ),
    );
  }

  void _showAddPersonDialog() {
    final nameC = TextEditingController();
    final phoneC = TextEditingController();
    final emailC = TextEditingController();
    final relationC = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text('Add Person', style: GoogleFonts.poppins()),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: nameC,
                  decoration: const InputDecoration(labelText: 'Name'),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: phoneC,
                  decoration: const InputDecoration(labelText: 'Phone'),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: emailC,
                  decoration: const InputDecoration(labelText: 'Email'),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: relationC,
                  decoration: const InputDecoration(labelText: 'Relationship'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF084852),
              ),
              onPressed: () {
                final p = Person(
                  name: nameC.text.trim(),
                  phone: phoneC.text.trim(),
                  email: emailC.text.trim(),
                  relation: relationC.text.trim(),
                );
                setState(() => people.add(p));
                Navigator.pop(ctx);
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  // -----------------------
  // 3. Case Details UI
  // -----------------------
  Widget _buildCaseDetails(bool isNarrow) {
    return Form(
      key: _caseFormKey,
      child: _wrapCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Case Details',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            _sizedField(
              controller: caseTitleController,
              label: 'Case Title',
              width: isNarrow ? double.infinity : 420,
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: caseDescController,
              maxLines: 5,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                labelText: 'Description',
              ),
              validator: (v) {
                if (v == null || v.trim().isEmpty)
                  return 'Please enter case description';
                return null;
              },
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 12,
              children: [
                DropdownButtonFormField<String>(
                  value: casePriority,
                  items: priorities
                      .map((p) => DropdownMenuItem(value: p, child: Text(p)))
                      .toList(),
                  onChanged: (v) =>
                      setState(() => casePriority = v ?? casePriority),
                  decoration: const InputDecoration(labelText: 'Priority'),
                ),
                DropdownButtonFormField<String>(
                  value: caseCategory,
                  items: categories
                      .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                      .toList(),
                  onChanged: (v) =>
                      setState(() => caseCategory = v ?? caseCategory),
                  decoration: const InputDecoration(labelText: 'Category'),
                ),
                SizedBox(
                  width: 180,
                  child: TextFormField(
                    readOnly: true,
                    decoration: InputDecoration(
                      labelText: reportedDate == null
                          ? 'Reported Date'
                          : reportedDate!.toLocal().toString().split(' ')[0],
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.calendar_today),
                        onPressed: () async {
                          final d = await _pickDate(context, reportedDate);
                          if (d != null) setState(() => reportedDate = d);
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Attach files (mock)',
                style: GoogleFonts.poppins(color: Colors.grey.shade600),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // -----------------------
  // 4. Case Inspector UI
  // -----------------------
  Widget _buildCaseInspector(bool isNarrow) {
    return Form(
      key: _inspectorFormKey,
      child: _wrapCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Case Inspector',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: inspectorName,
              items: [
                'Unassigned',
                'Amanda RSN',
                'Inspector B',
                'Inspector C',
              ].map((n) => DropdownMenuItem(value: n, child: Text(n))).toList(),
              onChanged: (v) =>
                  setState(() => inspectorName = v ?? inspectorName),
              decoration: const InputDecoration(labelText: 'Inspector'),
            ),
            const SizedBox(height: 8),
            TextFormField(
              initialValue: inspectorDepartment,
              decoration: const InputDecoration(labelText: 'Department'),
              onChanged: (v) => inspectorDepartment = v,
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                SizedBox(
                  width: 180,
                  child: TextFormField(
                    readOnly: true,
                    decoration: InputDecoration(
                      labelText: assignedDate == null
                          ? 'Assigned Date'
                          : assignedDate!.toLocal().toString().split(' ')[0],
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.calendar_today),
                        onPressed: () async {
                          final d = await _pickDate(context, assignedDate);
                          if (d != null) setState(() => assignedDate = d);
                        },
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                DropdownButtonFormField<String>(
                  value: inspectorStatus,
                  items: ['Assigned', 'In Progress', 'Closed']
                      .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                      .toList(),
                  onChanged: (v) =>
                      setState(() => inspectorStatus = v ?? inspectorStatus),
                  decoration: const InputDecoration(labelText: 'Status'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // -----------------------
  // 5. Violations UI
  // -----------------------
  Widget _buildViolations(bool isNarrow) {
    return Form(
      key: _violationsFormKey,
      child: _wrapCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Violations',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            ...violations.map((v) => _violationTile(v)).toList(),
            const SizedBox(height: 8),
            Row(
              children: [
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF084852),
                  ),
                  icon: const Icon(Icons.add),
                  label: const Text('Add Violation'),
                  onPressed: () => _showAddViolationDialog(),
                ),
                const SizedBox(width: 12),
                if (violations.isNotEmpty)
                  Text(
                    '${violations.length} violation(s)',
                    style: GoogleFonts.poppins(),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _violationTile(Violation v) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 2),
      title: Text(
        v.code ?? 'No code',
        style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
      ),
      subtitle: Text(
        '${v.description ?? '-'} • ${v.severity}',
        style: GoogleFonts.poppins(),
      ),
      trailing: IconButton(
        icon: const Icon(Icons.delete_outline, color: Colors.red),
        onPressed: () => setState(() => violations.remove(v)),
      ),
    );
  }

  void _showAddViolationDialog() {
    final codeC = TextEditingController();
    final descC = TextEditingController();
    String severity = 'Medium';

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text('Add Violation', style: GoogleFonts.poppins()),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: codeC,
                decoration: const InputDecoration(labelText: 'Violation Code'),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: descC,
                decoration: const InputDecoration(labelText: 'Description'),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: severity,
                items: ['Low', 'Medium', 'High']
                    .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                    .toList(),
                onChanged: (v) => severity = v ?? severity,
                decoration: const InputDecoration(labelText: 'Severity'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF084852),
              ),
              onPressed: () {
                final v = Violation(
                  code: codeC.text.trim(),
                  description: descC.text.trim(),
                  severity: severity,
                );
                setState(() => violations.add(v));
                Navigator.pop(ctx);
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  // -----------------------
  // 6. Action Log UI
  // -----------------------
  Widget _buildActionLog(bool isNarrow) {
    return Form(
      key: _actionFormKey,
      child: _wrapCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Action Log',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            ...actionLogs.map((a) => _actionTile(a)).toList(),
            const SizedBox(height: 8),
            Row(
              children: [
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF084852),
                  ),
                  icon: const Icon(Icons.add),
                  label: const Text('Add Action'),
                  onPressed: () => _showAddActionDialog(),
                ),
                const SizedBox(width: 12),
                if (actionLogs.isNotEmpty)
                  Text(
                    '${actionLogs.length} item(s)',
                    style: GoogleFonts.poppins(),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _actionTile(ActionLog a) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 2),
      title: Text(
        a.type ?? 'Action',
        style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
      ),
      subtitle: Text(
        '${a.date?.toLocal().toString().split(' ')[0] ?? '-'} • ${a.notes ?? '-'}',
        style: GoogleFonts.poppins(),
      ),
      trailing: IconButton(
        icon: const Icon(Icons.delete_outline, color: Colors.red),
        onPressed: () => setState(() => actionLogs.remove(a)),
      ),
    );
  }

  void _showAddActionDialog() {
    final date = DateTime.now();
    final typeC = TextEditingController();
    final notesC = TextEditingController();
    final officerC = TextEditingController();
    DateTime? chosenDate = date;

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text('Add Action', style: GoogleFonts.poppins()),
          content: StatefulBuilder(
            builder: (context, setS) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: typeC,
                    decoration: const InputDecoration(labelText: 'Action Type'),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: notesC,
                    decoration: const InputDecoration(labelText: 'Notes'),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: officerC,
                    decoration: const InputDecoration(
                      labelText: 'Officer Name',
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          chosenDate?.toLocal().toString().split(' ')[0] ??
                              'Select date',
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.calendar_today),
                        onPressed: () async {
                          final d = await _pickDate(context, chosenDate);
                          if (d != null) setS(() => chosenDate = d);
                        },
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF084852),
              ),
              onPressed: () {
                final a = ActionLog(
                  date: chosenDate,
                  type: typeC.text.trim(),
                  notes: notesC.text.trim(),
                  officer: officerC.text.trim(),
                );
                setState(() => actionLogs.add(a));
                Navigator.pop(ctx);
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  // -----------------------
  // Small helpers & widgets
  // -----------------------
  Widget _sizedField({
    required TextEditingController controller,
    required String label,
    double width = 200,
  }) {
    return SizedBox(
      width: width,
      child: TextFormField(
        controller: controller,
        validator: (v) {
          // optional validation for property fields
          return null;
        },
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }

  Widget _buildControls() {
    final isLast = _currentStep == steps.length - 1;
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if (_currentStep > 0)
          OutlinedButton(
            onPressed: _prevStep,
            child: Text('Previous', style: GoogleFonts.poppins()),
          ),
        const SizedBox(width: 12),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF084852),
          ),
          onPressed: _nextStep,
          child: Text(isLast ? 'Submit' : 'Next', style: GoogleFonts.poppins()),
        ),
      ],
    );
  }
}

// -----------------------
// Helper data classes
// -----------------------
class Person {
  final String name;
  final String? phone;
  final String? email;
  final String? relation;

  Person({required this.name, this.phone, this.email, this.relation});
}

class Violation {
  final String? code;
  final String? description;
  final String severity;

  Violation({this.code, this.description, this.severity = 'Medium'});
}

class ActionLog {
  final DateTime? date;
  final String? type;
  final String? notes;
  final String? officer;

  ActionLog({this.date, this.type, this.notes, this.officer});
}
