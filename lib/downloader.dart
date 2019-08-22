import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'dart:async';
import 'package:permission_handler/permission_handler.dart';
import 'package:lobster/model/Event.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math';

class FileDownloader extends StatefulWidget {
  final TargetPlatform platform;
  final Event event;
  final Function checkMix;

  FileDownloader({Key key, this.platform,this.event,this.checkMix}) : super(key: key);


  @override
  _FileDownloaderState createState() => _FileDownloaderState();
}

class _FileDownloaderState extends State<FileDownloader> {

  String mix = "";
  bool downloading = false;
  var progress = "";
  var path = "No Data";
  var platformVersion = "Unknown";
  bool _permissisonReady;

  var _onPressed;
  static final Random random = Random();

  @override
  void initState() {
    super.initState();
    this.mix = widget.event.mix;
   // downloadFile();
  }

  Future<String> _findLocalPath() async {
    final directory = widget.platform == TargetPlatform.android
        ? await getExternalStorageDirectory()
        : await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<bool> _checkPermission() async {
    if (widget.platform == TargetPlatform.android) {
      PermissionStatus permission = await PermissionHandler()
          .checkPermissionStatus(PermissionGroup.storage);
      if (permission != PermissionStatus.granted) {
        Map<PermissionGroup, PermissionStatus> permissions =
        await PermissionHandler()
            .requestPermissions([PermissionGroup.storage]);
        if (permissions[PermissionGroup.storage] == PermissionStatus.granted) {
          return true;
        }
      } else {
        return true;
      }
    } else {
      return true;
    }
    return false;
  }

  _saveMixLocatino(mix) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('mix',mix);
  }

  Future<void> downloadFile() async {
    Dio dio = Dio();
    bool checkPermission1 = await _checkPermission();
    if (checkPermission1 == true) {
      String dirloc = (await _findLocalPath()) + '/download';
      final savedDir = Directory(dirloc);
      bool hasExisted = await savedDir.exists();
      if (!hasExisted) {
        savedDir.create();
      }


      try {
        await dio.download(this.mix, dirloc+"/mix.mp3",
            onReceiveProgress: (receivedBytes, totalBytes) {
              setState(() {
                downloading = true;
                progress =
                    ((receivedBytes / totalBytes) * 100).toStringAsFixed(0) +
                        "%";
              });
            });
      } catch (e) {
        print(e);
      }

      setState(() {
        downloading = false;
        progress = "Download Completed.";
        path = dirloc + "/mix.mp3";
        _saveMixLocatino(path);
        widget.checkMix();

      });
    } else {
      setState(() {
        progress = "Permission Denied!";
        _onPressed = () {
          downloadFile();
        };
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final platform = Theme.of(context).platform;
    return Center(
      child: downloading
          ? Container(
        height: 120.0,
        width: 200.0,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CircularProgressIndicator(),
              SizedBox(height: 10.0,),
              Text('Downloading Mix: $progress',
                style: TextStyle(color: Colors.white),),
            ],
          ),
      )
          :
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(path),

              GestureDetector(
                    onTap: () {
                      //update BD and start download
                      downloadFile();
                    },
                    child:  Container(
                    color: Colors.orange,
                    alignment: FractionalOffset.center,
                    padding: const EdgeInsets.all(16.0),
                    child:   Text(
                    "Enroll and start download",
                    style: TextStyle(
                    color: Colors.white),
                    ),
              ),
              )

        ],
      ),

    );
  }

}