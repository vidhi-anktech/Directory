import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_directory_app/providers/location_notifier.dart';
import 'package:flutter_directory_app/resources.dart';
import 'package:flutter_directory_app/screens/main_screen.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class HomePage extends ConsumerStatefulWidget {
  HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  int currentPage = 0;
  String countryValue = "";
  String? stateValue = "";
  String? cityValue = "";
  String address = "";

  @override
  Widget build(BuildContext context) {
    final stateLoc = ref.watch(locationNotifier.select((value) => value.state));
    print("VALUE DEKHTE HE $stateLoc");
    final cityLoc = ref.watch(locationNotifier.select((value) => value.city));
    print("VALUE DEKHTE HE CITY $cityLoc");
    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop();
        return true;
      },
      child: Scaffold(
        backgroundColor: const Color.fromRGBO(242, 250, 254, 1),
        body: IndexedStack(
          index: currentPage,
          children: [
            homeContent(),
          ],
        ),
      ),
    );
  }

  homeContent() {
    print(
        "VALUE OF COUNTRY, STATE, CITY $countryValue , $stateValue , $cityValue");
    // final notifier = ref.read(locationNotifier.notifier);

    return LayoutBuilder(
      builder: (context, constraints) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  Assets.logoImage,
                  fit: BoxFit.cover,
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Text("Palliwal Jain Telephone Directory",
                //     style: GoogleFonts.anekDevanagari(
                //         textStyle: TextStyle(
                //             fontSize: 20,
                //             fontWeight: FontWeight.w500,
                //             color: Theme.of(context).colorScheme.primary)))
                AppConstantText.mainText,
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 40,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          side: AppBorderStyle.colorOutlinedBorderBtn,
                          shape: AppBorderStyle.roundedRectangleBorder,
                          backgroundColor:
                              Theme.of(context).colorScheme.primary,
                          foregroundColor: Colors.white,
                          elevation: 0),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const MainScreen()));
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          AppConstantText.getStartedBtn
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
