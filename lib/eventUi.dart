import 'package:flutter/material.dart';
import 'package:lobster/model/Event.dart';
import 'package:intl/intl.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lobster/downloader.dart';
import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:slide_countdown_clock/slide_countdown_clock.dart';
import 'package:countdown_flutter/countdown_flutter.dart';
import 'dart:async';
const img = 'assets/images/';
const title = TextStyle(color: Colors.white, fontSize: 36, letterSpacing: 13.0, fontWeight: FontWeight.w600);


class EventDetailsPage extends StatefulWidget {
  final Event event;

  EventDetailsPage({Key key, this.event}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _EventDetailsPageState();
}

class _EventDetailsPageState extends State<EventDetailsPage> {

  Event event;

  TextStyle secondaryText = TextStyle(fontSize: 14.0, color: Colors.white70);
  bool ifPast = false;
  bool ifMix = false;

  @override
  void initState() {
    super.initState();
    this.event = widget.event;
    _checkIfPast();
    _checkMix();
  }

  _checkIfPast(){
    DateTime now = DateTime.now();
    DateTime eventTime = new DateTime.fromMillisecondsSinceEpoch(widget.event.date);
    final difference = eventTime.difference(now).inMilliseconds;
    if(difference < 0){
      setState(() =>  this.ifPast = true);
    }
  }

  _checkMix() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String sound = prefs.getString('mix');

    if(sound != null){
      setState(() =>  this.ifMix = true);

    }
  }



  @override
  Widget build(BuildContext context) {
    final platform = Theme.of(context).platform;
    _checkIfPast();

    return Scaffold(
      backgroundColor: Color(0xff262626),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView(
              padding: EdgeInsets.all(0.0),
              children: <Widget>[

                //IMAGE COVER AND NAME
                Stack(
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 250,
                      child: FittedBox(
                        child: Image.network(this.event.cover),
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      top: 215,
                      right: 0,
                      child: Text(this.event.name.toUpperCase(), style: TextStyle(
                          fontSize: 32.0,
                          fontWeight: FontWeight.bold,
                      ),),
                    ),
                  ],
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    child: Text(this.event.location.city, style: TextStyle(
                      fontSize: 14.0,
                      color: Colors.white70,
                    ),),
                  ),
                ),
                SizedBox(height: 16.0,),

                //TIME AND DATE
                Container(
                  height: 55,
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(new DateFormat("d").format(new DateTime.fromMillisecondsSinceEpoch(this.event.date)),
                            style: TextStyle(
                            fontSize: 52.0,
                            fontWeight: FontWeight.bold,),
                            ),
                            Container(
                              alignment: Alignment.centerLeft,
                              padding: EdgeInsets.only(top: 15.0, left: 10.0),
                              child: Column(
                                children: <Widget>[
                                  Text(new DateFormat("MMM, yyyy").format(new DateTime.fromMillisecondsSinceEpoch(this.event.date)),
                                    style: TextStyle(
                                      fontSize: 14.0,),
                                  ),
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(new DateFormat.Hm().format(new DateTime.fromMillisecondsSinceEpoch(this.event.date)),
                                      style: TextStyle(
                                        fontSize: 14.0,
                                        color: Colors.white30,
                                        ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),

                      VerticalDivider(),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(Icons.timer),
                            SizedBox(width: 5.0,),
                            Text("~75 min")
                          ],
                        ),
                      ),

                    ],
                  ),
                ),


                SizedBox(height: 40.0,),
                _buildRow(
                    title: "Description".toUpperCase(),
                    content: this.event.description,

                ),
                SizedBox(height: 40.0,),
                _buildRow(
                  title: "Step by step instuction".toUpperCase(),
                  content: "",

                ),
                _buildStep(
                    leadingTitle: "smartphone.svg",
                    title: "Bring phone with this app",
                    content: ""

                ),

                SizedBox(height: 30.0,),
                _buildStep(
                    leadingTitle: "headphones.svg",
                    title: "Your headphones is must. We are going to listen music",
                    content: ""
                ),

                SizedBox(height: 30.0,),
                _buildStep(
                  leadingTitle: "dj-mixer.svg",
                  title: "Enroll to event and download mix for offline capability",
                  content: ""
                ),
                SizedBox(height: 30.0,),
                _buildStep(
                    leadingTitle: "placeholder.svg",
                    title: "On the day of the event You will receive location details.",
                    content: ""
                ),
                SizedBox(height: 30.0,),
                _buildStep(
                    leadingTitle: "backpacker.svg",
                    title: "Party will be outdoor. Bring you enjoyments and remember to be responsible.",
                    content: ""
                ),
                SizedBox(height: 30.0,),
                _buildStep(
                    leadingTitle: "party-dj.svg",
                    title: "Mix will start to play at exact time from this app. It will be synchronize time so everybody will be at same place.",
                    content: ""
                ),
                SizedBox(height: 30.0,),
                _buildStep(
                    leadingTitle: "man-standing-with-arms-up.svg",
                    title: "Let's have a good time",
                    content: ""
                ),

                Center(
                  child: this.ifMix ?
                  Text("Mix is ready", style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14.0,
                    color: Colors.white70,
                  )):
                  FileDownloader(platform: platform, event: this.event, checkMix: _checkMix)

                ),


              ],
            ),
          ),


          this.ifMix ?
          Container(
            padding: EdgeInsets.all(10.0),
            height: 70,
            child: this.ifPast ?
                  GestureDetector(
                    onTap: () { Navigator.push(context, MaterialPageRoute(builder: (context) => PlayRoute(event: this.event))); },
                    child: Image.asset('assets/icons/open-door.png'),
                    ) :
                   showTimer(context:context,event:this.event)

          ):
          SizedBox.shrink(),

        ],
      ),
    );
  }




  Widget showTimer({context,event}) {

    DateTime now = DateTime.now();
    DateTime eventTime = new DateTime.fromMillisecondsSinceEpoch(widget.event.date);
    final difference = eventTime.difference(now).inSeconds;
    Duration timer = Duration(seconds: difference);

    return  SlideCountdownClock(
      duration: timer,
      slideDirection: SlideDirection.Down,
      separator: ":",
      textStyle: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      onDone: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => PlayRoute(event:event)));
      }
    );
  }

  Widget _buildRow({String title, String content}) {
    return Padding(
      padding: const EdgeInsets.only(left: 85.0, right:0.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(width: 5.0,),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(title, style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14.0,
                    color: Colors.white30,
                )),
                Text(content, style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14.0,
                  color: Colors.white70,
                )),
              ],
            ),
          )
        ],
      ),
    );
  }



  Widget _buildStep({String leadingTitle, String title, String content}) {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right:10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[

          Container(
              width: 45,
              height: 45,
              child: SvgPicture.asset(
                'assets/icons/'+leadingTitle,
                width: 40,
                height: 40,
                color: Colors.white70
              ),
            ),

          SizedBox(width: 16.0,),
          new Flexible(
            child: Padding(
              padding: const EdgeInsets.only(top:0.0 , left: 10.0),
              child: Text(title, style: secondaryText,
                softWrap: true,),
            ),
          )
        ],
      ),
    );
  }


}

