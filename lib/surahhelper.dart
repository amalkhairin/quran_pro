
import 'dart:convert';
import 'package:hive/hive.dart';
import 'package:flutter/services.dart';

part 'surahhelper.g.dart';

@HiveType(adapterName: "SurahAdapter", typeId: 0)
class Surah {
  @HiveField(0)
  int? number;
  @HiveField(1)
  String? name;
  @HiveField(2)
  String? nameLatin;
  @HiveField(3)
  int? numberOfAyah;
  @HiveField(4)
  List<SurahText>? text;
  @HiveField(5)
  SurahTranslation? translation;

  Surah({this.number, this.name, this.nameLatin, this.numberOfAyah, this.text, this.translation});
}

@HiveType(adapterName: "SurahTextAdapter", typeId: 1)
class SurahText {
  @HiveField(0)
  int? number;
  @HiveField(1)
  String? ayah;
  @HiveField(2)
  SurahText(this.number, this.ayah);
}

@HiveType(adapterName: "SurahTranslationAdapter", typeId: 2)
class SurahTranslation{
  @HiveField(0)
  String? name;
  @HiveField(1)
  List<SurahTranslationText>? text;
  SurahTranslation(this.name,this.text);
}

@HiveType(adapterName: "SurahTranslationTextAdapter", typeId: 3)
class SurahTranslationText{
  @HiveField(0)
  int? number;
  @HiveField(1)
  String? text;
  SurahTranslationText(this.number,this.text);
}

@HiveType(adapterName: "SurahBookmarkAdapter", typeId: 4)
class SurahBookMark {
  @HiveField(0)
  String? name;
  @HiveField(1)
  String? nameLatin;
  @HiveField(2)
  String? text;
  @HiveField(3)
  String? translate;
  @HiveField(4)
  int? number;
  @HiveField(5)
  int? ayahNumber;
  SurahBookMark({this.ayahNumber,this.name,this.nameLatin,this.number,this.text,this.translate});
}

class SurahHelper {
  Future<List<Surah>> toModel() async {

    List<Surah>? _surahList = <Surah>[];
    var _surahBox = await Hive.openBox("surahList");

    // load all json data to model
    for (var i = 1; i < 115; i++) {
      String data = await rootBundle.loadString("assets/json/surah/$i.json");
      var resJson = json.decode(data);
      var result = resJson["$i"];

      List<SurahText>? _surahText = <SurahText>[];
      List<SurahTranslationText> _surahTranslationText = <SurahTranslationText>[];
      int lengthOfSurah = int.parse(result["number_of_ayah"]);
      for (var i = 1; i < lengthOfSurah+1; i++) {
        _surahText.add(
          SurahText(i,result["text"]["$i"])
        );

        _surahTranslationText.add(
          SurahTranslationText(i, result["translations"]["id"]["text"]["$i"])
        );
      }
      Surah _surah = Surah(
          number: int.parse(result["number"]),
          name: result["name"],
          nameLatin: result["name_latin"],
          numberOfAyah: int.parse(result["number_of_ayah"]),
          text: _surahText,
          translation: SurahTranslation(result["translations"]["id"]["name"], _surahTranslationText),
        );

      // save loaded data to the box
      _surahBox.add(_surah);
      _surahList.add(_surah);
    }
    print("completed");
    
    return _surahList;
  }
}