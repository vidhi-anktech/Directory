import 'package:flutter/material.dart';

final _contactController = TextEditingController();

@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text('Phone Number Validation'),
    ),
  
  );
}

//  _buildRegisterNowButton() {
//     return ElevatedButton(
//       onPressed: () {
//         setState(() {
//           validate = true; // Set validation to true when button is pressed
//         });
//         if (_validateForm()) {
//           if (wifeProfilePic != null) {
//             if (_validateWifeForm()) {
//               saveUser();
//             } else {
//               setState(() {
//                 scrollController.animateTo(
//                   scrollController.position.minScrollExtent,
//                   curve: Curves.easeOut,
//                   duration: const Duration(milliseconds: 500),
//                 );
//               });
//               ScaffoldMessenger.of(context).showSnackBar(
//                 SnackBar(
//                   content: AppConstantText.fillRequiredFieldsSpouseAlert,
//                 ),
//               );
//             }
//           } else {
//             saveUser();
//           }
//         } else {
//           setState(() {
//             scrollController.animateTo(
//               scrollController.position.minScrollExtent,
//               curve: Curves.easeOut,
//               duration: const Duration(milliseconds: 500),
//             );
//           });
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(
//               content: AppConstantText.fillRequiredFieldsAlert,
//             ),
//           );
//         }
//       },
//       style: ElevatedButton.styleFrom(
//         shape: AppBorderStyle.roundedRectangleBorder,
//         backgroundColor: Theme.of(context).colorScheme.primary,
//         foregroundColor: Colors.white,
//       ),
//       child: AppConstantText.save,
//     );
//   }
  
//   Future<void> saveUser() async {
//     Map<String, dynamic> userData;
//     var sharedPref = await SharedPreferences.getInstance();
//     var showNum = sharedPref.getString(MyAppState.PHONENUM);
//     String? validationResult = _validatePhoneNumber(headContactController.text);
//     String? validationWifeResult =
//         _validatePhoneNumber(wifeContactController.text);
//     print("VALIDATION WIFE RESULT $validationWifeResult");
//     try {
//       String hName = headNameController.text.trim();
//       String hGotra = headGotraController.text.trim();
//       String hOccupation = headOccupationController.text.trim();
//       String hContactString = headContactController.text.trim();
//       String hBirthplace = headBirthplaceController.text.trim();
//       String hPinCode = headCityPinController.text.trim();
//       String hState = headStateController.text.trim();
//       String hDistrict = headDistrictController.text.trim();
//       String hCity = headCityController.text.trim();
//       String hCurrentAddress = headCurrentAddressController.text.trim();
//       String wName = wifeNameController.text.trim();
//       String wGotra = wifeGotraController.text.trim();
//       String wOccupation = wifeOccupationController.text.trim();
//       String wContactString = wifeContactController.text.trim();
//       String wBirthplace = wifeBirthplaceController.text.trim();
//       String wPinCode = wifeCityPinController.text.trim();
//       String wState = wifeStateController.text.trim();
//       String wDistrict = wifeDistrictController.text.trim();
//       String wCity = wifeCityController.text.trim();
//       String wCurrentAddress = wifeCurrentAddressController.text.trim();
//       String hContact = "+91$hContactString";
//       String wContact = "+91$wContactString";

//       if (hName.isNotEmpty && hGotra.isNotEmpty && headProfilePic != null) {
//         if (validationResult == null) {
//           final headDownloadUrl =
//               await uploadFile(headProfilePic!, "headProfilePictures");
//           String? wifeDownloadUrl;

//           if (wifeProfilePic != null) {
//             wifeDownloadUrl =
//                 await uploadFile(wifeProfilePic!, "wifeProfilePictures");
//             if (wName.isNotEmpty &&
//                 wGotra.isNotEmpty &&
//                 wContact.isNotEmpty &&
//                 wCity.isNotEmpty) {
//               if (validationWifeResult == null) {
//                 userData = {
//                   "hProfilePic": headDownloadUrl,
//                   "hName": hName.capitalizeFirst,
//                   "hGotra": hGotra.capitalizeFirst,
//                   "hOccupation": hOccupation.capitalizeFirst,
//                   "hContact": hContact,
//                   "hBirthPlace": hBirthplace.capitalizeFirst,
//                   "hPinCode": hPinCode,
//                   "hState": hState.capitalizeFirst,
//                   "hDistrict": hDistrict.capitalizeFirst,
//                   "hCity": hCity.capitalizeFirst,
//                   "hCurrentAddress": hCurrentAddress.capitalizeFirst,
//                   "addedBy": showNum,
//                   "wProfilePic": wifeDownloadUrl,
//                   "wName": wName.capitalizeFirst,
//                   "wGotra": wGotra.capitalizeFirst,
//                   "wOccupation": wOccupation.capitalizeFirst,
//                   "wContact": wContact,
//                   "wBirthPlace": wBirthplace.capitalizeFirst,
//                   "wPinCode": wPinCode,
//                   "wState": wState.capitalizeFirst,
//                   "wDistrict": wDistrict.capitalizeFirst,
//                   "wCity": wCity.capitalizeFirst,
//                   "wCurrentAddress": wCurrentAddress.capitalizeFirst,
//                 };
//                 await FirebaseFirestore.instance
//                     .collection("directory-users")
//                     .add(userData);

//                 print("User Created!");
//                 print("ADDED BY : ${showNum}");
//                 submitForm();
//                 setState(() {
//                   scrollController.animateTo(
//                     scrollController.position.minScrollExtent,
//                     curve: Curves.easeOut,
//                     duration: const Duration(milliseconds: 500),
//                   );
//                 });
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   SnackBar(
//                     content: AppConstantText.userSavedAlert,
//                   ),
//                 );
//                 Navigator.push(context,
//                     MaterialPageRoute(builder: (context) => MainScreen()));
//               } else {
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   SnackBar(content: Text(validationWifeResult)),
//                 );
//               }
//             } else {
//               ScaffoldMessenger.of(context).showSnackBar(
//                 SnackBar(
//                   content: AppConstantText.fillRequiredFieldsSpouseAlert,
//                 ),
//               );
//             }
//           } else if (wName.isNotEmpty ||
//               wGotra.isNotEmpty ||
//               wOccupation.isNotEmpty ||
//               wContact.isNotEmpty ||
//               wBirthplace.isNotEmpty ||
//               wPinCode.isNotEmpty ||
//               wCity.isNotEmpty ||
//               wDistrict.isNotEmpty ||
//               wState.isNotEmpty ||
//               wCurrentAddress.isNotEmpty) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(
//                 content: AppConstantText.selectSpouseImage,
//               ),
//             );
//           } else {
//             userData = {
//               "hProfilePic": headDownloadUrl,
//               "hName": hName.capitalizeFirst,
//               "hGotra": hGotra.capitalizeFirst,
//               "hOccupation": hOccupation.capitalizeFirst,
//               "hContact": hContact,
//               "hBirthPlace": hBirthplace.capitalizeFirst,
//               "hPinCode": hPinCode,
//               "hState": hState.capitalizeFirst,
//               "hDistrict": hDistrict.capitalizeFirst,
//               "hCity": hCity.capitalizeFirst,
//               "hCurrentAddress": hCurrentAddress.capitalizeFirst,
//               "addedBy": showNum,
//               "wProfilePic": null,
//               "wName": null,
//               "wGotra": null,
//               "wOccupation": null,
//               "wContact": null,
//               "wBirthPlace": null,
//               "wPinCode": null,
//               "wState": null,
//               "wDistrict": null,
//               "wCity": null,
//               "wCurrentAddress": null,
//             };
      
//             await FirebaseFirestore.instance
//                 .collection("directory-users")
//                 .add(userData);

//             print("User Created!");
//             print("ADDED BY : ${showNum}");
//             submitForm();
//             setState(() {
//               scrollController.animateTo(
//                 scrollController.position.minScrollExtent,
//                 curve: Curves.easeOut,
//                 duration: const Duration(milliseconds: 500),
//               );
//             });
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(
//                 content: AppConstantText.userSavedAlert,
//               ),
//             );
//             // Navigator.pop(context);
//             Navigator.push(
//                 context, MaterialPageRoute(builder: (context) => MainScreen()));
//           }
//         } else {
//           print("HIDE LOADING CALLED");
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text(validationResult)),
//           );
//           setState(() {
//             scrollController.animateTo(
//               scrollController.position.minScrollExtent,
//               curve: Curves.easeOut,
//               duration: const Duration(milliseconds: 500),
//             );
//           });
//         }
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: AppConstantText.selectImage,
//           ),
//         );
//         setState(() {
//           scrollController.animateTo(
//             scrollController.position.minScrollExtent,
//             curve: Curves.easeOut,
//             duration: const Duration(milliseconds: 500),
//           );
//         });
//       }
//     } catch (error) {
//       print("Error saving user: $error");
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: AppConstantText.wentWrong,
//         ),
//       );
//     } 
//   }


// Future<void> saveUser() async {
//   Map<String, dynamic> userData;
//   var sharedPref = await SharedPreferences.getInstance();
//   var showNum = sharedPref.getString(MyAppState.PHONENUM);
//   String? validationResult = _validatePhoneNumber(headContactController.text);
//   String? validationWifeResult = _validatePhoneNumber(wifeContactController.text);

//   setState(() {
//     loading = true; // Show loading indicator when saving user
//   });

//   try {
//     // Your existing code...

//     // If everything is successful, hide loading indicator
//     setState(() {
//       loading = false;
//     });
//   } catch (error) {
//     print("Error saving user: $error");
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: AppConstantText.wentWrong,
//       ),
//     );

//     // If there's an error, hide loading indicator
//     setState(() {
//       loading = false;
//     });
//   }
// }
