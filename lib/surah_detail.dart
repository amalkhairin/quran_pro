// @dart=2.9
import 'dart:async';

import 'package:arabic_numbers/arabic_numbers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:quran_pro/share_instagram_dialog.dart';
import 'package:quran_pro/surahhelper.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:social_share/social_share.dart';
import 'package:hive_flutter/hive_flutter.dart';


  //surahList must be not null.
  //surah Number must be not null.
  //ayah number default value is 0.
class SurahDetail extends StatefulWidget {
  final List<Surah> surahList;
  final int surahNumber;
  final int surahState;
  SurahDetail({@required this.surahList, this.surahState, @required this.surahNumber});
  @override
  _SurahDetailState createState() => _SurahDetailState();
}

class _SurahDetailState extends State<SurahDetail> {
  ScrollController _scrollController;
  ItemScrollController _itemScrollController = ItemScrollController();
  ItemPositionsListener _itemPositionsListener = ItemPositionsListener.create();

  int _surahNumber;
  ArabicNumbers _arabicNumbers = ArabicNumbers();
  int _pos = 0;


  _nextSurah(int _number){
    setState(() {
      _surahNumber = _number;
    });
  }

  _prevSurah(int _number){
    setState(() {
      _surahNumber = _number;
    });
  }

  _saveSurahState(String name, int number, int position) async {
    var surahStateBox = await Hive.openBox("SurahState");
    await surahStateBox.put("surahName", name);
    await surahStateBox.put("ayahPosition", position);
    await surahStateBox.put("surahNumber", number);
  }

