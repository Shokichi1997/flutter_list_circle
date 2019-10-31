import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

class HorizontalTab extends StatelessWidget {

  int page = 2;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      child: new Swiper(

        onIndexChanged: (index) {
          page = index;
        },
        itemBuilder: (BuildContext context, int index) {
          return Container(
              child: Align(
                alignment: Alignment.center,
                child: Container(
                  height: page == index ? 100 : 30,
                  width: page == index ? 100 : 30,
                  child: Stack(
                    alignment: Alignment.center,
                    children: <Widget>[
                      new Container(
                        decoration: new BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.blue,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: new Align (
                          alignment: Alignment.center,
                          child: new Container(
                            width: 15,
                            height: 15,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white),
                            alignment: Alignment.center,
                            child: new Text(index.toString(),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
          );
        },
        itemCount: 10,
        viewportFraction: 1 / 9,
        scale: 0.9,
      ),
    );
  }
}