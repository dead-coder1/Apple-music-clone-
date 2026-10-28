import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() => runApp(const BoooApp());

class BoooApp extends StatelessWidget {
  const BoooApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Booo!!',
      theme: ThemeData.dark().copyWith(scaffoldBackgroundColor: Color(0xFF000000)),
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _c;
  @override
  void initState() {
    super.initState();
    _c = AnimationController(vsync: this, duration: Duration(milliseconds: 2200))..forward();
    Timer(Duration(milliseconds: 2800), () {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => HomeScreen()));
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: ScaleTransition(
          scale: CurvedAnimation(parent: _c, curve: Curves.elasticOut),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Container(width: 130, height: 130, decoration: BoxDecoration(color: Color(0xFFFA2F2F), borderRadius: BorderRadius.circular(32), boxShadow: [BoxShadow(color: Colors.red.withOpacity(0.4), blurRadius: 30)]), child: Icon(Icons.music_note_rounded, size: 70, color: Colors.white)),
            SizedBox(height: 30),
            Text('Booo!!', style: GoogleFonts.outfit(fontSize: 48, fontWeight: FontWeight.w900, color: Colors.white)),
            SizedBox(height: 12),
            Text('Developed by deadvishaal', style: GoogleFonts.spaceGrotesk(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
            SizedBox(height: 8),
            Text('ADVANCED • HAUNTED • MUSIC', style: TextStyle(fontSize: 10, color: Colors.white54, letterSpacing: 3)),
          ]),
        ),
      ),
    );
  }
}

// Baaki HomeScreen wala code maine pehle wale me diya tha, wahi rahega
class HomeScreen extends StatefulWidget { const HomeScreen({super.key}); @override State<HomeScreen> createState() => _HomeScreenState(); }
class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  int currentIndex = 0; bool isPlaying = false;
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(title: Text('Booo!!'), backgroundColor: Colors.black),
      body: Center(child: Text('Welcome to Booo!! 👻', style: TextStyle(fontSize: 24))),
      bottomSheet: Container(height: 100, color: Color(0xFF1C1C1E), child: Center(child: Text('Player by deadvishaal'))),
    );
  }
}