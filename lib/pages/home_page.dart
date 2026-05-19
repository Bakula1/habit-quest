import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar_item.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:habit_quest/auth.dart';
import 'package:habit_quest/widget_tree.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final User? user = Auth().currentUser;
  // ignore: unused_field
  int _page = 0;
  final GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();

  Future<void> signOut() async {
    await Auth().signOut();
  }

  Future<String> _getNickname() async {
    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user?.uid)
        .get();
    return doc.data()?['nickname'] ?? 'User';
  }

  Widget _signOutButton() {
    return ElevatedButton(
      onPressed: () async {
        await signOut();
        if (!mounted) return;
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
      bottomNavigationBar: CurvedNavigationBar(
        key: _bottomNavigationKey,
        backgroundColor: Colors.white,
        color: const Color.fromARGB(255, 21, 143, 208),
        buttonBackgroundColor: const Color.fromARGB(255, 21, 143, 208),
        animationCurve: Curves.easeInOut,
        animationDuration: const Duration(milliseconds: 250),
        items: [
          CurvedNavigationBarItem(
            child: Image.asset(
              'assets/icons/home.png',
              color: Colors.white,
              width: 28,
              height: 28,
            ),
            label: 'Home',
            labelStyle: TextStyle(color: Colors.white),
          ),
          CurvedNavigationBarItem(
            child: Image.asset(
              'assets/icons/habit.png',
              color: Colors.white,
              width: 28,
              height: 28,
            ),
            label: 'Habits',
            labelStyle: TextStyle(color: Colors.white),
          ),
          CurvedNavigationBarItem(
            child: Image.asset(
              'assets/icons/social.png',
              color: Colors.white,
              width: 28,
              height: 28,
            ),
            label: 'Social',
            labelStyle: TextStyle(color: Colors.white),
          ),
          CurvedNavigationBarItem(
            child: Image.asset(
              'assets/icons/profile.png',
              color: Colors.white,
              width: 28,
              height: 28,
            ),
            label: 'Profile',
            labelStyle: TextStyle(color: Colors.white),
          ),
        ],
        onTap: (index) {
          setState(() {
            _page = index;
          });
        },
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        child: FutureBuilder<String>(
          future: _getNickname(),
          builder: (context, snapshot) {
            final nickname = snapshot.data ?? '...';
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Welcome, $nickname!',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                _signOutButton(),
              ],
            );
          },
        ),
      ),
    );
  }
}
