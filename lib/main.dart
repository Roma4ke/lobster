import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:slide_countdown_clock/slide_countdown_clock.dart';
import 'package:intl/intl.dart';

const img = 'assets/images/';
const title = TextStyle(color: Colors.white, fontSize: 36, letterSpacing: 13.0, fontWeight: FontWeight.w600);

void main() {
  runApp(MaterialApp(
    theme: ThemeData(fontFamily: 'Nunito'),
    debugShowCheckedModeBanner: false,
    home: HomeRoute(),
  ));
}

class HomeRoute extends StatelessWidget {
  row(s1, s2, context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [soundBtn(s1, context), soundBtn(s2, context),],
    );
  }

  soundBtn(sound, context) {
    return GestureDetector(
      onTap: () { Navigator.push(context, MaterialPageRoute(builder: (context) => PlayRoute(sound: sound))); },
      child: Column(
        children: [
          Image.asset('assets/icons/$sound.png'),
          Text(sound.toUpperCase(), style: TextStyle(color: Colors.white, fontSize: 16, letterSpacing: 3.0))
        ],
      ),
    );
  }

  showTimer(timer,sound, context){
    return  SlideCountdownClock(
      duration: timer,
      slideDirection: SlideDirection.Down,
      separator: ":",
      textStyle: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      onDone: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => PlayRoute(sound: sound)));
      },
    );
  }

  @override
  build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    DateTime now = DateTime.now();
    DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
    DateTime eventTime = dateFormat.parse("2019-08-18 16:50:00");
    //String eventTime = DateFormat('yyyy-MM-dd – kk:mm').format(now);
    int difference = eventTime.difference(now).inSeconds;

    Duration _duration = Duration(seconds: difference);
    GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();




    return Scaffold(
      body: Stack(
        children: [
          Positioned(top: 0, left: 0, child: Image.asset(img + 'bkgnd_2.jpg')),
          Positioned(top: 115, width: width, child: Center(child: Text('LOBSTER', style: title))),
          Positioned(top: 165, width: width, child: Center(child: showTimer(_duration,'forest',context))),
          Positioned(top: 250, width: width, child: Column(children: [row('rain', 'forest', context), row('sunset', 'ocean', context)],)
          ),
        ],
      ),
    );
  }
}

class PlayRoute extends StatefulWidget {
  final String sound;
  const PlayRoute({Key key, this.sound}) : super(key: key);
  @override
  _PlayRouteState createState() => _PlayRouteState();
}

class _PlayRouteState extends State<PlayRoute> {
  AudioPlayer player;
  AudioCache cache;
  bool initialPlay = true;
  bool playing;

  @override
  initState() {
    super.initState();
    player = new AudioPlayer();
    cache = new AudioCache(fixedPlayer: player);
  }

  @override
  dispose() {
    super.dispose();
    player.stop();
  }

  playPause(sound) {
    if (initialPlay) {
      cache.play('audio/$sound.mp3');
      playing = true;
      initialPlay = false;
    }
    return IconButton(
      color: Colors.white70, iconSize: 80.0, icon: playing ? Icon(Icons.pause_circle_filled) : Icon(Icons.play_circle_filled),
      onPressed: () {
        setState(() {
          if (playing) {
            playing = false;
            player.pause();
          } else {
            playing = true;
            player.resume();
          }
        });
      },
    );
  }

  @override
  build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(top: 0, left: 0, child: Background(sound: widget.sound)),
          Positioned(top: 0, left: 0, right: 0, child: AppBar(backgroundColor: Colors.transparent, elevation: 0)),
          Padding(padding: const EdgeInsets.only(top: 180.0),
              child: Center(
                  child: Column(children: [Text(widget.sound.toUpperCase(), style: title), playPause(widget.sound)])
              )
          ),
        ],
      ),
    );
  }
}

class Background extends StatefulWidget {
  final String sound;
  const Background({Key key, this.sound}) : super(key: key);
  @override
  _BackgroundState createState() => _BackgroundState();
}

class _BackgroundState extends State<Background> {
  Timer timer;
  bool _visible = false;

  @override
  dispose() {
    timer.cancel();
    super.dispose();
  }

  swap() {
    if (mounted) {
      setState(() { _visible = !_visible;
      });
    }
  }

  @override
  build(BuildContext context) {
    timer = Timer(Duration(seconds: 6), swap);
    return Stack(
      children: [
        Image.asset(img + widget.sound + '_1.jpg'),
        AnimatedOpacity(
            child: Image.asset(img + widget.sound + '_2.jpg'),
            duration: Duration(seconds: 2),
            opacity: _visible ? 1.0 : 0.0)
      ],
    );
  }
}
