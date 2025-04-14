import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/home_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final Future<FirebaseApp> _firebaseInit = Firebase.initializeApp();
  TextEditingController _titleController = TextEditingController();
  String appTitle = "Billing App"; // Default

  @override
  void initState() {
    super.initState();
    _loadTitle();
  }

  Future<void> _loadTitle() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedTitle = prefs.getString('appTitle');
    setState(() {
      appTitle = savedTitle ?? appTitle;
      _titleController = TextEditingController(text: appTitle);
    });
  }

  Future<void> _saveTitle(String newTitle) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('appTitle', newTitle);
    setState(() {
      appTitle = newTitle;
      _titleController.text = newTitle;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: appTitle,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: FutureBuilder(
        future: _firebaseInit,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          } else if (snapshot.hasError) {
            return Scaffold(
              body: Center(child: Text("Error: ${snapshot.error}")),
            );
          }
          return HomeScreen(
            titleController: _titleController,
            onTitleChange: _saveTitle,
          );
        },
      ),
    );
  }
}
