import 'package:flutter/material.dart';
import 'core/presentation/theme/app_theme.dart';
import 'core/routing/app_go_router.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'TLU Support - Đăng nhập',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      routerConfig: AppGoRouter.router,
    );
  }
}
