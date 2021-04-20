// @dart=2.9
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:quran_pro/surah_detail.dart';
import 'package:quran_pro/surahhelper.dart';

class BookmarkPage extends StatefulWidget {
  final List<Surah> _surahList;
  BookmarkPage(this._surahList);
  @override
  _BookmarkPageState createState() => _BookmarkPageState();
}

class _BookmarkPageState extends State<BookmarkPage> {

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: Hive.box("surahBookmarkList").listenable(),
      builder: (context, Box box, _widget){
        // check if box is not empty
        List<dynamic> _surahMarkedList = [];
        if(box.isNotEmpty){
          _surahMarkedList = box.getAt(0);
        }
        if(_surahMarkedList.isNotEmpty){
          return Ink(
            color: Color(0xFFF8F8F8),
            child: ListView.separated(
              separatorBuilder: (context, index) {
                return Divider(
                  indent: 16.0,
                  endIndent: 16.0,
                );
              },
              itemCount: _surahMarkedList.length,
              itemBuilder: (context, index){
                return InkWell(
                  onTap: (){
                    Navigator.of(context).push(
                          MaterialPageRoute(builder: (context)=> SurahDetail(surahList: widget._surahList, surahNumber: _surahMarkedList[index].number, surahState: _surahMarkedList[index].ayahNumber-1,))
                        );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("${_surahMarkedList[index].nameLatin}", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600,)),
                            Text("ayat ${_surahMarkedList[index].ayahNumber}",style: TextStyle(fontSize: 12.0,))
                          ],
                        ),
                        Directionality(
                          textDirection: TextDirection.rtl,
                          child: Text(
                            "${_surahMarkedList[index].name}    ",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              fontFamily: "LPMQIsepMisbah",
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        } else {
          return Center(
            child: Text("Belum ada bookmark"),
          );
        }
      },
    );
  }
}