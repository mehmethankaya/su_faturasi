import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math' as math;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:telephony/telephony.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await KayitliBilgiler().createSharedPrefObject();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SU',
      theme: ThemeData(
        fontFamily: "yeniFont",
        primarySwatch: Colors.grey,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var maskFormatter = new MaskTextInputFormatter(
      mask: '(####) ### ## ##', filter: {"#": RegExp(r'[0-9]')});
  final Telephony telephony = Telephony.instance;
  TextEditingController _textEditingController1 = TextEditingController();
  TextEditingController _textEditingController2 = TextEditingController();
  TextEditingController _textEditingController3 = TextEditingController();
  TextEditingController _textEditingController4 = TextEditingController();
  TextEditingController _textEditingController5 = TextEditingController();

  //KayitliBilgiler bilgiIslem = KayitliBilgiler();
  int seciliAyNumarasi = 0;
  List<String> yilinAylari = [
    "Ocak",
    "Şubat",
    "Mart",
    "Nisan",
    "Mayıs",
    "Haziran",
    "Temmuz",
    "Agustos",
    "Eylül",
    "Ekim",
    "Kasım",
    "Aralık"
  ];
  List<String> kisilerinAdi = [
    "Şok Market",
    "Daire 3",
    "Daire 4",
    "Daire 5",
    "Daire 6",
    "Daire 7",
    "Daire 8",
    "Daire 9",
    "Daire 10"
  ];

  void initState() {
    super.initState();
    for (var i = 0; i < 9; i++) {
      KayitliBilgiler().saveValuetoSharedPref("10" + i.toString(), 12);
    }
    var now = new DateTime.now();
    var currentMon = now.month;
    seciliAyNumarasi = currentMon - 2;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                  flex: 6,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return Dialog(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            20.0)), //this right here
                                    child: Container(
                                      height: 250,
                                      child: Padding(
                                        padding: const EdgeInsets.all(12.0),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              yilinAylari[seciliAyNumarasi] +
                                                  " Faturası",
                                              style: TextStyle(fontSize: 20),
                                            ),
                                            TextField(
                                              controller:
                                                  _textEditingController2,
                                              keyboardType:
                                                  TextInputType.number,
                                              textAlign: TextAlign.center,
                                              decoration: InputDecoration(
                                                  border: InputBorder.none,
                                                  hintText: 'Tutar'),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      20, 0, 20, 0),
                                              child: Divider(
                                                height: 1,
                                              ),
                                            ),
                                            TextField(
                                              controller:
                                                  _textEditingController3,
                                              keyboardType:
                                                  TextInputType.number,
                                              textAlign: TextAlign.center,
                                              decoration: InputDecoration(
                                                  border: InputBorder.none,
                                                  hintText: 'Dükkan m³ Fiyatı'),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      20, 0, 20, 0),
                                              child: Divider(
                                                height: 1,
                                              ),
                                            ),
                                            TextField(
                                              controller:
                                                  _textEditingController5,
                                              keyboardType:
                                                  TextInputType.number,
                                              textAlign: TextAlign.center,
                                              decoration: InputDecoration(
                                                  border: InputBorder.none,
                                                  hintText: 'Aidat'),
                                            ),
                                            SizedBox(
                                              width: 320.0,
                                              child: RaisedButton(
                                                onPressed: () {
                                                  setState(() {
                                                    dynamic metrekup = 0;
                                                    int hepsiTammi = 0;
                                                    for (var i = 0;
                                                        i < 9;
                                                        i++) {
                                                      var var1 = KayitliBilgiler()
                                                          .loadValueFromSharedPref(
                                                              seciliAyNumarasi
                                                                  .toString(),
                                                              i.toString());
                                                      var var2 = KayitliBilgiler()
                                                          .loadValueFromSharedPref(
                                                              (seciliAyNumarasi -
                                                                      1)
                                                                  .toString(),
                                                              i.toString());
                                                      if (var1.runtimeType ==
                                                              int &&
                                                          var2.runtimeType ==
                                                              int) {
                                                        metrekup +=
                                                            (var1 - var2);
                                                        hepsiTammi++;
                                                      }
                                                    }
                                                    var toplamFatura =
                                                        KayitliBilgiler()
                                                            .loadValueFromSharedPref(
                                                                "fatura",
                                                                seciliAyNumarasi
                                                                    .toString());
                                                    var sokunKullanimi = KayitliBilgiler()
                                                            .loadValueFromSharedPref(
                                                                seciliAyNumarasi
                                                                    .toString(),
                                                                "0") -
                                                        KayitliBilgiler()
                                                            .loadValueFromSharedPref(
                                                                (seciliAyNumarasi -
                                                                        1)
                                                                    .toString(),
                                                                "0");
                                                    var sokunMetresi =
                                                        KayitliBilgiler()
                                                            .loadValueFromSharedPref(
                                                                "sok",
                                                                seciliAyNumarasi
                                                                    .toString());
                                                    if (toplamFatura != null &&
                                                        sokunKullanimi !=
                                                            null &&
                                                        sokunMetresi != null) {
                                                      KayitliBilgiler().saveValuetoSharedPrefDouble(
                                                          "metrekupbirim" +
                                                              seciliAyNumarasi
                                                                  .toString(),
                                                          (toplamFatura -
                                                                  (sokunKullanimi *
                                                                      sokunMetresi)) /
                                                              (metrekup -
                                                                  sokunKullanimi));
                                                    }
                                                  });
                                                  herYerdeKullan(
                                                      _textEditingController2
                                                              .text !=
                                                          "",
                                                      _textEditingController3
                                                              .text !=
                                                          "");
                                                  KayitliBilgiler()
                                                      .saveValuetoSharedPrefAidat(
                                                          int.parse(
                                                              _textEditingController5
                                                                  .text));

                                                  Navigator.pop(context);
                                                  _textEditingController2.text =
                                                      "";
                                                  _textEditingController3.text =
                                                      "";
                                                  _textEditingController5.text =
                                                      "";
                                                },
                                                child: Text(
                                                  "Kaydet",
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                                color: const Color(0xFF1BC0C5),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                });
                          },
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(3, 0, 0, 0),
                            child: Icon(Icons.description_outlined),
                          )),
                      Text(
                        yilinAylari[seciliAyNumarasi],
                        style: TextStyle(
                          fontFamily: "yeniFont",
                          color: Colors.black,
                          fontSize: 25,
                        ),
                      ),
                      GestureDetector(
                          onTap: () {
                            setState(() {
                              dynamic metrekup = 0;
                              int hepsiTammi = 0;
                              for (var i = 0; i < 9; i++) {
                                var var1 = KayitliBilgiler()
                                    .loadValueFromSharedPref(
                                        seciliAyNumarasi.toString(),
                                        i.toString());
                                var var2 = KayitliBilgiler()
                                    .loadValueFromSharedPref(
                                        (seciliAyNumarasi - 1).toString(),
                                        i.toString());
                                if (var1.runtimeType == int &&
                                    var2.runtimeType == int) {
                                  metrekup += (var1 - var2);
                                  hepsiTammi++;
                                }
                              }
                              var toplamFatura = KayitliBilgiler()
                                  .loadValueFromSharedPref(
                                      "fatura", seciliAyNumarasi.toString());
                              var sokunKullanimi = KayitliBilgiler()
                                      .loadValueFromSharedPref(
                                          seciliAyNumarasi.toString(), "0") -
                                  KayitliBilgiler().loadValueFromSharedPref(
                                      (seciliAyNumarasi - 1).toString(), "0");
                              var sokunMetresi = KayitliBilgiler()
                                  .loadValueFromSharedPref(
                                      "sok", seciliAyNumarasi.toString());
                              if (toplamFatura != null &&
                                  sokunKullanimi != null &&
                                  sokunMetresi != null) {
                                KayitliBilgiler().saveValuetoSharedPrefDouble(
                                    "metrekupbirim" +
                                        seciliAyNumarasi.toString(),
                                    (toplamFatura -
                                            (sokunKullanimi * sokunMetresi)) /
                                        (metrekup - sokunKullanimi));
                              }

                              //print(metrekup - sokunKullanimi);
                              if (hepsiTammi == 9 &&
                                  KayitliBilgiler().loadValueFromSharedPref(
                                          "fatura",
                                          seciliAyNumarasi.toString()) !=
                                      null &&
                                  KayitliBilgiler().loadValueFromSharedPref(
                                          "sok", seciliAyNumarasi.toString()) !=
                                      null) {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return Dialog(
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                                20.0)), //this right here
                                        child: Container(
                                          height: 150,
                                          child: Padding(
                                            padding: const EdgeInsets.all(12.0),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Text(
                                                  yilinAylari[
                                                          seciliAyNumarasi] +
                                                      " Faturası",
                                                  style:
                                                      TextStyle(fontSize: 20),
                                                ),
                                                SizedBox(height: 10),
                                                Text(
                                                  "Gelen Fatura Tutarı: ${KayitliBilgiler().loadValueFromSharedPref("fatura", seciliAyNumarasi.toString())} TL",
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 10),
                                                  child: Divider(height: 10),
                                                ),
                                                Text(
                                                  "Toplanacak Tutar: ${toplanacakTutarGosterici(seciliAyNumarasi)} TL",
                                                ),
                                                SizedBox(
                                                  width: 320.0,
                                                  child: RaisedButton(
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                    child: Text(
                                                      "Kapat",
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    ),
                                                    color:
                                                        const Color(0xFF1BC0C5),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    });
                              } else {
                                Fluttertoast.showToast(
                                    msg: "Eksik giriş yaptınız",
                                    fontSize: 15,
                                    gravity: ToastGravity.BOTTOM,
                                    backgroundColor:
                                        Colors.black.withOpacity(0.3),
                                    textColor: Colors.white);
                              }
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 3, 0),
                            child: Icon(Icons.calculate_outlined),
                          )),
                    ],
                  )),
              Expanded(
                  flex: 90,
                  child: ListView.builder(
                    itemCount: 9,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.all(4.0),
                        child: GestureDetector(
                          onTap: () {
                            if (index == 0) {
                              sokFirstDialog(context, index);
                            } else {
                              firstDialog(context, index);
                            }
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                gradient: LinearGradient(colors: [
                                  Color(0xFF1BC0C5),
                                  Color(0xFF1BC0C5).withOpacity(0.5),
                                ]),
                                borderRadius: BorderRadius.circular(5)),
                            height: 90,
                            width: double.infinity,
                            child: Row(children: [
                              Expanded(
                                flex: 10,
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(3, 0, 0, 0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        kisilerinAdi[index],
                                        style: TextStyle(
                                            fontFamily: "yeniFontBold",
                                            color: Colors.white,
                                            fontSize: 25),
                                      ),
                                      Text(
                                        "Geçen Ay Okunan: ${KayitliBilgiler().loadValueFromSharedPref((seciliAyNumarasi - 1).toString(), index.toString())} m³",
                                        style: TextStyle(
                                            color:
                                                Colors.white.withOpacity(0.8)),
                                      ),
                                      Text(
                                        "Bu Ay Okunan: ${KayitliBilgiler().loadValueFromSharedPref(seciliAyNumarasi.toString(), index.toString())} m³",
                                        style: TextStyle(
                                            color:
                                                Colors.white.withOpacity(0.8)),
                                      ),
                                      ayFarki(
                                          KayitliBilgiler()
                                              .loadValueFromSharedPref(
                                                  (seciliAyNumarasi - 1)
                                                      .toString(),
                                                  index.toString()),
                                          KayitliBilgiler()
                                              .loadValueFromSharedPref(
                                                  seciliAyNumarasi.toString(),
                                                  index.toString())),
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 5,
                                child: Container(
                                  height: 90,
                                  width: 141,
                                  child: Center(
                                    child: Text(
                                      bireyselFaturaGosterici(
                                          index, seciliAyNumarasi),
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: "yeniFontBold",
                                          fontSize: 25),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              )
                            ]),
                          ),
                        ),
                      );
                    },
                  )),
              Expanded(
                  flex: 10,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      IconButton(
                        iconSize: 18.0,
                        icon: Icon(Icons.arrow_back_ios_new),
                        onPressed: () {
                          setState(() {
                            if (seciliAyNumarasi != 0) {
                              seciliAyNumarasi--;
                            }
                          });
                        },
                      ),
                      TextButton.icon(
                        icon: Icon(Icons.send_rounded),
                        label: Text('Gönder'),
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return Dialog(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          20.0)), //this right here
                                  child: Container(
                                    height: 150,
                                    child: Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            "SMS gönder",
                                            style: TextStyle(fontSize: 20),
                                          ),
                                          Text(
                                            "SMS gönderimini onaylıyor musunuz?",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: 16,
                                            ),
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              SizedBox(
                                                width: 100.0,
                                                child: RaisedButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                    for (int i = 1; i < 9; i++)
                                                      topluMesajGonder(
                                                          telephony,
                                                          KayitliBilgiler()
                                                              .loadValueFromSharedPrefSonTutarlar(
                                                                  seciliAyNumarasi,
                                                                  i),
                                                          KayitliBilgiler()
                                                              .loadValueFromSharedPrefTelefonNumarasi(
                                                                  i),
                                                          KayitliBilgiler()
                                                              .loadValueFromSharedPrefAidat());
                                                  },
                                                  child: Text(
                                                    "Evet",
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                  color:
                                                      const Color(0xFF1FD537),
                                                ),
                                              ),
                                              SizedBox(
                                                width: 100.0,
                                                child: RaisedButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: Text(
                                                    "Hayır",
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                  color:
                                                      const Color(0xFFCC3300),
                                                ),
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              });
                        },
                      ),
                      Transform.rotate(
                        angle: 180 * math.pi / 180,
                        child: IconButton(
                          iconSize: 18.0,
                          icon: new Icon(Icons.arrow_back_ios_new),
                          onPressed: () {
                            setState(() {
                              if (seciliAyNumarasi != 11) {
                                seciliAyNumarasi++;
                              }
                            });
                          },
                        ),
                      ),
                    ],
                  ))
            ],
          ),
        ),
      ),
    );
  }

  Future<dynamic> firstDialog(BuildContext context, int index) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)), //this right here
            child: Container(
              height: 200,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      kisilerinAdi[index],
                      style: TextStyle(fontSize: 20),
                    ),
                    TextField(
                      controller: _textEditingController1,
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                          border: InputBorder.none, hintText: 'Son okuma'),
                    ),
                    TextField(
                      inputFormatters: [maskFormatter],
                      controller: _textEditingController4,
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Telefon Numarası'),
                    ),
                    SizedBox(
                      width: 320.0,
                      child: RaisedButton(
                        onPressed: () {
                          setState(() {
                            if (_textEditingController1.text.isNotEmpty &&
                                _textEditingController4.text.isEmpty) {
                              KayitliBilgiler().saveValuetoSharedPref(
                                  seciliAyNumarasi.toString() +
                                      index.toString(),
                                  int.parse(_textEditingController1.text));
                              Navigator.pop(context);

                              _textEditingController1.text = "";
                              _textEditingController4.text = "";
                            } else if (_textEditingController1
                                    .text.isNotEmpty &&
                                _textEditingController4.text.isNotEmpty) {
                              KayitliBilgiler().saveValuetoSharedPref(
                                  seciliAyNumarasi.toString() +
                                      index.toString(),
                                  int.parse(_textEditingController1.text));
                              KayitliBilgiler().saveValuetoSharedPrefString(
                                  "telefon" + index.toString(),
                                  "+9" + maskFormatter.getUnmaskedText());
                              _textEditingController1.text = "";
                              _textEditingController4.text = "";
                              Navigator.pop(context);
                            } else if (_textEditingController1.text.isEmpty &&
                                _textEditingController4.text.isNotEmpty) {
                              KayitliBilgiler().saveValuetoSharedPrefString(
                                  "telefon" + index.toString(),
                                  "+9" + maskFormatter.getUnmaskedText());
                              _textEditingController1.text = "";
                              _textEditingController4.text = "";
                              Navigator.pop(context);
                            } else {
                              Navigator.pop(context);
                            }
                          });
                        },
                        child: Text(
                          "Kaydet",
                          style: TextStyle(color: Colors.white),
                        ),
                        color: const Color(0xFF1BC0C5),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }

  Future<dynamic> sokFirstDialog(BuildContext context, int index) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)), //this right here
            child: Container(
              height: 150,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      kisilerinAdi[index],
                      style: TextStyle(fontSize: 20),
                    ),
                    TextField(
                      controller: _textEditingController1,
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                          border: InputBorder.none, hintText: 'Son okuma'),
                    ),
                    SizedBox(
                      width: 320.0,
                      child: RaisedButton(
                        onPressed: () {
                          setState(() {
                            KayitliBilgiler().saveValuetoSharedPref(
                                seciliAyNumarasi.toString() + index.toString(),
                                int.parse(_textEditingController1.text));
                            Navigator.pop(context);

                            _textEditingController1.text = "";
                          });
                        },
                        child: Text(
                          "Kaydet",
                          style: TextStyle(color: Colors.white),
                        ),
                        color: const Color(0xFF1BC0C5),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }

  void herYerdeKullan(bool birincisi, bool ikincisi) {
    return setState(() {
      if (birincisi && ikincisi) {
        KayitliBilgiler().saveValuetoSharedPref(
            "fatura" + seciliAyNumarasi.toString(),
            int.parse(_textEditingController2.text));

        KayitliBilgiler().saveValuetoSharedPref(
            "sok" + seciliAyNumarasi.toString(),
            int.parse(_textEditingController3.text));
      } else if (birincisi && ikincisi == false) {
        KayitliBilgiler().saveValuetoSharedPref(
            "fatura" + seciliAyNumarasi.toString(),
            int.parse(_textEditingController2.text));
      } else if (birincisi == false && ikincisi) {
        KayitliBilgiler().saveValuetoSharedPref(
            "sok" + seciliAyNumarasi.toString(),
            int.parse(_textEditingController3.text));
      }
    });
  }
}

