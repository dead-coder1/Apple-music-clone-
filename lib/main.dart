import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(AppleMusicApp());
}

class AppleMusicApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BoooMusicHome(),
    );
  }
}

class BoooMusicHome extends StatefulWidget {
  @override
  State<BoooMusicHome> createState() => _BoooMusicHomeState();
}

class _BoooMusicHomeState extends State<BoooMusicHome> with TickerProviderStateMixin {
  late AnimationController _ghostController;
  bool isPlaying = false;
  int currentIndex = 0;

  List<Map<String, String>> songs = [
    {"title": "Blinding Lights", "artist": "The Weeknd", "img": "🌙"},
    {"title": "Levitating", "artist": "Dua Lipa", "img": "👻"},
    {"title": "Stay", "artist": "Justin Bieber", "img": "🎃"},
    {"title": "Booo!! Anthem", "artist": "deadvishaal", "img": "💀"},
  ];

  @override
  void initState() {
    super.initState();
    _ghostController = AnimationController(vsync: this, duration: Duration(seconds: 2))..repeat(reverse: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0A0A0A),
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Row(
          children: [
            FadeTransition(
              opacity: _ghostController,
              child: Text("👻", style: TextStyle(fontSize: 24)),
            ),
            SizedBox(width: 8),
            Text("Booo!!", style: GoogleFonts.creepster(color: Colors.white, fontSize: 28, letterSpacing: 2)),
          ],
        ),
        actions: [Icon(Icons.search, color: Colors.white), SizedBox(width: 16)],
      ),
      body: Column(
        children: [
          // Ghost Header
          Container(
            margin: EdgeInsets.all(16),
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [Color(0xFF1F1F1F), Color(0xFF2D2D2D)]),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white12),
            ),
            child: Row(
              children: [
                ScaleTransition(
                  scale: Tween(begin: 0.9, end: 1.1).animate(CurvedAnimation(parent: _ghostController, curve: Curves.easeInOut)),
                  child: Text("👻", style: TextStyle(fontSize: 50)),
                ),
                SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Booo!! Advanced", style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
                    Text("Developed by deadvishaal", style: GoogleFonts.poppins(color: Colors.white54, fontSize: 12)),
                    SizedBox(height: 4),
                    Text("Spooky Vibes Only • 2026", style: GoogleFonts.poppins(color: Color(0xFFFF2D55), fontSize: 10, letterSpacing: 1)),
                  ],
                ),
              ],
            ),
          ),

          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 16),
              itemCount: songs.length,
              itemBuilder: (context, index) {
                bool selected = currentIndex == index;
                return GestureDetector(
                  onTap: () => setState(() { currentIndex = index; isPlaying = true; }),
                  child: Container(
                    margin: EdgeInsets.only(bottom: 12),
                    padding: EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: selected ? Color(0xFFFF2D55).withOpacity(0.15) : Color(0xFF1A1A1A),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: selected ? Color(0xFFFF2D55) : Colors.transparent),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 50, height: 50,
                          decoration: BoxDecoration(color: Color(0xFF2A2A2A), borderRadius: BorderRadius.circular(10)),
                          child: Center(child: Text(songs[index]["img"]!, style: TextStyle(fontSize: 24))),
                        ),
                        SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(songs[index]["title"]!, style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w600)),
                            Text(songs[index]["artist"]!, style: GoogleFonts.poppins(color: Colors.white54, fontSize: 12)),
                          ],
                        ),
                        Spacer(),
                        Icon(selected && isPlaying ? Icons.pause_circle : Icons.play_circle, color: selected ? Color(0xFFFF2D55) : Colors.white38, size: 30),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // Player Bar
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(color: Color(0xFF1F1F1F), borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
            child: Column(
              children: [
                Row(
                  children: [
                    Text(songs[currentIndex]["img"]!, style: TextStyle(fontSize: 20)),
                    SizedBox(width: 10),
                    Text(songs[currentIndex]["title"]!, style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w600)),
                    Spacer(),
                    GestureDetector(
                      onTap: () => setState(() => isPlaying = !isPlaying),
                      child: Icon(isPlaying ? Icons.pause : Icons.play_arrow, color: Colors.white, size: 32),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Center(child: Text("Developed by deadvishaal 👻", style: GoogleFonts.poppins(color: Colors.white24, fontSize: 10))),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        selectedItemColor: Color(0xFFFF2D55),
        unselectedItemColor: Colors.white38,
        currentIndex: 0,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.library_music), label: "Booo!!"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "deadvishaal"),
        ],
      ),
    );
  }
}