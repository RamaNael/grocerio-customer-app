import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CheckUserStatus extends StatefulWidget {
  const CheckUserStatus({super.key});

  @override
  State<CheckUserStatus> createState() => _CheckUserStatusState();
}

class _CheckUserStatusState extends State<CheckUserStatus> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPersistentFrameCallback((callback) {
      if (FirebaseAuth.instance.currentUser == null) {
        Navigator.pushReplacementNamed(context, '/login');
      } else {
        Navigator.pushReplacementNamed(context, '/home');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: CircularProgressIndicator(color: Colors.green)),
    );
  }
}
