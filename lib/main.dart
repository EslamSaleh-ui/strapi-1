import 'package:flutter/material.dart';
import 'package:payment/screens/products_list.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp( const Splash());
}

class Splash extends StatefulWidget {
  const Splash({super.key});


  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  bool yes=false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    redirect();
  }

  redirect()async{await Future.delayed(const Duration(seconds: 5),(){yes=true; setState(() {}); });}

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: "UIStore",
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightGreenAccent),
          useMaterial3: true,
        ),
        home:yes?const Products_list(): Scaffold(body: Container(
          alignment: Alignment.center,
          height: double.infinity,
          width:double.infinity,
       child: Image.asset('assets/—Pngtree—fast shopping bag logo designs_5301634.png'))
        )
    );
  }
}
