import 'package:flutter/material.dart';

final _contactController = TextEditingController();

@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text('Phone Number Validation'),
    ),
    body: Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildPhoneTextField(),
          SizedBox(height: 16.0),
          ElevatedButton(
            onPressed: () {
              String? validationResult = _validatePhoneNumber(_contactController.text);
              if (validationResult == null) {
                // Phone number is valid
                // Add your logic here
              } else {
                // Phone number is invalid, show error message
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(validationResult)),
                );
              }
            },
            child: Text('Submit'),
          ),
        ],
      ),
    ),
  );
}

Widget _buildPhoneTextField() {
  return TextFormField(
    controller: _contactController,
    keyboardType: TextInputType.phone,
    decoration: InputDecoration(
      labelText: 'Phone Number',
      hintText: 'Enter phone number',
      border: OutlineInputBorder(),
    ),
    validator: (value) {
      if (value == null || value.isEmpty) {
        return 'Phone number is required';
      } else {
        String? validationResult = _validatePhoneNumber(value);
        return validationResult;
      }
    },
  );
}

String? _validatePhoneNumber(String value) {
  // Validate phone number
  if (value.length != 10) {
    return 'Phone number must be 10 digits';
  }
  return null; // Return null if phone number is valid
}
