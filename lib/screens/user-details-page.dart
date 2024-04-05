import 'package:flutter/material.dart';
import 'package:flutter_directory_app/resources.dart';
import 'package:flutter_directory_app/screens/edit_details_page.dart';
import 'package:flutter_directory_app/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserDetailsPage extends StatefulWidget {
  final Map<String, dynamic> userData;
  final userId;
  const UserDetailsPage(
      {super.key, required this.userData, required this.userId});

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
      appBar: AppBar(),
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
                    AppConstantText.headOfFamily,
                    GestureDetector(
                      onTap: () async {
                        print("VECTOR IMAGE TAPPED");

                        var sharedPref = await SharedPreferences.getInstance();
                        var checkNum =
                            sharedPref.getString(MyAppState.PHONENUM);

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
                              ? Image.asset(Assets.editIcon)
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
                            AppConstantText.name,
                            Text(
                                " ${widget.userData["hName"]} ${widget.userData["hGotra"]}",
                                style: AppTextStyles.subHeading),
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
                            AppConstantText.occupation,
                            Text("${widget.userData["hOccupation"]}",
                                style: AppTextStyles.subHeading),
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
                            AppConstantText.zipCode,
                            Text("${widget.userData["hPinCode"]}",
                                style: AppTextStyles.subHeading),
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
                            AppConstantText.city,
                            Text("${widget.userData["hCity"]}",
                                style: AppTextStyles.subHeading),
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
                            AppConstantText.district,
                            Text("${widget.userData["hDistrict"]}",
                                style: AppTextStyles.subHeading),
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
                            AppConstantText.state,
                            Text("${widget.userData["hState"]}",
                                style: AppTextStyles.subHeading),
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
                            AppConstantText.currentAddress,
                            Text("${widget.userData["hCurrentAddress"]}",
                                style: AppTextStyles.subHeading),
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
                            AppConstantText.contact,
                            Text("${widget.userData["hContact"]}",
                                style: AppTextStyles.subHeading),
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
                            AppConstantText.birthPlace,
                            Text("${widget.userData["hBirthPlace"]}",
                                style: AppTextStyles.subHeading),
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
                      AppConstantText.spouse,
                      GestureDetector(
                        onTap: () async {
                          print("VECTOR IMAGE TAPPED");

                          var sharedPref =
                              await SharedPreferences.getInstance();
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
                                ? Image.asset(Assets.editIcon)
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
                              AppConstantText.name,
                              Text(
                                  " ${widget.userData["wName"]} ${widget.userData["wGotra"]}",
                                  style: AppTextStyles.subHeading),
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
                             AppConstantText.occupation,
                              Text("${widget.userData["wOccupation"]}",
                                  style: AppTextStyles.subHeading),
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
                              AppConstantText.zipCode,
                              Text("${widget.userData["wPinCode"]}",
                                  style: AppTextStyles.subHeading),
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
                              AppConstantText.city,
                              Text("${widget.userData["wCity"]}",
                                  style: AppTextStyles.subHeading),
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
                             AppConstantText.district,
                              Text("${widget.userData["wDistrict"]}",
                                  style: AppTextStyles.subHeading),
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
                              AppConstantText.state,
                              Text("${widget.userData["wState"]}",
                                  style: AppTextStyles.subHeading),
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
                             AppConstantText.currentAddress,
                              Text("${widget.userData["wCurrentAddress"]}",
                                  style: AppTextStyles.subHeading),
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
                              AppConstantText.contact,
                              Text("${widget.userData["wContact"]}",
                                  style: AppTextStyles.subHeading),
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
                              AppConstantText.birthPlace,
                              Text("${widget.userData["wBirthPlace"]}",
                                  style: AppTextStyles.subHeading),
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
