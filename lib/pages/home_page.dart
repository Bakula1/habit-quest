import 'package:firebase_auth/firebase_auth.dart';
import 'package:habit_quest/widget_tree.dart';
import 'package:habit_quest/auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final User? user = Auth().currentUser;

  Future<void> signOut() async {
    await Auth().signOut();
  }

  Widget _title() {
    return const Text('Firebase Auth');
  }

  Widget _userUid() {
    return Text(user?.email ?? 'User email');
  }

  Widget _signOutButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        await signOut();
        if (!context.mounted) return; // dodaj ovo
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const WidgetTree()),
          (route) => false,
        );
      },
      child: const Text('Sign Out'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 201, 65, 47),
        title: _title(),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[_userUid(), _signOutButton(context)],
        ),
      ),
    );
  }
}
