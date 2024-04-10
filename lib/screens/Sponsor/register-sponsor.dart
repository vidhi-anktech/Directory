import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_directory_app/resources.dart';
import 'package:get/utils.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:uuid/uuid.dart';

class SponsorRegistration extends StatefulWidget {
  const SponsorRegistration({super.key});

  @override
  State<SponsorRegistration> createState() => _SponsorRegistrationState();
}

class _SponsorRegistrationState extends State<SponsorRegistration> {
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final priorityController = TextEditingController();

  bool validateName = false;
  File? profilePic;
  bool validate = false;
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AppSponsorText.addSponsorTxt,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 10),
              Card(
                elevation: 0,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.topCenter,
                        child: Column(
                          children: [
                            SizedBox(
                              child: 
                              CircleAvatar(
                                radius: 60.0,
                                backgroundColor:
                                    const Color.fromARGB(255, 168, 162, 162),
                                child: GestureDetector(
                                  onTap: () async {
                                    final selectedImage = await ImagePicker()
                                        .pickImage(source: ImageSource.gallery);
                                    if (selectedImage != null) {
                                      File convertedFile =
                                          File(selectedImage.path);

                                      setState(() {
                                        profilePic = convertedFile;
                                      });
                                      // print("Image selected");
                                    } else {
                                      // ignore: use_build_context_synchronously
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: AppSponsorText.chooseImage,
                                        ),
                                      );
                                    }
                                  },
                                  child: Column(
                                    children: [
                                      if (profilePic == null) ...[
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
                                          backgroundImage: profilePic != null
                                              ? FileImage(profilePic!)
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
                            if (profilePic != null) ...[
                              TextButton(
                                  onPressed: () {
                                    _cropImage();
                                  },
                                  child: AppSponsorText.cropBtn)
                            ]
                          ],
                        ),
                      ),
                      const SizedBox(height: 15),
                      _buildTextField(
                        'Sponsor Name',
                        nameController,
                        validateName,
                      ),
                      _buildTextField(
                        'Description',
                        descriptionController,
                        false,
                      ),
                      _buildPriorityTextField(false),
                      _buildAddButton(),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  _buildTextField(
    String label,
    TextEditingController controller,
    bool validate,
  ) {
    return Column(
      children: [
        TextField(
          textCapitalization: TextCapitalization.words,
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

  _buildPriorityTextField(
    bool validate,
  ) {
    return Column(
      children: [
        TextField(
          // textCapitalization: TextCapitalization.words,
          keyboardType: TextInputType.number,
          cursorColor: Colors.black,
          controller: priorityController,
          decoration: InputDecoration(
            labelText: "select priority",
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

  _buildAddButton() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    validate = true;
                  });
                  _onLoading();
                  if (_validateForm()) {
                    saveSponsor();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: AppSponsorText.fillRequiredFieldsAlert,
                      ),
                    );
                    Navigator.pop(context);
                  }
                },
                style: ElevatedButton.styleFrom(
                  shape: AppBorderStyle.roundedRectangleBorder,
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Colors.white,
                ),
                child: AppSponsorText.saveBtn),
          ),
        ],
      ),
    );
  }

  _validateForm() {
    validateName = nameController.text.isEmpty;
    profilePic == null;

    return !validateName;
  }

  void saveSponsor() async {
    try {
      String sponsorName = nameController.text.trim();
      String sponsorDescription = descriptionController.text.trim();
      var sponsorPriority = priorityController.text.trim();
      if (sponsorName.isNotEmpty && profilePic != null) {
        final downloadUrl = await uploadFile(profilePic!);
        Map<String, dynamic> sponsorData = {
          "sponsorImage": downloadUrl,
          "sponsorName": sponsorName.capitalize,
          "sponsorDescription": sponsorDescription.capitalizeFirst,
          "sponsorPriority": int.parse(sponsorPriority),
        };
        await FirebaseFirestore.instance
            .collection("directory-sponsors")
            .add(sponsorData);
        print(" SPONSOR CREATED!");
        submitForm();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: AppSponsorText.savedSuccessAlert,
          ),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: AppSponsorText.chooseImage,
          ),
        );
        Navigator.pop(context);
      }
    } catch (ex) {
      print("ERROR SAVING $ex");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: AppSponsorText.wentWrong,
        ),
      );
    } finally {
      setState(() {
        loading = false;
        profilePic = null;
      });
    }
  }

  Future<String> uploadFile(File file) async {
    try {
      final ref = FirebaseStorage.instance
          .ref()
          .child("sponsor-images")
          .child(const Uuid().v1());
      final uploadTask = ref.putFile(file);
      final taskSnapshot = await uploadTask;
      return await taskSnapshot.ref.getDownloadURL();
    } catch (error) {
      print("Error uploading file: $error");
      rethrow;
    }
  }

  void _onLoading() {
    setState(() {
      loading = true;
    });
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
  }

  void submitForm() {
    setState(() {
      loading = false;
    });
    nameController.clear();
    descriptionController.clear();
  }

  Future _cropImage() async {
    if (profilePic != null) {
      CroppedFile? cropped = await ImageCropper()
          .cropImage(sourcePath: profilePic!.path, aspectRatioPresets: [
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
          profilePic = File(cropped.path);
        });
      }
    }
  }
}
