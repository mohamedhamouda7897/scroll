// import 'dart:io';
//
// import 'package:dio/dio.dart';
// import 'package:ext_storage/ext_storage.dart';
// import 'package:flutter/material.dart';
// import 'package:permission_handler/permission_handler.dart';
//
// class MyPdf extends StatefulWidget {
//   @override
//   _MyPdfState createState() => _MyPdfState();
// }
//
// class _MyPdfState extends State<MyPdf> {
//   final String imgUrl='http://www.pdf995.com/samples/pdf.pdf';
//
//   var dio=Dio();
//
//
//
//
//   @override
//   Widget build(BuildContext context) {
//     // TODO: implement build
//    return Scaffold(
//      appBar: AppBar(title: Text('download pdf flie'),),
//
//      body: Center(
//        child: Column(
//          mainAxisAlignment: MainAxisAlignment.center,
//          children: [
//           RaisedButton.icon(
//               onPressed:() async {
//                 String path =
//                     await ExtStorage.getExternalStoragePublicDirectory(
//                     ExtStorage.DIRECTORY_DOWNLOADS);
//
//                 String fullPath = "$path/newtask1.pdf";
//                 await download2(dio,imgUrl,fullPath);
//               },
//               icon: Icon(Icons.file_download,color: Colors.white,),
//               color: Colors.green,
//               textColor: Colors.white,
//               label: Text('Download'))
//          ],
//        ),
//      ),
//    );
//   }
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     getPermission();
//   }
//   //get storage permission
//   void getPermission() async {
//     print("getPermission");
//     // await PermissionHandler().requestPermissions([PermissionGroup.storage]);
//     await Permission.storage.request();
//   }
//
//   Future download2(Dio dio, String url, String savePath) async {
//     //get pdf from link
//     Response response = await dio.get(
//       url,
//       onReceiveProgress: showDownloadProgress,
//       //Received data with List<int>
//       options: Options(
//           responseType: ResponseType.bytes,
//           followRedirects: false,
//           validateStatus: (status) {
//             return status < 500;
//           }),
//     );
//
//     //write in download folder
//     File file = File(savePath);
//     var raf = file.openSync(mode: FileMode.write);
//     raf.writeFromSync(response.data);
//     await raf.close();
//   }
// //progress bar
//
//
//
//   void showDownloadProgress( received,  total) {
//     if (total != -1) {
//       print((received / total * 100).toStringAsFixed(0) + "%");
//     }
//
//   }
// }
//
//
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_full_pdf_viewer_null_safe/full_pdf_viewer_scaffold.dart';

import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

// import 'package:simple_permissions/simple_permissions.dart';

class FileDownload extends StatefulWidget {
  @override
  _FileDownloadState createState() => _FileDownloadState();
}

class _FileDownloadState extends State<FileDownload> {
  bool? isLoading;
  bool _allowWriteFile = false;

  List<Course>? courseContent;

  String progress = "";
  Dio? dio;

  @override
  void initState() {
    super.initState();
    dio = Dio();
    courseContent!.add(Course(
        title: 'Chapter 2',
        path: 'https://www.cs.purdue.edu/homes/ayg/CS251/slides/chap2.pdf'));
    courseContent!.add(Course(
        title: 'Chapter 3',
        path: 'https://www.cs.purdue.edu/homes/ayg/CS251/slides/chap3.pdf'));
    courseContent!.add(Course(
        title: 'Chapter 4',
        path: 'https://www.cs.purdue.edu/homes/ayg/CS251/slides/chap4.pdf'));
    courseContent!.add(Course(
        title: 'Chapter 5',
        path: 'https://www.cs.purdue.edu/homes/ayg/CS251/slides/chap5.pdf'));
    courseContent!.add(Course(
        title: 'Chapter 6',
        path: 'https://www.cs.purdue.edu/homes/ayg/CS251/slides/chap6.pdf'));
    courseContent!.add(Course(
        title: 'Chapter 7A',
        path: 'https://www.cs.purdue.edu/homes/ayg/CS251/slides/chap7a.pdf'));
  }

  requestWritePermission() async {
    // PermissionStatus permissionStatus = await SimplePermissions.requestPermission(Permission.WriteExternalStorage);
    PermissionStatus permissionStatus = await Permission.storage.request();

    print('permassionss');
    print(permissionStatus.isGranted);
    // if (permissionStatus == PermissionStatus.granted) {
    if (permissionStatus.isGranted) {
      setState(() {
        _allowWriteFile = true;
      });
    }
  }

  Future<String> getDirectoryPath() async {
    Directory appDocDirectory = await getApplicationDocumentsDirectory();

    Directory directory =
        await new Directory(appDocDirectory.path + '/' + 'dir')
            .create(recursive: true);

    return directory.path;
  }

  Future downloadFile(String url, path) async {
    if (!_allowWriteFile) {
      print('permassion');
      requestWritePermission();
    }
    try {
      // ProgressDialog progressDialog =
      //     ProgressDialog(context, type: ProgressDialogType.Normal);
      // progressDialog?.style(message: "Downloading File");
      // progressDialog?.show();

      // await dio?.download(url, path, onReceiveProgress: (rec, total) {
      //   print('url $url');
      //   print('path $path');
      //   setState(() {
      //     isLoading = true;
      //     progress = ((rec / total) * 100).toStringAsFixed(0) + "%";
      //     progressDialog.update(message: "Dowloading $progress");
      //   });
      // });
      // progressDialog.hide();
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Colors.white70,
      appBar: AppBar(
        title: Text("FIle Download"),
        backgroundColor: Colors.red,
      ),
      body: Container(
        child: ListView.builder(
          itemBuilder: (context, index) {
            String? url = courseContent![index].path;
            String? title = courseContent![index].title;
            //String extension = url.substring(url.lastIndexOf("/"));
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                elevation: 10,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "$title",
                        style: TextStyle(
                            fontSize: 26,
                            color: Colors.purpleAccent,
                            fontWeight: FontWeight.bold),
                      ),
                      RaisedButton(
                        color: Colors.green,
                        onPressed: () {
                          // getDirectoryPath().then((path) {
                          //   File f = File(path + "${extension!}");
                          //   if (f.existsSync()) {
                          //     Navigator.push(context,
                          //         MaterialPageRoute(builder: (context) {
                          //       return PDFScreen(f.path);
                          //     }));
                          //     return;
                          //   }

                          //   downloadFile(url!, "$path/$extension");
                          // });
                        },
                        child: Text(
                          "View",
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
          itemCount: courseContent?.length,
        ),
      ),
    );
  }
}

class ProgressDialogType {}

class PDFScreen extends StatelessWidget {
  String pathPDF = "";
  PDFScreen(this.pathPDF);

  @override
  Widget build(BuildContext context) {
    return PDFViewerScaffold(
        appBar: AppBar(
          title: Text("Document"),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.share),
              onPressed: () {},
            ),
          ],
        ),
        path: pathPDF);
  }
}

class Course {
  String? title;
  String? path;
  Course({this.title, this.path});
}
