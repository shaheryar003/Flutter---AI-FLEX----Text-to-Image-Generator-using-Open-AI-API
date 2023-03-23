import 'dart:io';

import 'package:ai_image_generator/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class art_screen extends StatefulWidget {
  const art_screen({super.key});

  @override
  State<art_screen> createState() => _art_screenState();
}

class _art_screenState extends State<art_screen> {
  List imgList = [];

  getImages() async {
    final directory = Directory("/storage/emulated/0//DCIM/AI-FLEX");
    imgList = directory.listSync();
  }

  popImgae(filepath) {
    showDialog(
        context: context,
        builder: (context) => Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: Container(
                clipBehavior: Clip.antiAlias,
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                    color: whiteColor, borderRadius: BorderRadius.circular(12)),
                child: Image.file(
                  filepath,
                  fit: BoxFit.cover,
                ),
              ),
            ));
  }

  @override
  void initState() {
    super.initState();
    getImages();
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
                  onPressed: () {},
                  child: Text("My Art")),
            )
          ],
          centerTitle: true,
          title: Text(
            "Art Gallery",
            style: TextStyle(fontFamily: "poppins_bold", color: whiteColor),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
          child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, mainAxisSpacing: 8, crossAxisSpacing: 8),
              itemCount: imgList.length,
              itemBuilder: (BuildContext context, index) {
                return GestureDetector(
                  onTap: () {
                    popImgae(imgList[index]);
                  },
                  child: Container(
                    clipBehavior: Clip.antiAlias,
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(14)),
                    child: Image.file(imgList[index]),
                  ),
                );
              }),
        ));
  }
}
