import 'dart:isolate';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';


class TestPage extends StatefulWidget {
  const TestPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {

  late VideoPlayerController _videoPlayerController;
  bool playerInitialized = false;

  String fileName = "video7.mp4";


  String? taskId;

  late String filePath;

  String testVideoUrl = "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4";

  final ReceivePort _port = ReceivePort();

void initPlayerSecondTime() async {
    Directory appDocDirectory = await getApplicationDocumentsDirectory();
    String path = "${appDocDirectory.path}/videos";
    await Directory(path).create(recursive: true);

    filePath =  path + "/" +fileName;
    var file = File(filePath);
    /// You can change this to  VideoPlayerController.file
    _videoPlayerController = VideoPlayerController.network(
      file.path,
    );
    _videoPlayerController.initialize().then((value) => setState(() {

      playerInitialized = true;
      _videoPlayerController.play();
    }));
  }


  @override
  void initState() {
    super.initState();

    //initPlayerSecondTime();

    IsolateNameServer.registerPortWithName(_port.sendPort, 'downloader_send_port');
    _port.listen((dynamic data) async {
      int progress = data[2];

      if(progress > 25 && taskId != null && !playerInitialized){
        await FlutterDownloader.pause(taskId: taskId!);
        
          var file = File(filePath);
          _videoPlayerController = VideoPlayerController.network(
            file.path,
          );
          _videoPlayerController.initialize().then((value) => setState(() => playerInitialized = true));

      }
    });
    FlutterDownloader.registerCallback(downloadCallback);
    initPlayer();


  }

  @pragma('vm:entry-point')
  static void downloadCallback(String id, int status, int progress) {
    final SendPort? send = IsolateNameServer.lookupPortByName('downloader_send_port');
    send?.send([id, status, progress]);
  }

  Future<void> initPlayer() async {
    Directory appDocDirectory = await getApplicationDocumentsDirectory();
    String path = "${appDocDirectory.path}/videos";
    await Directory(path).create(recursive: true);
    //String fileName = "video1.mp4";
    FlutterDownloader.enqueue(
      url: testVideoUrl,
      savedDir: path,
      fileName: fileName,
      showNotification: false, // show download progress in status bar (for Android)
      // openFileFromNotification: true, // click on notification to open downloaded file (for Android)
    ).then((value) {
      print("enter file to queue");
      setState(() {
        taskId = value;
        filePath =  path + "/" +fileName;
      });

    }).onError((error, stackTrace) {
      print("error $error");
    });
  }


  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 20,),
            playerInitialized ?
            VisibilityDetector(
              key: const Key("video"),
              onVisibilityChanged: (visibilityFraction){
                if(visibilityFraction.visibleFraction > 0.5){
                  _videoPlayerController.play();
                  FlutterDownloader.resume(taskId: taskId!);
                }
              },
              child: SizedBox(
                height: MediaQuery.of(context).size.width,
                width: MediaQuery.of(context).size.width * 16/9,
                child: VideoPlayer(
                  _videoPlayerController,
                ),
              ),
            ) :
            Container()
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){},
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }

  @override
  void dispose() async {
    _videoPlayerController.dispose();
     IsolateNameServer.removePortNameMapping('downloader_send_port');
     super.dispose();
  }
}

