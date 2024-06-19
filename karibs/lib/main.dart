import 'package:flutter/material.dart';
import 'package:karibs/overlay.dart';
import 'package:karibs/providers/student_grading_provider.dart';
import 'screens/teacher_dashboard.dart';
import 'student_screens/student_screen.dart';
import 'database/database_helper.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

const Color DeepPurple = Color(0xFF250A4E);
const Color MidPurple = Color(0xFF7c6c94);
const Color LightPurple = Color(0xFFD3BEFA);
const Color NotWhite = Color(0xFFEFEBF1);
const Color White = Colors.white;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseHelper().deleteDatabaseFile(); // Delete the existing database, remove when done testing
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => StudentGradingProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'KLAS Tracker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  MainScreenState createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> {
  bool _isAnimating = false;
  bool _showTutorial = true; // Flag to control showing tutorial dialog

  @override
  void initState() {
    super.initState();
    // Show the tutorial dialog when the screen first loads
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      if (_showTutorial) {
        _showMainTutorialDialog();
        _showTutorial = false; // Set to false to prevent showing again on subsequent launches
      }
    });
  }

  void _showMainTutorialDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return MainTutorialDialog();
      },
    );
  }

  void _navigateToScreen(Widget screen) {
    setState(() {
      _isAnimating = true;
    });

    Future.delayed(const Duration(milliseconds: 500), () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => screen),
      ).then((_) {
        setState(() {
          _isAnimating = false;
        });
      });
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Text('Choose User Type'),
            SizedBox(width: 8), // Adjust spacing between title and icon
            IconButton(
              icon: Icon(Icons.help_outline),
              onPressed: () {
                // Show tutorial dialog
                _showMainTutorialDialog();
              },
            ),
          ],
        ),
        backgroundColor: DeepPurple,
        foregroundColor: White,
      ),
      body: Stack(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
            transform: Matrix4.translationValues(0, _isAnimating ? 600 : 0, 0),
            child: AnimatedOpacity(
              opacity: _isAnimating ? 0.0 : 1.0,
              duration: const Duration(milliseconds: 500),
              child: Container(
                decoration: const BoxDecoration(color: White),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 25),
                      Image.asset('images/logo.jpg'),
                      Text(
                        'WELCOME TO',
                        style: GoogleFonts.raleway(fontSize: 34, color: DeepPurple),
                      ),
                      Expanded(
                        child: Text(
                          'KLAS',
                          style: GoogleFonts.raleway(fontSize: 50, fontWeight: FontWeight.bold, color: DeepPurple),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 35.0, horizontal: 35), // Padding inside the container
                        decoration: BoxDecoration(
                          color: DeepPurple,
                          border: Border.all(width: 2, color: DeepPurple),
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(5),
                            bottomLeft: Radius.circular(5),
                            bottomRight: Radius.circular(30),
                          ),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 10,
                              offset: Offset(3, 3), // Shadow position
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'CHOOSE USER TYPE',
                              style: GoogleFonts.raleway(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: White,
                              ),
                            ),
                            const SizedBox(height: 24),
                            Column(
                              children: [
                                ElevatedButton(
                                  onPressed: () => _navigateToScreen(TeacherDashboard()),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: White,
                                    foregroundColor: Colors.white,
                                    side: const BorderSide(width: 2, color: MidPurple),
                                    padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 18), // Button padding
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                  ),
                                  child: Text(
                                    'I\'m a Teacher',
                                    style: GoogleFonts.raleway(fontSize: 28, color: DeepPurple),
                                  ),
                                ),
                                const SizedBox(height: 25),
                                ElevatedButton(
                                  onPressed: () => _navigateToScreen(const StudentScreen()),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: White,
                                    foregroundColor: Colors.white,
                                    side: const BorderSide(width: 2, color: MidPurple),
                                    padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 18), // Button padding
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                  ),
                                  child: Text(
                                    'I\'m a Student',
                                    style: GoogleFonts.raleway(fontSize: 28, color: DeepPurple),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
