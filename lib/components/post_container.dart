import 'package:flutter/material.dart';
import 'package:hazard_reporting_app/data_types/reports.dart';
import 'package:hazard_reporting_app/data_types/utils.dart';

class PostContainer extends StatelessWidget {
  final ReportsRecord? report;
  final ReporterRecord? reporter;

  const PostContainer(
      {super.key, required this.report, required this.reporter});

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.symmetric(
            vertical: 8.0, horizontal: 16.0),
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [
                CircleAvatar(
                  foregroundImage: reporter?.photo?.image ??
                      const AssetImage('images/logo-notext.png'),
                  radius: 20,
                  backgroundColor: const Color(0xFF29AB84),
                  child: const Text(
                    'DP',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        reporter?.displayName ?? "Anonymous",
                        textAlign: TextAlign.left,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                        ),
                      ),
                      Text(
                        report?.address ?? "Location Unknown",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                Stack(
                  alignment: AlignmentDirectional.center,
                  children: [
                    Icon(
                      report?.category?.icon.icon ??
                          Categories.miscellaneous.category.icon.icon,
                      size: 60,
                      color: Colors.grey,
                      opticalSize: 2,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color:
                            const Color(0xFF29AB84).withOpacity(0.5),
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: Text(
                        report?.category?.name ?? "Miscellaneous",
                        textAlign: TextAlign.start,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                )
              ]),
              Text(
                report?.title ?? "Untitled",
                textAlign: TextAlign.left,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0,
                  color: Colors.black,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Stack(children: [
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: const Center(
                    child: Text(
                      'Image Placeholder',
                      style: TextStyle(fontSize: 16.0),
                    ),
                  ),
                ),
                report?.image ??
                    Image.asset("images/UPatrol-logo.png"),
              ]),
            ]));
  }
}
