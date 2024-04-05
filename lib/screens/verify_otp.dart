import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_directory_app/main.dart';
import 'package:flutter_directory_app/resources.dart';
import 'package:flutter_directory_app/screens/main_screen.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class VerifyOtpScreen extends ConsumerStatefulWidget {
  final String verificationId;
  final String phoneNo;
  const VerifyOtpScreen(
      {Key? key, required this.verificationId, required this.phoneNo})
      : super(key: key);

  @override
  ConsumerState<VerifyOtpScreen> createState() => _VerifyOtpScreenState();
}

class _VerifyOtpScreenState extends ConsumerState<VerifyOtpScreen>
    with CodeAutoFill {
  TextEditingController otpController = TextEditingController();
  String _verificationId = "";
  int? _resendToken = 0;
  String codeValue = "";
  bool _loading = false;
  Timer? _timer;
  int _countDown = 70;
  bool canResend = false;

  @override
  void codeUpdated() {
    setState(() {
      codeValue = code!;
    });
  }

  @override
  void initState() {
    super.initState();
    listenOtp();
    startTimer();
  }

  void listenOtp() async {
    await SmsAutoFill().listenForCode;
  }

  @override
  void dispose() {
    SmsAutoFill().unregisterListener();
    _timer?.cancel();
    super.dispose();
  }

  void startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_countDown > 0) {
          _countDown--;
        } else {
          canResend = true;
          _timer?.cancel();
        }
      });
    });
  }

  void verifyOTP() async {
    String otp = codeValue;

    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: widget.verificationId, smsCode: otp);

    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      if (userCredential.user != null) {
        var sharedPref = await SharedPreferences.getInstance();
        sharedPref.setBool(MyAppState.KEYLOGIN, true);
        sharedPref.setString(MyAppState.PHONENUM, widget.phoneNo);
        bool isAdminUser = await isAdmin(widget.phoneNo);
        if (isAdminUser) {
          sharedPref.setBool(MyAppState.ISADMIN, true);
          print("HELLO MR ADMIN");
          var admin = sharedPref.getBool(MyAppState.ISADMIN);
          print("are you an admin $admin");
        } else {
          sharedPref.setBool(MyAppState.ISADMIN, false);
          print("HELLO MR USER");
          var user = sharedPref.getBool(MyAppState.ISADMIN);
          print("are you an admin $user");
        }
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const MainScreen()));
      }
    } on FirebaseAuthException catch (ex) {
      print(ex.code.toString());
    }
  }

  void resendOTP(String phone) async {
    try {
      print("RESEND OTP FUNCTION CALLED");
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phone,
        verificationCompleted: (credential) {},
        verificationFailed: (ex) {
          print("ERROR : ${ex.code.toString()}");
        },
        codeSent: (String verificationId, int? resendToken) {
          print("CHECKING VERIFICATION ID: $verificationId");
          print("CHECKING RESEND TOKEN: $resendToken");
          setState(() {
            _verificationId = verificationId;
            _resendToken = resendToken!;
          });
          print("Resending OTP: $verificationId");
        },
        timeout: const Duration(seconds: 70),
        forceResendingToken: _resendToken,
        codeAutoRetrievalTimeout: (verificationId) {
          setState(() {
            _verificationId = verificationId;
          });
          print("Auto Retrieval Timeout: $verificationId");
        },
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("OTP Resent Successfully"),
        ),
      );
      //  startTimer();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<bool> isAdmin(String phoneNumber) async {
    try {
      var adminSnapshot = await FirebaseFirestore.instance
          .collection('admins')
          .where('phoneNumber', isEqualTo: widget.phoneNo)
          .get();

      // If there is a match, the user is an admin
      return adminSnapshot.docs.isNotEmpty;
    } catch (e) {
      print('Error checking admin status: $e');
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    check() async {
      var sharedPref = await SharedPreferences.getInstance();
      var test = sharedPref.getString(MyAppState.PHONENUM);
      print("VALUE OF SHARED PREFERENCE PHONE NUMBER AT Verify otp IS $test");
    }

    // check();
    print(
        "VALUE OF constructor PHONE NUMBER AT Verify otp IS ${widget.phoneNo}");
    return Scaffold(
      backgroundColor: const Color.fromRGBO(255, 255, 255, 1),
      body: ModalProgressHUD(
        inAsyncCall: _loading,
        progressIndicator: LoadingAnimationWidget.twistingDots(
          leftDotColor: const Color.fromRGBO(5, 111, 146, 1),
          rightDotColor: Theme.of(context).colorScheme.primary,
          size: 40,
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  AppConstantText.verifyTitleText
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Text(
                    "Sent via SMS to ${widget.phoneNo}",
                    style: AppTextStyles.smallText
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              PinFieldAutoFill(
                controller: otpController,
                decoration: UnderlineDecoration(
                  textStyle: const TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                  colorBuilder: const FixedColorBuilder(Colors.transparent),
                  bgColorBuilder:
                      FixedColorBuilder(Colors.grey.withOpacity(0.2)),
                ),
                currentCode: codeValue,
                codeLength: 6,
                onCodeChanged: (code) {
                  setState(() {
                    codeValue = code.toString();
                  });
                  // verifyOTP();
                  if (otpController.text.length == 6) {
                    verifyOTP();
                  }
                },
                onCodeSubmitted: (val) {
                  setState(() {
                    _loading = true;
                  });
                  verifyOTP();
                },
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Row(
                    children: [
                      canResend
                          ? InkWell(
                              onTap: () async {
                                print(
                                    "RESENDING OTP ON PHONE NUMBER : ${widget.phoneNo}");
                                resendOTP(widget.phoneNo);
                              },
                              child: AppConstantText.resendBtn
                            )
                          : AppConstantText.resendTxt
                    ],
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                AppConstantText.otpIn,
                  const SizedBox(
                    width: 5,
                  ),
                  Text(
                    "00:${_countDown.toString()}",
                    style: AppTextStyles.smallText
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
