import 'package:flutter/material.dart';
import 'package:hazard_reporting_app/data_types/reports.dart';

final GlobalKey<ScaffoldMessengerState> rootScaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();
final GlobalKey<NavigatorState> navigatorKey =
    GlobalKey<NavigatorState>();

ReporterRecord? currentUser;
List<String> categoryFilters = List.filled(1, "test", growable: true);
