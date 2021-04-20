// @dart=2.9
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:quran_pro/preparing_data.dart';
import 'package:quran_pro/app.dart';
import 'package:quran_pro/surahhelper.dart';
import 'package:path_provider/path_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // load data from local storage
  // get application directory
  var appDir = await getApplicationDocumentsDirectory();
  // initiate Hive Database to the path
  Hive.init(appDir.path);
  // register type adapter of stored data
  Hive.registerAdapter(SurahAdapter());
  Hive.registerAdapter(SurahTextAdapter());
  Hive.registerAdapter(SurahTranslationAdapter());
  Hive.registerAdapter(SurahTranslationTextAdapter());
  Hive.registerAdapter(SurahBookmarkAdapter());
  // check if box is exist
  bool exist = await Hive.boxExists("surahList");
  // open surah state box
  // this is use to get the last opened surah position
  await Hive.openBox("SurahState");
  // open surah bookmark list box
  await Hive.openBox("surahBookmarkList");
  //load surah list from surahList box if exist
  List<Surah> _surahList = <Surah>[];
  if(exist){
    var box = await Hive.openBox("surahList");
    if(box.length != 0){
      for (var i = 0; i < box.length; i++) {
        Surah surah = box.getAt(i);
        _surahList.add(surah);
      }
    }
  }
  runApp(MyApp(_surahList));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  final List<Surah> surahList;
  MyApp(this.surahList);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Quran Pro',
      // if surahList is empty, return to Preparing data, if not empty return to main app
      home: surahList.isNotEmpty? AppMain(surahList) : PreParingData(),
    );
  }
}