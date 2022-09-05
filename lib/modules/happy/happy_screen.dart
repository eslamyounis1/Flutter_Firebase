import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HappyScreen extends StatefulWidget {
  const HappyScreen({Key? key}) : super(key: key);

  @override
  State<HappyScreen> createState() => _HappyScreenState();
}

class _HappyScreenState extends State<HappyScreen> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Happy Happy!'),
      ),
      body: Center(
        child: MaterialButton(
          onPressed: ()async{
            // FirebaseAnalytics firebaseAnalytics = FirebaseAnalytics.instance;
           await FirebaseAnalytics.instance.logEvent(name: 'Happy',parameters: null);
          },
          child: const Text('I\'m happy!'),
        ),
      ),
    );
  }
}
