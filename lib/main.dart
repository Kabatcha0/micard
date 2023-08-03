import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:micard/cubit/cubit.dart';
import 'package:micard/cubit/states.dart';
import 'package:micard/modules/splash.dart';
import 'package:micard/shared/local.dart';
import 'package:sizer/sizer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await CacheHelper.init();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeRight,
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.portraitDown,
    DeviceOrientation.portraitUp,
  ]);
  bool check = CacheHelper.getData(key: "dark") ?? false;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => MicardCubit(),
        child: BlocConsumer<MicardCubit, MicardStates>(
          builder: (context, state) => Sizer(
            builder: (context, orientation, deviceType) => const MaterialApp(
              title: "MiCard",
              debugShowCheckedModeBanner: false,
              home: Splash(),
            ),
          ),
          listener: (context, state) {},
        ));
  }
}