  toLatestPosition(){
    if(_itemScrollController.isAttached){
      _itemScrollController.jumpTo(index: _pos, alignment: 0);
    } else {
      Timer(Duration(milliseconds: 400), ()=> toLatestPosition());
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _scrollController = ScrollController();
    _surahNumber = widget.surahNumber;
    _saveSurahState(widget.surahList[widget.surahNumber-1].nameLatin, widget.surahNumber, widget.surahState);
    _pos = widget.surahState;
  }

  @override
  Widget build(BuildContext context) {
    // go to the latest position when the widget is build
    WidgetsBinding.instance.addPostFrameCallback((_)=> toLatestPosition());

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: 80,
                color: Color(0xFF25BBA0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _surahNumber > 1
                        ? IconButton(
                            icon: Icon(Icons.navigate_before, color: Colors.white, size: 36.0),
                            onPressed: () async {
                              _prevSurah(_surahNumber-1);
                              setState(() {
                                _pos = 0;
                              });
                              _itemScrollController.jumpTo(index: 0,);
                              // reset surah state to 0
                              _saveSurahState(widget.surahList[_surahNumber-1].nameLatin, _surahNumber,0);
                              
                            },
                          )
                        : SizedBox(width: 36.0,),
                        SizedBox(width: 24.0,),
                        Text("${widget.surahList[_surahNumber-1].nameLatin}", style: TextStyle(color: Colors.white, fontSize: 18)),
                        SizedBox(width: 24.0,),
                        _surahNumber < 114 
                        ? IconButton(
                            icon: Icon(Icons.navigate_next, color: Colors.white, size: 36.0),
                            onPressed: ()async {
                              _nextSurah(_surahNumber+1);
                              setState(() {
                                _pos = 0;
                              });
                              _itemScrollController.jumpTo(index: 0,);
                              // reset surah state to 0
                              _saveSurahState(widget.surahList[_surahNumber-1].nameLatin, _surahNumber,0);
                            },
                          )
                        : SizedBox(width: 36.0,),
                      ],
                    ),
                    Text("${widget.surahList[_surahNumber-1].translation.name} - ${widget.surahList[_surahNumber - 1].numberOfAyah} ayat", style: TextStyle(color: Colors.white)),
                    SizedBox(height: 10.0,),
                  ],
                ),
              ),
              Flexible(
                child: Ink(
                  child: ValueListenableBuilder(
                    valueListenable: Hive.box("surahBookmarkList").listenable(),
                    builder: (context, Box box, _widget) {
                      // check if the box is not empty
                      List<dynamic> _listBookmark = [];
                      if(box.isNotEmpty){
                        _listBookmark = box.getAt(0);
                      }
                      // add all of marked ayah in this surah to _surahbookmark list
                      List<SurahBookMark> _surahBookmark = [];
                      for (var item in _listBookmark){
                        if(item.number == _surahNumber){
                          _surahBookmark.add(item);
                        }
                      }
                      // notification listener to detect scroll update
                      return NotificationListener<ScrollUpdateNotification>(
                        onNotification: (t){
                          // get the minimum index of item in current view in listview
                          var min = _itemPositionsListener.itemPositions.value
                                .where((ItemPosition position) => position.itemTrailingEdge > 0)
                                .reduce((ItemPosition min, ItemPosition position) =>
                                    position.itemTrailingEdge < min.itemTrailingEdge
                                        ? position
                                        : min)
                                .index;
                          // save the position of minimum index
                          _saveSurahState(widget.surahList[_surahNumber-1].nameLatin, _surahNumber,min);
                          return true;
                        },
                        child: ScrollablePositionedList.builder(
                          physics: BouncingScrollPhysics(),
                          itemScrollController: _itemScrollController,
                          itemPositionsListener: _itemPositionsListener,
                          itemCount: widget.surahList[_surahNumber-1].text.length,
                          itemBuilder: (context, index){
                            // check if the current ayah is marked
                            bool _isMarked = false;
                            for (var item in _surahBookmark){
                              if(item.ayahNumber == index+1){
                                _isMarked = true;
                              }
                            }
                            return Stack(
                              children: [
                                RepaintBoundary(
                                  key: GlobalObjectKey(index.toString()),
                                  child: InkWell(
                                    onLongPress: (){
                                      print("long pressed");
                                      showDialog(
                                        context: context,
                                        builder: (context){
                                          return SimpleDialog(
                                            title: Text("Pilih Opsi"),
                                            children: [
                                              !_isMarked
                                              ? SimpleDialogOption(
                                                  onPressed: () async {
                                                    Box _tempBox = Hive.box("surahBookmarkList");
                                                    // check if the box is not empty
                                                    List<dynamic> _tempList = [];
                                                    if(_tempBox.isNotEmpty){
                                                      _tempList = _tempBox.getAt(0);
                                                    }

                                                    SurahBookMark _bookmark = SurahBookMark(
                                                      name: widget.surahList[_surahNumber-1].name,
                                                      nameLatin: widget.surahList[_surahNumber-1].nameLatin,
                                                      ayahNumber: index+1,
                                                      number: _surahNumber,
                                                      text: widget.surahList[_surahNumber-1].text[index].ayah,
                                                      translate: widget.surahList[_surahNumber-1].translation.text[index].text
                                                    );

                                                    // save this current ayah to the bookmark box
                                                    _tempList.add(_bookmark);
                                                    if(_tempBox.isEmpty){
                                                      _tempBox.add(_tempList);
                                                    } else {
                                                      _tempBox.putAt(0, _tempList);
                                                    }

                                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Disimpan ke bookmark")));
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: Row(
                                                    children: [
                                                      Icon(Icons.bookmark, color: Color(0xFF25BBA0),),
                                                      SizedBox(width: 10,),
                                                      Text("Simpan ke bookmark", style: TextStyle(color: Color(0xFF25BBA0), fontWeight: FontWeight.w600),)
                                                    ],
                                                  ),
                                                )
                                              : SimpleDialogOption(
                                                  onPressed: () async {
                                                    Box _tempBox = Hive.box("surahBookmarkList");
                                                    // check if the box is exist
                                                    List<dynamic> _tempList = [];
                                                    if(_tempBox.isNotEmpty){
                                                      _tempList = _tempBox.getAt(0);
                                                    }
                                                    
                                                    // remove this ayah from bookmark
                                                    for (var i = 0; i < _tempList.length; i++) {
                                                      if(_tempList[i].number == _surahNumber){
                                                        if(_tempList[i].ayahNumber == index+1){
                                                          _tempList.removeAt(i);
                                                        }
                                                      }
                                                    }

                                                    // save this current ayah to the bookmark box
                                                    if(_tempBox.isEmpty){
                                                      _tempBox.add(_tempList);
                                                    } else {
                                                      _tempBox.putAt(0, _tempList);
                                                    }

                                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Dihapus dari bookmark")));
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: Row(
                                                    children: [
                                                      Icon(Icons.bookmark, color: Color(0xFF25BBA0),),
                                                      SizedBox(width: 10,),
                                                      Text("Hapus dari bookmark", style: TextStyle(color: Color(0xFF25BBA0), fontWeight: FontWeight.w600),)
                                                    ],
                                                  ),
                                                ),
                                              SimpleDialogOption(
                                                onPressed: (){
                                                  // copy to clipboard
                                                  Clipboard.setData(ClipboardData(text: "${widget.surahList[_surahNumber - 1].nameLatin} ($_surahNumber) ayat ${index + 1}:\n${widget.surahList[_surahNumber - 1].text[index].ayah}\n\n ${widget.surahList[_surahNumber - 1].translation.text[index].text}"));
                                                  Navigator.of(context).pop();
                                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Disalin ke clipboard")));
                                                },
                                                child: Row(
                                                  children: [
                                                    Icon(Icons.copy, color: Color(0xFF25BBA0),),
                                                    SizedBox(width: 10,),
                                                    Text("Salin ke clipboard", style: TextStyle(color: Color(0xFF25BBA0), fontWeight: FontWeight.w600),)
                                                  ],
                                                ),
                                              ),
                                              SimpleDialogOption(
                                                onPressed: (){
                                                  // show share option
                                                  SocialShare.shareOptions(
                                                    "${widget.surahList[_surahNumber - 1].nameLatin} ($_surahNumber) ayat ${index + 1}:\n${widget.surahList[_surahNumber - 1].text[index].ayah}\n\n ${widget.surahList[_surahNumber - 1].translation.text[index].text}\n\n#QuranPro #MariMembaca",
                                                  ).then((data){
                                                    print(data);
                                                  });
                                                  Navigator.of(context).pop();
                                                },
                                                child: Row(
                                                  children: [
                                                    Icon(Icons.share, color: Color(0xFF25BBA0),),
                                                    SizedBox(width: 10,),
                                                    Text("Bagikan", style: TextStyle(color: Color(0xFF25BBA0), fontWeight: FontWeight.w600),)
                                                  ],
                                                ),
                                              ),
                                              SimpleDialogOption(
                                                onPressed: () async {
                                                  // share to instagram story
                                                  Navigator.of(context).pop();
                                                  showDialog(
                                                    context: context,
                                                    builder: (context){
                                                      return ShareToInstagramDialog(
                                                        context: context,
                                                        surahName: widget.surahList[_surahNumber-1].nameLatin,
                                                        surahText: widget.surahList[_surahNumber - 1].text[index].ayah,
                                                        translateText: widget.surahList[_surahNumber - 1].translation.text[index].text,
                                                        ayahNumber: index+1,
                                                      );
                                                    }
                                                  );
                                                },
                                                child: Row(
                                                  children: [
                                                    Icon(Icons.share, color: Color(0xFF25BBA0),),
                                                    SizedBox(width: 10,),
                                                    Text("Bagikan ke Story", style: TextStyle(color: Color(0xFF25BBA0), fontWeight: FontWeight.w600),)
                                                  ],
                                                ),
                                              ),
                                            ],
                                          );
                                        }
                                      );
                                    },
                                    child: Container(
                                      color: Colors.white,
                                      child: Column(
                                        children: [
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
                                                  child: Center(child:Text("${_arabicNumbers.convert(index + 1)}", style: TextStyle(fontSize: 20, color: Colors.white),))
                                                ),
                                                SizedBox(width: 26,),
                                                Expanded(
                                                  child: Directionality(
                                                    textDirection: TextDirection.rtl,
                                                    child: Text(
                                                      "${widget.surahList[_surahNumber - 1].text[index].ayah}",
                                                      style: TextStyle(fontSize: 24, fontFamily: "LPMQIsepMisbah", height: 2.5),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            color: Color(0xFFF8F8F8),
                                            width: MediaQuery.of(context).size.width,
                                            padding: EdgeInsets.only(top: 16.0, bottom: 16.0),
                                            child: Padding(
                                              padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                                              child: Text("${widget.surahList[_surahNumber - 1].translation.text[index].text}"),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                _isMarked
                                ? Padding(
                                    padding: const EdgeInsets.only(top: 4, left: 22.0),
                                    child: Icon(Icons.bookmark, color: Color(0xFF25BBA0), size: 20,),
                                  )
                                : Container(),
                              ],
                            );
                          },
                        ),
                      );
                    }
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}