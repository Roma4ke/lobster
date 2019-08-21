import 'package:flutter/material.dart';
import 'package:lobster/model/Event.dart';
import 'package:intl/intl.dart';
import 'package:flutter_svg/flutter_svg.dart';

class EventDetailsPage extends StatefulWidget {
  final Event event;

  EventDetailsPage({Key key, this.event}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _EventDetailsPageState();
}

class _EventDetailsPageState extends State<EventDetailsPage> {

  Event event;

  TextStyle secondaryText = TextStyle(fontSize: 14.0, color: Colors.white70);

  @override
  void initState() {
    super.initState();
    this.event = widget.event;
    var date = new DateTime.fromMillisecondsSinceEpoch(this.event.date * 1000);

  }



  @override
  Widget build(BuildContext context) {
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


              ],
            ),
          ),
        ],
      ),
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
                'assets/images/'+leadingTitle,
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