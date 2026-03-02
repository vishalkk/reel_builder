/*
TODO:
import firebase options based on the app flavor
 */


// import 'package:firebase_core/firebase_core.dart';

// import 'package:mobile/firebase_options.dart' as prod;
// import 'package:mobile/firebase_options_uat.dart' as stg;
// import 'package:mobile/firebase_options_dev.dart' as dev;
// import 'package:mobile/flavors.dart';

// Future<void> initializeFirebaseApp(Flavor? appFlavor) async {
//   final FirebaseOptions firebaseOptions;

//   // Determine which Firebase options to use based on the flavor
//   if (appFlavor == Flavor.prod) {
//     firebaseOptions = prod.DefaultFirebaseOptions.currentPlatform;
//   } else if (appFlavor == Flavor.uat) {
//     firebaseOptions = stg.DefaultFirebaseOptions.currentPlatform;
//   } else if (appFlavor == Flavor.dev) {
//     firebaseOptions = dev.DefaultFirebaseOptions.currentPlatform;
//   } else {
//     throw UnsupportedError('Invalid flavor: $appFlavor');
//   }
//   await Firebase.initializeApp(options: firebaseOptions);
// }
