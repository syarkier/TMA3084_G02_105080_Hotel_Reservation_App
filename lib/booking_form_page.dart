import 'package:flutter/material.dart';

import 'room_list_page.dart';
import 'room_type.dart';
import 'validators.dart';

class BookingFormPage extends StatefulWidget {
  const BookingFormPage({super.key});

  @override
  State<BookingFormPage> createState() => _BookingFormPageState();
}

class _BookingFormPageState extends State<BookingFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  DateTime? _checkIn;
  double _guests = 2;
  RoomPreference _room = RoomPreference.double;
  bool _breakfast = false;
  bool _accepted = false;
  String? _dateError;
  String? _policyError;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _checkIn ?? now,
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
    );
    if (!mounted || picked == null) return;
    setState(() {
      _checkIn = picked;
      _dateError = null;
    });
  }

  void _submit() {
    final formIsValid = _formKey.currentState!.validate();
    final dateError = validateCheckIn(_checkIn);
    final policyError = validateAgreement(_accepted);
    setState(() {
      _dateError = dateError;
      _policyError = policyError;
    });
    if (!formIsValid || dateError != null || policyError != null) return;

    final guest = _nameController.text.trim();
    final checkInText = MaterialLocalizations.of(context)
        .formatShortDate(_checkIn!);
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('Booking saved for $guest')));
    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (_) => RoomListPage(
          preferred: _room,
          guests: _guests.round(),
          checkIn: checkInText,
        ),
      ),
    );
  }

  // Animation 1: error messages fade and grow in instead of popping in
  Widget _animatedError(String? message, TextStyle style, double top) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      transitionBuilder: (child, animation) {
        return FadeTransition(
          opacity: animation,
          child: SizeTransition(sizeFactor: animation, child: child),
        );
      },
      child: message == null
          ? const SizedBox.shrink()
          : Padding(
              key: ValueKey(message),
              padding: EdgeInsets.only(top: top, left: 12),
              child: Text(message, style: style),
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final checkIn = _checkIn;
    final dateError = _dateError;
    final policyError = _policyError;
    final errorStyle = TextStyle(
      color: Theme.of(context).colorScheme.error,
      fontSize: 12,
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Book a Room')),
      body: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Change 2: hotel header card
              Card(
                color: colors.primaryContainer,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Icon(
                        Icons.hotel,
                        size: 40,
                        color: colors.onPrimaryContainer,
                      ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Hotel Kenyalang',
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(color: colors.onPrimaryContainer),
                          ),
                          Text(
                            'Kuching, Sarawak',
                            style: TextStyle(color: colors.onPrimaryContainer),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Guest name',
                  prefixIcon: Icon(Icons.person),
                ),
                validator: validateName,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: 'Phone number',
                  prefixIcon: Icon(Icons.phone),
                ),
                validator: validatePhone,
              ),
              const SizedBox(height: 16),
              OutlinedButton.icon(
                onPressed: _pickDate,
                icon: const Icon(Icons.calendar_month),
                label: Text(
                  checkIn == null
                      ? 'Choose check-in date'
                      : MaterialLocalizations.of(context)
                            .formatShortDate(checkIn),
                ),
              ),
              _animatedError(dateError, errorStyle, 6),
              const SizedBox(height: 16),
              Text('Guests: ${_guests.round()}'),
              Slider(
                value: _guests,
                min: 1,
                max: 6,
                divisions: 5,
                label: '${_guests.round()}',
                onChanged: (double value) {
                  setState(() => _guests = value);
                },
              ),
              const SizedBox(height: 8),
              SegmentedButton<RoomPreference>(
                segments: const [
                  ButtonSegment(
                    value: RoomPreference.single,
                    label: Text('Single'),
                  ),
                  ButtonSegment(
                    value: RoomPreference.double,
                    label: Text('Double'),
                  ),
                  ButtonSegment(
                    value: RoomPreference.family,
                    label: Text('Family'),
                  ),
                ],
                selected: {_room},
                onSelectionChanged: (Set<RoomPreference> selection) {
                  setState(() => _room = selection.first);
                },
              ),
              const SizedBox(height: 8),
              SwitchListTile(
                title: const Text('Include breakfast'),
                value: _breakfast,
                onChanged: (bool value) {
                  setState(() => _breakfast = value);
                },
              ),
              CheckboxListTile(
                title: const Text('I accept the hotel policy'),
                value: _accepted,
                controlAffinity: ListTileControlAffinity.leading,
                onChanged: (bool? value) {
                  setState(() {
                    _accepted = value ?? false;
                    _policyError = null;
                  });
                },
              ),
              _animatedError(policyError, errorStyle, 0),
              const SizedBox(height: 16),
              FilledButton(onPressed: _submit, child: const Text('Reserve')),
            ],
          ),
        ),
      ),
    );
  }
}
