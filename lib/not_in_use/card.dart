import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_directory_app/screens/Sponsor/sponsor_card.dart';

class SponsorDetailScreen extends StatefulWidget {
  final int index;

  const SponsorDetailScreen({super.key, required this.index});

  @override
  State<SponsorDetailScreen> createState() => _SponsorDetailScreenState();
}

class _SponsorDetailScreenState extends State<SponsorDetailScreen> {
  late PageController controller;
  int curr = 0;

  @override
  void initState() {
    super.initState();
    controller = PageController(initialPage: widget.index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                      const SizedBox(
                        height: 100,
                      ),
                      SizedBox(
                        height: 400,
                        width: 400,
                        child: PageView.builder(
                            controller: controller,
                            itemCount: sponsors.length,
                            itemBuilder: (context, index) {
                              final sponsorData = sponsors[index].data();
                              final sponsorName =
                                  sponsorData['sponsorName'] as String;
                              final sponsorDescription =
                                  sponsorData['sponsorDescription'] as String;
                              final sponsorImageUrl =
                                  sponsorData['sponsorImage'] as String;

                              // return SponsorCard(
                              //   sponsorName: sponsorName,
                              //   sponsorDescription: sponsorDescription,
                              //   sponsorImageUrl: sponsorImageUrl,
                              // );
                            }),
                      ),
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
