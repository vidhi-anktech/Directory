
import 'package:flutter/material.dart';
import 'package:flutter_directory_app/screens/edit_details_page.dart';
import 'package:flutter_directory_app/main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserDetailsPage extends StatefulWidget {
  final Map<String, dynamic> userData;
  var userId;
  UserDetailsPage({super.key, required this.userData, required this.userId});

  @override
  State<UserDetailsPage> createState() => _UserDetailsPageState();
}

class _UserDetailsPageState extends State<UserDetailsPage> {
  var textController = TextEditingController();
  var checkNum;


  void _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
    isAdmin = prefs.getBool(MyAppState.ISADMIN)!;
    });
  }

  bool isAdmin = false;

  check() async {
    var sharedPref = await SharedPreferences.getInstance();
    checkNum = sharedPref.getString(MyAppState.PHONENUM);
    print("VALUE OF CHECK NUM IN CHECK() $checkNum");
    return checkNum;
  }

    @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 10.0),
        child: Center(
          child: Container(
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Head of the family/Husband",
                        style: GoogleFonts.openSans(
                          textStyle: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        )),
                    GestureDetector(
                      onTap: () async {
                        print("VECTOR IMAGE TAPPED");

                        var sharedPref = await SharedPreferences.getInstance();
                        var checkNum =
                            sharedPref.getString(MyAppState.PHONENUM );
                              
                            print("ARe you an admin? $isAdmin");
                            print("Value of checknum $checkNum");
                        if (checkNum == widget.userData['addedBy'] ||
                            checkNum == widget.userData['hContact'] ||
                            checkNum == widget.userData['wContact'] ||
                            isAdmin == true) {
                          // ignore: use_build_context_synchronously
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditDetails(
                                userData: widget.userData,
                                userId: widget.userId,
                              ),
                            ),
                          );
                        }
                      },
                      child: FutureBuilder<dynamic>(
                        future: check(),
                        builder: (context, snapshot) {
                          var checkNum = snapshot.data;
                            print("ARe you an admin check? $isAdmin");
                          return (checkNum == widget.userData['addedBy'] ||
                                  checkNum == widget.userData['hContact'] ||
                                  checkNum == widget.userData['wContact'] ||
                                  isAdmin == true)
                              ? Image.asset('assets/images/editIcon.png')
                              : Container(); 
                        },
                      ),
                    ),
                  ],
                ),
                Container(
                  width: double.infinity,
                  color: Colors.white,
                  child: Card(
                    elevation: 0.5,
                    color: const Color.fromRGBO(255, 255, 255, 1),
                    child: Column(children: [
                      const SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        height: 150,
                        width: 150,
                        child: CircleAvatar(
                          radius: 60,
                          backgroundImage:
                              NetworkImage(widget.userData['hProfilePic']),
                          backgroundColor:
                              const Color.fromRGBO(243, 239, 239, 1),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Divider(
                        color: Colors.grey,
                        thickness: 0.5,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          children: [
                            Text("Name : ",
                                style: GoogleFonts.openSans(
                                  textStyle: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                )),
                            Text(
                                " ${widget.userData["hName"]} ${widget.userData["hGotra"]}",
                                style: GoogleFonts.openSans(
                                  textStyle: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                  ),
                                )),
                          ],
                        ),
                      ),
                      const Divider(
                        color: Colors.grey,
                        thickness: 0.5,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          children: [
                            Text("Occupation : ",
                                style: GoogleFonts.openSans(
                                  textStyle: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                )),
                            Text("${widget.userData["hOccupation"]}",
                                style: GoogleFonts.openSans(
                                  textStyle: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                  ),
                                )),
                          ],
                        ),
                      ),
                      const Divider(
                        color: Colors.grey,
                        thickness: 0.5,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          children: [
                            Text("Zip-Code : ",
                                style: GoogleFonts.openSans(
                                  textStyle: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                )),
                            Text("${widget.userData["hPinCode"]}",
                                style: GoogleFonts.openSans(
                                  textStyle: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                  ),
                                )),
                          ],
                        ),
                      ),
                      const Divider(
                        color: Colors.grey,
                        thickness: 0.5,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          children: [
                            const Text("City : ",
                                style: TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: 15)),
                            Text("${widget.userData["hCity"]}",
                                style: const TextStyle(
                                    fontWeight: FontWeight.w400, fontSize: 15)),
                          ],
                        ),
                      ),
                      const Divider(
                        color: Colors.grey,
                        thickness: 0.5,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          children: [
                            const Text("District : ",
                                style: TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: 15)),
                            Text("${widget.userData["hDistrict"]}",
                                style: const TextStyle(
                                    fontWeight: FontWeight.w400, fontSize: 15)),
                          ],
                        ),
                      ),
                      const Divider(
                        color: Colors.grey,
                        thickness: 0.5,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          children: [
                            const Text("State : ",
                                style: TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: 15)),
                            Text("${widget.userData["hState"]}",
                                style: const TextStyle(
                                    fontWeight: FontWeight.w400, fontSize: 15)),
                          ],
                        ),
                      ),
                      const Divider(
                        color: Colors.grey,
                        thickness: 0.5,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          children: [
                            const Text("Current Address : ",
                                style: TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: 15)),
                            Text("${widget.userData["hCurrentAddress"]}",
                                style: const TextStyle(
                                    fontWeight: FontWeight.w400, fontSize: 15)),
                          ],
                        ),
                      ),
                      const Divider(
                        color: Colors.grey,
                        thickness: 0.5,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          children: [
                            const Text("Contact : ",
                                style: TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: 15)),
                            Text("${widget.userData["hContact"]}",
                                style: const TextStyle(
                                    fontWeight: FontWeight.w400, fontSize: 15)),
                          ],
                        ),
                      ),
                      const Divider(
                        color: Colors.grey,
                        thickness: 0.5,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          children: [
                            const Text("Birth Place : ",
                                style: TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: 15)),
                            Text("${widget.userData["hBirthPlace"]}",
                                style: const TextStyle(
                                    fontWeight: FontWeight.w500, fontSize: 15)),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                    ]),
                  ),
                ),
                const SizedBox(height: 20),
                if (widget.userData["wName"] != null ||
                    widget.userData["wGotra"] != null ||
                    widget.userData["wOccupation"] != null ||
                    widget.userData["wContact"] != null ||
                    widget.userData['wCurrentAddress'] != null ||
                    widget.userData['wBirthPlace'] != null) ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Spouse",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      GestureDetector(
                          onTap: () async {
                        print("VECTOR IMAGE TAPPED");

                        var sharedPref = await SharedPreferences.getInstance();
                        var checkNum =
                            sharedPref.getString(MyAppState.PHONENUM);
                        if (checkNum == widget.userData['addedBy'] ||
                            checkNum == widget.userData['hContact'] ||
                            checkNum == widget.userData['wContact']) {
                          // ignore: use_build_context_synchronously
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditDetails(
                                userData: widget.userData,
                                userId: widget.userId,
                              ),
                            ),
                          );
                        }
                      },
                          child: FutureBuilder<dynamic>(
                        future: check(),
                        builder: (context, snapshot) {
                          var checkNum = snapshot.data;

                          return (checkNum == widget.userData['addedBy'] ||
                                  checkNum == widget.userData['hContact'] ||
                                  checkNum == widget.userData['wContact'])
                              ? Image.asset('assets/images/editIcon.png')
                              : Container(); 
                        },
                      ),
                      )
                    ],
                  ),
                  Container(
                    width: double.infinity,
                    color: Colors.white,
                    child: Card(
                      elevation: 0.5,
                      color: const Color.fromRGBO(255, 255, 255, 1),
                      child: Column(children: [
                        const SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                          height: 150,
                          width: 150,
                          child: CircleAvatar(
                            radius: 60,
                            backgroundImage:
                                NetworkImage(widget.userData['wProfilePic']),
                            backgroundColor:
                                const Color.fromRGBO(243, 239, 239, 1),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const Divider(
                          color: Colors.grey,
                          thickness: 0.5,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Row(
                            children: [
                              const Text("Name : ",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 15)),
                              Text(
                                  " ${widget.userData["wName"]} ${widget.userData["wGotra"]}",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 15)),
                            ],
                          ),
                        ),
                        const Divider(
                          color: Colors.grey,
                          thickness: 0.5,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Row(
                            children: [
                              const Text("Occupation : ",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 15)),
                              Text("${widget.userData["wOccupation"]}",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 15)),
                            ],
                          ),
                        ),
                        const Divider(
                          color: Colors.grey,
                          thickness: 0.5,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Row(
                            children: [
                              const Text("Zip-Code : ",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 15)),
                              Text("${widget.userData["wPinCode"]}",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 15)),
                            ],
                          ),
                        ),
                        const Divider(
                          color: Colors.grey,
                          thickness: 0.5,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Row(
                            children: [
                              const Text("City : ",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 15)),
                              Text("${widget.userData["wCity"]}",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 15)),
                            ],
                          ),
                        ),
                        const Divider(
                          color: Colors.grey,
                          thickness: 0.5,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Row(
                            children: [
                              const Text("District : ",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 15)),
                              Text("${widget.userData["wDistrict"]}",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 15)),
                            ],
                          ),
                        ),
                        const Divider(
                          color: Colors.grey,
                          thickness: 0.5,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Row(
                            children: [
                              const Text("State : ",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 15)),
                              Text("${widget.userData["wState"]}",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 15)),
                            ],
                          ),
                        ),
                        const Divider(
                          color: Colors.grey,
                          thickness: 0.5,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Row(
                            children: [
                              const Text("Current Address : ",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 15)),
                              Text("${widget.userData["wCurrentAddress"]}",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 15)),
                            ],
                          ),
                        ),
                        const Divider(
                          color: Colors.grey,
                          thickness: 0.5,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Row(
                            children: [
                              const Text("Contact : ",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 15)),
                              Text("${widget.userData["wContact"]}",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 15)),
                            ],
                          ),
                        ),
                        const Divider(
                          color: Colors.grey,
                          thickness: 0.5,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Row(
                            children: [
                              const Text("Birth Place : ",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 15)),
                              Text("${widget.userData["wBirthPlace"]}",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 15)),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                      ]),
                    ),
                  ),
                ] else
                  Container(),
              ]),
            ),
          ),
        ),
      ),
    );
  }
}
