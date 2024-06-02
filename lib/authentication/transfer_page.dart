import 'package:flutter/material.dart';
import 'package:hazard_reporting_app/components/template.dart';
import 'package:hazard_reporting_app/pages/dashboard.dart';

void transferPage(BuildContext context) {
  var destination =
      const Template(title: "Dashboard", child: Dashboard());

  Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => destination));
}
