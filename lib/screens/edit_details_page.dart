import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_directory_app/resources.dart';
import 'package:flutter_directory_app/screens/main_screen.dart';
import 'package:get/utils.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:uuid/uuid.dart';

class EditDetails extends ConsumerStatefulWidget {
  final Map<String, dynamic> userData;
  final String userId;
  const EditDetails({
    super.key,
    required this.userData,
    required this.userId,
  });

  @override
  ConsumerState<EditDetails> createState() => _EditDetailsState();
}

class _EditDetailsState extends ConsumerState<EditDetails> {
  var textController = TextEditingController();
  final hNameEditController = TextEditingController();
  final hGotraEditController = TextEditingController();
  final hOccupationEditController = TextEditingController();
  final hPinCodeEditController = TextEditingController();
  final hDistrictEditController = TextEditingController();
  final hCityEditController = TextEditingController();
  final hStateEditController = TextEditingController();
  final hAddressEditController = TextEditingController();
  final hContactEditController = TextEditingController();
  final hBirthPlaceEditController = TextEditingController();
  final wNameEditController = TextEditingController();
  final wGotraEditController = TextEditingController();
  final wOccupationEditController = TextEditingController();
  final wAddressEditController = TextEditingController();
  final wPinCodeEditController = TextEditingController();
  final wDistrictEditController = TextEditingController();
  final wCityEditController = TextEditingController();
  final wStateEditController = TextEditingController();
  final wContactEditController = TextEditingController();
  final wBirthPlaceEditController = TextEditingController();
  final spouseNameController = TextEditingController();
  final spouseGotraController = TextEditingController();
  final spouseContactController = TextEditingController();
  final spouseOccupationController = TextEditingController();
  final spouseAddressController = TextEditingController();
  final spousePinCodeController = TextEditingController();
  final spouseStateController = TextEditingController();
  final spouseDistrictController = TextEditingController();
  final spouseCityController = TextEditingController();
  final spouseCurrentAddressController = TextEditingController();
  final spouseBirthPlaceController = TextEditingController();
  File? headEditedProfilePic;
  File? wifeEditedProfilePic;
  bool _loading = false;
  Map<String, dynamic> editedData = {};
  File? wifeProfilePic;
  bool validate = false;
  bool validateWifeName = false;
  bool validateWifeGotra = false;
  bool validateWifeCity = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? validationResult;
  String? validationWifeResult;
  String? validationEmptyWifeResult;
  ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ModalProgressHUD(
        inAsyncCall: _loading,
        progressIndicator: LoadingAnimationWidget.twistingDots(
          leftDotColor: const Color.fromRGBO(5, 111, 146, 1),
          rightDotColor: Theme.of(context).colorScheme.primary,
          size: 40,
        ),
        child: SingleChildScrollView(
          controller: scrollController,
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
            child: Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.always,
              // autovalidate: _autoValidate,
              child: Column(
                children: [
                  Column(
                    children: [
                       Row(
                        children: [
                         AppConstantText.headOfFamily
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      _buildHPersonDetails("Head", widget.userData),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                         AppConstantText.spouse
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      _buildWPersonDetails("Wife", widget.userData),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(flex: 3, child: _buildCancelButton()),
                        const SizedBox(
                          width: 15,
                        ),
                        Expanded(flex: 3, child: _buildUpdateNowButton()),
                      ]),
                  const SizedBox(height: 40)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHPersonDetails(String person, Map<String, dynamic> userData) {
    return Card(
      elevation: 0.7,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () async {
                final hSelectedImage =
                    await ImagePicker().pickImage(source: ImageSource.gallery);
                if (hSelectedImage != null) {
                  File editedFile = File(hSelectedImage.path);
                  setState(() {
                    headEditedProfilePic = editedFile;
                  });
                  print("Image selected");
                } else {
                  print("No image selected");
                }
              },
              child: headEditedProfilePic == null
                  ? CircleAvatar(
                      radius: 60,
                      backgroundImage:
                          NetworkImage(widget.userData['hProfilePic']))
                  : CircleAvatar(
                      radius: 60,
                      backgroundImage: FileImage(headEditedProfilePic!)),
            ),
            if (headEditedProfilePic != null) ...[
              TextButton(
                onPressed: () {
                  _cropImage();
                },
                child: AppConstantText.cropBtn
              )
            ] else
              TextButton(
                  onPressed: () async {
                    final hSelectedImage = await ImagePicker()
                        .pickImage(source: ImageSource.gallery);
                    if (hSelectedImage != null) {
                      File editedFile = File(hSelectedImage.path);
                      setState(() {
                        headEditedProfilePic = editedFile;
                      });
                    }
                  },
                  child: AppConstantText.editBtn
                  ),
            _buildTextField(
                "$person Name", "hName", userData["hName"], TextInputType.text),
            _buildTextField("$person Gotra", "hGotra", userData["hGotra"],
                TextInputType.text),
            _buildTextField("$person Occupation", "hOccupation",
                userData["hOccupation"], TextInputType.text),
            _buildTextField("$person Pin Code", "hPinCode",
                userData["hPinCode"], TextInputType.number),
            _buildTextField("$person State", "hState", userData["hState"],
                TextInputType.text),
            _buildTextField("$person District", "hDistrict",
                userData["hDistrict"], TextInputType.text),
            _buildTextField(
                "$person City", "hCity", userData["hCity"], TextInputType.text),
            _buildTextField("$person Current Address", "hCurrentAddress",
                userData["hCurrentAddress"], TextInputType.text),
            
            _buildPhoneTextField(
                "$person Contact Number",
                "hContact",
                userData["hContact"],
                TextInputType.phone,
                hContactEditController),
            _buildTextField("$person Birth Place", "hBirthPlace",
                userData["hBirthPlace"], TextInputType.text),
          ],
        ),
      ),
    );
  }

  Widget _buildWPersonDetails(String person, Map<String, dynamic> userData) {
    if (userData["wName"] != null ||
        userData["wGotra"] != null ||
        userData["wOccupation"] != null ||
        userData["wContact"] != null ||
        userData['wBirthPlace'] != null) {
      return Card(
        elevation: 0.7,
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              GestureDetector(
                onTap: () async {
                  final wSelectedImage = await ImagePicker()
                      .pickImage(source: ImageSource.gallery);
                  if (wSelectedImage != null) {
                    File wEditedFile = File(wSelectedImage.path);
                    setState(() {
                      wifeEditedProfilePic = wEditedFile;
                    });
                    print("Wife Image selected");
                  } else {
                    print("No Wife image selected");
                  }
                },
                child: wifeEditedProfilePic == null
                    ? CircleAvatar(
                        radius: 60,
                        backgroundImage:
                            NetworkImage(widget.userData['wProfilePic']))
                    : CircleAvatar(
                        radius: 60,
                        backgroundImage: FileImage(wifeEditedProfilePic!)),
              ),
              if (wifeEditedProfilePic != null) ...[
                TextButton(
                  onPressed: () {
                    _wEditedCropImage();
                  },
                  child: AppConstantText.cropBtn
                )
              ] else
                TextButton(
                    onPressed: () async {
                      final wSelectedImage = await ImagePicker()
                          .pickImage(source: ImageSource.gallery);
                      if (wSelectedImage != null) {
                        File wEditedFile = File(wSelectedImage.path);
                        setState(() {
                          wifeEditedProfilePic = wEditedFile;
                        });
                      }
                    },
                    child: AppConstantText.editBtn
                    ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTextField("$person Name", "wName", userData["wName"],
                      TextInputType.text),
                  _buildTextField("$person Gotra", "wGotra", userData["wGotra"],
                      TextInputType.text),
                  _buildTextField("$person Occupation", "wOccupation",
                      userData["wOccupation"], TextInputType.text),
                  _buildTextField("$person Pin Code", "wPinCode",
                      userData["wPinCode"], TextInputType.number),
                  _buildTextField("$person State", "wState", userData["wState"],
                      TextInputType.text),
                  _buildTextField("$person District", "wDistrict",
                      userData["wDistrict"], TextInputType.text),
                  _buildTextField("$person City", "wCity", userData["wCity"],
                      TextInputType.text),
                  _buildTextField("$person Current Address", "wCurrentAddress",
                      userData["wCurrentAddress"], TextInputType.text),
                  _buildContactTextField("$person Contact Number", "wContact",
                      wContactEditController, userData['wContact']),
                  _buildTextField("$person Birth Place", "wBirthPlace",
                      userData["wBirthPlace"], TextInputType.text),
                ],
              ),
            ],
          ),
        ),
      );
    } else {
      return Column(
        children: [
          Card(
            elevation: 0.7,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 10),
                  GestureDetector(
                    onTap: () async {
                      final wSelectedImage = await ImagePicker()
                          .pickImage(source: ImageSource.gallery);

                      if (wSelectedImage != null) {
                        File wConvertedFile = File(wSelectedImage.path);
                        setState(() {
                          wifeProfilePic = wConvertedFile;
                        });
                        print("Image selected");
                      } else {
                        print("No image selected");
                      }
                    },
                    child: wifeProfilePic == null
                        ? const CircleAvatar(
                            radius: 60,
                            backgroundColor: Color.fromARGB(255, 219, 215, 215),
                          )
                        : CircleAvatar(
                            radius: 60,
                            backgroundImage: FileImage(wifeProfilePic!)),
                  ),
                  if (wifeProfilePic != null) ...[
                    TextButton(
                      onPressed: () {
                        _wCropImage();
                      },
                      child: AppConstantText.cropBtn
                    )
                  ] else
                    TextButton(
                        onPressed: () async {
                          final wSelectedImage = await ImagePicker()
                              .pickImage(source: ImageSource.gallery);
                          if (wSelectedImage != null) {
                            File wConvertedFile = File(wSelectedImage.path);
                            setState(() {
                              wifeProfilePic = wConvertedFile;
                            });
                          }
                        },
                        child: AppConstantText.addImageBtn,
                        ),
                  const SizedBox(height: 5),
                  _buildWifeEmptyTextField('Spouse Name', spouseNameController,
                      'wName', validateWifeName, TextInputType.text),
                  _buildWifeEmptyTextField(
                      'Spouse Gotra',
                      spouseGotraController,
                      'wGotra',
                      validateWifeGotra,
                      TextInputType.text),
                  _buildWifeEmptyTextField(
                      'Spouse Occupation',
                      spouseOccupationController,
                      'wOccupation',
                      false,
                      TextInputType.text),
                  _buildWifeEmptyTextField(
                      'Spouse Pin Code',
                      spousePinCodeController,
                      'wPinCode',
                      false,
                      TextInputType.number),
                  _buildWifeEmptyTextField(
                      'Spouse State',
                      spouseStateController,
                      'wState',
                      false,
                      TextInputType.text),
                  _buildWifeEmptyTextField(
                      'Spouse District',
                      spouseDistrictController,
                      'wDistrict',
                      false,
                      TextInputType.text),
                  _buildWifeEmptyTextField('Spouse City', spouseCityController,
                      'wCity', validateWifeCity, TextInputType.text),
                 
                  _buildEmptyContactTextField(
                      'Spouse Contact', 'wContact', spouseContactController),
                  _buildWifeEmptyTextField(
                      'Spouse Birthplace',
                      spouseBirthPlaceController,
                      'wBirthPlace',
                      false,
                      TextInputType.text),
                  _buildWifeEmptyTextField(
                      'Spouse CurrentAddress',
                      spouseCurrentAddressController,
                      'wCurrentAddress',
                      false,
                      TextInputType.text),
                ],
              ),
            ),
          ),
        ],
      );
    }
  }

  Widget _buildContactTextField(String label, String field,
      TextEditingController controller, String initialValue) {
    String last10Digits = initialValue.length >= 10
        ? initialValue.substring(initialValue.length - 10)
        : initialValue;
    return Column(
      children: [
        TextFormField(
          textCapitalization: TextCapitalization.words,
          keyboardType: TextInputType.phone,
          // controller: controller,
          initialValue: last10Digits,
          style: AppTextStyles.initialValueStyle,
          decoration: InputDecoration(
            contentPadding:
                const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            labelText: label,
            labelStyle: AppTextStyles.labelStyle,
            enabledBorder: AppBorderStyle.enabledBorder,
            focusedBorder: AppBorderStyle.focusedBorder,
            errorStyle: AppTextStyles.errorStyle,
            errorBorder: AppBorderStyle.errorBorder,
            focusedErrorBorder: AppBorderStyle.focusedErrorBorder
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'required';
            } else {
              String? validationWifeResult = _validateWifePhoneNumber(value);
              return validationWifeResult;
            }
          },
          onChanged: (value) {
            validationWifeResult = _validateWifePhoneNumber(value);
            print("VALIDATIONWIFERESULT $validationWifeResult");
          },
        ),
        const SizedBox(
          height: 10,
        )
      ],
    );
  }

  Widget _buildEmptyContactTextField(
      String label, String field, TextEditingController controller) {
    return Column(
      children: [
        TextFormField(
          textCapitalization: TextCapitalization.words,
          keyboardType: TextInputType.phone,
          controller: spouseContactController,
          style: AppTextStyles.initialValueStyle,
          decoration: InputDecoration(
            contentPadding:
                const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            labelText: label,
           labelStyle: AppTextStyles.labelStyle,
            enabledBorder: AppBorderStyle.enabledBorder,
            focusedBorder: AppBorderStyle.focusedBorder,
            errorStyle: AppTextStyles.errorStyle,
            errorBorder: AppBorderStyle.errorBorder,
            focusedErrorBorder: AppBorderStyle.focusedErrorBorder
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Required';
            } else {
              String? validationEmptyWifeResult =
                  _validateEmptyWifePhoneNumber(value);
              return validationEmptyWifeResult;
            }
          },
          onChanged: (value) {
            validationEmptyWifeResult = _validateEmptyWifePhoneNumber(value);

            print(
                "VALIDATIONWIFERESULT HUAHHHHHAHAHHAH $validationEmptyWifeResult");
          },
        ),
        const SizedBox(
          height: 10,
        )
      ],
    );
  }

  _buildWifeEmptyTextField(
    String label,
    TextEditingController controller,
    String field,
    bool validate,
    TextInputType keyboardType,
  ) {
    print("VALUE OF BOOOOOLL VAIDATE $validate");
    return Column(
      children: [
        TextField(
          textCapitalization: TextCapitalization.words,
          keyboardType: keyboardType,
          cursorColor: Colors.black,
          controller: controller,
          decoration: InputDecoration(
            contentPadding:
                const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
            enabledBorder: AppBorderStyle.enabledBorder,
            focusedBorder: AppBorderStyle.focusedBorder,
            labelText: label,
            labelStyle: AppTextStyles.labelStyle,
            errorText: validate ? 'Required' : null,
            errorStyle: AppTextStyles.errorStyle,
            errorBorder: AppBorderStyle.errorBorder,
            focusedErrorBorder: AppBorderStyle.focusedErrorBorder,
          ),
          onChanged: (value) {
            editedData[field] = value.capitalize ?? "";
            // if (validateForm()) {
            //   editedData[field] = value.capitalize ?? "";
            // }
          },
        ),
        const SizedBox(height: 10)
      ],
    );
  }

  Widget _buildTextField(
    String label,
    String field,
    String? initialValue,
    TextInputType keyboardType,
  ) {
    return Column(
      children: [
        TextFormField(
          textCapitalization: TextCapitalization.words,
          keyboardType: keyboardType,
          initialValue: initialValue ?? '',
          style: AppTextStyles.initialValueStyle,
          decoration: InputDecoration(
            contentPadding:
                const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            labelText: label,
            labelStyle: AppTextStyles.labelStyle,
            enabledBorder: AppBorderStyle.enabledBorder,
            focusedBorder: AppBorderStyle.focusedBorder,
            errorStyle: AppTextStyles.errorStyle,
            errorBorder: AppBorderStyle.errorBorder,
            focusedErrorBorder: AppBorderStyle.focusedErrorBorder
          ),
          onChanged: (value) {
            editedData[field] = value.capitalizeFirst ?? "";
          },
        ),
        const SizedBox(
          height: 10,
        )
      ],
    );
  }

  Widget _buildPhoneTextField(String label, String field, String? initialValue,
      TextInputType keyboardType, TextEditingController controller) {
    String last10Digits = initialValue != null && initialValue.length >= 10
        ? initialValue.substring(initialValue.length - 10)
        : initialValue ?? '';
    return Column(
      children: [
        TextFormField(
          keyboardType: keyboardType,
          // initialValue: initialValue ?? '',
          initialValue: last10Digits,
          style: AppTextStyles.initialValueStyle,
          decoration: InputDecoration(
            contentPadding:
                const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            labelText: label,
            labelStyle: AppTextStyles.labelStyle,
            enabledBorder: AppBorderStyle.enabledBorder,
            focusedBorder: AppBorderStyle.focusedBorder,
            errorStyle: AppTextStyles.errorStyle,
            errorBorder: AppBorderStyle.errorBorder,
            focusedErrorBorder: AppBorderStyle.focusedErrorBorder
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
            validationResult = _validatePhoneNumber(value);
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
    } else {
      editedData['hContact'] = "+91$value";
      return null; // Return null if phone number is valid
    }
  }

  String? _validateWifePhoneNumber(String value) {
    // Validate phone number
    if (value.length != 10) {
      return 'Phone number must be 10 digits';
    } else {
      editedData['wContact'] = "+91$value";
      return null; // Return null if phone number is valid
    }
  }

  String? _validateEmptyWifePhoneNumber(String value) {
    // Validate phone number
    if (value.length != 10) {
      return 'Phone number must be 10 digits';
    } else {
      editedData['wContact'] = "+91$value";
      return ""; // Return null if phone number is valid
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

  Widget _buildCancelButton() {
    return ElevatedButton(
      onPressed: () {
        Navigator.pop(context);
      },
      style: ElevatedButton.styleFrom(
          side: AppBorderStyle.colorOutlinedBorderBtn,
          shape: AppBorderStyle.roundedRectangleBorder,
          backgroundColor: Colors.transparent,
          elevation: 0),
      child: AppConstantText.cancelBtn
    );
  }

  Widget _buildUpdateNowButton() {
    print("Result Validation $validationResult");
    print("Result Wife validation $validationWifeResult");
    print("Result HUUUHAHAHAHA $validationEmptyWifeResult");

    return ElevatedButton(
      onPressed: () async {
        if (spouseNameController.text.isEmpty &&
            spouseGotraController.text.isEmpty &&
            spouseOccupationController.text.isEmpty &&
            spousePinCodeController.text.isEmpty &&
            spouseStateController.text.isEmpty &&
            spouseDistrictController.text.isEmpty &&
            spouseCityController.text.isEmpty &&
            spouseContactController.text.isEmpty &&
            spouseBirthPlaceController.text.isEmpty &&
            spouseCurrentAddressController.text.isEmpty) {
          if (wifeProfilePic == null) {
            print("Result Validation aaa $validationResult");
            if (validationResult == null) {
              setState(() {
                _loading = true;
              });
              await _uploadAndSaveImage();
              await FirebaseFirestore.instance
                  .collection("directory-users")
                  .doc(widget.userId)
                  .update(editedData)
                  .then((value) => {
                        print("HURRAAAYYY! DATA UPDATED SUCCESSFULLY"),
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const MainScreen())),
                        // Navigator.pop(context),
                      });
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: AppConstantText.invalidPhoneNo),
              );
            }
          }
        } else {
          if (wifeProfilePic == null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content:
                     AppConstantText.selectSpouseImage),
            );
          } else {
            if (validateForm()) {
              if (validationEmptyWifeResult != null &&
                  validationEmptyWifeResult == '') {
                setState(() {
                  _loading = true;
                });
                await _uploadAndSaveImage();
                await FirebaseFirestore.instance
                    .collection("directory-users")
                    .doc(widget.userId)
                    .update(editedData)
                    .then((value) => {
                          print("HURRAAAYYY! DATA UPDATED SUCCESSFULLY"),
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const MainScreen())),
                          // Navigator.pop(context),
                        });
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content: AppConstantText.invalidPhoneNo),
                );
              }
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                 SnackBar(content: AppConstantText.fillRequiredFieldsAlert),
              );
              setState(() {
                validateWifeName == true;
                validateWifeGotra == true;
                validateWifeCity == true;
              });
            }
          }
        }
      },
      style: ElevatedButton.styleFrom(
        shape: AppBorderStyle.roundedRectangleBorder,
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      child: AppConstantText.updateBtn,
    );
  }

  Future<void> _uploadAndSaveImage() async {
    if (headEditedProfilePic != null) {
      final downloadUrl =
          await uploadFile(headEditedProfilePic!, "headProfilePictures");
      setState(() {
        editedData['hProfilePic'] = downloadUrl;
      });
    }

    if (wifeEditedProfilePic != null) {
      final wDownloadUrl =
          await uploadFile(wifeEditedProfilePic!, "wifeProfilePictures");
      setState(() {
        editedData['wProfilePic'] = wDownloadUrl;
      });
    } else if (wifeProfilePic != null) {
      final wifeDownloadUrl =
          await uploadFile(wifeProfilePic!, "wifeProfilePictures");
      setState(() {
        editedData['wProfilePic'] = wifeDownloadUrl;
      });
    }
  }

  Future _cropImage() async {
    if (headEditedProfilePic != null) {
      CroppedFile? cropped = await ImageCropper().cropImage(
          sourcePath: headEditedProfilePic!.path,
          aspectRatioPresets: [
            CropAspectRatioPreset.square,
            CropAspectRatioPreset.ratio3x2,
            CropAspectRatioPreset.original,
            CropAspectRatioPreset.ratio4x3,
            CropAspectRatioPreset.ratio16x9
          ],
          uiSettings: [
            AndroidUiSettings(
                toolbarTitle: 'Crop',
                cropGridColor: Colors.black,
                initAspectRatio: CropAspectRatioPreset.original,
                lockAspectRatio: false),
            IOSUiSettings(title: 'Crop')
          ]);

      if (cropped != null) {
        setState(() {
          headEditedProfilePic = File(cropped.path);
        });
      }
    }
  }

  Future _wEditedCropImage() async {
    if (wifeEditedProfilePic != null) {
      CroppedFile? cropped = await ImageCropper().cropImage(
          sourcePath: wifeEditedProfilePic!.path,
          aspectRatioPresets: [
            CropAspectRatioPreset.square,
            CropAspectRatioPreset.ratio3x2,
            CropAspectRatioPreset.original,
            CropAspectRatioPreset.ratio4x3,
            CropAspectRatioPreset.ratio16x9
          ],
          uiSettings: [
            AndroidUiSettings(
                toolbarTitle: 'Crop',
                cropGridColor: Colors.black,
                initAspectRatio: CropAspectRatioPreset.original,
                lockAspectRatio: false),
            IOSUiSettings(title: 'Crop')
          ]);

      if (cropped != null) {
        setState(() {
          wifeEditedProfilePic = File(cropped.path);
        });
      }
    }
  }

  Future _wCropImage() async {
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

  validateForm() {
    validateWifeName = spouseNameController.text.isEmpty;
    validateWifeGotra = spouseGotraController.text.isEmpty;
    validateWifeCity = spouseCityController.text.isEmpty;

    return !validateWifeName && !validateWifeGotra && !validateWifeCity;
  }
}
