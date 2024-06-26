import 'package:flutter/material.dart';
import 'package:flutter_directory_app/resources.dart';
import 'package:flutter_directory_app/screens/organizing-committee-details.dart';

class OrganizingCommittee extends StatefulWidget {
  const OrganizingCommittee({Key? key}) : super(key: key);

  @override
  State<OrganizingCommittee> createState() => _OrganizingCommitteeState();
}

class _OrganizingCommitteeState extends State<OrganizingCommittee> {
  final List<PhotoItem> _items = [
    PhotoItem(Assets.woman2, "Person1"),
    PhotoItem(Assets.family1, "Person2"),
    PhotoItem(Assets.man2, "Person3"),
    PhotoItem(Assets.man1, "Person4"),
    PhotoItem(Assets.woman1, "Person5"),
    PhotoItem(Assets.man3, "Person6"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: AppConstantText.committeeAppBar),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: GridView.builder(
          itemCount: _items.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisSpacing: 5,
            mainAxisSpacing: 10,
            crossAxisCount: 2,
          ),
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => OrganizingCommitteeDetail(
                      items: _items,
                      initialIndex: index,
                    ),
                  ),
                );
              },
              child: Column(
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage(_items[index].image),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _items[index].name,
                        style: AppTextStyles.listTileHeading,
                      ),
                    ],
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class PhotoItem {
  final String image;
  final String name;
  PhotoItem(this.image, this.name);
}
