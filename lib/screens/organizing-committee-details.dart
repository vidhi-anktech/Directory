import 'package:flutter/material.dart';
import 'package:flutter_directory_app/resources.dart';
import 'package:flutter_directory_app/screens/organizing_committee.dart';

class OrganizingCommitteeDetail extends StatefulWidget {
  final List<PhotoItem> items;
  final int initialIndex;

  const OrganizingCommitteeDetail(
      {super.key, required this.items, this.initialIndex = 0});

  @override
  // ignore: library_private_types_in_public_api
  _OrganizingCommitteeDetailState createState() =>
      _OrganizingCommitteeDetailState();
}

class _OrganizingCommitteeDetailState extends State<OrganizingCommitteeDetail> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController =
        PageController(initialPage: widget.initialIndex, viewportFraction: 0.9);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: PageView.builder(
        padEnds: true,
        controller: _pageController,
        itemCount: widget.items.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onHorizontalDragEnd: (details) {
              if (details.primaryVelocity! > 0) {
                // Swiped right
                if (index > 0) {
                  _pageController.previousPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.ease,
                  );
                }
              } else if (details.primaryVelocity! < 0) {
                // Swiped left
                if (index < widget.items.length - 1) {
                  _pageController.nextPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.ease,
                  );
                }
              }
            },
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Card(
                      elevation: 1,
                      child: FittedBox(
                        child: Container(
                          // height: MediaQuery.of(context).size.height,
                          height: 500,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: AssetImage(widget.items[index].image),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(20.0),
                    child: Center(
                      child: Text(
                        widget.items[index].name,
                        style: AppTextStyles.titleText,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
