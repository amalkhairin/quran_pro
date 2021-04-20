import 'dart:async';

import 'package:flutter/material.dart';
import 'package:quran_pro/surahhelper.dart';
import 'package:quran_pro/app.dart';

class PreParingData extends StatefulWidget {
  @override
  _PreParingDataState createState() => _PreParingDataState();
}

class _PreParingDataState extends State<PreParingData> {
  List<Surah>? _surahList;
  Duration _duration = Duration(seconds: 2);

  loadSurah() async {
    List<Surah>? surahList;
    print("Preparing data...");
    surahList = await SurahHelper().toModel();
    setState(() {
      _surahList = surahList;
    });
    Timer(_duration, (){
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => AppMain(_surahList))
      );
    });
  }

  @override
    void initState() {
      // TODO: implement initState
      super.initState();
      loadSurah();
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _surahList == null
                ? Container(
                    width: MediaQuery.of(context).size.width/2,
                    child: LinearProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF25BBA0)), backgroundColor: Colors.grey[300],)
                  )
                : Icon(Icons.check_circle, color: Color(0xFF25BBA0), size: 60,),
              SizedBox(height: 25,),
              Flexible(child: Text("Mempersiapkan Aplikasi (No data usage)", style: TextStyle(fontWeight: FontWeight.w700),)),
              SizedBox(height: 8,),
              Text("Proses ini mungkin memerlukan beberapa menit"),
            ],
          ),
        ),
      ),
    );
  }
}