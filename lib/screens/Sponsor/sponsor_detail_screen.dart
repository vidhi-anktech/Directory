import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_directory_app/resources.dart';
import 'package:flutter_directory_app/screens/Sponsor/sponsor_card.dart';

class SponsorDetailScreen extends StatefulWidget {
  final int index;
  final Map<String, dynamic> sponsorData;
  final userId;

  const SponsorDetailScreen({
    Key? key,
    required this.index,
    required this.sponsorData,
    required this.userId,
  }) : super(key: key);

  @override
  State<SponsorDetailScreen> createState() => _SponsorDetailScreenState();
}

class _SponsorDetailScreenState extends State<SponsorDetailScreen> {
  late PageController controller;
  int curr = 0;

  @override
  void initState() {
    super.initState();
    controller = PageController(initialPage: widget.index, viewportFraction: 0.9);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("directory-sponsors")
              .orderBy("sponsorPriority")
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              if (snapshot.hasData && snapshot.data != null) {
                final sponsors = snapshot.data!.docs;
                return SizedBox(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: PageView.builder(
                    controller: controller,
                    itemCount: sponsors.length,
                    onPageChanged: (value) {
                      // setState(() {
                      //   curr = value;
                      // });
                      curr = value;
                    },
                    itemBuilder: (context, index) {
                      final sponsorData = sponsors[index].data();
                      final sponsorName = sponsorData['sponsorName'] as String;
                      final sponsorDescription = sponsorData['sponsorDescription'] as String;
                      final sponsorImageUrl = sponsorData['sponsorImage'] as String;

                      return SponsorCard(
                        sponsorName: sponsorName,
                        sponsorDescription: sponsorDescription,
                        sponsorImageUrl: sponsorImageUrl,
                        sponsorData: widget.sponsorData,
                        userId: widget.userId,
                      );
                    },
                  ),
                );
              } else {
                return AppSponsorText.noDataFound;
              }
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }
}