class KayitliBilgiler {
  static SharedPreferences? _sharedPrefObject;
  Future<void> createSharedPrefObject() async {
    _sharedPrefObject = await SharedPreferences.getInstance();
  }

  void saveValuetoSharedPref(String key, int girilenSayi) {
    _sharedPrefObject?.setInt(key, girilenSayi);
  }

  void saveValuetoSharedPrefDouble(String key, double girilenSayi) {
    _sharedPrefObject?.setDouble(key, girilenSayi);
  }

  void saveValuetoSharedPrefString(String key, String telefonNumarasi) {
    _sharedPrefObject?.setString(key, telefonNumarasi);
  }

  void saveValuetoSharedPrefYuvarlanmisInt(String key, int fatura) {
    _sharedPrefObject?.setInt(key, fatura);
  }

  void saveValuetoSharedPrefYuvarlanmamisInt(String key, double fatura) {
    _sharedPrefObject?.setDouble(key, fatura);
  }

  loadValueFromSharedPref(String ayNumarasi, String index) {
    return _sharedPrefObject?.get(ayNumarasi + index);
  }

  loadValueFromSharedPrefAidat() {
    return _sharedPrefObject?.get("aidat");
  }

  void saveValuetoSharedPrefAidat(int aidat) {
    _sharedPrefObject?.setInt("aidat", aidat);
  }

