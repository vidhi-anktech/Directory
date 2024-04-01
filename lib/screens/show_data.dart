import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_directory_app/screens/add_profile.dart';
import 'package:flutter_directory_app/screens/home_page.dart';
import 'package:flutter_directory_app/main.dart';
import 'package:flutter_directory_app/providers/phone_number_notifier.dart';
import 'package:flutter_directory_app/screens/register_details_page.dart';
import 'package:flutter_directory_app/screens/user-details-page.dart';
import 'package:get/utils.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShowData extends ConsumerStatefulWidget {
  const ShowData({
    super.key,
  });

  @override
  ConsumerState<ShowData> createState() => _ShowDataState();
}

class _ShowDataState extends ConsumerState<ShowData> {
  List _allResults = [];
  List resultList = [];
  late Stream<dynamic> dataStream;
  var checkNum;
  bool searchClick = false;
  var searchCityController = TextEditingController();
  var selectedCity;
  bool _toggle = true;
  // var checkNumber;

  void _doToggle() => setState(() => _toggle = !_toggle);

  Future check() async {
    var sharedPref = await SharedPreferences.getInstance();
    checkNum = sharedPref.getString(MyAppState.PHONENUM);
    checkNum = await checkNum;
    print("VALUE OF CHECK NUM IN CHECK() $checkNum");
    return checkNum;
  }

  checkLoggedIn() async {
    var sharedPref = await SharedPreferences.getInstance();
    var loggedIn = sharedPref.getBool(MyAppState.KEYLOGIN);
    print(" VALUE OF IS LOGGED IN in build context: $loggedIn");
    return loggedIn;
  }

  final TextEditingController searchController = TextEditingController();
  ScrollController _controller = ScrollController();

