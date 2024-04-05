import 'package:flutter/material.dart';

class Assets {
  static String logoImage = 'assets/images/logo.png';
  static String loginImage = "assets/images/loginImage.png";
  static String searchIcon = 'assets/images/search.png';
  static String crossIcon = 'assets/images/cross.png';
  static String homeIcon = 'assets/images/home.png';
  static String addIcon = 'assets/images/add.png';
  static String sponsorIcon = 'assets/images/sponsors_icon.png';
  static String moreIcon = 'assets/images/more.png';
  static String editIcon = 'assets/images/editIcon.png';
  static String userImage = 'assets/images/user-profile.avif';
  static String customerSupport = 'assets/images/customerSupport.png';
  static String organizingCommittee = 'assets/images/organizingIcon.png';
  static String man1 = 'assets/images/man.webp';
  static String man2 = 'assets/images/man2.jpg';
  static String man3 = 'assets/images/man3.jpg';
   static String woman1 = 'assets/images/woman1.jpg';
  static String woman2 = 'assets/images/woman2.jpg';
  static String family1 = 'assets/images/family.png';
  static String family2 = 'assets/images/family2.jpg';

}

class AppTextStyles {
  static TextStyle heading = const TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      color: Color.fromRGBO(0, 0, 0, 1));

  static TextStyle subHeading =
      const TextStyle(fontSize: 14, fontWeight: FontWeight.w400);

  static TextStyle smallText = const TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: Color.fromRGBO(122, 122, 122, 1),
  );

  static TextStyle buttonText =
      const TextStyle(fontSize: 14, fontWeight: FontWeight.w600);

  static TextStyle listTileHeading = const TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w600,
  );

  static TextStyle titleText = const TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
  );

  static TextStyle btn =
      const TextStyle(fontWeight: FontWeight.w600, fontSize: 12);

  static TextStyle listTileSubHeading =
      const TextStyle(fontSize: 12, fontWeight: FontWeight.w400);

  static TextStyle listTileWifeHeading =
      const TextStyle(fontSize: 14, fontWeight: FontWeight.w600);

  static TextStyle listTileWifeSubHeading =
      const TextStyle(fontSize: 11, fontWeight: FontWeight.w400);

  static TextStyle moreText = const TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w400,
      color: Color.fromRGBO(35, 129, 198, 1));

  static TextStyle selectedLabel = const TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w400,
    color: Color.fromRGBO(35, 129, 198, 1),
  );

  static TextStyle unselectedLabel = const TextStyle(
      color: Color.fromRGBO(0, 0, 0, 1),
      fontSize: 10,
      fontWeight: FontWeight.w400);

  static TextStyle labelStyle = const TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w400,
      color: Color.fromRGBO(0, 0, 0, 1));

  static TextStyle errorStyle =
      const TextStyle(fontSize: 10, fontWeight: FontWeight.w400);

  static TextStyle initialValueStyle = const TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: Color.fromRGBO(0, 0, 0, 1),
  );

  static TextStyle mainTextStyle = const TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: Color.fromRGBO(35, 129, 198, 1));
}

class AppConstantText {
  static Text wentWrong = const Text("Oops! Something went wrong");
  static Text selectImage = const Text('Please select an image');
  static Text selectSpouseImage =
      const Text('Please select an image for spouse to continue');
  static Text cancelAlert = const Text('Are you sure you want to exit?');
  static Text noAlert = const Text('No');
  static Text yesAlert = const Text('Yes, exit');
  static Text userSavedAlert = const Text('User Saved Successfully!');
  static Text fillRequiredFieldsSpouseAlert =
      const Text('Please fill in all required fields for spouse.');
  static Text fillRequiredFieldsAlert =
      const Text('Please fill in all required fields.');
  static Text invalidPhoneNo = const Text("Please enter valid phone number");
  static Text noDataFound = const Text("No Data Found");

// Edit-User Screen
  static Text headOfFamily = Text(
    'Head of the family',
    style: AppTextStyles.titleText,
  );
  static Text spouse = Text(
    'Spouse',
    style: AppTextStyles.titleText,
  );
  static Text save = Text(
    "Save",
    style: AppTextStyles.buttonText,
  );
  static Text cancelBtn = Text(
    "Cancel",
    style: AppTextStyles.buttonText,
  );
  static Text cropBtn = Text(
    "Crop Image",
    style: AppTextStyles.btn,
  );
  static Text editBtn = Text(
    "Edit Image",
    style: AppTextStyles.btn,
  );
  static Text addImageBtn = Text(
    "Add Image",
    style: AppTextStyles.btn,
  );
  static Text updateBtn = Text(
    "Update",
    style: AppTextStyles.btn,
  );

  // Home Screen
  static Text mainText = Text(
    "Palliwal Jain Telephone Directory",
    style: AppTextStyles.mainTextStyle,
  );
  static Text getStartedBtn = Text(
    "Get Started",
    style: AppTextStyles.buttonText,
  );

