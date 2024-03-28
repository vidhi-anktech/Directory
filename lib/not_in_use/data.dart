import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_directory_app/screens/Sponsor/sponsor_detail_screen.dart';

class Sponsors extends StatefulWidget {
  const Sponsors({super.key});

  @override
  State<Sponsors> createState() => _SponsorsState();
}

class _SponsorsState extends State<Sponsors> {
  late String imageUrl;
  late String imageUrl1;
  late String imageUrl2;
  late String imageUrl3;
  final storage = FirebaseStorage.instance;
  List<String> names = ["Name 1", "Name 2", "Name 3", "Name 4"];
  List<String?> imagePaths = [];

  @override
  void initState() {
    super.initState();
    imageUrl = "";
    imageUrl1 = "";
    imageUrl2 = "";
    imageUrl3 = "";
    getImageUrl();
  }

  Future<void> getImageUrl() async {
    final ref = storage.ref().child('sponsor-images/user.avif');
    final ref1 = storage.ref().child('sponsor-images/user2.avif');
    final ref2 = storage.ref().child('sponsor-images/user3.jpg');
    final ref3 = storage.ref().child('sponsor-images/user4.jpg');
    final url = await ref.getDownloadURL();
    final url1 = await ref1.getDownloadURL();
    final url2 = await ref2.getDownloadURL();
    final url3 = await ref3.getDownloadURL();
    setState(() {
      imageUrl = url;
      imageUrl1 = url1;
      imageUrl2 = url2;
      imageUrl3 = url3;
      // Assign URLs to imagePaths list
      imagePaths = [imageUrl, imageUrl1, imageUrl2, imageUrl3];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Sponsors"),
        ),
        body: imagePaths.isEmpty
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : GridView.builder(
                itemCount: imagePaths.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  childAspectRatio: 8.0 / 10.0,
                  crossAxisCount: 2,
                ),
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                    child: GestureDetector(
                      onTap: () {
                        // Navigator.push(
                        //   context,
                          // MaterialPageRoute(
                          //   builder: (context) => SponsorDetailScreen(
                          //     imagePath: imagePaths[index]!,
                          //     name: names[index],
                          //     description:
                          //         'Description of ${names[index]}', // Add description here
                          //   ),
                          // ),
                        // );
                      },
                      child: Card(
                        elevation: 0,
                        color: const Color.fromRGBO(217, 217, 217, 1),
                        semanticContainer: true,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Expanded(
                              child: Stack(
                                fit: StackFit.expand,
                                children: [
                                  FadeInImage(
                                    placeholder: const AssetImage(
                                        'assets/images/user-profile.avif'),
                                    image: NetworkImage(imagePaths[index]!),
                                    fit: BoxFit.fill,
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    names[index],
                                    style: const TextStyle(fontSize: 15.0),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ));
  }
}

