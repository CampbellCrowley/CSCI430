import 'package:flutter/material.dart';

class FloorHeatmap extends StatelessWidget {
  const FloorHeatmap({Key key, this.floor}) : super(key: key);
  final String floor;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: AppBar(
          title: Text(floor),
          actions: [],
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Stack(
            children: [
              Center(child: Image.asset('assets/map-floor-4.gif')),
              Padding(
                padding: const EdgeInsets.only(
                  left: 120.0,
                ),
                child: Center(
                  child: Container(
                    height: 1,
                    width: 1,
                    decoration: BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                            color: Colors.red,
                            blurRadius: 25.0,
                            spreadRadius: 40.0,
                            offset: Offset(0.1, 0.1))
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