  // ShowData Screen
  static Text jaiJinendra =
      Text("Jai-Jinendra!", style: AppTextStyles.buttonText);
  static Text notLoggedIn =
      Text("Have you not logged in yet?", style: AppTextStyles.subHeading);
  static Text logInNow = Text("Log in now.", style: AppTextStyles.smallText);
  static Text addProfileTile =
      Text("Add Profile", style: AppTextStyles.buttonText);
  static Text loginTile = Text('Login', style: AppTextStyles.buttonText);
  static Text logoutTile = Text('Logout', style: AppTextStyles.buttonText);
  static Text more = Text("more", style: AppTextStyles.moreText);

// userDetail screen
  static Text name = Text(
    "Name : ",
    style: AppTextStyles.titleText,
  );
  static Text occupation = Text(
    "Occupation : ",
    style: AppTextStyles.titleText,
  );
  static Text zipCode = Text(
    "Zip-Code : ",
    style: AppTextStyles.titleText,
  );
  static Text city = Text(
    "City : ",
    style: AppTextStyles.titleText,
  );
  static Text district = Text(
    "District : ",
    style: AppTextStyles.titleText,
  );
  static Text state = Text(
    "State : ",
    style: AppTextStyles.titleText,
  );
  static Text currentAddress = Text(
    "Current-Address : ",
    style: AppTextStyles.titleText,
  );
  static Text contact = Text(
    "Contact : ",
    style: AppTextStyles.titleText,
  );
  static Text birthPlace = Text(
    "Birth-Place : ",
    style: AppTextStyles.titleText,
  );

  // Verify-OTP Screen
  static Text verifyTitleText = Text(
    "Verify with OTP",
    style: AppTextStyles.heading,
  );
  static Text resendBtn = Text("Resend", style: AppTextStyles.buttonText);
  static Text resendTxt = Text("Resend", style: AppTextStyles.smallText);
  static Text otpIn = Text("OTP in", style: AppTextStyles.smallText);

  // Login Screen
  static Text loginTitle = Text(
    "Log in",
    style: AppTextStyles.heading,
  );
  static Text enterMobileNo = Text("Please enter your phone number to continue",
      style: AppTextStyles.smallText);
  static Text continueBtn = Text(
    "Continue",
    style: AppTextStyles.buttonText,
  );

  // Profile page
  static Text customerSupport =
      Text("Customer Support", style: AppTextStyles.titleText);
  static Text organizingCommittee =
      Text("Organizing Committee", style: AppTextStyles.titleText);
  static Text developedBy =
      Text("Developed By", style: AppTextStyles.titleText);
  static Text logOutBtn = Text("Logout", style: AppTextStyles.buttonText);

  // My-Profile

  static Text saveBtn = Text("Save", style: AppTextStyles.buttonText);
  static Text profileSavedAlert = const Text('Profile Saved Successfully!');
}

class AppSponsorText {
  // add-sponsor-page
  static Text addSponsorTxt = Text("Add Sponsor", style: AppTextStyles.heading);
  static Text chooseImage = const Text('Please select an image');
  static Text cropBtn = Text(
    "Crop Image",
    style: AppTextStyles.btn,
  );
  static Text fillRequiredFieldsAlert =
      const Text('Please fill in all required fields.');
  static Text saveBtn = Text(
    "Save",
    style: AppTextStyles.buttonText,
  );
  static Text savedSuccessAlert = const Text('Sponsor Saved Successfully!');
  static Text wentWrong = const Text('Oops! Something went wrong');

  // sponsor-page
  static Text sponsorTitle = Text(
          "Sponsors",
          style: AppTextStyles.heading,
        );
  static Text noDataFound = const Text("No data Found");
}

class AppBorderStyle {
  static OutlineInputBorder focusedBorder = OutlineInputBorder(
    borderSide: const BorderSide(color: Color.fromARGB(255, 168, 162, 162)),
    borderRadius: BorderRadius.circular(10),
  );

  static OutlineInputBorder enabledBorder = OutlineInputBorder(
    borderSide: const BorderSide(color: Color.fromARGB(255, 168, 162, 162)),
    borderRadius: BorderRadius.circular(10),
  );

  static OutlineInputBorder errorBorder = OutlineInputBorder(
    borderSide: const BorderSide(color: Color.fromARGB(255, 211, 41, 29)),
    borderRadius: BorderRadius.circular(10),
  );

  static OutlineInputBorder focusedErrorBorder = OutlineInputBorder(
    borderSide: const BorderSide(color: Color.fromARGB(255, 211, 41, 29)),
    borderRadius: BorderRadius.circular(10),
  );

  static BorderSide colorOutlinedBorderBtn =
      const BorderSide(color: Color.fromRGBO(35, 129, 198, 1), width: 1);

  static RoundedRectangleBorder roundedRectangleBorder =
      const RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(5)),
  );
}
