import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layout/home_screen.dart';
import 'package:social_app/modules/login/login.dart';
import 'package:social_app/shared/bloc_observer.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/cubit/cubit.dart';
import 'shared/components/constants.dart';
import 'shared/network/local/cashe_helper.dart';
import 'shared/styles/themes.dart';

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // await Firebase.initializeApp();
  // print('Handling a background message: ${message.messageId}');
  
  print('a background message');
  print(message.data.toString());
  Toastt(message: 'a background message', state: ToastStates.SUCCESS);


}

void main() async {
  Widget widget;

  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = MyBlocObserver();
  await Firebase.initializeApp();
  var token = await FirebaseMessaging.instance.getToken();

  print(token);


  await CacheHelper.init();

  uId = CacheHelper.getData(key: 'uId');

  if (uId != null) {
    widget = HomeScreen();
  } else {
    widget = LoginScreen();
  }

  runApp(MyApp(startWidget: widget));
}

class MyApp extends StatelessWidget {
  MyApp({super.key, required this.startWidget});

  final Widget startWidget;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AppCubit()..getUserData()..getPosts(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: lightMode,
        home: startWidget,
      ),
    );
  }
}
