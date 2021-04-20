import 'package:flutter/material.dart';
import 'package:quran_pro/surah_detail.dart';
import 'package:quran_pro/surahhelper.dart';

class SurahPage extends StatelessWidget {
  final List<Surah> _surahList;
  SurahPage(this._surahList);

  @override
  Widget build(BuildContext context) {
    return Ink(
      color: Color(0xFFF8F8F8),
      child: ListView.separated(
        itemCount: _surahList.length,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              print(_surahList[index].number!);
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context)=> SurahDetail(surahList: _surahList, surahNumber: _surahList[index].number!, surahState: 0,))
              );
            },
            child: Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, top: 18, bottom: 18),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                  color: Color(0xFF25BBA0), width: 2.0)),
                          child: Center(
                              child:
                                  Text("${_surahList[index].number}"))),
                      SizedBox(
                        width: 14,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("${_surahList[index].nameLatin}",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              )),
                          Text(
                              "${_surahList[index].translation!.name} - ${_surahList[index].numberOfAyah} ayat",
                              style: TextStyle(
                                fontSize: 11.0,
                              ))
                        ],
                      ),
                    ],
                  ),
                  Directionality(
                    textDirection: TextDirection.rtl,
                    child: Text(
                      "${_surahList[index].name}    ",
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
        separatorBuilder: (context, index) {
          return Divider(
            indent: 16.0,
            endIndent: 16.0,
          );
        },
      ),
    );
  }
}