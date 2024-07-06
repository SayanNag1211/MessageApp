import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:smsq/Services/GoogleLoginService/GoogleLog.dart';
import 'package:smsq/const/Theme.dart';

class Loginscreen extends StatelessWidget {
  const Loginscreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: SizedBox(
                    // color: Colors.red,
                    height: 560,
                    width: 540,
                    child: Image.asset('assets/ani/logbg.png'))
                .animate(delay: .5000.seconds)
                .fade(duration: 1500.ms)
                .slideX(),
          ),
          const SizedBox(height: 5),
          Text(
            'Connect instantly with friends and family on our seamless chat app.',
            style: TextTh.logsubstyle,
          ), //.animate(delay: .5100.seconds).fade(duration: 2000.ms).scaleX(),
          const SizedBox(
            height: 14,
          ),
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                LoginGoogle.signInWithGoogle(context: context);
              },
              child: Container(
                width: 360,
                height: 50,
                decoration: BoxDecoration(
                  // color: const Color(0xff6C63FF),
                  color: const Color(0xff25292e),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Center(
                  child: Image.asset(
                    'assets/ani/G.png',
                    height: 28,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
