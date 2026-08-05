import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../logic/core/colors_manager.dart';
import '../../logic/core/txt_style.dart';

// 1. قاعدة بيانات الأذكار
class AzkarData {
  static const List<Map<String, dynamic>> morningAzkar = [
    {"text": "أَصْبَحْنَا وَأَصْبَحَ الْمُلْكُ لِلَّهِ، وَالْحَمْدُ لِلَّهِ رَبِّ الْعَالَمِينَ", "count": 1},
    {"text": "اللَّهُمَّ بِكَ أَصْبَحْنَا وَبِكَ أَمْسَيْنَا، وَبِكَ نَحْيَا وَبِكَ نَمُوتُ وَإِلَيْكَ الْمَصِيرُ", "count": 1},
    {"text": "سُبْحَانَ اللَّهِ وَبِحَمْدِهِ", "count": 100},
    {"text": "لاَ إِلَهَ إِلاَّ اللَّهُ وَحْدَهُ لاَ شَرِيكَ لَهُ، لَهُ الْمُلْكُ وَلَهُ الْحَمْدُ وَهُوَ عَلَى كُلِّ شَيْءٍ قَدِيرٌ", "count": 1},
    {"text": "أَعُوذُ بِاللَّهِ مِنْ الشَّيْطَانِ الرَّجِيمِ", "count": 3},
  ];

  static const List<Map<String, dynamic>> eveningAzkar = [
    {"text": "أَمْسَيْنَا وَأَمْسَى الْمُلْكُ لِلَّهِ، وَالْحَمْدُ لِلَّهِ رَبِّ الْعَالَمِينَ", "count": 1},
    {"text": "اللَّهُمَّ بِكَ أَمْسَيْنَا وَبِكَ أَصْبَحْنَا، وَبِكَ نَحْيَا وَبِكَ نَمُوتُ وَإِلَيْكَ الْمَصِيرُ", "count": 1},
    {"text": "سُبْحَانَ اللَّهِ وَبِحَمْدِهِ", "count": 100},
    {"text": "أَعُوذُ بِكَلِمَاتِ اللَّهِ التَّامَّاتِ مِنْ شَرِّ مَا خَلَقَ", "count": 3},
    {"text": "اللَّهُمَّ صَلِّ عَلَى مُحَمَّدٍ وَعَلَى آلِ مُحَمَّدٍ", "count": 10},
  ];

  static List<Map<String, dynamic>> getCurrentAzkar() {
    final now = DateTime.now();
    final hour = now.hour;
    if (hour >= 5 && hour < 18) {
      return morningAzkar;
    } else {
      return eveningAzkar;
    }
  }
}

class TasbeehScreen extends StatefulWidget {
  const TasbeehScreen({super.key});

  @override
  State<TasbeehScreen> createState() => _TasbeehScreenState();
}

class _TasbeehScreenState extends State<TasbeehScreen> {
  List<Map<String, dynamic>> _azkarList = [];
  int _currentIndex = 0;
  int _counter = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _azkarList = AzkarData.getCurrentAzkar();

    int savedIndex = prefs.getInt("current_index") ?? 0;
    if (savedIndex < _azkarList.length) {
      _currentIndex = savedIndex;
    } else {
      _currentIndex = 0;
      await prefs.setInt("current_index", 0);
    }
    _counter = prefs.getInt("current_counter") ?? 0;

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _saveState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt("current_index", _currentIndex);
    await prefs.setInt("current_counter", _counter);
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
    _saveState();

