import 'package:cupcoffee/src/start_app/startapp.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'src/app.dart';

//todo: user ekle
//todo: para azalma mantığı ekle
//todo: sepetten çıkartma
//todo: favorilere ekleme
//todo: kupon kodu
//todo: türkçe ekle
//todo: hata yakalamaları yap

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await StartApp.startFirebase();
  await StartApp.setupLocator();

  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);

  runApp(MyApp());
}
