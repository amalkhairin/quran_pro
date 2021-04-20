// @dart=2.9
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:social_share/social_share.dart';
import 'dart:ui' as ui;
import 'package:path_provider/path_provider.dart';
import 'package:arabic_numbers/arabic_numbers.dart';

class ShareToInstagramDialog extends StatelessWidget {
  final BuildContext context;
  final String surahName;
  final String surahText;
  final int ayahNumber;
  final String translateText;
  ShareToInstagramDialog({this.context, this.ayahNumber, this.surahName, this.translateText, this.surahText});

  ArabicNumbers _arabicNumbers = ArabicNumbers();
  GlobalKey _captureAyahKey = GlobalKey();

  Future<String> _createStory(GlobalKey key) async {
    RenderRepaintBoundary boundary = key.currentContext.findRenderObject();
    ui.Image image = await boundary.toImage(pixelRatio: 3.0);
    ByteData byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    var pngBytes = byteData.buffer.asUint8List();
    var bs64 = base64Encode(pngBytes);
    Uint8List bytes = base64Decode(bs64);
    String dir = (await getApplicationDocumentsDirectory()).path;
    print(dir);
    File file = File("$dir/bg_share_${DateTime.now().millisecondsSinceEpoch}.png");
    await file.writeAsBytes(bytes);
    return file.path;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.all(0.0),
      actions: [
        TextButton.icon(
          onPressed: () async {
            var capturePath = await _createStory(_captureAyahKey);
            print(capturePath);

            SocialShare.shareInstagramStory(
              capturePath,
              backgroundBottomColor: "#17D7B4",
              backgroundTopColor: "#60F193"
            );
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.share),
          label: Text("Bagikan"),
        ),
      ],
      content: RepaintBoundary(
        key: _captureAyahKey,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.0)
          ),
          child: Wrap(
            children: [
              Column(
                children: [
                  Container(
                    width: double.maxFinite,
                    margin: EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      color: Color(0xFF25BBA0),
                      borderRadius: BorderRadius.circular(6.0)
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("$surahName", style: TextStyle(color: Colors.white),),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 24, bottom: 24, left: 16.0, right: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          height: 35.0,
                          width: 35.0,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xFF25BBA0),
                          ),
                          child: Center(child:Text("${_arabicNumbers.convert(ayahNumber)}", style: TextStyle(fontSize: 20, color: Colors.white),))
                        ),
                        SizedBox(width: 26,),
                        Expanded(
                          child: Directionality(
                            textDirection: TextDirection.rtl,
                            child: Text(
                              "$surahText",
                              style: TextStyle(fontSize: 24, fontFamily: "LPMQIsepMisbah", height: 2.5),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Container(
                color: Color(0xFFF8F8F8),
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.only(top: 16.0, bottom: 16.0),
                child: Padding(
                  padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                  child: Text("$translateText"),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(6.0)
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Share with QuranPro apps",style: TextStyle(color: Colors.grey[400], fontSize: 12.0)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}