import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_directory_app/main.dart';
import 'package:flutter_directory_app/resources.dart';
import 'package:flutter_directory_app/screens/Sponsor/edit_sponsors.dart';
import 'package:flutter_directory_app/screens/Sponsor/register-sponsor.dart';
import 'package:flutter_directory_app/screens/Sponsor/sponsor_detail_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Sponsors extends StatefulWidget {
  const Sponsors({super.key});

  @override
  State<Sponsors> createState() => _SponsorsState();
}

class _SponsorsState extends State<Sponsors> {
  List results = [];
  var checkNum;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 238, 249, 255),
      floatingActionButton: FutureBuilder<Widget>(
        future: floatingButton(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator(); // or any other loading indicator
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            return snapshot.data ??
                Container(); // return the button widget or an empty container if data is null
          }
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      appBar: AppBar(
        title: AppSponsorText.sponsorTitle,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("directory-sponsors")
              .orderBy("sponsorPriority")
              .snapshots()
              .asBroadcastStream(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              if (snapshot.hasData && snapshot.data != null) {
                results = snapshot.data!.docs;
                return GridView.builder(
                    itemCount: results.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      childAspectRatio: 7.0 / 10.0,
                      crossAxisCount: 1,
                    ),
                    itemBuilder: (context, index) {
                      Future<Widget> editIcon() async {
                        var sharedPref = await SharedPreferences.getInstance();
                        bool? isAdmin = sharedPref.getBool(MyAppState.ISADMIN);
                        print("Are you an admin for edit icon? $isAdmin");
                        if (isAdmin == true) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EditSponsor(
                                    userId: results[index].id,
                                    sponsorData: results[index].data()
                                        as Map<String, dynamic>,
                                    sponsorName: results[index]['sponsorName'],
                                    sponsorDescription: results[index]
                                        ['sponsorDescription'],
                                    sponsorImageUrl: results[index]
                                        ['sponsorImage'],
                                  ),
                                ),
                              );
                            },
                            child: Image.asset(Assets.editIcon),
                          );
                        } else {
                          return Container();
                        }
                      }

                      Future<Widget> deleteSponsor(String docId) async {
                        var sharedPref = await SharedPreferences.getInstance();
                        bool? isAdmin = sharedPref.getBool(MyAppState.ISADMIN);
                        if (isAdmin == true) {
                          return GestureDetector(
                            onTap: () async {
                              final value = await showDialog<bool>(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      content: AppConstantText.deleteAlert,
                                      actions: <Widget>[
                                        TextButton(
                                          child: AppConstantText.noAlert,
                                          onPressed: () {
                                            Navigator.of(context).pop(false);
                                          },
                                        ),
                                        TextButton(
                                          child: AppConstantText.yesDeleteAlert,
                                          onPressed: () async {
                                            try {
                                              await FirebaseFirestore.instance
                                                  .collection(
                                                      "directory-sponsors")
                                                  .doc(docId)
                                                  .delete();
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                const SnackBar(
                                                  content: Text(
                                                      "Sponsor deleted successfully"),
                                                ),
                                              );
                                              Navigator.of(context).pop(false);
                                            } catch (error) {
                                              print(
                                                  "Error deleting sponsor: $error");
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                const SnackBar(
                                                  content: Text(
                                                      "Failed to delete sponsor"),
                                                ),
                                              );
                                            }
                                          },
                                        ),
                                      ],
                                    );
                                  });
                            },
                            child: const Icon(
                              Icons.delete,
                              color: Colors.red,
                            ),
                          );
                        } else {
                          return Container();
                        }
                      }

                      return GestureDetector(
                        onTap: () {
                          var sponsorPriority =
                              results[index]['sponsorPriority'];
                          print("SPONSOR-PRIORITY $sponsorPriority");
                          var sponsorData =
                              results[index].data() as Map<String, dynamic>;
                          var docId = results[index].id;
                          print("INDEX $index TAPPED");
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SponsorDetailScreen(
                                        index: index,
                                        sponsorData: sponsorData,
                                        userId: docId,
                                      )));
                        },
                        child: Card(
                          elevation: 0,
                          semanticContainer: true,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          clipBehavior: Clip.antiAlias,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    FutureBuilder<Widget>(
                                      future: editIcon(),
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return CircularProgressIndicator(); // or any other loading indicator
                                        } else if (snapshot.hasError) {
                                          return Text(
                                              'Error: ${snapshot.error}');
                                        } else {
                                          return snapshot.data ??
                                              Container(); // return the button widget or an empty container if data is null
                                        }
                                      },
                                    ),
                                    const SizedBox(
                                      width: 8,
                                    ),
                                    FutureBuilder(
                                        future:
                                            deleteSponsor(results[index].id),
                                        builder: (context, snapshot) {
                                          if (snapshot.connectionState ==
                                              ConnectionState.waiting) {
                                            return CircularProgressIndicator(); // or any other loading indicator
                                          } else if (snapshot.hasError) {
                                            return Text(
                                                'Error: ${snapshot.error}');
                                          } else {
                                            return snapshot.data ??
                                                Container(); // return the button widget or an empty container if data is null
                                          }
                                        }),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Center(
                                  child: Stack(
                                    fit: StackFit.loose,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(20.0),
                                        child: FadeInImage(
                                          placeholder: AssetImage(
                                            Assets.userImage,
                                          ),
                                          image: NetworkImage(
                                            results[index]["sponsorImage"],
                                          ),
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("${results[index]['sponsorName']}",
                                      style: AppTextStyles.titleText),
                                ],
                              ),
                              const SizedBox(
                                height: 15,
                              )
                            ],
                          ),
                        ),
                      );
                    });
              } else {
                return Center(child: AppSponsorText.noDataFound);
              }
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }

  Future<Widget> floatingButton() async {
    var sharedPref = await SharedPreferences.getInstance();
    bool? isAdmin = sharedPref.getBool(MyAppState.ISADMIN);
    print("Are you an admin? $isAdmin");
    if (isAdmin == true) {
      return FloatingActionButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        backgroundColor: Theme.of(context).colorScheme.primary,
        onPressed: () async {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const SponsorRegistration(),
            ),
          );
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      );
    } else {
      return Container();
    }
  }
}
