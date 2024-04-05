import 'package:flutter/material.dart';
import 'package:flutter_directory_app/resources.dart';

class OrganizingCommitteeDetail extends StatefulWidget {
  final String image;
  final String name;
  const OrganizingCommitteeDetail(
      {super.key, required this.image, required this.name});

  @override
  State<OrganizingCommitteeDetail> createState() =>
      _OrganizingCommitteeDetailState();
}

class _OrganizingCommitteeDetailState extends State<OrganizingCommitteeDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          AspectRatio(
            aspectRatio: 1,
            child: Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height,
              child: Image(
                image: AssetImage(widget.image),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.all(20.0),
            child: Center(
              child: Text(
                widget.name,
                style: AppTextStyles.titleText,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
