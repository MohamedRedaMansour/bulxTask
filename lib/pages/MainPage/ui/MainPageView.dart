import 'dart:math';

import 'package:bulx/components/TextWidget.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:share_plus/share_plus.dart';

class MainPageView extends StatefulWidget {
  const MainPageView({Key? key}) : super(key: key);

  @override
  State<MainPageView> createState() => _MainPageViewState();
}

class _MainPageViewState extends State<MainPageView> with SingleTickerProviderStateMixin {
  AnimationController? _animationController;
  Animation? animation;
  late ConfettiController _controllerBottomCenter;

  @override
  void initState() {
    super.initState();
    _controllerBottomCenter =
        ConfettiController(duration: const Duration(seconds: 2));
    _animationController = AnimationController(
      duration: const Duration(seconds: 3),
        vsync: this);
    animation = Tween<double>(begin: 0.00 ,end: 200.00).animate(_animationController!);
    _animationController?.addListener(() {
      setState(() {
        debugPrint(animation?.value.toString());
        if(animation?.value == 200.0){
          _controllerBottomCenter.play();
          Future.delayed(const Duration(seconds: 2), () {
            _controllerBottomCenter.stop();
          });
        _animationController?.stop();

        }
      });
    });
    _animationController?.forward();
  }

  Path drawStar(Size size) {
    // Method to convert degree to radians
    double degToRad(double deg) => deg * (pi / 180.0);

    const numberOfPoints = 5;
    final halfWidth = size.width / 2;
    final externalRadius = halfWidth;
    final internalRadius = halfWidth / 2.5;
    final degreesPerStep = degToRad(360 / numberOfPoints);
    final halfDegreesPerStep = degreesPerStep / 2;
    final path = Path();
    final fullAngle = degToRad(360);
    path.moveTo(size.width, halfWidth);

    for (double step = 0; step < fullAngle; step += degreesPerStep) {
      path.lineTo(halfWidth + externalRadius * cos(step),
          halfWidth + externalRadius * sin(step));
      path.lineTo(halfWidth + internalRadius * cos(step + halfDegreesPerStep),
          halfWidth + internalRadius * sin(step + halfDegreesPerStep));
    }
    path.close();
    return path;
  }

  @override
  void dispose() {
    _animationController?.dispose();
    _controllerBottomCenter.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 18.h),
        child: Column(
          children: [
            SafeArea(
              child: Padding(
                padding: EdgeInsets.only(top: 8.0.h,bottom: 8.0.h),
                child: Center(
                  child: SvgPicture.asset(
                      'assets/logo.svg',
                     placeholderBuilder: (BuildContext context) => const SizedBox(
                      child: CircularProgressIndicator()),
                  ),
                ),
              ),
            ),
            SizedBox(height: 16.h,),
            Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                      color: const Color.fromRGBO(235, 249, 251, 1),
                      borderRadius: BorderRadius.circular(15)
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 24.h),
                  height: 90.h,//MediaQuery.of(context).size.height *.15,
                  width: MediaQuery.of(context).size.width ,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const TextWidget(
                            title: 'Your Total Saving',
                            fontSize: 13,
                            color: Color.fromRGBO(117, 128, 138, 1),
                          ),
                          Row(
                            children: [
                              SvgPicture.asset(
                                'assets/savingsIcon.svg',
                              ),
                              SizedBox(width:8.h),
                               TextWidget(

                                fontSize: 21,
                                title: "EGP ${animation?.value.round().toString()}.00",
                                fontWeight: FontWeight.bold,
                              )
                            ],
                          )
                        ],
                      ),
                      TextButton(
                        onPressed: ()async{
                          //_animationController?.forward();
                          await Share.share('Share Bulx App with your freinds', subject: 'Welcome Message');
                        },
                        child: const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 5),
                          child: TextWidget(
                            title: 'Tell a friend',
                            color: Colors.black,
                          ),
                        ),
                        style: ButtonStyle(
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.h),
                                  side: const BorderSide(color: Colors.transparent)
                              )),
                          backgroundColor:
                          MaterialStateProperty.all<Color>(
                              Colors.white),
                        ),
                      )
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: ConfettiWidget(
                      confettiController: _controllerBottomCenter,
                       blastDirectionality: BlastDirectionality.explosive, // don't specify a direction, blast randomly
                      shouldLoop: true,
                      // colors: const [
                      //   Colors.green,
                      //   Colors.blue,
                      //   Colors.pink,
                      //   Colors.orange,
                      //   Colors.purple
                      // ],
                      createParticlePath: drawStar,
                    ),
                  ),
                ),
                Positioned(
                  right: 0,
                  top: 0,
                  child: SvgPicture.asset("assets/star.svg"),
                ),
                Positioned(
                  right: 0,
                  left: 0,
                  top: 0,
                  child: SvgPicture.asset("assets/arrow.svg"),
                ),
                Positioned(
                  right: MediaQuery.of(context).size.width *.3,
                  left: MediaQuery.of(context).size.width *.45,
                  bottom: 0,
                  child: SvgPicture.asset("assets/heart.svg",),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
