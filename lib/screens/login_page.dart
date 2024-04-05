import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_directory_app/main.dart';
import 'package:flutter_directory_app/providers/phone_number_notifier.dart';
import 'package:flutter_directory_app/resources.dart';
import 'package:flutter_directory_app/screens/verify_otp.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _phoneController = TextEditingController();
  final _phoneFocusNode = FocusNode();
  bool _validateNumber = false;
  bool _loading = false;

  @override
  void dispose() {
    _phoneController.dispose();
    _phoneFocusNode.dispose();
    super.dispose();
  }

  String? _validatePhoneNumber(value) {
    final RegExp phoneRegex = RegExp(r'^\d{10}$');

    if (!phoneRegex.hasMatch(value)) {
      setState(() {
        _validateNumber = false;
      });
      return 'Enter a valid 10-digit phone number';
    } else {
      return null;
    }
  }

  void _sendOTP() async {
    String phone = "+91" + _phoneController.text.trim();
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phone,
      verificationCompleted: (credential) {},
      verificationFailed: (ex) {
        print(ex.code.toString());
      },
      codeSent: (verificationId, resendToken) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => VerifyOtpScreen(
              verificationId: verificationId,
              phoneNo: phone,
            ),
          ),
        );
      },
      codeAutoRetrievalTimeout: (verificationId) {},
      timeout: Duration(seconds: 80),
    );
  }

  @override
  Widget build(BuildContext context) {
    check() async {
      var sharedPref = await SharedPreferences.getInstance();
      var test = sharedPref.getString(MyAppState.PHONENUM);
      print("VALUE OF SHARED PREFERENCE PHONE NUMBER AT LOGIN PAGE IS $test");
    }

    check();
    final state = ref.watch(phoneNoProvider);
    print("value of phone number state in showdata page $state");
    return Scaffold(
      backgroundColor:const  Color.fromRGBO(255, 255, 255, 1),
      body: ModalProgressHUD(
        inAsyncCall: _loading,
        progressIndicator: LoadingAnimationWidget.twistingDots(
          leftDotColor: const Color.fromRGBO(5, 111, 146, 1),
          rightDotColor: Theme.of(context).colorScheme.primary,
          size: 40,
        ),
        child: SingleChildScrollView(
        
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 70),
                Stack(
                  children: [
                  
                    Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        width: 300,
                        height: 300,
                        // child: Image.asset('assets/images/loginImage.png'),
                        child: Image.asset(Assets.loginImage),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                   AppConstantText.loginTitle
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                   AppConstantText.enterMobileNo,
                  ],
                ),
                const SizedBox(height: 2),
                TextFormField(
                  controller: _phoneController,
                  focusNode: _phoneFocusNode,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    contentPadding:
                        const EdgeInsets.symmetric(vertical: 2, horizontal: 15),
                    prefixText: "+91",
                    errorText: _validateNumber
                        ? _validatePhoneNumber(_phoneController.text)
                        : null,
                    errorStyle: AppTextStyles.errorStyle,
                    enabledBorder: AppBorderStyle.enabledBorder,
                    focusedBorder: AppBorderStyle.focusedBorder,
                    errorBorder: AppBorderStyle.errorBorder,
                    focusedErrorBorder: AppBorderStyle.focusedErrorBorder,
                    fillColor: Colors.white,
                    filled: true,
                  ),
                ),
                const SizedBox(height: 10),
                // Row(
                //   children: [
                //     Flexible(
                //       child: RichText(
                //         overflow: TextOverflow.ellipsis,
                //         text: TextSpan(
                //           style: DefaultTextStyle.of(context).style,
                //           children: [
                //             TextSpan(
                //               text: "By continuing, I agree to the ",
                //               style: GoogleFonts.openSans(
                //                 textStyle: const TextStyle(
                //                   fontWeight: FontWeight.w400,
                //                   fontSize: 10,
                //                   color: Color.fromRGBO(122, 122, 122, 1),
                //                 ),
                //               ),
                //             ),
                //             TextSpan(
                //               text: "Terms of Use & Privacy Policy",
                //               style: GoogleFonts.openSans(
                //                 textStyle: TextStyle(
                //                   fontWeight: FontWeight.w600,
                //                   fontSize: 13,
                //                   color: Theme.of(context).colorScheme.primary,
                //                 ),
                //               ),
                //             ),
                //           ],
                //         ),
                //       ),
                //     ),
                //   ],
                // ),
                // const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      String phone = "+91" + _phoneController.text.trim();
                      final notifier = ref.read(phoneNoProvider.notifier);
                      notifier.setPhoneNo(phoneNo: phone);
                  
                      setState(() {
                        _validateNumber =
                            _validatePhoneNumber(_phoneController.text) != null;
                      });
                  
                      if (!_validateNumber) {
                        setState(() {
                          _loading = true;
                        });
                  
                        _sendOTP();
                        // clearScreen();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      backgroundColor:
                          Theme.of(context).colorScheme.primary,
                      foregroundColor: Colors.white,
                    ),
                    child:  AppConstantText.continueBtn
                ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
