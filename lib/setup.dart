import 'package:flutter/material.dart';

class Setup extends StatefulWidget {
  const Setup({Key key}) : super(key: key);

  @override
  _SetupState createState() => _SetupState();
}

class _SetupState extends State<Setup> {
  double x_pos = 0.0;

  double y_pos = 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Setup'),
        actions: [],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            "(${x_pos.toStringAsPrecision(5)}, ${y_pos.toStringAsPrecision(5)})",
            style: TextStyle(fontSize: 20),
          ),
          GestureDetector(
            onTapDown: (TapDownDetails x) {
              print(x.globalPosition);
              setState(() {
                x_pos = x.localPosition.dx;
                y_pos = x.localPosition.dy;
              });
            },
            child: Stack(
              children: [
                Container(
                  child: Center(child: Image.asset('assets/map-floor-4.gif')),
                ),
                Positioned(
                    left: x_pos,
                    top: y_pos,
                    child: Container(
                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle, color: Colors.black),
                    ))
              ],
            ),
          ),
        ],
      ),
    );
  }
}
