import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:habit_quest/pages/home_page.dart';
import 'package:flutter/material.dart';

class NicknamePage extends StatefulWidget {
  final String uid;
  const NicknamePage({super.key, required this.uid});

  @override
  State<NicknamePage> createState() => _NicknamePageState();
}

class _NicknamePageState extends State<NicknamePage> {
  final TextEditingController _nicknameController = TextEditingController();
  bool _loading = false;
  String? _error;
  String? _selectedGender;
  DateTime? _selectedDate;

  final List<String> _genders = ['Male', 'Female', 'Other'];

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(now.year - 18),
      firstDate: DateTime(1900),
      lastDate: now,
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  Future<void> _saveProfile() async {
    final nickname = _nicknameController.text.trim();

    if (nickname.isEmpty) {
      setState(() => _error = 'Please enter a nickname');
      return;
    }
    if (_selectedGender == null) {
      setState(() => _error = 'Please select a gender');
      return;
    }
    if (_selectedDate == null) {
      setState(() => _error = 'Please select your date of birth');
      return;
    }

    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      await FirebaseFirestore.instance.collection('users').doc(widget.uid).set({
        'nickname': nickname,
        'gender': _selectedGender,
        'dateOfBirth': _selectedDate!.toIso8601String(),
        'hasCompletedOnboarding': true,
      }, SetOptions(merge: true));

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => HomePage()),
        );
      }
    } catch (e) {
      setState(() {
        _loading = false;
        _error = 'Error: $e'; // vidjet ćeš točno što puca
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 201, 65, 47),
        title: const Text('Welcome!'),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 40),
              const Text(
                'Set up your profile',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 30),

              // Nickname
              TextField(
                controller: _nicknameController,
                decoration: const InputDecoration(
                  labelText: 'Nickname',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),

              // Spol
              DropdownButtonFormField<String>(
                initialValue: _selectedGender,
                decoration: const InputDecoration(
                  labelText: 'Gender',
                  border: OutlineInputBorder(),
                ),
                items: _genders
                    .map((g) => DropdownMenuItem(value: g, child: Text(g)))
                    .toList(),
                onChanged: (val) => setState(() => _selectedGender = val),
              ),
              const SizedBox(height: 20),

              // Datum rođenja
              GestureDetector(
                onTap: _pickDate,
                child: AbsorbPointer(
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: 'Date of Birth',
                      border: const OutlineInputBorder(),
                      suffixIcon: const Icon(Icons.calendar_today),
                      hintText: _selectedDate == null
                          ? 'Select date'
                          : '${_selectedDate!.day}.${_selectedDate!.month}.${_selectedDate!.year}',
                    ),
                    controller: TextEditingController(
                      text: _selectedDate == null
                          ? ''
                          : '${_selectedDate!.day}.${_selectedDate!.month}.${_selectedDate!.year}',
                    ),
                  ),
                ),
              ),

              // Error poruka
              if (_error != null) ...[
                const SizedBox(height: 12),
                Text(_error!, style: const TextStyle(color: Colors.red)),
              ],

              const SizedBox(height: 30),
              _loading
                  ? const CircularProgressIndicator()
                  : SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _saveProfile,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(
                            255,
                            201,
                            65,
                            47,
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 15),
                        ),
                        child: const Text(
                          'Continue',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
