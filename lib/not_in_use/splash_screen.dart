import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_directory_app/screens/Sponsor/sponsor_card.dart';

class SponsorDetailScreen extends StatefulWidget {
  final int index;

  const SponsorDetailScreen({Key? key, required this.index}) : super(key: key);

  @override
  State<SponsorDetailScreen> createState() => _SponsorDetailScreenState();
}

class _SponsorDetailScreenState extends State<SponsorDetailScreen> {
  late int curr;
  late List<DocumentSnapshot> sponsors;

  @override
  void initState() {
    super.initState();
    curr = widget.index;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("directory-sponsors")
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data == null) {
              return Center(child: Text("No Data Found"));
            } else {
              sponsors = snapshot.data!.docs;
              return Column(
                children: [
                  SizedBox(
                    height: 400,
                    width: 400,
                    // child: SponsorCard(
                    //   sponsorName: sponsors[curr]['sponsorName'] ?? '',
                    //   sponsorDescription: sponsors[curr]['sponsorDescription'] ?? '',
                    //   sponsorImageUrl: sponsors[curr]['sponsorImage'] ?? '',
                    // ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      FloatingActionButton(
                        heroTag: "prevBtn",
                        onPressed: () {
                          setState(() {
                            curr = (curr - 1).clamp(0, sponsors.length - 1);
                          });
                        },
                        child: Icon(Icons.navigate_before),
                      ),
                      FloatingActionButton(
                        heroTag: "nextBtn",
                        onPressed: () {
                          setState(() {
                            curr = (curr + 1).clamp(0, sponsors.length - 1);
                          });
                        },
                        child: Icon(Icons.navigate_next),
                      ),
                    ],
                  ),
                
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
