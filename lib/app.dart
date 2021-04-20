import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:quran_pro/bookmark_page.dart';
import 'package:quran_pro/surah_detail.dart';
import 'package:quran_pro/surahhelper.dart';
import 'package:quran_pro/surah_page.dart';
import 'package:hive_flutter/hive_flutter.dart';


class AppMain extends StatefulWidget {
  final List<Surah>? surahList;
  AppMain(this.surahList);
  @override
  _AppMainState createState() => _AppMainState();
}

class _AppMainState extends State<AppMain> with TickerProviderStateMixin{
  // TabController? _bottomTabController;
  TabController? _tabController;
  List<Surah> _surahList = <Surah>[];

  @override
    void initState() {
      // TODO: implement initState
      _tabController = TabController(length: 2, vsync: this);
      // _bottomTabController = TabController(length: 3, vsync: this);
      super.initState();
      _surahList = widget.surahList!;
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // bottomNavigationBar: Material(
      //   color: Colors.white,
      //   child: TabBar(
      //     controller: _bottomTabController,
      //     indicatorColor: Color(0xFF25BBA0),
      //     indicator: CustomTabIndicator(),
      //     labelColor: Colors.white,
      //     unselectedLabelColor: Colors.black38,
      //     isScrollable: false,
      //     tabs: [
      //       Tab(
      //         icon: Icon(Icons.auto_stories),
      //       ),
      //       Tab(
      //         icon: Icon(Icons.access_time),
      //       ),
      //       Tab(
      //         icon: Icon(Icons.explore),
      //       ),
      //     ],
      //   ),
      // ),
      body: SafeArea( //tabbarview here
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 16.0, top: 10.0),
              child: Text("Quran Pro", style: TextStyle(fontSize: 32.0, fontWeight: FontWeight.bold, color: Color(0xFF25BBA0)),),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: Text("Al-Quran dan Terjemahan", style: TextStyle(fontSize: 12.0),),
            ),
            ValueListenableBuilder(
              valueListenable: Hive.box('SurahState').listenable(),
              builder:(context, box, widget) {
                var stateBox = Hive.box("SurahState");
                if(stateBox.get("surahName") == null){
                  return Container();
                } else {
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: InkWell(
                      onTap: (){
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (context)=> SurahDetail(surahList: _surahList, surahNumber: stateBox.get("surahNumber"), surahState: stateBox.get("ayahPosition"),))
                        );
                      },
                      child: Card(
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                        child: Ink(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(colors: [Color(0xFF17D7B4), Color(0xFF60F193)]),
                            borderRadius: BorderRadius.all(Radius.circular(10.0))
                          ),
                          child: Stack(
                            children: [
                              Positioned(
                                right: 0,
                                child: Container(
                                  height: 120,
                                  width: 200,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: AssetImage("assets/img/quran.png"),
                                      alignment: Alignment.topCenter,
                                      fit: BoxFit.cover,
                                    ),
                                    borderRadius: BorderRadius.all(Radius.circular(10.0))
                                  ),
                                ),
                              ),
                              Container(
                                height: 120,
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [Color(0xFF17D7B4), Color(0xFF60F193).withOpacity(0.1)]
                                  ),
                                  borderRadius: BorderRadius.all(Radius.circular(10.0))
                                ),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width,
                                height: 120,
                                child: Padding(
                                  padding: const EdgeInsets.all(14.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text("Bacaan terakhir", style: TextStyle(color: Colors.white),),
                                      SizedBox(height: 20,),
                                      Text("${stateBox.get("surahName")}", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),),
                                      SizedBox(height: 8,),
                                      Text("Lanjutkan membaca", style: TextStyle(color: Colors.white)),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }
              } 
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: TabBar(
                controller: _tabController,
                indicatorColor: Color(0xFF25BBA0),
                labelColor: Color(0xFF25BBA0),
                unselectedLabelColor: Colors.black54,
                isScrollable: true,
                tabs: [
                  Tab(
                    text: "Surah",
                  ),
                  Tab(
                    text: "Bookmark",
                  ),
                ],
              ),
            ),
            Flexible(
              child: TabBarView(
                controller: _tabController, 
                children: [
                  SurahPage(widget.surahList!),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 200,
                    color: Color(0xFFF8F8F8),
                    child: BookmarkPage(widget.surahList!)
                  ),
                ]
              ),
            ),
          ],
        ),
      ),
    );
  }
}