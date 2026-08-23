import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:snap_ecommerce_app/models/user_model.dart';
import 'package:snap_ecommerce_app/viewModel/user_view_model.dart';

class UserProvider extends ChangeNotifier {
  UserViewModel userViewModel = UserViewModel();
  StreamSubscription<DocumentSnapshot>? userStreamSubscription;

  String nameOfUser = "";
  String emailOfUser = "";
  String addressOfUser = "";
  String phoneNumberOfUser = "";

  UserProvider() {
    getUserData();
  }

  getUserData() {
    userStreamSubscription?.cancel();
    userStreamSubscription = userViewModel.retrieveUserData().listen((
      dataSnapshot,
    ) {
      final UserModel userData = UserModel.fromJson(
        dataSnapshot.data() as Map<String, dynamic>,
      );
      nameOfUser = userData.name;
      emailOfUser = userData.email;
      addressOfUser = userData.address;
      phoneNumberOfUser = userData.phone;
      notifyListeners();
    });
  }

  declineProvider() {
    String nameOfUser = "";
    String emailOfUser = "";
    String addressOfUser = "";
    String phoneNumberOfUser = "";
    userStreamSubscription?.cancel();
    notifyListeners();
  }

  @override
  void dispose() {
    declineProvider();
    userStreamSubscription?.cancel();
    super.dispose();
  }
}
