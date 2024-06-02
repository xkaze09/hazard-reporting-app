import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hazard_reporting_app/backend/firebase_auth.dart';
import 'package:hazard_reporting_app/data_types/reports.dart';

GlobalKey<ScaffoldMessengerState> rootScaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();
final GlobalKey<ScaffoldMessengerState> loggedScaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();
final GlobalKey<NavigatorState> navigatorKey =
    GlobalKey<NavigatorState>();

Stream<QuerySnapshot> reportStream = getActiveReports();
ValueNotifier<bool> filterListener = ValueNotifier(checkFilter);
ReporterRecord? currentUser;
List<String> categoryFilters = List.filled(1, "test", growable: true);
bool hideUnverifiedReports = true;
bool hideVerifiedReports = false;
bool hideResolvedReports = false;
bool hidePendingReports = false;
bool checkFilter = false;
