import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_directory_app/screens/Sponsor/sponsor_card.dart';

class SponsorDetailScreen extends StatefulWidget {
  final int index;
  final Map<String, dynamic> sponsorData;
  final userId;
  const SponsorDetailScreen(
      {super.key,
      required this.index,
      required this.sponsorData,
      required this.userId});

  @override
  State<SponsorDetailScreen> createState() => _SponsorDetailScreenState();
}

class _SponsorDetailScreenState extends State<SponsorDetailScreen>
    with TickerProviderStateMixin {
  late PageController controller;
  int curr = 0;

  // @override
  // void initState() {
  //   super.initState();
  //   controller =
  //       PageController(initialPage: widget.index, viewportFraction: 0.8);
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection("directory-sponsors")
                .snapshots()
                .asBroadcastStream(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.active) {
                if (snapshot.hasData && snapshot.data != null) {
                  final sponsors = snapshot.data!.docs;
                  print("VALUE OF CARDS $sponsors");
                  return Column(
                    children: [
                      SizedBox(
                        height: 500,
                        // width: 400,
                        width: MediaQuery.of(context).size.width,
                        child: PageView.builder(
                            // controller: controller,
                            controller: PageController(
                                initialPage: widget.index,
                                viewportFraction: 0.9),
                            padEnds: false,
                            itemCount: sponsors.length,
                            onPageChanged: (value) {
                              print("value of hehe VALUE $value");
                              curr = value;
                              print("value of hehe CURR $curr");
                              // setState(() {

                              // });
                            },
                            itemBuilder: (context, index) {
                              final sponsorData = sponsors[index].data();
                              final sponsorName =
                                  sponsorData['sponsorName'] as String;
                              final sponsorDescription =
                                  sponsorData['sponsorDescription'] as String;
                              final sponsorImageUrl =
                                  sponsorData['sponsorImage'] as String;

                              return Column(
                                children: [
                                  Expanded(
                                    child: Container(
                                      margin: const EdgeInsets.all(10),
                                      child: SponsorCard(
                                        sponsorName: sponsorName,
                                        sponsorDescription: sponsorDescription,
                                        sponsorImageUrl: sponsorImageUrl,
                                        sponsorData: widget.sponsorData,
                                        userId: widget.userId,
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            }),
                      ),

                      // TabPageSelector(
                      //   controller: TabController(
                      //       length: sponsors.length,
                      //       initialIndex: curr,
                      //       vsync: this),
                      // )

                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      //   children: [
                      //     FloatingActionButton(
                      //       heroTag: "prevBtn",
                      //       onPressed: () {
                      //         setState(() {
                      //           curr = (curr - 1).clamp(0, sponsors.length - 1);
                      //         });
                      //       },
                      //       child: Icon(Icons.navigate_before),
                      //     ),
                      //     FloatingActionButton(
                      //       heroTag: "nextBtn",
                      //       onPressed: () {
                      //         setState(() {
                      //           curr = (curr + 1).clamp(0, sponsors.length - 1);
                      //         });
                      //       },
                      //       child: Icon(Icons.navigate_next),
                      //     ),
                      //   ],
                      // ),
                    ],
                  );
                } else {
                  return const Text("No Data Found");
                }
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            }),
      ),
    );
  }
}
