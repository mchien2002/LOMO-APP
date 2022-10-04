import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:lomo/libraries/photo_manager/photo_provider.dart';
import 'package:lomo/res/strings.dart';

class TakePictureScreen extends StatefulWidget {
  final CameraDescription camera;

  const TakePictureScreen({Key? key, required this.camera}) : super(key: key);

  @override
  TakePictureScreenState createState() => TakePictureScreenState();
}

class TakePictureScreenState extends State<TakePictureScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  Uint8List? u8List;
  bool isFirst = true;

  @override
  void initState() {
    super.initState();
    _controller = CameraController(
      widget.camera,
      ResolutionPreset.max,
    );
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        child: Stack(
          children: [
            FutureBuilder<void>(
              future: _initializeControllerFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return Center(child: CameraPreview(_controller));
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
            if (u8List != null) Center(child: _reviewPickture()),
            Align(
              alignment: Alignment.topRight,
              child: Container(
                  margin: EdgeInsets.only(right: 20, top: 65),
                  child: InkWell(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 32,
                      ))),
            )
          ],
        ),
      ),
      floatingActionButton:
          u8List == null ? _bottomAction() : _bottomActionPreview(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      //bottomNavigationBar: _bottomAction(),
    );
  }

  Widget _reviewPickture() {
    return Container(
        child: Image.memory(
      u8List!,
      fit: BoxFit.cover,
      filterQuality: FilterQuality.low,
    ));
  }

  Widget _bottomAction() {
    return Container(
      margin: EdgeInsets.only(bottom: 40),
      child: InkWell(
        child: Container(
          width: 70,
          height: 70,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(70),
            color: Colors.white.withOpacity(0.75),
          ),
          child: Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(70),
              color: Colors.transparent,
              border: Border.all(width: 2, color: Colors.black),
            ),
          ),
        ),
        onTap: () async {
          try {
            await _initializeControllerFuture;
            final XFile image = await _controller.takePicture();
            u8List = await image.readAsBytes();
            setState(() {});
          } catch (e) {
            print(e);
          }
        },
      ),
    );
  }

  Widget _bottomActionPreview() {
    return Container(
      padding: EdgeInsets.only(left: 15, right: 15, bottom: 40),
      height: 80,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            child: Text(
              Strings.retake.localize(context),
              style: TextStyle(fontSize: 15, color: Colors.white),
            ),
            onTap: () {
              setState(() {
                u8List = null;
              });
            },
          ),
          InkWell(
            child: Text(
              Strings.usePhoto.localize(context),
              style: TextStyle(fontSize: 15, color: Colors.white),
            ),
            onTap: () async {
              Navigator.of(context)
                  .pop(PhotoInfo(u8List: u8List, isCamera: true));
            },
          ),
        ],
      ),
    );
  }
}