    int requiredCount = _azkarList[_currentIndex]['count'];
    if (_counter >= requiredCount) {
      _moveToNextZikr();
    }
  }

  void _moveToNextZikr() {
    setState(() {
      if (_currentIndex < _azkarList.length - 1) {
        _currentIndex++;
        _counter = 0;
      } else {
        _showCompletionDialog();
        _currentIndex = 0;
        _counter = 0;
      }
    });
    _saveState();
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: ColorsManager.lightBeige,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("أحسنت!", style: TextStyle(color: ColorsManager.primaryColor, fontWeight: FontWeight.bold)),
        content: const Text("لقد أنهيت جميع أذكار هذا الوقت، بارك الله فيك وثبتك."),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {});
            },
            child: const Text("ابدأ من جديد", style: TextStyle(color: ColorsManager.primaryColor, fontWeight: FontWeight.bold)),
          )
        ],
      ),
    );
  }

  void _resetCurrentZikr() {
    setState(() {
      _counter = 0;
    });
    _saveState();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: ColorsManager.lightBeige,
        body: Center(child: CircularProgressIndicator(color: ColorsManager.primaryColor)),
      );
    }

    final currentZikr = _azkarList[_currentIndex];
    final requiredCount = currentZikr['count'];
    final text = currentZikr['text'];
    final progress = _counter / requiredCount;

    return Scaffold(
      backgroundColor: ColorsManager.lightBeige,
      body: Stack(
        children: [
          //layer 1 background----------------------------------------------Ly1
          Container(
            height: 250,
            color: ColorsManager.primaryColor,
          ),
          Padding(
            padding:  EdgeInsets.only(top: 640),
            child: Divider(
              color: ColorsManager.primaryColor,
              thickness: 30,
            ),
          ),
          //layer 2 counter & rest button ----------------------------------LY2
          Padding(
            padding:  EdgeInsets.only(top: 600),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 10,
              children: [
                InkWell(
                  onTap: () {
                    _incrementCounter();
                  },
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  child: Container(
                    height: 90,
                    width: 90,
                    decoration: BoxDecoration(
                      color: ColorsManager.primaryColor,
                      borderRadius: BorderRadius.circular(55),
                      border: Border.all(color: ColorsManager.lightBeige),
                    ),
                    child: Icon(Icons.add, size: 70, color: ColorsManager.lightBeige),
                  ),
                ),
                InkWell(
                  onTap: () {
                    _resetCurrentZikr();
                  },
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  child: Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      color: ColorsManager.primaryColor,
                      borderRadius: BorderRadius.circular(55),
                      border: Border.all(color: ColorsManager.lightBeige),
                    ),
                    child: Icon(Icons.refresh_sharp, size: 30, color: ColorsManager.lightBeige),
                  ),
                ),
              ],
            ),
          ),
          //layer3 divider -------------------------------------------------LY3
          Padding(
            padding: const EdgeInsets.only(top: 230),
            child: Divider(),
          ),
          // (جديد) شريط التقدم أسفل الـ Divider مباشرة
          Padding(
            padding: const EdgeInsets.only(top: 235),
            child: LinearProgressIndicator(
              value: progress > 1 ? 1 : progress,
              backgroundColor: ColorsManager.lightBeige.withOpacity(0.5),
              color: ColorsManager.primaryColor,
              minHeight: 8,
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: 60,
                ),
                //Search Bar -------------------------------------- SEC1
                Center(
                  child: Container(
                    height: 45,
                    width: 340,
                    decoration: BoxDecoration(
                      color: ColorsManager.darkPlum,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(vertical: 14),
                                border: InputBorder.none,
                                hintText: "Islamic Words",
                                hintStyle: TxtStyle.font300Size14SoftLightBeige,
                                prefixIcon: Icon(Icons.search_outlined, color: ColorsManager.lightBeige, size: 30),
                              ),
                              cursorColor: ColorsManager.lightBeige,
                              style: TxtStyle.font600Size16LightBeige,
                            ),
                          ),
                          Container(
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                              color: ColorsManager.lightBeige,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(Icons.filter_list, color: ColorsManager.primaryColor, size: 27),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                // تم إعادة الصورة تحت الـ Search Bar كما طلبت
                SizedBox(
                  height: 100,
                  width: 400,
                  child: Image.asset("assets/images/zekr_image.png"),
                ),

                // العداد الدائري
                Container(
                  height: 110,
                  width: 110,
                  decoration: BoxDecoration(
                    color: ColorsManager.primaryColor,
                    borderRadius: BorderRadius.circular(55),
                    border: Border.all(color: ColorsManager.lightBeige),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _counter.toString(),
                          style: TxtStyle.font700Size40LightBeige,
                        ),
                        Text(
                          "/ $requiredCount",
                          style: TxtStyle.font600Size16LightBeige.copyWith(fontSize: 12, color: ColorsManager.softLightBeige),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 300,
                  width: 400,
                  child: Center(
                    child: SingleChildScrollView(
                      child: Text(
                        text,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 35,
                          fontWeight: FontWeight.w600,
                          color: ColorsManager.primaryColor,
                          height: 1.5,
                          fontFamily: 'Arial',
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}