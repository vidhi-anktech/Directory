import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/utils.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class AddProfile extends StatefulWidget {
  const AddProfile({super.key});

  @override
  State<AddProfile> createState() => _AddProfileState();
}

class _AddProfileState extends State<AddProfile> {
  File? profilePic;
  final nameController = TextEditingController();
  bool validateName = false;
   bool loading = false;
   bool validate = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: SizedBox(
                    child: CircleAvatar(
                      radius: 60.0,
                      backgroundColor: const Color.fromARGB(255, 168, 162, 162),
                      child: GestureDetector(
                        onTap: () async {
                          final selectedImage = await ImagePicker()
                              .pickImage(source: ImageSource.gallery);
                          if (selectedImage != null) {
                            File convertedFile = File(selectedImage.path);

                            setState(() {
                              profilePic = convertedFile;
                            });
                            // print("Image selected");
                          } else {
                            // ignore: use_build_context_synchronously
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Please select an image'),
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
                ),
                const SizedBox(height: 10),
                _buildTextField(
                  'Your Name',
                  nameController,
                  validateName,
                ),
                 _buildAddButton(),
              ],
            ),
          ),
        ));
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
            labelStyle: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: Color.fromRGBO(0, 0, 0, 1)),
            enabledBorder: OutlineInputBorder(
              borderSide:
                  const BorderSide(color: Color.fromARGB(255, 168, 162, 162)),
              borderRadius: BorderRadius.circular(10),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide:
                  const BorderSide(color: Color.fromARGB(255, 168, 162, 162)),
              borderRadius: BorderRadius.circular(10),
            ),
            errorText: validate ? 'Required' : null,
            errorStyle:
                const TextStyle(fontSize: 10, fontWeight: FontWeight.w400),
            errorBorder: OutlineInputBorder(
              borderSide:
                  const BorderSide(color: Color.fromARGB(255, 211, 41, 29)),
              borderRadius: BorderRadius.circular(10),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide:
                  const BorderSide(color: Color.fromARGB(255, 211, 41, 29)),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
       
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
                    const SnackBar(
                      content: Text('Please fill in all required fields.'),
                    ),
                  );
                  Navigator.pop(context);
                }
              },
              style: ElevatedButton.styleFrom(
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                ),
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Colors.white,
              ),
              child: const Text(
                "Save",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
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

   void _onLoading() {
    setState(() {
      loading = true;
    });
   }


  void saveSponsor() async {
    try {
      String name = nameController.text.trim();
     

      if (name.isNotEmpty && profilePic != null) {
        final downloadUrl = await uploadFile(profilePic!);

        Map<String, dynamic> profileData = {
          "profilePicture": downloadUrl,
          "name": name.capitalize,
          
        };

        await FirebaseFirestore.instance
            .collection("my-profile")
            .add(profileData);

        print(" PROFILE CREATED!");
        submitForm();
             ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profile Saved Successfully!'),
          ),
        );
        Navigator.pop(context);
      }
      else{
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please choose an image'),
          ),
        );
        Navigator.pop(context);
      }
    } catch (ex) {
      print("ERROR SAVING $ex");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Oops! Something went wrong'),
        ),
      );
    }
    finally{
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
          .child("profileImages")
          .child(const Uuid().v1());
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
      loading = false;
    });
    nameController.clear();
  }
}