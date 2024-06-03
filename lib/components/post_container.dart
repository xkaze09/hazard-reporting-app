import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hazard_reporting_app/data_types/globals.dart';
import 'package:hazard_reporting_app/data_types/reports.dart';
import 'package:hazard_reporting_app/data_types/utils.dart';

class PostContainer extends StatefulWidget {
  final ReportsRecord? report;
  final ReporterRecord? reporter;

  const PostContainer(
      {super.key, required this.report, required this.reporter});

  @override
  State<PostContainer> createState() => _PostContainerState();
}

class _PostContainerState extends State<PostContainer> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    late Size size = MediaQuery.of(context).size;
    String tag = "";
    if (widget.report?.isResolved ?? false) {
      tag = "Resolved";
    } else if (widget.report?.isPending ?? false) {
      tag = "Pending";
    } else if ((widget.report?.isVerified ?? false) &&
        currentUser?.getRole() == "Moderator") {
      tag = "Verified";
    } else if ((widget.report?.isVerified != true)) {
      tag = "Unverified";
    }
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
                  foregroundImage:
                      NetworkImage(widget.reporter?.photoUrl ?? ""),
                  radius: 20,
                  backgroundImage:
                      AssetImage("assets/images/anon.png"),
                  backgroundColor:
                      const Color.fromARGB(255, 11, 14, 13),
                  // child: Image.asset("assets/images/anon.png")
                  // const Text(
                  //   'DP',
                  //   style: TextStyle(color: Colors.white),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.reporter?.displayName ?? "Anonymous",
                        textAlign: TextAlign.left,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                        ),
                      ),
                      Text(
                        widget.report?.address ?? "Location Unknown",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                Visibility(
                  visible: widget.report?.isPending ?? false,
                  child: Expanded(
                    child: Container(
                      alignment: Alignment.topLeft,
                      // padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Text(""),
                    ),
                  ),
                ),
                Column(
                  children: [
                    Icon(
                      widget.report?.category?.icon.icon,
                      size: 30,
                      color: widget.report?.category?.color,
                    ),
                    Center(
                      child: Text(
                          widget.report?.category?.name ?? 'Unknown',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 14,
                          )),
                    )
                  ],
                ),
              ]),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.report?.title ?? "Untitled",
                    textAlign: TextAlign.left,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                      color: Colors.black,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(5),
                    decoration: (tag.isNotEmpty)
                        ? BoxDecoration(
                            color: (tag == "Unverified" ||
                                    tag == "Pending")
                                ? Colors.grey
                                : Colors.green,
                            borderRadius:
                                BorderRadius.all(Radius.circular(3)))
                        : null,
                    child: Center(
                        child: Text(
                      tag,
                      style: TextStyle(color: Colors.white),
                    )),
                  )
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Stack(children: [
                Container(
                  height: size.height * 0.4,
                  decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(10.0),
                      image: DecorationImage(
                          fit: BoxFit.cover,
                          image: widget.report?.image?.image ??
                              MemoryImage(const Base64Codec().decode(
                                  "R0lGODlhAQABAIAAAAAAAP///yH5BAEAAAAALAAAAAABAAEAAAIBRAA7")))),
                ),
              ]),
            ]));
  }
}
