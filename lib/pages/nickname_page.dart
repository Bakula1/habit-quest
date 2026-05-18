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
  final TextEditingController _controller = TextEditingController();
  bool _loading = false;
  String? _error;

  Future<void> _saveNickname() async {
    final nickname = _controller.text.trim();
    if (nickname.isEmpty) {
      setState(() => _error = 'Please enter a nickname');
      return;
    }

    setState(() {
      _loading = true;
      _error = null;
    });

    await FirebaseFirestore.instance.collection('users').doc(widget.uid).set({
      'nickname': nickname,
      'hasCompletedOnboarding': true,
    }, SetOptions(merge: true));

    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => HomePage()),
      );
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Choose a nickname',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Nickname',
                errorText: _error,
              ),
            ),
            const SizedBox(height: 20),
            _loading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _saveNickname,
                    child: const Text('Continue'),
                  ),
          ],
        ),
      ),
    );
  }
}
