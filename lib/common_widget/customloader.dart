import 'dart:math';

import 'package:flutter/material.dart';
import 'package:pachub/Utils/appcolors.dart';
// import 'package:shimmer/shimmer.dart';


class CustomLoader extends StatefulWidget{
  @override
  CustomLoaderstate createState() => CustomLoaderstate();
}

class CustomLoaderstate extends State<CustomLoader> with SingleTickerProviderStateMixin {
  AnimationController? controller;
  Animation<double>? animation_rotation;
  Animation<double>? animation_radius_in;
  Animation<double>? animation_radius_out;
  final double initialradius=15.0;
  double radius=0.0;

  @override
  void initState(){
    super.initState();
    controller=AnimationController(vsync: this, duration: Duration(seconds: 5));
    animation_rotation =Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: controller!, curve: Interval(0.0,1.0,curve: Curves.linear)));


    animation_radius_in=Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(parent: controller!,curve: Interval(0.75,1.0,curve: Curves.elasticIn))
    );
    animation_radius_out=Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: controller!,curve: Interval(0.0,0.25,curve: Curves.elasticInOut))
    );
    controller!.addListener(() {
      setState((){
        if(controller!.value>=0.75&&controller!.value<=1.0){
          radius=animation_radius_in!.value*initialradius;
        }
        else if(controller!.value>=0.0&&controller!.value<=0.25){
          radius=animation_radius_out!.value*initialradius;
        }
      });
    });
    controller!.repeat();

  }

  @override
  void dispose() {
    controller!.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: 100.0,
      height: 100.0,
      child: Center(
        child: RotationTransition(
          turns: animation_rotation!,
          child: Stack(
            children: <Widget>[
              Dot(
                radius: 15.0,
                color: AppColors.grey_hint_color,
              ),
              Transform.translate(
                offset: Offset(radius *  cos(pi/4),radius * sin(pi/4)),
                child: Dot(
                  radius: 5.0,
                  color: Colors.redAccent,
                ),
              ),
              Transform.translate(
                offset: Offset(radius * cos(2*pi/4),radius * sin(2*pi/4)),
                child: Dot(
                  radius: 5.0,
                  color: Colors.greenAccent,
                ),
              ),Transform.translate(
                offset: Offset(radius*cos(3*pi/4),radius*sin(3*pi/4)),
                child: Dot(
                  radius: 5.0,
                  color: Colors.blueAccent,
                ),
              ),Transform.translate(
                offset: Offset(radius*cos(4*pi/4),radius*sin(4*pi/4)),
                child: Dot(
                  radius: 5.0,
                  color: Colors.amberAccent,
                ),
              ),
              Transform.translate(
                offset: Offset(radius*cos(5*pi/4),radius*sin(5*pi/4)),
                child: Dot(
                  radius: 5.0,
                  color: Colors.blue,
                ),
              ),

              Transform.translate(
                offset: Offset(radius*cos(6*pi/4),radius*sin(6*pi/4)),
                child: Dot(
                  radius: 5.0,
                  color: Colors.orangeAccent,
                ),
              ), Transform.translate(
                offset: Offset(radius*cos(7*pi/4),radius*sin(7*pi/4)),
                child: Dot(
                  radius: 5.0,
                  color: Colors.lightGreen,
                ),
              ), Transform.translate(
                offset: Offset(radius*cos(8*pi/4),radius*sin(8*pi/4)),
                child: Dot(
                  radius: 5.0,
                  color: Colors.redAccent,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/* return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.centerRight,
                colors: [AppColors.black, AppColors.black])),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                valueColor: new AlwaysStoppedAnimation<Color>(AppColors.scaffold_background),
              ),
              SizedBox(height: 20,),
              Text("Loading")
            ],
          ),
        ),
      ),
    ); */

class  Dot extends StatelessWidget {
  final double? radius;
  final Color? color;
  Dot ({this.color,this.radius});

  @override
  Widget build(BuildContext context){
    return Center(
      child: Container(
        height: this.radius,
        width: this.radius,
        decoration: BoxDecoration(
          color: this.color,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}



/*
class Shimmerdesignraw extends StatelessWidget {
 bool _isLoadRunning = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      child:
      Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        enabled: _isLoadRunning,
        child: ListView.builder(
          itemCount: 10,
          itemBuilder: (_, __) => Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 48.0,
                  height: 48.0,
                  color: Colors.white,
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        width: double.infinity,
                        height: 8.0,
                        color: Colors.white,
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 2.0),
                      ),
                      Container(
                        width: double.infinity,
                        height: 8.0,
                        color: Colors.white,
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 2.0),
                      ),
                      Container(
                        width: 40.0,
                        height: 8.0,
                        color: Colors.white,
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),);
  }
}
*/

