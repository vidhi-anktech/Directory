import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class EditSponsor extends StatefulWidget {
  final Map<String, dynamic> sponsorData;
  final userId;
  const EditSponsor({super.key,
  required this.sponsorData,
  required this.userId});

  @override
  State<EditSponsor> createState() => _EditSponsorState();
}

class _EditSponsorState extends State<EditSponsor> {
  File? editedProfilePic;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Align(
          alignment: Alignment.center,
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    GestureDetector(
                    onTap: () async {
                      final selectedImage =
                          await ImagePicker().pickImage(source: ImageSource.gallery);
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
                            radius: 60,
                            backgroundImage:
                                NetworkImage(widget.sponsorData['sponsorImage']))
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
                        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
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
                          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
                        ),),
                           TextFormField(
          textCapitalization: TextCapitalization.words,
          keyboardType: TextInputType.text,
          // initialValue: widget.sponsorData,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: Color.fromRGBO(0, 0, 0, 1),
          ),
          decoration: InputDecoration(
            contentPadding:
                const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            labelText: "title",
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
          // onChanged: (value) {
          //   editedData[field] = value.capitalizeFirst ?? "";
          // },
        ),
        const SizedBox(
          height: 10,
        )
                  ],
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
      CroppedFile? cropped = await ImageCropper().cropImage(
          sourcePath: editedProfilePic!.path,
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
          editedProfilePic = File(cropped.path);
        });
      }
    }
  }

}