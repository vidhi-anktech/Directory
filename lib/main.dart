import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_directory_app/firebase_options.dart';
import 'package:flutter_directory_app/screens/home_page.dart';
import 'package:flutter_directory_app/screens/login_page.dart';
import 'package:flutter_directory_app/screens/profile.dart';
import 'package:flutter_directory_app/screens/register_details_page.dart';
import 'package:flutter_directory_app/screens/show_data.dart';
import 'package:flutter_directory_app/screens/Sponsor/sponsors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerStatefulWidget {

  const MyApp({super.key });

  @override
  ConsumerState<MyApp> createState() => MyAppState();
}

class MyAppState extends ConsumerState<MyApp> {
   static const String KEYLOGIN = 'login';
   static const String PHONENUM = '';
   static const String STATEVALUE = '';
   static const String CITYVALUE = '';
   static const String ISADMIN = 'admin';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Directory App',
      initialRoute: '/',
      routes: {
        '/first': (context) =>  HomePage(),
        '/second': (context) => const LoginPage(),
        '/third': (context) =>  const ShowData(),
        '/fourth':(context) => RegistrationPage(),
        '/fifth' :(context) => const Sponsors(),
        '/sixth' :(context) => const MyProfile(),
      },
      theme: ThemeData(
        fontFamily: GoogleFonts.openSans().fontFamily,
        inputDecorationTheme: const InputDecorationTheme(
          hintStyle: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
          prefixIconColor: Color.fromRGBO(119, 119, 119, 1),
        ),
        textSelectionTheme: const TextSelectionThemeData(
          cursorColor: Colors.black,
        ),
        textTheme: const TextTheme(
            titleLarge: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 30,
            ),
            titleMedium: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
            bodySmall: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            )),
       
        colorScheme: ColorScheme.fromSeed(
          // rgba(35, 129, 198, 1)
          seedColor: const Color.fromRGBO(35, 129, 198, 1),
          primary: Color.fromRGBO(35, 129, 198, 1),
        ),
        appBarTheme: const AppBarTheme(
          titleTextStyle: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}
