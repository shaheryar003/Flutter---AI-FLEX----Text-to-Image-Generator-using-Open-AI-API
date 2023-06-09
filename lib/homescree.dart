import 'dart:io';
import 'dart:typed_data';

import 'package:ai_image_generator/api_services.dart';
import 'package:ai_image_generator/art_screen.dart';
import 'package:ai_image_generator/color.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var sizes = ["Small", "Medium", "Large"];
  var values = ["256x256", "512x512", "1024x1024"];
  String? dropValue;
  var textController = TextEditingController();
  String? image;
  var isLoaded = false;
  var btnPressed = false;
  ScreenshotController screenshotController = ScreenshotController();
  shareImage() async {
    await screenshotController
        .capture(delay: Duration(milliseconds: 100), pixelRatio: 1.0)
        .then((Uint8List? img) async {
      if (img != null) {
        final directory = (await getApplicationDocumentsDirectory()).path;
        final filename = "share.png";
        final imagePath = await File("${directory}/$filename").create();
        await imagePath.writeAsBytes(img);

        Share.shareFiles([imagePath.path], text: "Generated by Ai- Shaheryar");
      } else {
        print("Failed to take Screenshot");
      }
    });
  }

  downloadImage() async {
    final filename = "${DateTime.now().millisecondsSinceEpoch}.png";
    final permission = Permission.storage;
    final status = await permission.status;
    debugPrint('>>>Status $status');

    /// here it is coming as PermissionStatus.granted
    if (status != PermissionStatus.granted) {
      await permission.request();
      if (await permission.status.isGranted) {
        final path = Directory('/storage/emulated/0/DCIM/AI-FLEX');

        ///perform other stuff to download file
        if (await path.exists()) {
          screenshotController.captureAndSave(path.path,
              delay: Duration(milliseconds: 100),
              fileName: filename,
              pixelRatio: 1.0);
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text("Saved to ${path.path}")));
        } else {
          await path.create();
          screenshotController.captureAndSave(path.path,
              delay: Duration(milliseconds: 100),
              fileName: filename,
              pixelRatio: 1.0);
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text("Saved to ${path.path}")));
        }
      } else {
        await permission.request();
      }
      debugPrint('>>> ${await permission.status}');
    }
    final path = Directory('/storage/emulated/0/DCIM/AI-FLEX');

    await path.create();
    screenshotController.captureAndSave(path.path,
        delay: Duration(milliseconds: 100),
        fileName: filename,
        pixelRatio: 1.0);
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text("Saved to ${path.path}")));

//     var result = await Permission.photos.request();
//     final filename = "${DateTime.now().millisecondsSinceEpoch}.png";
//     bool storage = true;
//     bool videos = true;
//     bool photos = true;

// // Only check for storage < Android 13
//     DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
//     AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
//     if (androidInfo.version.sdkInt >= 33) {
//       videos = await Permission.videos.status.isGranted;
//       photos = await Permission.photos.status.isGranted;
//     } else {
//       storage = await Permission.storage.status.isGranted;
//     }

//     if (storage && videos && photos) {
//       final foldername = "Ai Image";
//       final path = Directory("/storage/emulated/0/$foldername");
//       if (await path.exists()) {
//         screenshotController.captureAndSave(path.path,
//             delay: Duration(milliseconds: 100),
//             fileName: filename,
//             pixelRatio: 1.0);
//         ScaffoldMessenger.of(context)
//             .showSnackBar(SnackBar(content: Text("Saved to ${path.path}")));
//       } else {
//         await path.create();
//         screenshotController.captureAndSave(path.path,
//             delay: Duration(milliseconds: 100),
//             fileName: filename,
//             pixelRatio: 1.0);
//         ScaffoldMessenger.of(context)
//             .showSnackBar(SnackBar(content: Text("Saved to ${path.path}")));
//       }
//     } else {
//       ScaffoldMessenger.of(context)
//           .showSnackBar(SnackBar(content: Text("Permission Denied")));
//     }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.all(8), backgroundColor: btnColor),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => art_screen()));
                },
                child: Text("My Art")),
          )
        ],
        centerTitle: true,
        title: Text(
          "AI FLEX",
          style: TextStyle(color: whiteColor),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 0),
                        decoration: BoxDecoration(
                            color: whiteColor,
                            borderRadius: BorderRadius.circular(12)),
                        child: TextFormField(
                          maxLines: null,
                          textAlign: TextAlign.left,
                          controller: textController,
                          decoration: InputDecoration(
                            isDense: true,
                            hintText: "eg cat on moon",
                            hintStyle: TextStyle(fontSize: 15),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 12,
                    ),
                    Container(
                      height: 44,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                          color: whiteColor,
                          borderRadius: BorderRadius.circular(12)),
                      child: DropdownButtonHideUnderline(
                          child: DropdownButton(
                              icon: const Icon(
                                Icons.arrow_downward,
                                color: btnColor,
                              ),
                              value: dropValue,
                              hint: const Text(
                                "Select Size",
                                style: TextStyle(fontSize: 15),
                              ),
                              items: List.generate(
                                  sizes.length,
                                  (index) => DropdownMenuItem(
                                        child: Text(sizes[index]),
                                        value: values[index],
                                      )),
                              onChanged: (value) {
                                setState(() {
                                  dropValue = value.toString();
                                });
                              })),
                    )
                  ],
                ),
                SizedBox(
                    width: 300,
                    height: 44,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: btnColor, shape: StadiumBorder()),
                        onPressed: () async {
                          setState(() {
                            isLoaded = false;
                            btnPressed = true;
                          });

                          if (textController.text.isNotEmpty &&
                              dropValue!.isNotEmpty) {
                            image = await Api.generateImage(
                                textController.text, dropValue!);

                            setState(() {
                              isLoaded = true;
                              btnPressed = false;
                            });
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content:
                                    Text("Please Pass Query & Select Size")));
                          }
                        },
                        child: Text("Generate")))
              ],
            )),
            Expanded(
              flex: 4,
              child: isLoaded
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                            clipBehavior: Clip.antiAlias,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12)),
                            child: Screenshot(
                              controller: screenshotController,
                              child: Image.network(
                                image!,
                                fit: BoxFit.contain,
                              ),
                            )),
                        SizedBox(
                          height: 12,
                        ),
                        Row(
                          children: [
                            Expanded(
                                child: ElevatedButton.icon(
                                    icon: Icon(
                                        Icons.download_for_offline_outlined),
                                    style: ElevatedButton.styleFrom(
                                        padding: EdgeInsets.all(8),
                                        backgroundColor: btnColor),
                                    onPressed: () {
                                      downloadImage();
                                    },
                                    label: Text("Download Image"))),
                            SizedBox(
                              width: 12,
                            ),
                            Expanded(
                                child: ElevatedButton.icon(
                                    icon: Icon(Icons.share),
                                    style: ElevatedButton.styleFrom(
                                        padding: EdgeInsets.all(8),
                                        backgroundColor: btnColor),
                                    onPressed: () async {
                                      await shareImage();
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                              content: Text("Image Shared")));
                                    },
                                    label: Text("Share Image")))
                          ],
                        ),
                      ],
                    )
                  : Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: whiteColor),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                              height: 50,
                              child: Image.asset('assets/images/loaders.gif')),
                          SizedBox(
                            height: 20,
                          ),
                          btnPressed
                              ? Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                      "Please wait while we make some shit"),
                                )
                              : Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                      "Come on Enter some thing and Press Generate"),
                                )
                        ],
                      ),
                    ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Designed By Shaheryar Ashfaq",
                style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: whiteColor),
              ),
            )
          ],
        ),
      ),
    );
  }
}
