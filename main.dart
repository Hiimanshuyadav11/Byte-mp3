import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
                seedColor: const Color.fromARGB(255, 88, 9, 112)),
            scaffoldBackgroundColor: const Color.fromARGB(255, 0, 0, 0)),
        home: ByteMusicPlayer(
          title: 'Music',
        ));
  }
}

class ByteMusicPlayer extends StatefulWidget {
  const ByteMusicPlayer({super.key, required this.title});

  final String title;

  @override
  State<ByteMusicPlayer> createState() => _ByteMusicPlayerState();
}

class _ByteMusicPlayerState extends State<ByteMusicPlayer> {
  final AudioPlayer _player = AudioPlayer();

  final List<String> _songs = [
    'assets/audio/song.mp3',
    'assets/audio/song2.mp3',
    'assets/audio/Paaro.mp3',
    'assets/audio/longtimenosee.mp3',
    'assets/audio/tuhaikahan.mp3',
  ];

  int _currentindex = 0;
  bool _isPlaying = false;
  String? currentsong;
  Set<String> _favourites = {};
 

  Future<void> _playsong(int index) async {
    await _player.stop();
    await _player.play(AssetSource(_songs[index].replaceFirst('assets/', '')));
    setState(() {
      _currentindex = index;
      _isPlaying = true;
    });
  }

  Future<void> _togglePlayPause() async {
    if (_isPlaying) {
      await _player.pause();
    } else {
      await _player.resume();
    }
    setState(() {
      _isPlaying = !_isPlaying;
    });
  }

  void _nextSong() {
    int nextIndex = (_currentindex + 1) % _songs.length;
    _playsong(nextIndex);
  }

  void _previousSong() {
    int prevIndex = (_currentindex - 1 + _songs.length) % _songs.length;
    _playsong(prevIndex);
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
  return Scaffold(
   appBar: AppBar(title: const Text("Music Player",
     style: TextStyle(color: Colors.white),
        ),
  backgroundColor: const Color.fromARGB(120, 141, 18, 172),
  centerTitle: true,
  shape: const RoundedRectangleBorder(borderRadius:BorderRadiusGeometry.vertical(bottom: Radius.circular(30))),),
  
  body: Column(children: [
  Expanded(child: ListView.builder( itemCount: _songs.length,itemBuilder: (context, index) {
    return ListTile(title: Text("Song ${index + 1}",
  style: TextStyle(
  color: index == _currentindex
  ? const Color.fromARGB(255, 77, 24, 161)
   : Colors.white,
      ),
   ),
trailing: IconButton(
    icon: Icon(
     _favourites.contains(_songs[index])
    ? Icons.favorite
    : Icons.favorite_border,
    color: _favourites.contains(_songs[index])? Colors.red: Colors.white,),
    onPressed: () {
    setState(() {
    if (_favourites.contains(_songs[index])) {
    _favourites.remove(_songs[index]);
    } else {
    _favourites.add(_songs[index]);
      }
    });
     },
  ),
onTap: () => _playsong(index),
 );
 },
 ),
          
  ),
Container(
  padding: const EdgeInsets.all(16),
  decoration: BoxDecoration(
  borderRadius: BorderRadius.only(
    topLeft: Radius.circular(25),
    topRight: Radius.circular(25),
              ),
    color: Color.fromARGB(221, 78, 3, 97),
            ),
   child: Row(
    mainAxisAlignment: MainAxisAlignment.spaceAround,
    children: [
     IconButton(
     icon: const Icon(Icons.skip_previous, color: Colors.white),
     onPressed: _previousSong, iconSize: 40,
                ),
    IconButton(
    icon: Icon(
     _isPlaying ? Icons.pause_circle : Icons.play_circle,
      color: Colors.white, ),
      onPressed: _togglePlayPause,
      iconSize: 60,
                ),
    IconButton(
    icon: const Icon(Icons.skip_next, color: Colors.white),
     onPressed: _nextSong,
       iconSize: 40,
                ),
              ],
  )),
      ]),
         );
  }
}
