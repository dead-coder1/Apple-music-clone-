import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:just_audio/just_audio.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'dart:ui';

void main() => runApp(BoooApp());

class BoooApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: StreamingPlayer());
  }
}

class StreamingPlayer extends StatefulWidget {
  @override
  State<StreamingPlayer> createState() => _StreamingPlayerState();
}

class _StreamingPlayerState extends State<StreamingPlayer> {
  final player = AudioPlayer();
  final yt = YoutubeExplode();
  final searchController = TextEditingController();
  
  bool isPlaying = false;
  bool isLoading = false;
  String currentTitle = "Booo!! Tap to Search";
  String currentArtist = "Developed by deadvishaal";
  List<Video> searchResults = [];

  @override
  void initState() {
    super.initState();
    player.playerStateStream.listen((state) {
      if (mounted) setState(() => isPlaying = state.playing);
    });
  }

  Future<void> searchSongs(String query) async {
    if (query.isEmpty) return;
    setState(() => isLoading = true);
    try {
      var results = await yt.search.search(query);
      setState(() {
        searchResults = results.toList();
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }

  Future<void> playVideo(Video video) async {
    setState(() {
      isLoading = true;
      currentTitle = video.title;
      currentArtist = video.author;
    });
    try {
      var manifest = await yt.videos.streamsClient.getManifest(video.id);
      var audio = manifest.audioOnly.withHighestBitrate();
      await player.setUrl(audio.url.toString());
      await player.play();
      setState(() => isLoading = false);
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Play failed: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text("Booo!!", style: GoogleFonts.inter(fontWeight: FontWeight.w900, fontSize: 28)),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(100),
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                TextField(
                  controller: searchController,
                  style: TextStyle(color: Colors.white),
                  onSubmitted: searchSongs,
                  decoration: InputDecoration(
                    hintText: "Search any song... (YouTube)",
                    hintStyle: TextStyle(color: Colors.white38),
                    prefixIcon: Icon(Icons.search, color: Colors.white54),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.08),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(25), borderSide: BorderSide.none),
                  ),
                ),
                SizedBox(height: 8),
                Text("Developed by deadvishaal • BitChord Style • Online Streaming", style: GoogleFonts.inter(color: Colors.white30, fontSize: 10)),
              ],
            ),
          ),
        ),
      ),
      body: isLoading && searchResults.isEmpty
          ? Center(child: CircularProgressIndicator(color: Color(0xFFFF2D55)))
          : searchResults.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("👻", style: TextStyle(fontSize: 60)),
                      SizedBox(height: 16),
                      Text("Search karke gaana bajao", style: GoogleFonts.inter(color: Colors.white54)),
                      Text("Ex: Arijit Singh, Weeknd, etc.", style: GoogleFonts.inter(color: Colors.white24, fontSize: 12)),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: EdgeInsets.all(16),
                  itemCount: searchResults.length,
                  itemBuilder: (context, i) {
                    var v = searchResults[i];
                    return ListTile(
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(v.thumbnails.highResUrl, width: 50, height: 50, fit: BoxFit.cover, errorBuilder: (_, __, ___) => Container(width: 50, height: 50, color: Colors.grey[900], child: Icon(Icons.music_note))),
                      ),
                      title: Text(v.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: GoogleFonts.inter(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600)),
                      subtitle: Text(v.author, maxLines: 1, style: GoogleFonts.inter(color: Colors.white54, fontSize: 12)),
                      trailing: Icon(Icons.play_circle, color: Color(0xFFFF2D55)),
                      onTap: () => playVideo(v),
                    );
                  },
                ),
      bottomSheet: ClipRRect(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            color: Color(0xFF1C1C1E).withOpacity(0.9),
            padding: EdgeInsets.fromLTRB(20, 12, 20, 30),
            child: Row(
              children: [
                Container(width: 45, height: 45, decoration: BoxDecoration(color: Color(0xFFFF2D55), borderRadius: BorderRadius.circular(10)), child: Icon(isLoading ? Icons.hourglass_empty : Icons.music_note, color: Colors.white)),
                SizedBox(width: 12),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(currentTitle, maxLines: 1, style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 13)), Text(currentArtist, maxLines: 1, style: GoogleFonts.inter(color: Colors.white54, fontSize: 11))])),
                IconButton(icon: Icon(isPlaying ? Icons.pause_circle_filled : Icons.play_circle_fill, size: 40, color: Colors.white), onPressed: () => isPlaying ? player.pause() : player.play()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    player.dispose();
    yt.close();
    super.dispose();
  }
}