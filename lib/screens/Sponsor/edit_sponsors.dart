import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_directory_app/resources.dart';
import 'package:flutter_directory_app/screens/main_screen.dart';
import 'package:get/utils.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:uuid/uuid.dart';

class EditSponsor extends StatefulWidget {
  final Map<String, dynamic> sponsorData;
  final userId;
  final String sponsorName;
  final String sponsorDescription;
  final String sponsorImageUrl;
  const EditSponsor({
    super.key,
    required this.sponsorData,
    required this.userId,
    required this.sponsorDescription,
    required this.sponsorImageUrl,
    required this.sponsorName,
  });

  @override
  State<EditSponsor> createState() => _EditSponsorState();
}

class _EditSponsorState extends State<EditSponsor> {
  final sponsorNameController = TextEditingController();
  final sponsorDescController = TextEditingController();
  final priorityController = TextEditingController();
  File? editedProfilePic;
  Map<String, dynamic> editedData = {};
  bool _loading = false;
  bool validate = false;
  bool validateName = false;

  @override
  Widget build(BuildContext context) {
    print("PRINTING SPONSOR DATA ${widget.sponsorData}");
    print(
        "PRINTING VALUE OF SPONSORID AND SPONSOR DATA IN SPONSOR EDIT DETAIL PAGE ${widget.userId},,${widget.sponsorData}");
    Map<String, dynamic> sponsorData = widget.sponsorData;
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
          child: Align(
            alignment: Alignment.center,
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Card(
                elevation: 0,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () async {
                          final selectedImage = await ImagePicker()
                              .pickImage(source: ImageSource.gallery);
                          if (selectedImage != null) {
                            File editedFile = File(selectedImage.path);
                            setState(() {
                              editedProfilePic = editedFile;
                            });
                            print("Image selected");
                          } else {
                            print("No image selected");
                          }
                        },
                        child: editedProfilePic == null
                            ? CircleAvatar(
                                radius: 60, backgroundImage: NetworkImage(
                                    // widget.sponsorData['sponsorImage']
                                    widget.sponsorImageUrl))
                            : CircleAvatar(
                                radius: 60,
                                backgroundImage: FileImage(editedProfilePic!)),
                      ),
                      if (editedProfilePic != null) ...[
                        TextButton(
                          onPressed: () {
                            _cropImage();
                          },
                          child: const Text(
                            "Crop Image",
                            style: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 12),
                          ),
                        )
                      ] else
                        TextButton(
                          onPressed: () async {
                            final selectedImage = await ImagePicker()
                                .pickImage(source: ImageSource.gallery);
                            if (selectedImage != null) {
                              File editedFile = File(selectedImage.path);
                              setState(() {
                                editedProfilePic = editedFile;
                              });
                            }
                          },
                          child: const Text(
                            "Edit Image",
                            style: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 12),
                          ),
                        ),
                      TextFormField(
                        textCapitalization: TextCapitalization.words,
                        keyboardType: TextInputType.text,
                        initialValue: widget.sponsorName,
                        style: AppTextStyles.initialValueStyle,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 10),
                          labelText: "title",
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
                          }
                        },
                        onChanged: (value) {
                          editedData["sponsorName"] =
                              value.capitalizeFirst ?? "";
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        textCapitalization: TextCapitalization.words,
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        // initialValue: sponsorData["sponsorDescription"],
                        initialValue: widget.sponsorDescription,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: Color.fromRGBO(0, 0, 0, 1),
                        ),
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 10),
                          labelText: "description",
                          labelStyle: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: Color.fromRGBO(0, 0, 0, 1)),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Color.fromARGB(255, 168, 162, 162),
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Color.fromARGB(255, 168, 162, 162),
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onChanged: (value) {
                          editedData["sponsorDescription"] =
                              value.capitalizeFirst ?? "";
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        initialValue: sponsorData['sponsorPriority'].toString(),
                        keyboardType: TextInputType.number,
                        cursorColor: Colors.black,
                        decoration: InputDecoration(
                          labelText: "edit priority",
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 10),
                          labelStyle: AppTextStyles.labelStyle,
                          enabledBorder: AppBorderStyle.enabledBorder,
                          focusedBorder: AppBorderStyle.focusedBorder,
                          errorText: validate ? 'Required' : null,
                          errorStyle: AppTextStyles.errorStyle,
                          errorBorder: AppBorderStyle.errorBorder,
                          focusedErrorBorder: AppBorderStyle.focusedErrorBorder,
                        ),
                        onChanged: (value) {
                          editedData["sponsorPriority"] = int.parse(value);
                        },
                      ),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Expanded(flex: 3, child: _buildCancelButton()),
                              // const SizedBox(
                              //   width: 15,
                              // ),
                              Expanded(flex: 3, child: _buildUpdateNowButton()),
                            ]),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future _cropImage() async {
    if (editedProfilePic != null) {
      CroppedFile? cropped = await ImageCropper()
          .cropImage(sourcePath: editedProfilePic!.path, aspectRatioPresets: [
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
          editedProfilePic = File(cropped.path);
        });
      }
    }
  }

  Future<String> uploadFile(File file) async {
    try {
      final ref = FirebaseStorage.instance
          .ref()
          .child("sponsor-images")
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
          side: BorderSide(
              color: Theme.of(context).colorScheme.primary, width: 1),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(5)),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0),
      child: const Text(
        "Cancel",
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  void _onLoading() {
    setState(() {
      _loading = true;
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

  Widget _buildUpdateNowButton() {
    return ElevatedButton(
      onPressed: () async {
        setState(() {
          _loading = true;
          validate = true;
        });
        // _onLoading();

        await _uploadAndSaveImage();
        await FirebaseFirestore.instance
            .collection("directory-sponsors")
            .doc(widget.userId)
            .update(editedData)
            .then((value) => {
                  print("HURRAAAYYY! DATA UPDATED SUCCESSFULLY"),
                  Navigator.pop(context),
                });
      },
      style: ElevatedButton.styleFrom(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(5)),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      child: const Text(
        "Update",
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Future<void> _uploadAndSaveImage() async {
    if (editedProfilePic != null) {
      final downloadUrl = await uploadFile(editedProfilePic!);
      setState(() {
        editedData['sponsorImage'] = downloadUrl;
      });
    }
  }

  _validateForm() {
    validateName = sponsorNameController.text.isEmpty;
    editedProfilePic == null;

    return !validateName;
  }
}