  loadValueFromSharedPrefYeni(String index) {
    return _sharedPrefObject?.get("metrekupbirim" + index);
  }

  loadValueFromSharedPrefTelefonNumarasi(int index) {
    return _sharedPrefObject?.get("telefon" + index.toString());
  }

  loadValueFromSharedPrefSonTutarlar(int seciliAyNumarasi, int index) {
    return _sharedPrefObject
        ?.get(seciliAyNumarasi.toString() + "yuvarlanmis" + index.toString());
  }

  loadValueFromSharedPrefSokMarket(int seciliAyNumarasi) {
    return _sharedPrefObject?.get(seciliAyNumarasi.toString() + "sokmarket");
  }

  void saveValueFromSharedPrefSokMarket(int seciliAyNumarasi, int tutar) {
    _sharedPrefObject?.setInt(seciliAyNumarasi.toString() + "sokmarket", tutar);
  }
}

ayFarki(dynamic birincisayi, dynamic ikincisayi) {
  if (birincisayi != null && ikincisayi != null) {
    return Text(
      "Aylık Kullanım: " + (ikincisayi - birincisayi).toString() + " m³",
      style: TextStyle(color: Colors.white, fontFamily: "yeniFontBold"),
    );
  } else {
    return Text(
      "Sonuç yok",
      style: TextStyle(color: Colors.white, fontFamily: "yeniFontBold"),
    );
  }
}

