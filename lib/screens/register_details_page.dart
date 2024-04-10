import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_directory_app/main.dart';
import 'package:flutter_directory_app/resources.dart';
import 'package:flutter_directory_app/screens/main_screen.dart';
import 'package:get/utils.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;

class RegistrationPage extends ConsumerStatefulWidget {
  RegistrationPage({
    super.key,
  });

  @override
  ConsumerState<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends ConsumerState<RegistrationPage> {
  final snackBar = SnackBar(
    content: AppConstantText.wentWrong,
  );
  bool validate = false;
  bool _loading = false;
  bool validateHeadName = false;
  bool validateHeadGotra = false;
  bool validateHeadContact = false;
  bool validatePin = false;
  bool validateCity = false;
  bool validateHProfile = false;
  bool validateWProfile = false;
  bool validateWifeName = false;
  bool validateWifeGotra = false;
  bool validateWifeContact = false;
  bool validateWifeCity = false;

  final TextEditingController headNameController = TextEditingController();

  final TextEditingController headGotraController = TextEditingController();

  final TextEditingController headOccupationController =
      TextEditingController();

  final TextEditingController headContactController = TextEditingController();

  final TextEditingController headBirthplaceController =
      TextEditingController();

  final TextEditingController headCityPinController = TextEditingController();

  final TextEditingController headCityController = TextEditingController();

  final TextEditingController headDistrictController = TextEditingController();

  final TextEditingController headStateController = TextEditingController();

  final TextEditingController headCurrentAddressController =
      TextEditingController();

  final TextEditingController wifeNameController = TextEditingController();

  final TextEditingController wifeGotraController = TextEditingController();

  final TextEditingController wifeOccupationController =
      TextEditingController();

  final TextEditingController wifeContactController = TextEditingController();

  final TextEditingController wifeBirthplaceController =
      TextEditingController();
  final TextEditingController wifeCityPinController = TextEditingController();
  final TextEditingController wifeCityController = TextEditingController();
  final TextEditingController wifeDistrictController = TextEditingController();
  final TextEditingController wifeStateController = TextEditingController();
  final TextEditingController wifeCurrentAddressController =
      TextEditingController();
  final textController = TextEditingController();

  File? headProfilePic;
  File? wifeProfilePic;

  String pinCodeDetails = "";
  FocusNode focusNode = FocusNode();

  ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    hello() async {
      var sharedPref = await SharedPreferences.getInstance();
      var checkNum = sharedPref.getString(MyAppState.PHONENUM);
      print(
          "SHARED PREFERENCE CALLED AT BUILD CONTEXT OF REGISTRATION PAGE $checkNum");
    }

    hello();

    return Scaffold(
      appBar: AppBar(),
      body: ModalProgressHUD(
        inAsyncCall: _loading,
        progressIndicator: LoadingAnimationWidget.twistingDots(
          leftDotColor: const Color.fromRGBO(5, 111, 146, 1),
          rightDotColor: Theme.of(context).colorScheme.primary,
          size: 40,
        ),
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 5),
            child: SingleChildScrollView(
              controller: scrollController,
              child: Column(
                children: [
                  Column(children: [
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 0),
                          child: AppConstantText.headOfFamily,
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Card(
                      elevation: 0,
                      child: Column(
                        children: [
                          const SizedBox(height: 10),
                          Align(
                            alignment: Alignment.topCenter,
                            child: SizedBox(
                              child: CircleAvatar(
                                radius: 60.0,
                                backgroundColor:
                                    const Color.fromARGB(255, 168, 162, 162),
                                child: GestureDetector(
                                  onTap: () async {
                                    final hSelectedImage = await ImagePicker()
                                        .pickImage(source: ImageSource.gallery);
                                    if (hSelectedImage != null) {
                                      File convertedFile =
                                          File(hSelectedImage.path);

                                      // Crop feature for convertedFile of house-holder

                                      setState(() {
                                        headProfilePic = convertedFile;
                                      });
                                      print("Image selected");
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: AppConstantText.selectImage,
                                        ),
                                      );
                                    }
                                  },
                                  child: Column(
                                    children: [
                                      if (headProfilePic == null) ...[
                                        const SizedBox(
                                          height: 40,
                                        ),
                                        const Expanded(
                                          child: Align(
                                            alignment: Alignment.center,
                                            child: Icon(
                                              Icons.person_add,
                                              size: 30,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                      ],
                                      Expanded(
                                        child: CircleAvatar(
                                          radius: 58.0,
                                          backgroundColor: Colors.transparent,
                                          backgroundImage:
                                              headProfilePic != null
                                                  ? FileImage(headProfilePic!)
                                                  : null,
                                          child: const Align(
                                            alignment: Alignment.bottomRight,
                                            child: CircleAvatar(
                                              backgroundColor: Colors.white,
                                              radius: 18.0,
                                              child: Icon(
                                                Icons.camera_alt,
                                                size: 20.0,
                                                color: Color(0xFF404040),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          if (headProfilePic != null) ...[
                            IconButton(
                                onPressed: () {
                                  _cropImage();
                                },
                                icon: const Icon(Icons.crop))
                          ],
                          const SizedBox(height: 10),
                          _buildPersonForm("House-holder"),
                        ],
                      ),
                    ),
                  ]),
                  const SizedBox(height: 10),
                  Column(
                    children: [
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0, vertical: 0),
                              child: AppConstantText.spouse),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Card(
                        elevation: 0,
                        child: Column(
                          children: [
                            const SizedBox(height: 10),
                            Align(
                              alignment: Alignment.topCenter,
                              child: SizedBox(
                                child: CircleAvatar(
                                  radius: 60.0,
                                  backgroundColor:
                                      const Color.fromARGB(255, 168, 162, 162),
                                  child: GestureDetector(
                                    onTap: () async {
                                      final wSelectedImage = await ImagePicker()
                                          .pickImage(
                                              source: ImageSource.gallery);
                                      if (wSelectedImage != null) {
                                        File wConvertedFile =
                                            File(wSelectedImage.path);
                                        setState(() {
                                          wifeProfilePic = wConvertedFile;
                                        });
                                      } else {
                                        print("No image selected");
                                      }
                                    },
                                    child: Column(
                                      children: [
                                        if (wifeProfilePic == null) ...[
                                          const SizedBox(
                                            height: 40,
                                          ),
                                          const Expanded(
                                            child: Align(
                                              alignment: Alignment.center,
                                              child: Icon(
                                                Icons.person_add,
                                                size: 30,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ),
                                        ],
                                        Expanded(
                                          child: CircleAvatar(
                                            radius: 58.0,
                                            backgroundColor: Colors.transparent,
                                            backgroundImage:
                                                wifeProfilePic != null
                                                    ? FileImage(wifeProfilePic!)
                                                    : null,
                                            child: const Align(
                                              alignment: Alignment.bottomRight,
                                              child: CircleAvatar(
                                                backgroundColor: Colors.white,
                                                radius: 18.0,
                                                child: Icon(
                                                  Icons.camera_alt,
                                                  size: 20.0,
                                                  color: Color(0xFF404040),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            if (wifeProfilePic != null) ...[
                              IconButton(
                                  onPressed: () {
                                    _wCropImage();
                                  },
                                  icon: const Icon(Icons.crop))
                            ],
                            const SizedBox(height: 10),
                            _buildPersonForm("Spouse"),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      children: [
                        Expanded(flex: 3, child: _buildCancelButton()),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(flex: 3, child: _buildRegisterNowButton()),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            )),
      ),
    );
  }

  Future _cropImage() async {
    print('CROP IMAGE METHOD CALLED');
    if (headProfilePic != null) {
      CroppedFile? cropped = await ImageCropper()
          .cropImage(sourcePath: headProfilePic!.path, aspectRatioPresets: [
        CropAspectRatioPreset.square,
        CropAspectRatioPreset.ratio3x2,
        CropAspectRatioPreset.original,
        CropAspectRatioPreset.ratio4x3,
        CropAspectRatioPreset.ratio16x9
      ], uiSettings: [
        AndroidUiSettings(
            toolbarTitle: 'Crop',
            cropGridColor: Colors.black,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        IOSUiSettings(title: 'Crop')
      ]);

      if (cropped != null) {
        setState(() {
          headProfilePic = File(cropped.path);
        });
      }
    }
  }

  Future _wCropImage() async {
    print('CROP IMAGE METHOD CALLED');
    if (wifeProfilePic != null) {
      CroppedFile? cropped = await ImageCropper()
          .cropImage(sourcePath: wifeProfilePic!.path, aspectRatioPresets: [
        CropAspectRatioPreset.square,
        CropAspectRatioPreset.ratio3x2,
        CropAspectRatioPreset.original,
        CropAspectRatioPreset.ratio4x3,
        CropAspectRatioPreset.ratio16x9
      ], uiSettings: [
        AndroidUiSettings(
            toolbarTitle: 'Crop',
            cropGridColor: Colors.black,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        IOSUiSettings(title: 'Crop')
      ]);

      if (cropped != null) {
        setState(() {
          wifeProfilePic = File(cropped.path);
        });
      }
    }
  }

  _buildRegisterNowButton() {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          validate = true; // Set validation to true when button is pressed
        });
        if (_validateForm()) {
          if (wifeProfilePic != null) {
            if (_validateWifeForm()) {
              saveUser();
            } else {
              _hideLoading();
              setState(() {
                scrollController.animateTo(
                  scrollController.position.minScrollExtent,
                  curve: Curves.easeOut,
                  duration: const Duration(milliseconds: 500),
                );
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: AppConstantText.fillRequiredFieldsSpouseAlert,
                ),
              );
            }
          } else {
            saveUser();
            _hideLoading();
          }
        } else {
          setState(() {
            scrollController.animateTo(
              scrollController.position.minScrollExtent,
              curve: Curves.easeOut,
              duration: const Duration(milliseconds: 500),
            );
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: AppConstantText.fillRequiredFieldsAlert,
            ),
          );
        }
      },
      style: ElevatedButton.styleFrom(
        shape: AppBorderStyle.roundedRectangleBorder,
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      child: AppConstantText.save,
    );
  }

  Widget _buildCancelButton() {
    return ElevatedButton(
      onPressed: () async {
        final value = await showDialog<bool>(
            context: context,
            builder: (context) {
              return AlertDialog(
                content: AppConstantText.cancelAlert,
                actions: <Widget>[
                  TextButton(
                    child: AppConstantText.noAlert,
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    },
                  ),
                  TextButton(
                    child: AppConstantText.yesAlert,
                    onPressed: () {
                      Navigator.of(context).pop(true);
                      headProfilePic = null;
                      wifeProfilePic = null;
                      clearRegScreen();
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MainScreen()));
                    },
                  ),
                ],
              );
            });
     
      },
      style: ElevatedButton.styleFrom(
          side: AppBorderStyle.colorOutlinedBorderBtn,
          shape: AppBorderStyle.roundedRectangleBorder,
          backgroundColor: Colors.transparent,
          elevation: 0),
      child: AppConstantText.cancelBtn,
    );
  }

  _buildPersonForm(String title) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          _buildTextField(
            '$title Name',
            title == "House-holder" ? headNameController : wifeNameController,
            title == "House-holder" ? validateHeadName : validateWifeName,
            false,
            TextInputType.text,
          ),
          _buildTextField(
            '$title Gotra',
            title == "House-holder" ? headGotraController : wifeGotraController,
            title == "House-holder" ? validateHeadGotra : validateWifeGotra,
            false,
            TextInputType.text,
          ),
          _buildTextField(
            '$title Occupation',
            title == "House-holder"
                ? headOccupationController
                : wifeOccupationController,
            false,
            false,
            TextInputType.text,
          ),
          _buildPhoneNumTextField(
            '$title Phone Number',
            title == "House-holder"
                ? headContactController
                : wifeContactController,
            title == "House-holder" ? validateHeadContact : validateWifeContact,
          ),
          _buildTextField(
            '$title Birthplace',
            title == "House-holder"
                ? headBirthplaceController
                : wifeBirthplaceController,
            false,
            false,
            TextInputType.text,
          ),
          _buildZipCodeTextField(
            '$title Zip-code',
            title == 'House-holder'
                ? headCityPinController
                : wifeCityPinController,
            title == "House-holder" ? validatePin : false,
          ),
          _buildTextField(
            '$title City',
            title == 'House-holder' ? headCityController : wifeCityController,
            title == "House-holder" ? validateCity : validateWifeCity,
            false,
            TextInputType.text,
          ),
          _buildTextField(
            '$title District',
            title == 'House-holder'
                ? headDistrictController
                : wifeDistrictController,
            false,
            false,
            TextInputType.text,
          ),
          _buildTextField(
            '$title State',
            title == 'House-holder' ? headStateController : wifeStateController,
            false,
            false,
            TextInputType.text,
          ),
          _buildTextField(
            '$title CurrentAddress',
            title == "House-holder"
                ? headCurrentAddressController
                : wifeCurrentAddressController,
            false,
            false,
            TextInputType.text,
          ),
        ],
      ),
    );
  }

  _buildZipCodeTextField(
    String label,
    TextEditingController controller,
    bool validate,
  ) {
    return Column(
      children: [
        TextField(
          keyboardType: TextInputType.number,
          cursorColor: Colors.black,
          controller: controller,
          decoration: InputDecoration(
            labelText: label,
            contentPadding:
                const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            labelStyle: AppTextStyles.labelStyle,
            enabledBorder: AppBorderStyle.enabledBorder,
            focusedBorder: AppBorderStyle.focusedBorder,
            errorText: validate ? 'Required' : null,
            errorStyle: AppTextStyles.errorStyle,
          ),
          onChanged: (value) {
            if (value.length == 6) {
              getDataFromPinCode(value, label);
            }
          },
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  _buildTextField(
    String label,
    TextEditingController controller,
    bool validate,
    bool showSuffixIcon,
    TextInputType keyboardType,
  ) {
    return Column(
      children: [
        TextField(
          textCapitalization: TextCapitalization.words,
          keyboardType: keyboardType,
          cursorColor: Colors.black,
          controller: controller,
          decoration: InputDecoration(
            labelText: label,
            contentPadding:
                const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            labelStyle: AppTextStyles.labelStyle,
            enabledBorder: AppBorderStyle.enabledBorder,
            focusedBorder: AppBorderStyle.focusedBorder,
            errorText: validate ? 'Required' : null,
            errorStyle: AppTextStyles.errorStyle,
            errorBorder: AppBorderStyle.errorBorder,
            focusedErrorBorder: AppBorderStyle.focusedErrorBorder,
          ),
        ),
        const SizedBox(
          height: 10,
        )
      ],
    );
  }

  _buildPhoneNumTextField(
    String label,
    TextEditingController controller,
    bool validate,
  ) {
    return Column(
      children: [
        TextFormField(
          keyboardType: TextInputType.phone,
          cursorColor: Colors.black,
          controller: controller,
          decoration: InputDecoration(
            labelText: label,
            contentPadding:
                const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            labelStyle: AppTextStyles.labelStyle,
            enabledBorder: AppBorderStyle.enabledBorder,
            focusedBorder: AppBorderStyle.focusedBorder,
            errorText: validate ? 'Required' : null,
            errorStyle: AppTextStyles.errorStyle,
            errorBorder: AppBorderStyle.errorBorder,
            focusedErrorBorder: AppBorderStyle.focusedErrorBorder,
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Required';
            } else {
              String? validationResult = _validatePhoneNumber(value);
              return validationResult;
            }
          },
          onChanged: (value) {
            if (controller == headContactController) {}
          },
        ),
        const SizedBox(
          height: 10,
        )
      ],
    );
  }

  String? _validatePhoneNumber(String value) {
    // Validate phone number
    if (value.length != 10) {
      return 'Phone number must be 10 digits';
    }
    return null; // Return null if phone number is valid
  }

  Future<void> saveUser() async {
    Map<String, dynamic> userData;
    var sharedPref = await SharedPreferences.getInstance();
    var showNum = sharedPref.getString(MyAppState.PHONENUM);
    String? validationResult = _validatePhoneNumber(headContactController.text);
    String? validationWifeResult =
        _validatePhoneNumber(wifeContactController.text);
    print("VALIDATION WIFE RESULT $validationWifeResult");
    try {
      String hName = headNameController.text.trim();
      String hGotra = headGotraController.text.trim();
      String hOccupation = headOccupationController.text.trim();
      String hContactString = headContactController.text.trim();
      String hBirthplace = headBirthplaceController.text.trim();
      String hPinCode = headCityPinController.text.trim();
      String hState = headStateController.text.trim();
      String hDistrict = headDistrictController.text.trim();
      String hCity = headCityController.text.trim();
      String hCurrentAddress = headCurrentAddressController.text.trim();
      String wName = wifeNameController.text.trim();
      String wGotra = wifeGotraController.text.trim();
      String wOccupation = wifeOccupationController.text.trim();
      String wContactString = wifeContactController.text.trim();
      String wBirthplace = wifeBirthplaceController.text.trim();
      String wPinCode = wifeCityPinController.text.trim();
      String wState = wifeStateController.text.trim();
      String wDistrict = wifeDistrictController.text.trim();
      String wCity = wifeCityController.text.trim();
      String wCurrentAddress = wifeCurrentAddressController.text.trim();
      String hContact = "+91$hContactString";
      String wContact = "+91$wContactString";

      if (hName.isNotEmpty && hGotra.isNotEmpty && headProfilePic != null) {
        if (validationResult == null) {
          final headDownloadUrl =
              await uploadFile(headProfilePic!, "headProfilePictures");
          String? wifeDownloadUrl;

          if (wifeProfilePic != null) {
            // _onLoading();
            wifeDownloadUrl =
                await uploadFile(wifeProfilePic!, "wifeProfilePictures");
            if (wName.isNotEmpty &&
                wGotra.isNotEmpty &&
                wContact.isNotEmpty &&
                wCity.isNotEmpty) {
              if (validationWifeResult == null) {
                _onLoading();
                userData = {
                  "hProfilePic": headDownloadUrl,
                  "hName": hName.capitalizeFirst,
                  "hGotra": hGotra.capitalizeFirst,
                  "hOccupation": hOccupation.capitalizeFirst,
                  "hContact": hContact,
                  "hBirthPlace": hBirthplace.capitalizeFirst,
                  "hPinCode": hPinCode,
                  "hState": hState.capitalizeFirst,
                  "hDistrict": hDistrict.capitalizeFirst,
                  "hCity": hCity.capitalizeFirst,
                  "hCurrentAddress": hCurrentAddress.capitalizeFirst,
                  "addedBy": showNum,
                  "wProfilePic": wifeDownloadUrl,
                  "wName": wName.capitalizeFirst,
                  "wGotra": wGotra.capitalizeFirst,
                  "wOccupation": wOccupation.capitalizeFirst,
                  "wContact": wContact,
                  "wBirthPlace": wBirthplace.capitalizeFirst,
                  "wPinCode": wPinCode,
                  "wState": wState.capitalizeFirst,
                  "wDistrict": wDistrict.capitalizeFirst,
                  "wCity": wCity.capitalizeFirst,
                  "wCurrentAddress": wCurrentAddress.capitalizeFirst,
                };
                await FirebaseFirestore.instance
                    .collection("directory-users")
                    .add(userData);

                print("User Created!");
                _hideLoading();
                print("ADDED BY : ${showNum}");
                submitForm();
                setState(() {
                  scrollController.animateTo(
                    scrollController.position.minScrollExtent,
                    curve: Curves.easeOut,
                    duration: const Duration(milliseconds: 500),
                  );
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: AppConstantText.userSavedAlert,
                  ),
                );
                _hideLoading();
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => MainScreen()));
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(validationWifeResult)),
                );
              }
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: AppConstantText.fillRequiredFieldsSpouseAlert,
                ),
              );
              _hideLoading();
            }
          } else if (wName.isNotEmpty ||
              wGotra.isNotEmpty ||
              wOccupation.isNotEmpty ||
              wContact.isNotEmpty ||
              wBirthplace.isNotEmpty ||
              wPinCode.isNotEmpty ||
              wCity.isNotEmpty ||
              wDistrict.isNotEmpty ||
              wState.isNotEmpty ||
              wCurrentAddress.isNotEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: AppConstantText.selectSpouseImage,
              ),
            );
          } else {
            _onLoading();
            userData = {
              "hProfilePic": headDownloadUrl,
              "hName": hName.capitalizeFirst,
              "hGotra": hGotra.capitalizeFirst,
              "hOccupation": hOccupation.capitalizeFirst,
              "hContact": hContact,
              "hBirthPlace": hBirthplace.capitalizeFirst,
              "hPinCode": hPinCode,
              "hState": hState.capitalizeFirst,
              "hDistrict": hDistrict.capitalizeFirst,
              "hCity": hCity.capitalizeFirst,
              "hCurrentAddress": hCurrentAddress.capitalizeFirst,
              "addedBy": showNum,
              "wProfilePic": null,
              "wName": null,
              "wGotra": null,
              "wOccupation": null,
              "wContact": null,
              "wBirthPlace": null,
              "wPinCode": null,
              "wState": null,
              "wDistrict": null,
              "wCity": null,
              "wCurrentAddress": null,
            };
            // _onLoading();
            await FirebaseFirestore.instance
                .collection("directory-users")
                .add(userData);

            print("User Created!");
            print("ADDED BY : ${showNum}");
            submitForm();
            setState(() {
              scrollController.animateTo(
                scrollController.position.minScrollExtent,
                curve: Curves.easeOut,
                duration: const Duration(milliseconds: 500),
              );
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: AppConstantText.userSavedAlert,
              ),
            );
            // Navigator.pop(context);
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => MainScreen()));
          }
        } else {
          _hideLoading();
          print("HIDE LOADING CALLED");
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(validationResult)),
          );
          setState(() {
            scrollController.animateTo(
              scrollController.position.minScrollExtent,
              curve: Curves.easeOut,
              duration: const Duration(milliseconds: 500),
            );
          });
        }
      } else {
        _hideLoading();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: AppConstantText.selectImage,
          ),
        );
        // _hideLoading();
        // Navigator.pop(context);
        setState(() {
          scrollController.animateTo(
            scrollController.position.minScrollExtent,
            curve: Curves.easeOut,
            duration: const Duration(milliseconds: 500),
          );
        });
      }
    } catch (error) {
      print("Error saving user: $error");
      // _hideLoading();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: AppConstantText.wentWrong,
        ),
      );
    } finally {
      _hideLoading(); // Hide loading indicator whether there's an error or not
      setState(() {
        _loading = false;
      });
    }
  }

  Future<String> uploadFile(File file, String folder) async {
    try {
      final ref = FirebaseStorage.instance
          .ref()
          .child("Profilepictures")
          .child(folder)
          .child(Uuid().v1());
      final uploadTask = ref.putFile(file);
      final taskSnapshot = await uploadTask;
      return await taskSnapshot.ref.getDownloadURL();
    } catch (error) {
      print("Error uploading file: $error");
      throw error;
    }
  }

  void submitForm() {
    setState(() {
      _loading = false;
      clearRegScreen();
    });

    final headData = {
      'hName': headNameController.text.trim(),
      'hGotra': headGotraController.text.trim(),
      'hOccupation': headOccupationController.text.trim(),
      'hContactString': headContactController.text.trim(),
      'hBirthplace': headBirthplaceController.text.trim(),
      'hCurrentAddress': headCurrentAddressController.text.trim(),
      'hPinCode': headCityPinController.text.trim(),
      'hState': headStateController.text.trim(),
      'hCity': headCityController.text.trim(),
    };
    final wifeData = {
      'wName': wifeNameController.text.trim(),
      'wGotra': wifeGotraController.text.trim(),
      'wOccupation': wifeOccupationController.text.trim(),
      'wContactString': wifeContactController.text.trim(),
      'wBirthplace': wifeBirthplaceController.text.trim(),
      'wCurrentAddress': wifeCurrentAddressController.text.trim(),
      'wPinCode': wifeCityPinController.text.trim(),
      'wState': wifeStateController.text.trim(),
      'wCity': wifeCityController.text.trim(),
    };
    print('Head of the Family: $headData');
    print('Wife: $wifeData');
  }

  void clearRegScreen() {
    headNameController.clear();
    headGotraController.clear();
    headOccupationController.clear();
    headContactController.clear();
    headBirthplaceController.clear();
    headCityPinController.clear();
    headStateController.clear();
    headDistrictController.clear();
    headCityController.clear();
    headCurrentAddressController.clear();
    wifeNameController.clear();
    wifeGotraController.clear();
    wifeOccupationController.clear();
    wifeContactController.clear();
    wifeBirthplaceController.clear();
    wifeCityPinController.clear();
    wifeStateController.clear();
    wifeDistrictController.clear();
    wifeCityController.clear();
    wifeCurrentAddressController.clear();
    headProfilePic = null;
    wifeProfilePic = null;
  }

  void _onLoading() {
    _loading = true;
    if (_loading = true) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return SizedBox(
            height: 50,
            width: 50,
            child: Center(
              child: LoadingAnimationWidget.twistingDots(
                leftDotColor: const Color.fromRGBO(5, 111, 146, 1),
                rightDotColor: Theme.of(context).colorScheme.primary,
                size: 20,
              ),
            ),
          );
        },
      );
    } else {
      Container();
    }
  }

  void _hideLoading() {
    // Navigator.pop(context); // Close the loading dialog
    print("VALUE OF LOADING $_loading");
    setState(() {
      _loading = false;
    });
    setState(() {
      scrollController.animateTo(
        scrollController.position.minScrollExtent,
        curve: Curves.easeOut,
        duration: const Duration(milliseconds: 500),
      );
    });
  }

  _validateForm() {
    validateHeadName = headNameController.text.isEmpty;
    validateHeadGotra = headGotraController.text.isEmpty;
    validateHeadContact = headContactController.text.isEmpty;
    validateCity = headCityController.text.isEmpty;
    headProfilePic == null;

    return !validateHeadName &&
        !validateHeadGotra &&
        !validateHeadContact &&
        !validateCity;
    // && !validatePin;
  }

  _validateWifeForm() {
    validateWifeName = wifeNameController.text.isEmpty;
    validateWifeGotra = wifeGotraController.text.isEmpty;
    validateWifeContact = wifeContactController.text.isEmpty;
    validateWifeCity = wifeCityController.text.isEmpty;
    wifeProfilePic == null;

    return !validateWifeName &&
        !validateWifeGotra &&
        !validateWifeContact &&
        !validateWifeCity;
    // && !validatePin;
  }

  Future<void> getDataFromPinCode(String pinCode, String title) async {
    final url = "http://www.postalpincode.in/api/pincode/$pinCode";
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);

        if (jsonResponse['Status'] == 'Error') {
          showSnackbar(context, "Pin Code is not valid. ");
          setState(() {
            pinCodeDetails = 'Pin code is not valid.';
          });
        } else {
          final postOfficeArray = jsonResponse['PostOffice'] as List;
          final obj = postOfficeArray[0];

          final district = obj['District'];
          final state = obj['State'];

          setState(() {
            pinCodeDetails =
                'Details of pin code are:\nDistrict: $district\nState: $state';

            print("PINCODE DETAILS ARE: $pinCodeDetails");
            if (title == "House-holder Zip-code") {
              headDistrictController.text = district;
              headStateController.text = state;
            } else {
              wifeDistrictController.text = district;
              wifeStateController.text = state;
            }
          });
        }
      } else {
        showSnackbar(context, "Failed to fetch data. Please try again");
        setState(() {
          pinCodeDetails = 'Failed to fetch data. Please try again.';
        });
      }
    } catch (e) {
      showSnackbar(context, "Error Occurred. Please try again");
      setState(() {
        pinCodeDetails = 'Error occurred. Please try again.';
      });
    }
  }

  void showSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 2),
      ),
    );
  }
}
