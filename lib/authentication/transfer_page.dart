import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hazard_reporting_app/backend/firebase_auth.dart';
import 'package:hazard_reporting_app/backend/firestore.dart';
import 'package:hazard_reporting_app/components/template.dart';
import 'package:hazard_reporting_app/data_types/globals.dart';
import 'package:hazard_reporting_app/moderator_home_page.dart';
import 'package:hazard_reporting_app/pages/dashboard.dart';
import 'package:hazard_reporting_app/receiver_home_page.dart';

void transferPage(BuildContext context) {
  var destination = const Template(child: Dashboard());
  if (currentUser?.isModerator ?? false) {
    destination = const Template(child: ModeratorHomePage());
  } else if (currentUser?.isResponder ?? false) {
    destination = const Template(child: ReceiverHomePage());
  }

  Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => destination));
}
