/*
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:better_player/better_player.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  late BetterPlayerController _videoPlayerController;
  bool playerInitialized = false;

  final httpClient = http.Client();

  Future<String> downloadFile(String url, {required String fullPath}) async {
    var request = http.Request('GET', Uri.parse(url));
    var response = httpClient.send(request);

    List<List<int>> chunks = List.empty(growable: true);
    int downloaded = 0;
    File file = File(fullPath);

    response.asStream().listen((http.StreamedResponse r) {
      //Utils.printf('Listen to http.StreamedResponse');
      r.stream.listen((List<int> chunk) {
        // Display percentage of completion
        //Utils.printf('downloadPercentage: ${downloaded / r.contentLength! * 100}');

        chunks.add(chunk);
        downloaded += chunk.length;

        final Uint8List bytes = Uint8List(r.contentLength!);
        int offset = 0;
        for (List<int> chunk in chunks) {
          bytes.setRange(offset, offset + chunk.length, chunk);
          offset += chunk.length;
        }

        file.writeAsBytes(bytes, mode: FileMode.write);
      }, onDone: () async {
        // // Display percentage of completion
        //Utils.printf('download Completed: ${downloaded / r.contentLength! * 100}');
        // // Save the file
        // File file = new File('$dir/$filename');
        // final Uint8List bytes = Uint8List(r.contentLength);
        // int offset = 0;
        // for (List<int> chunk in chunks) {
        //   bytes.setRange(offset, offset + chunk.length, chunk);
        //   offset += chunk.length;
        // }
        // await file.writeAsBytes(bytes);
        // return;
      });
    });

    return file.path;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    initPlayer();
  }

  initPlayer() {

    var fileStream  = DefaultCacheManager().getFileStream(
        "https://media.w3.org/2010/05/sintel/trailer.mp4",
        headers: {
          "Content-Type": "video/mp4"
        },
        // key: 'test123',
        withProgress: true
    );

     fileStream.listen((fileResponse) {
      if(fileResponse is DownloadProgress){
         print("download progress instance");
         print("download: ${fileResponse.downloaded}");
         print("total size : ${fileResponse.totalSize}");
         print("progress : ${fileResponse.progress}");
         print("filePath : ${fileResponse.filePath}");
if(!playerInitialized){
           _videoPlayerController = VideoPlayerController.file(
               File("/data/user/0/com.example.test_file_streaming/cache/libCachedImageData/${fileResponse.filePath}")
           );
           setState(() {
             playerInitialized = true;
           });
         }

         if(!playerInitialized){
           setState(() {
             print("enter to set state");
             _videoPlayerController = BetterPlayerController(
                 const BetterPlayerConfiguration(
                     fit: BoxFit.cover,
                     startAt: Duration(seconds: 0),
                     allowedScreenSleep: false,
                     autoPlay: true,
                     autoDispose: false,
                     handleLifecycle: false,
                     looping: false
                 ),
                 betterPlayerDataSource: BetterPlayerDataSource.file(
                     File("/data/user/0/com.example.test_file_streaming/cache/libCachedImageData/" + fileResponse.filePath).path,
                     cacheConfiguration: const BetterPlayerCacheConfiguration(useCache: false)));
             playerInitialized = true;
             //_videoPlayerController = VideoPlayerController.file(
             //    File(fileResponse.file.path)
             //);
             // playerInitialized = true;
           });
         }
      }
      if(fileResponse is FileInfo){
        print("fileInfo Instance");
        print("file response ${fileResponse.file.path}");

      }
    });
  }




  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    ScreenUtil.init(context);
    print("call build $playerInitialized");
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          children: [
            const SizedBox(height: 20,),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.width * 9/16,
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: playerInitialized  ? BetterPlayer(
                     controller: _videoPlayerController
                  ) :  Container()),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){},
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
*/
