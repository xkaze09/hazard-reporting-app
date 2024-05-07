import 'package:flutter/material.dart';
import 'package:hazard_reporting_app/components/template.dart';
import 'package:hazard_reporting_app/data_types/globals.dart';
import 'package:hazard_reporting_app/moderator_home_page.dart';
import 'package:hazard_reporting_app/pages/dashboard.dart';
import 'package:hazard_reporting_app/receiver_home_page.dart';

void transferPage(BuildContext context) {
  var destination =
      const Template(title: "Dashboard", child: Dashboard());
  if (currentUser?.isModerator ?? false) {
    destination = const Template(
        title: "Dashboard", child: ModeratorHomePage());
  } else if (currentUser?.isResponder ?? false) {
    destination =
        const Template(title: "Dashboard", child: ReceiverHomePage());
  }

  Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => destination));
}