ayFarkiYeni(dynamic birincisayi, dynamic ikincisayi) {
  if (birincisayi != null && ikincisayi != null) {
    return ikincisayi - birincisayi;
  } else {
    return "Sonuç yok";
  }
}

bireyselFaturaGosterici(int index, int seciliAyNumarasi) {
  int hepsiTammi = 0;
  for (var i = 0; i < 9; i++) {
    var var1 = KayitliBilgiler()
        .loadValueFromSharedPref(seciliAyNumarasi.toString(), i.toString());
    var var2 = KayitliBilgiler().loadValueFromSharedPref(
        (seciliAyNumarasi - 1).toString(), i.toString());
    if (var1.runtimeType == int && var2.runtimeType == int) {
      hepsiTammi++;
    }
  }
  if (hepsiTammi == 9 &&
      index != 0 &&
      KayitliBilgiler()
              .loadValueFromSharedPrefYeni(seciliAyNumarasi.toString()) !=
          null) {
    var kullanilacakDeger = (((((ayFarkiYeni(
                            KayitliBilgiler().loadValueFromSharedPref(
                                (seciliAyNumarasi - 1).toString(),
                                index.toString()),
                            KayitliBilgiler().loadValueFromSharedPref(
                                seciliAyNumarasi.toString(),
                                index.toString())) *
                        KayitliBilgiler().loadValueFromSharedPrefYeni(
                            seciliAyNumarasi.toString())) +
                    0.25) *
                2)
            .round()) /
        2);
    if (kullanilacakDeger == kullanilacakDeger.round()) {
      KayitliBilgiler().saveValuetoSharedPrefYuvarlanmisInt(
          seciliAyNumarasi.toString() + "yuvarlanmis" + index.toString(),
          kullanilacakDeger.round());
      return kullanilacakDeger.round().toString() + " TL";
    } else if (kullanilacakDeger != kullanilacakDeger.round()) {
      KayitliBilgiler().saveValuetoSharedPrefYuvarlanmamisInt(
          seciliAyNumarasi.toString() + "yuvarlanmis" + index.toString(),
          kullanilacakDeger);
      return kullanilacakDeger.toString() + " TL";
    }
  } else if (hepsiTammi == 9 &&
      index == 0 &&
      KayitliBilgiler()
              .loadValueFromSharedPref("sok", seciliAyNumarasi.toString()) !=
          null &&
      KayitliBilgiler()
              .loadValueFromSharedPrefYeni(seciliAyNumarasi.toString()) !=
          null) {
    KayitliBilgiler().saveValueFromSharedPrefSokMarket(
        seciliAyNumarasi,
        ((ayFarkiYeni(
                KayitliBilgiler().loadValueFromSharedPref(
                    (seciliAyNumarasi - 1).toString(), index.toString()),
                KayitliBilgiler().loadValueFromSharedPref(
                    seciliAyNumarasi.toString(), index.toString()))) *
            KayitliBilgiler()
                .loadValueFromSharedPref("sok", seciliAyNumarasi.toString())));
    return ((ayFarkiYeni(
                    KayitliBilgiler().loadValueFromSharedPref(
                        (seciliAyNumarasi - 1).toString(), index.toString()),
                    KayitliBilgiler().loadValueFromSharedPref(
                        seciliAyNumarasi.toString(), index.toString()))) *
                KayitliBilgiler().loadValueFromSharedPref(
                    "sok", seciliAyNumarasi.toString()))
            .toString() +
        " TL";
  } else {
    return "0 TL";
  }
}

mesajGonder(Telephony telephony) async {
  await telephony.sendSms(
      to: "+905347971518",
      message:
          "Merhaba Bahtiyar Bey. Bu ayki su faturanız 115 TL. İyi günler!");
}

topluMesajGonder(Telephony telephony, dynamic yuvarlatilmisSonuc,
    String telefonNumarasi, int aidat) async {
  await telephony.sendSms(
      to: telefonNumarasi,
      message: "İyi günler. Bu ayki su faturanız ve aidatınız toplam " +
          (yuvarlatilmisSonuc + aidat).toString() +
          " TL");
}

toplanacakTutarGosterici(
  int seciliAyNumarasi,
) {
  double toplanacaktutar = 0;
  for (int i = 1; i < 9; i++) {
    toplanacaktutar += KayitliBilgiler()
        .loadValueFromSharedPrefSonTutarlar(seciliAyNumarasi, i);
  }
  toplanacaktutar +=
      (KayitliBilgiler().loadValueFromSharedPrefSokMarket(seciliAyNumarasi));

  return toplanacaktutar;
}
