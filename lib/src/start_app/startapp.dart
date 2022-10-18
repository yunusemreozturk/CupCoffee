import 'package:cupcoffee/src/repository/firestore_repository.dart';
import 'package:cupcoffee/src/viewmodel/firestore_viewmodel.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';

import '../../firebase_options.dart';
import '../service/firestore_service.dart';

class StartApp {
  static startFirebase() async {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
  }

  static setupLocator() {
    Get.lazyPut(() => FirestoreService(), fenix: true);
    Get.lazyPut(() => FirestoreRepository(), fenix: true);
    Get.lazyPut(() => FirestoreViewModel(), fenix: true);
  }
}
