import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_directory_app/resources.dart';
import 'package:url_launcher/url_launcher.dart';

class DeveloperScreen extends StatefulWidget {
  const DeveloperScreen({super.key});

  @override
  State<DeveloperScreen> createState() => _DeveloperScreenState();
}

class _DeveloperScreenState extends State<DeveloperScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(242, 250, 254, 1),
      appBar: AppBar(
        title: AppConstantText.developedAppBarText
      ),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Center(
              child: SizedBox(
                height: 500,
                width: 400,
                child: Image.asset('assets/images/anktech.JPG'),
              ),
            ),
            Positioned(
              left: 10,
              right: 10,
              bottom: -130,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                child: Container(
                  // color: 
                  //     const Color.fromARGB(255, 190, 190, 190).withOpacity(0.7),
                  color: Colors.white,
                  width: 300,
                  height: 300,
                  child: ConstrainedBox(
                      constraints: const BoxConstraints(minHeight: 50),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: CircleAvatar(
                              radius: 35,
                              backgroundImage: AssetImage(Assets.ashishJain),
                            ),
                          ),
                          AppConstantText.developerHeading,
                          const SizedBox(
                            height: 5,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.phone,
                                size: 20,
                                color: Color.fromARGB(255, 82, 81, 81),
                              ),
                              // AppConstantText.developerPhoneNumText,
                              AppConstantText.developerPhoneNum,
                            ],
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.web,
                                size: 20,
                                color: Color.fromARGB(255, 82, 81, 81),
                              ),
                              const SizedBox(width:5),
                              InkWell(
                                onTap: () {
                                  Uri url = Uri.parse(
                                      'https://www.anktech.co.in/');

                                  launchUrl(url);
                                },
                                child: AppConstantText.urlText
                              ),
                            ],
                          ),
                        ],
                      )),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }


}
