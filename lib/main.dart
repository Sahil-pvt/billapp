import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final Future<FirebaseApp> _firebaseInit = Firebase.initializeApp();
  final TextEditingController _titleController = TextEditingController(
    text: "Product Scanner",
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: _titleController.text, // Dynamic title
      theme: ThemeData(primarySwatch: Colors.blue),
      home: FutureBuilder<FirebaseApp>(
        future: _firebaseInit,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          } else if (snapshot.hasError) {
            return Scaffold(
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error, color: Colors.red, size: 50),
                    const SizedBox(height: 10),
                    Text(
                      "⚠️ Firebase Init Failed:\n${snapshot.error}",
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 16, color: Colors.red),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () => main(), // Restart app
                      child: const Text("Retry"),
                    ),
                  ],
                ),
              ),
            );
          }
          return HomeScreen(
            titleController: _titleController,
            onTitleChange: (newTitle) {
              setState(() {
                _titleController.text = newTitle;
              });
            },
          );
        },
      ),
    );
  }
}
