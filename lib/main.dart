import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'app.dart';
import 'core/config/firebase_env.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  try {
    await Firebase.initializeApp(
      options: FirebaseOptions(
        apiKey: FirebaseEnv.apiKey,
        appId: FirebaseEnv.appId,
        messagingSenderId: FirebaseEnv.messagingSenderId,
        projectId: FirebaseEnv.projectId,
        authDomain: FirebaseEnv.authDomain,
        storageBucket: FirebaseEnv.storageBucket,
        measurementId: FirebaseEnv.measurementId,
      ),
    );
  } catch (e) {
    if (e.toString().contains('duplicate-app')) {
      // Firebase đã được khởi tạo, không cần làm gì thêm
    } else {
      rethrow; // Ném lại lỗi nếu không phải lỗi duplicate-app
    }
  }
  
  runApp(const MyApp());
}