  @override
  void initState() {
    super.initState();

    dataStream = FirebaseFirestore.instance
        .collection("directory-users")
        .snapshots()
        .asBroadcastStream();
    searchController.addListener(onSearchChanged);
    _controller = ScrollController();

    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) async {
        checkNum = await check();

        setState(() {});
      },
    );
  }

  onSearchChanged() {
    searchResultList(_allResults);
  }

  searchResultList(List<dynamic> allResults) {
    var showResults = [];

    if (searchController.text != "") {
      for (var clientSnapShot in allResults) {
        var hName = clientSnapShot['hName'].toString().toLowerCase();
        var wName = clientSnapShot['wName'].toString().toLowerCase();
        var hCurrentAddress =
            clientSnapShot['hCurrentAddress'].toString().toLowerCase();
        var wCurrentAddress =
            clientSnapShot['wCurrentAddress'].toString().toLowerCase();
        var hCity = clientSnapShot['hCity'].toString().toLowerCase();
        var wCity = clientSnapShot['wCity'].toString().toLowerCase();
        var hGotra = clientSnapShot['hGotra'].toString().toLowerCase();
        var wGotra = clientSnapShot['wGotra'].toString().toLowerCase();
        var hContact = clientSnapShot['hContact'].toString();
        var wContact = clientSnapShot['wContact'].toString();

        if (hName.contains(searchController.text.toLowerCase()) ||
            wName.contains(searchController.text.toLowerCase()) ||
            hCurrentAddress.contains(searchController.text.toLowerCase()) ||
            wCurrentAddress.contains(searchController.text.toLowerCase()) ||
            hCity.contains(searchController.text.toLowerCase()) ||
            wCity.contains(searchController.text.toLowerCase()) ||
            hGotra.contains(searchController.text.toLowerCase()) ||
            wGotra.contains(searchController.text.toLowerCase()) ||
            wContact.contains(searchController.text) ||
            hContact.contains(searchController.text)) {
          showResults.add(clientSnapShot);
        }
      }
    }
    setState(() {
      resultList = showResults;
    });
  }

  getClientStream() async {
    searchResultList(_allResults);
  }

  @override
  void dispose() {
    searchController.removeListener(onSearchChanged);
    searchController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    getClientStream();
    super.didChangeDependencies();
  }

  String maskLastThreeDigits(String phoneNumber) {
    if (phoneNumber.length == 13) {
      String maskedNumber = '***-***-${phoneNumber.substring(10)}';
      return maskedNumber;
    } else {
      print("GRAND FAILURE");
      return phoneNumber;
    }
  }

  void logout() async {
    var sharedPref = await SharedPreferences.getInstance();
    sharedPref.setBool(MyAppState.KEYLOGIN, false);
    final notifier = ref.read(phoneNoProvider.notifier);
    notifier.setPhoneNo(phoneNo: '');
    sharedPref.setString(MyAppState.PHONENUM, '');
    sharedPref.setBool(MyAppState.ISADMIN, false);
    await FirebaseAuth.instance.signOut();
    // ignore: use_build_context_synchronously
    Navigator.popUntil(context, (route) => route.isFirst);
    // ignore: use_build_context_synchronously
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => HomePage()));
  }

  @override
  Widget build(BuildContext context) {
    check();
    checkLoggedIn();

    print("VALUE OF CHECK NUMBER INSIDE BUILD $checkNum");
    print("value of checkNum $checkNum");
    print("VALUE OF SEARCH CITY CONTROLLER TEXT ${searchCityController.text}");

    return Scaffold(
      backgroundColor: const Color.fromRGBO(246, 246, 246, 1),
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: StreamBuilder<dynamic>(
              stream: dataStream,
              builder: (context, snapshot) {
                return TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                        filled: true,
                        fillColor: const Color.fromRGBO(246, 246, 246, 1),
                        contentPadding: const EdgeInsets.symmetric(vertical: 0),
                        hintText: "Search",
                        hintStyle: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Color.fromRGBO(0, 0, 0, 0.4),
                        ),
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color.fromRGBO(225, 225, 225, 1),
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color.fromRGBO(225, 225, 225, 1),
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        prefixIcon: Image.asset('assets/images/search.png'),
                        prefixIconConstraints: const BoxConstraints(
                          minWidth: 35,
                          minHeight: 30,
                        ),
                        suffixIcon: GestureDetector(
                            onTap: () {
                              searchController.clear();
                            },
                            child: Image.asset('assets/images/cross.png'))),
                    onChanged: (searchController) {
                      _allResults = snapshot.data!.docs;
                      searchResultList(_allResults);
                    });
              }),
        ),
      ),
      drawer: FutureBuilder(
          future: check(),
          builder: (context, snapshot) {
            print("VALUE OF CHECK NUMBE INSIDE DRAWER $checkNum");

            return Drawer(
              child: ListView(
                children: [
                  DrawerHeader(
                    decoration: const BoxDecoration(
                        color: Color.fromRGBO(217, 217, 217, 1)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Jai-Jinendra!",
                          style: TextStyle(
                            // color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(height: 10),
                        if (checkNum == null || checkNum.isEmpty) ...[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Have you not logged in yet?",
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(context, '/second');
                                },
                                child: const Text(
                                  "Log in now.",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 12,
                                  ),
                                ),
                              )
                            ],
                          )
                        ] else
                          Text(
                            "$checkNum",
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                            ),
                          )
                      ],
                    ),
                  ),
                  ListTile(
                    title: const Text(
                      "Add profile",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    onTap: () async {
                      var sharedPref = await SharedPreferences.getInstance();
                      var isLoggedIn = sharedPref.getBool(MyAppState.KEYLOGIN);
                      print(
                          " VALUE OF IS LOGGED IN in userdetails: $isLoggedIn");
                      if (isLoggedIn != null) {
                        if (isLoggedIn == true) {
                          // ignore: use_build_context_synchronously
                          // Navigator.push(
                          //     context,
                          //     MaterialPageRoute(
                          //         builder: (context) => RegistrationPage())
                          //         );
                           Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const AddProfile())
                                  );
                        } else {
                          Navigator.pushNamed(context, '/second');
                        }
                      } else {
                        Navigator.pushNamed(context, '/second');
                      }
                    },
                  ),
                  const Divider(
                    thickness: 0.5,
                  ),
                  checkNum == null || checkNum.isEmpty
                      ? ListTile(
                          title: const Text(
                            'Login',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          onTap: () {
                            Navigator.pushNamed(context, '/second');
                          },
                        )
                      : ListTile(
                          title: const Text(
                            'Logout',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          onTap: logout),
                  const Divider(
                    thickness: 0.5,
                  ),
                ],
              ),
            );
          }),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(
              height: 15,
            ),
            // citySearchBar(),

            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 15.0),
            //   child: Align(
            //     alignment: Alignment.topLeft,
            //     child: Row(
            //       children: [
            //         Image.asset('assets/images/location.png'),
            //         const SizedBox(
            //           width: 10,
            //         ),
            //         SizedBox(
            //           width: 150,
            //           child: TextField(
            //             controller: searchCityController,
            //             textInputAction: TextInputAction.search,
            //             decoration: const InputDecoration.collapsed(
            //                 border: InputBorder.none,
            //                 hintText: "Enter your City",
            //                 hintStyle: TextStyle(
            //                     fontSize: 14,
            //                     fontWeight: FontWeight.w400,
            //                     color: Color.fromRGBO(0, 0, 0, 1))),
            //             onChanged: (val) {
            //               setState(() {
            //                 selectedCity = searchCityController.text
            //                     .trim()
            //                     .capitalizeFirst;
            //               });
            //             },
            //           ),
            //         ),
            //       ],
            //     ),
            //   ),
            // ),

            const SizedBox(
              height: 15,
            ),
            Expanded(
              child: StreamBuilder(
                stream: selectedCity != null && selectedCity.isNotEmpty
                    ? FirebaseFirestore.instance
                        .collection("directory-users")
                        .where("hCity", isEqualTo: selectedCity)
                        .snapshots()
                    : FirebaseFirestore.instance
                        .collection("directory-users")
                        .orderBy("hName", descending: false)
                        .snapshots(),
                builder: (context, snapshot) {
                  print(
                      "VALUE OF SELECT CITY CONTROLLER INSIDE BUILDER $selectedCity");
                  if (snapshot.connectionState == ConnectionState.active) {
                    if (snapshot.hasData && snapshot.data != null) {
                      if (searchController.text.isEmpty) {
                        _allResults = snapshot.data!.docs;
                        print("value of checkNum in streambuilder $checkNum");
                        return ListView.builder(
                          controller: _controller,
                          itemCount: _allResults.length,
                          itemBuilder: (context, index) {
                            var docId = _allResults[index].id;

                            String hPhoneNumber =
                                _allResults[index]['hContact'];
                            String maskedHPhoneNum =
                                maskLastThreeDigits(hPhoneNumber);
                            String wPhoneNumber;
                            String? maskedWPhoneNum;
                            if (_allResults[index]['wContact'] != null) {
                              wPhoneNumber = _allResults[index]['wContact'];
                              maskedWPhoneNum =
                                  maskLastThreeDigits(wPhoneNumber);
                            }

                            return GestureDetector(
                              onTap: () async {
                                var sharedPref =
                                    await SharedPreferences.getInstance();
                                var isLoggedIn =
                                    sharedPref.getBool(MyAppState.KEYLOGIN);
                                print(
                                    " VALUE OF IS LOGGED IN in userdetails: $isLoggedIn");
                                if (isLoggedIn != null) {
                                  if (isLoggedIn == true) {
                                    // ignore: use_build_context_synchronously
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => UserDetailsPage(
                                          userData: _allResults[index].data()
                                              as Map<String, dynamic>,
                                          userId: docId,
                                        ),
                                      ),
                                    );
                                  } else {
                                    Navigator.pushNamed(context, '/second');
                                  }
                                } else {
                                  Navigator.pushNamed(context, '/second');
                                }
                              },
                              child: Column(
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Container(
                                          decoration: const BoxDecoration(
                                            boxShadow: [
                                              BoxShadow(
                                                color: Color.fromARGB(
                                                    255, 236, 236, 236),
                                                blurRadius: 20.0,
                                                spreadRadius: 5.0,
                                              ),
                                            ],
                                          ),
                                          child: Card(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15.0),
                                            ),
                                            child: Column(
                                              children: [
                                                Container(
                                                  color: Colors.white,
                                                  child: Column(
                                                    children: [
                                                      ListTile(
                                                        leading: CircleAvatar(
                                                          radius: 25,
                                                          backgroundImage:
                                                              NetworkImage(
                                                            _allResults[index][
                                                                    "hProfilePic"] ??
                                                                '',
                                                          ),
                                                        ),
                                                        title: Text(
                                                          _allResults[index]
                                                                  ["hName"] +
                                                              " " +
                                                              _allResults[index]
                                                                  ["hGotra"] +
                                                              " ",
                                                          style: const TextStyle(
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600),
                                                        ),
                                                        subtitle: Column(
                                                          children: [
                                                            Row(
                                                              children: [
                                                                Text(
                                                                  "$maskedHPhoneNum",
                                                                  style:
                                                                      const TextStyle(
                                                                    fontSize:
                                                                        12,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                Text(
                                                                  "${_allResults[index]['hCity']}",
                                                                  style:
                                                                      const TextStyle(
                                                                    fontSize:
                                                                        12,
                                                                  ),
                                                                ),
                                                                _allResults[index]
                                                                            [
                                                                            'wProfilePic'] ==
                                                                        null
                                                                    ? Text(
                                                                        "more",
                                                                        style:
                                                                            TextStyle(
                                                                          color: Theme.of(context)
                                                                              .colorScheme
                                                                              .primary,
                                                                          fontSize:
                                                                              12,
                                                                          fontWeight:
                                                                              FontWeight.w400,
                                                                        ),
                                                                      )
                                                                    : Container(),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      if (_allResults[index][
                                                                  'wProfilePic'] !=
                                                              null &&
                                                          _allResults[index]
                                                                  ["wName"] !=
                                                              null &&
                                                          _allResults[index]
                                                                  ["wGotra"] !=
                                                              null &&
                                                          _allResults[index][
                                                                  "wContact"] !=
                                                              null) ...[
                                                        Column(
                                                          children: [
                                                            ListTile(
                                                              visualDensity:
                                                                  VisualDensity(
                                                                      vertical:
                                                                          -4),
                                                              leading:
                                                                  CircleAvatar(
                                                                radius: 25,
                                                                backgroundImage:
                                                                    NetworkImage(
                                                                  _allResults[index]
                                                                          [
                                                                          "wProfilePic"] ??
                                                                      '',
                                                                ),
                                                              ),
                                                              title: Text(
                                                                _allResults[index]
                                                                        [
                                                                        'wName'] +
                                                                    " " +
                                                                    _allResults[
                                                                            index]
                                                                        [
                                                                        'wGotra'],
                                                                style: const TextStyle(
                                                                    fontSize:
                                                                        14,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ),
                                                              subtitle: Column(
                                                                children: [
                                                                  if (_allResults[
                                                                              index]
                                                                          [
                                                                          "wContact"] !=
                                                                      null)
                                                                    Row(
                                                                      children: [
                                                                        Text(
                                                                          "$maskedWPhoneNum",
                                                                          style:
                                                                              const TextStyle(
                                                                            fontSize:
                                                                                11,
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  if (_allResults[
                                                                              index]
                                                                          [
                                                                          "wCity"] !=
                                                                      null)
                                                                    Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          Text(
                                                                            _allResults[index]['wCity'],
                                                                            style:
                                                                                const TextStyle(
                                                                              fontSize: 11,
                                                                            ),
                                                                          ),
                                                                          Text(
                                                                            "more",
                                                                            style:
                                                                                TextStyle(
                                                                              color: Theme.of(context).colorScheme.primary,
                                                                              fontSize: 12,
                                                                              fontWeight: FontWeight.w400,
                                                                            ),
                                                                          ),
                                                                        ])
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        )
                                                      ] else
                                                        Container(),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 5)
                                ],
                              ),
                            );
                          },
                        );
                      } else {
                        return ListView.builder(
                          controller: _controller,
                          itemCount: resultList.length,
                          itemBuilder: (context, index) {
                            var docId = resultList[index].id;

                            String hPhoneNumber = resultList[index]['hContact'];
                            String maskedHResultedPhoneNum =
                                maskLastThreeDigits(hPhoneNumber);
                            String? wPhoneNumber;
                            String? maskedWResultedPhoneNum;
                            if (resultList[index]['wContact'] != null) {
                              wPhoneNumber = resultList[index]['wContact'];
                              maskedWResultedPhoneNum =
                                  maskLastThreeDigits(wPhoneNumber!);
                            }

                            return GestureDetector(
                              onTap: () async {
                                var sharedPref =
                                    await SharedPreferences.getInstance();
                                var isLoggedIn =
                                    sharedPref.getBool(MyAppState.KEYLOGIN);
                                print(
                                    " VALUE OF IS LOGGED IN in userdetails: $isLoggedIn");
                                if (isLoggedIn != null) {
                                  if (isLoggedIn == true) {
                                    // ignore: use_build_context_synchronously
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => UserDetailsPage(
                                            userData: resultList[index].data()
                                                as Map<String, dynamic>,
                                            userId: docId),
                                      ),
                                    );
                                  } else {
                                    Navigator.pushNamed(context, '/second');
                                  }
                                } else {
                                  Navigator.pushNamed(context, '/second');
                                }
                              },
                              child: Container(
                                decoration: const BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: Color.fromARGB(255, 236, 236, 236),
                                      blurRadius: 20.0,
                                      spreadRadius: 5.0,
                                    ),
                                  ],
                                ),
                                child: Card(
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                  child: Column(
                                    children: [
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            child: Column(
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(1.0),
                                                  child: Column(
                                                    children: [
                                                      ListTile(
                                                        leading: CircleAvatar(
                                                          radius: 25,
                                                          backgroundImage:
                                                              NetworkImage(
                                                            resultList[index][
                                                                    "hProfilePic"] ??
                                                                '',
                                                          ),
                                                        ),
                                                        title: Text(
                                                          resultList[index]
                                                                  ["hName"] +
                                                              " " +
                                                              resultList[index]
                                                                  ["hGotra"] +
                                                              " ",
                                                          style: const TextStyle(
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600),
                                                        ),
                                                        subtitle: Column(
                                                          children: [
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                Text(
                                                                  "$maskedHResultedPhoneNum",
                                                                  style:
                                                                      const TextStyle(
                                                                    fontSize:
                                                                        12,
                                                                  ),
                                                                ),
                                                                resultList[index]
                                                                            [
                                                                            'wProfilePic'] ==
                                                                        null
                                                                    ? Text(
                                                                        "more",
                                                                        style:
                                                                            TextStyle(
                                                                          color: Theme.of(context)
                                                                              .colorScheme
                                                                              .primary,
                                                                          fontSize:
                                                                              12,
                                                                          fontWeight:
                                                                              FontWeight.w400,
                                                                        ),
                                                                      )
                                                                    : Container(),
                                                              ],
                                                            ),
                                                            Row(
                                                              children: [
                                                                Text(
                                                                  "${resultList[index]['hCity']}",
                                                                  style:
                                                                      const TextStyle(
                                                                    fontSize:
                                                                        12,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      if (resultList[index]
                                                                  ["wName"] !=
                                                              null &&
                                                          resultList[index]
                                                                  ["wGotra"] !=
                                                              null &&
                                                          resultList[index][
                                                                  "wProfilePic"] !=
                                                              null &&
                                                          resultList[index][
                                                                  "wContact"] !=
                                                              null) ...[
                                                        Column(
                                                          children: [
                                                            ListTile(
                                                              leading:
                                                                  CircleAvatar(
                                                                radius: 25,
                                                                backgroundImage:
                                                                    NetworkImage(
                                                                  resultList[index]
                                                                          [
                                                                          "wProfilePic"] ??
                                                                      '',
                                                                ),
                                                              ),
                                                              title: Text(
                                                                resultList[index]
                                                                        [
                                                                        'wName'] +
                                                                    " " +
                                                                    resultList[
                                                                            index]
                                                                        [
                                                                        'wGotra'],
                                                                style: const TextStyle(
                                                                    fontSize:
                                                                        14,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ),
                                                              subtitle: Column(
                                                                children: [
                                                                  Row(
                                                                    children: [
                                                                      Text(
                                                                        "$maskedWResultedPhoneNum",
                                                                        style:
                                                                            const TextStyle(
                                                                          fontSize:
                                                                              11,
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    children: [
                                                                      Text(
                                                                        "${resultList[index]['wCity']}",
                                                                        style:
                                                                            const TextStyle(
                                                                          fontSize:
                                                                              11,
                                                                        ),
                                                                      ),
                                                                      Text(
                                                                        "more",
                                                                        style:
                                                                            TextStyle(
                                                                          color: Theme.of(context)
                                                                              .colorScheme
                                                                              .primary,
                                                                          fontSize:
                                                                              12,
                                                                          fontWeight:
                                                                              FontWeight.w400,
                                                                        ),
                                                                      )
                                                                    ],
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        )
                                                      ] else
                                                        Container(),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      }
                    } else {
                      return const Text("No data");
                    }
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ),
            const SizedBox(height: 5),
          ],
        ),
      ),
    );
  }

  Widget citySearchBar() {
    return Stack(children: [
      GestureDetector(
        onTap: _doToggle,
        child: const SizedBox(
            height: kToolbarHeight * 0.8,
            child: Row(
              children: [
                Icon(
                  Icons.location_on,
                  size: 25.0,
                ),
                SizedBox(
                  width: 10.0,
                ),
                Text(
                  "Tap to select your city",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            )),
      ),
      AnimatedContainer(
        width: _toggle ? 0 : MediaQuery.of(context).size.width,
        transform: Matrix4.translationValues(
            _toggle ? MediaQuery.of(context).size.width : 0, 0, 0),
        duration: const Duration(seconds: 1),
        height: kToolbarHeight * 0.8,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5.0),
          border: Border.all(
            width: 0.5,
            color: Color.fromRGBO(225, 225, 225, 1),
          ),
        ),
        child: TextField(
          controller: searchCityController,
          textInputAction: TextInputAction.search,
          decoration: InputDecoration(
              contentPadding: EdgeInsets.zero,
              label: const Text("Enter Your City"),
              labelStyle:
                  const TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
              prefixIcon: AnimatedOpacity(
                  duration: const Duration(milliseconds: 1),
                  opacity: _toggle ? 0 : 1,
                  child: IconButton(
                    icon: const Icon(
                      Icons.arrow_back_ios,
                      size: 20,
                    ),
                    onPressed: _doToggle,
                  )),
              border: InputBorder.none),
          onChanged: (val) {
            setState(() {
              selectedCity = searchCityController.text.trim().capitalizeFirst;
            });
          },
        ),
      )
    ]);
  }
}