enum PlayerState { stopped, playing, paused }
class PlayRoute extends StatefulWidget {

  final Event event;

  const PlayRoute({Key key,this.event}) : super(key: key);
  @override
  _PlayRouteState createState() => _PlayRouteState();
}

class _PlayRouteState extends State<PlayRoute> {
  AudioPlayer player;
  AudioCache cache;
  bool initialPlay = true;
  bool playing;
  String sound;

  AudioPlayer _audioPlayer;
  AudioPlayerState _audioPlayerState;
  Duration _duration;
  Duration _position;

  PlayerState _playerState = PlayerState.stopped;
  StreamSubscription _durationSubscription;
  StreamSubscription _positionSubscription;
  StreamSubscription _playerCompleteSubscription;
  StreamSubscription _playerErrorSubscription;
  StreamSubscription _playerStateSubscription;

  get _isPlaying => _playerState == PlayerState.playing;
  get _isPaused => _playerState == PlayerState.paused;
  get _durationText => _duration?.toString()?.split('.')?.first ?? '';
  get _positionText => _position?.toString()?.split('.')?.first ?? '';

  @override
  initState() {
    super.initState();
    _initAudioPlayer();
    _playMix();
  }





  @override
  dispose() {
    _audioPlayer.stop();
    _durationSubscription?.cancel();
    _positionSubscription?.cancel();
    _playerCompleteSubscription?.cancel();
    _playerErrorSubscription?.cancel();
    _playerStateSubscription?.cancel();
    super.dispose();
  }

  _playMix() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    this.sound = prefs.getString('mix');

    // start mix syncronisly with time
    DateTime now = DateTime.now();
    DateTime eventTime = new DateTime.fromMillisecondsSinceEpoch(widget.event.date);
    final difference = eventTime.difference(now).inMilliseconds;
    final difference2 = now.difference(eventTime).inMilliseconds;
    Duration _position = Duration(milliseconds: difference2);

    if(_playerState != PlayerState.playing && this.sound != null) {
      final result =
      await _audioPlayer.play(this.sound, isLocal: true, position: _position);
      if (result == 1) setState(() => _playerState = PlayerState.playing);
      return result;
    }

  }

  void _initAudioPlayer() {
    _audioPlayer = AudioPlayer();

    _durationSubscription =
        _audioPlayer.onDurationChanged.listen((duration) => setState(() {
          _duration = duration;
        }));

    _positionSubscription =
        _audioPlayer.onAudioPositionChanged.listen((p) => setState(() {
          _position = p;
        }));

    _playerCompleteSubscription =
        _audioPlayer.onPlayerCompletion.listen((event) {
          _onComplete();
          setState(() {
            _position = _duration;
          });
        });

    _playerErrorSubscription = _audioPlayer.onPlayerError.listen((msg) {
      print('audioPlayer error : $msg');
      setState(() {
        _playerState = PlayerState.stopped;
        _duration = Duration(seconds: 0);
        _position = Duration(seconds: 0);
      });
    });

    _audioPlayer.onPlayerStateChanged.listen((state) {
      if (!mounted) return;
      setState(() {
        _audioPlayerState = state;
      });
    });


  }

  void _onComplete() {
    setState(() => _playerState = PlayerState.stopped);
  }


  @override
  build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(top: 0, left: 0, child: Background(sound: "forest")),
          Padding(padding: const EdgeInsets.only(top: 180.0),
              child: Center(
                  child: Column(children: [Text("forest", style: title)])
              )
          ),
          Slider(
            value: _position?.inMilliseconds?.toDouble() ?? 0,
            min: 0.0,
            max: _duration.inMilliseconds.toDouble(),
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
