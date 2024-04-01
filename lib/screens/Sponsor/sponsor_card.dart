import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_directory_app/screens/Sponsor/edit_sponsors.dart';

class SponsorCard extends StatefulWidget {
  final String sponsorName;
  final String sponsorDescription;
  final String sponsorImageUrl;
  final Map<String, dynamic> sponsorData;
  final userId;

  const SponsorCard(
      {super.key,
      required this.sponsorName,
      required this.sponsorDescription,
      required this.sponsorImageUrl,
      required this.sponsorData,
      required this.userId});

  @override
  State<SponsorCard> createState() => _SponsorCardState();
}

class _SponsorCardState extends State<SponsorCard> {
  @override
  Widget build(BuildContext context) {
    print(
        "PRINTING VALUE OF SPONSORID AND SPONSOR DATA IN SPONSOR CARD PAGE ${widget.userId},,${widget.sponsorData}");
    return Scaffold(
      body: Card(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Color.fromARGB(255, 241, 240, 240).withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 5,
                // offset: Offset(0, 3),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
               
                Stack(
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: SizedBox(
                        height: 500,
                        width: 500,
                        child: Image.network(
                          widget.sponsorImageUrl,
                          fit: BoxFit.cover,
                          // fit: BoxFit.fitWidth,
                          loadingBuilder: (BuildContext context, Widget child,
                              ImageChunkEvent? loadingProgress) {
                            if (loadingProgress == null) {
                              return child;
                            } else {
                              return Center(
                                child: CircularProgressIndicator(
                                  value: loadingProgress.expectedTotalBytes !=
                                          null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                          loadingProgress.expectedTotalBytes!
                                      : null,
                                ),
                              );
                            }
                          },
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                            color: Colors.white),
                        child: Column(
                          children: [
                            Text(
                              widget.sponsorName,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            Padding(
                              padding: EdgeInsets.all(8),
                              child: Text(
                                widget.sponsorDescription,
                                style: const TextStyle(
                                  fontSize: 14,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                // Padding(
                //   padding: EdgeInsets.all(8),
                //   child: Text(
                //     widget.sponsorDescription,
                //     style: const TextStyle(
                //       fontSize: 14,
                //     ),
                //     textAlign: TextAlign.center,
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
