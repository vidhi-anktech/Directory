import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_directory_app/resources.dart';
import 'package:url_launcher/url_launcher.dart';

class CustomerSupport extends StatefulWidget {
  const CustomerSupport({super.key});

  @override
  State<CustomerSupport> createState() => _CustomerSupportState();
}

class _CustomerSupportState extends State<CustomerSupport> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(242, 250, 254, 1),
      appBar: AppBar(
        title: AppConstantText.customerSupportAppBarText,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: SizedBox(
                    width: 300,
                    height: 300,
                    child: Image.asset(Assets.customerCare)),
              ),
              FittedBox(
                child: Column(
                  children: [
                    AppConstantText.customerSupportHeadingText1,
                    AppConstantText.customerSupportHeadingText2
                  ],
                ),
              ),
              const SizedBox(height: 50),
              ColoredBox(
                color: Colors.white,
                child: GestureDetector(
                  onTap: () {
                    final Uri emailLaunchUri = Uri(
                      scheme: 'mailto',
                      path: 'vidhi.jain@anktech.co.in',
                      query: encodeQueryParameters(<String, String>{
                        'subject':
                            'Feedback Request: How can we improve your experience?',
                      }),
                    );
                    launchUrl(emailLaunchUri);
                  },
                  child: ListTile(
                    leading: const Icon(Icons.email),
                    title: AppConstantText.emailText,
                    subtitle: AppConstantText.emailAddress,
                    trailing: const Icon(
                      Icons.arrow_forward_ios,
                      size: 15,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 5),
              ColoredBox(
                color: Colors.white,
                child: GestureDetector(
                  onTap: ()async{
                     final call = Uri.parse('tel:+91 9462546455');
                    if (await canLaunchUrl(call)) {
                      launchUrl(call);
                    } else {
                      throw 'Could not launch $call';
                    }
                  },
                  child: ListTile(
                    leading: const Icon(Icons.phone),
                    title: AppConstantText.callText,
                    subtitle: AppConstantText.phoneNumber,
                    trailing: const Icon(
                      Icons.arrow_forward_ios,
                      size: 15,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String? encodeQueryParameters(Map<String, String> params) {
    return params.entries
        .map((MapEntry<String, String> e) =>
            '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
        .join('&');
  }
}
