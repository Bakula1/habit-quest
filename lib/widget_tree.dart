import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:habit_quest/auth.dart';
import 'package:habit_quest/pages/home_page.dart';
import 'package:habit_quest/pages/login_register_page.dart';
import 'package:habit_quest/pages/nickname_page.dart';
import 'package:flutter/material.dart';

class WidgetTree extends StatefulWidget {
  const WidgetTree({super.key});

  @override
  State<WidgetTree> createState() => _WidgetTreeState();
}

class _WidgetTreeState extends State<WidgetTree> {
  Future<bool> _hasCompletedOnboarding(String uid) async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .get();

      if (!doc.exists) return false;
      return doc.data()?['hasCompletedOnboarding'] ?? false;
    } catch (e) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Auth().authStateChanges,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const LoginPage();
        }

        final uid = snapshot.data!.uid;

        return FutureBuilder<bool>(
          future: _hasCompletedOnboarding(uid),
          builder: (context, onboardSnapshot) {
            if (onboardSnapshot.hasError) {
              return Scaffold(
                body: Center(child: Text('Error: ${onboardSnapshot.error}')),
              );
            }

            if (onboardSnapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }

            if (onboardSnapshot.data == true) {
              return HomePage();
            }

            return NicknamePage(uid: uid);
          },
        );
      },
    );
  }
}
