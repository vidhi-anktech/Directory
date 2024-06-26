import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_directory_app/resources.dart';
import 'package:flutter_directory_app/screens/customer_support.dart';
import 'package:flutter_directory_app/screens/developer_screen.dart';
import 'package:flutter_directory_app/screens/home_page.dart';
import 'package:flutter_directory_app/main.dart';
import 'package:flutter_directory_app/providers/phone_number_notifier.dart';
import 'package:flutter_directory_app/screens/organizing_committee.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyProfile extends ConsumerStatefulWidget {
  const MyProfile({super.key});

  @override
  ConsumerState<MyProfile> createState() => _MyProfileState();
}

class _MyProfileState extends ConsumerState<MyProfile> {
  final textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
          child: Column(
        children: [
          _profileView(),
        ],
      )),
    );
  }

  void logout() async {
    var sharedPref = await SharedPreferences.getInstance();
    sharedPref.setBool(MyAppState.KEYLOGIN, false);
    final notifier = ref.read(phoneNoProvider.notifier);
    notifier.setPhoneNo(phoneNo: '');
    sharedPref.setString(MyAppState.PHONENUM, '');
    sharedPref.setBool(MyAppState.ISADMIN, false);
    await FirebaseAuth.instance.signOut();
    Navigator.popUntil(context, (route) => route.isFirst);
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => HomePage()));
  }

  Widget _profileView() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Card(
                elevation: 0.5,
                semanticContainer: true,
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const CustomerSupport()));
                      },
                      child: ListTile(
                        leading: GestureDetector(
                          child: Image.asset(Assets.customerSupport),
                        ),
                        title: AppConstantText.customerSupport,
                        trailing: IconButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const CustomerSupport()));
                            },
                            icon: const Icon(
                              Icons.arrow_forward_ios_outlined,
                              size: 18,
                            )),
                      ),
                    ),
                    const Divider(
                      color: Color.fromRGBO(222, 220, 220, 1),
                      thickness: 0.5,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => OrganizingCommittee()));
                      },
                      child: ListTile(
                        leading: GestureDetector(
                          child: Image.asset(Assets.organizingCommittee),
                        ),
                        title: AppConstantText.organizingCommittee,
                        trailing: IconButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          OrganizingCommittee()));
                            },
                            icon: const Icon(
                              Icons.arrow_forward_ios_outlined,
                              size: 18,
                            )),
                      ),
                    ),
                    const Divider(
                      color: Color.fromRGBO(222, 220, 220, 1),
                      thickness: 0.5,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const DeveloperScreen()));
                      },
                      child: ListTile(
                        leading: GestureDetector(
                          child: Image.asset(Assets.customerSupport),
                        ),
                        title: AppConstantText.developedBy,
                        trailing: IconButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const DeveloperScreen()));
                            },
                            icon: const Icon(
                              Icons.arrow_forward_ios_outlined,
                              size: 18,
                            )),
                      ),
                    ),
                    const Divider(
                      color: Color.fromRGBO(222, 220, 220, 1),
                      thickness: 0.5,
                    ),
                    const SizedBox(height: 80)
                  ],
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: ElevatedButton(
                          onPressed: () {
                            logout();
                          },
                          style: ElevatedButton.styleFrom(
                              side: AppBorderStyle.colorOutlinedBorderBtn,
                              shape: AppBorderStyle.roundedRectangleBorder,
                              backgroundColor: Colors.transparent,
                              elevation: 0),
                          child: AppConstantText.logOutBtn),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
