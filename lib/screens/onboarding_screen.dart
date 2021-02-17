import 'package:flutter/material.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:ndawana_app/constants.dart';


class OnBoardingScreen extends StatefulWidget {
  @override
  _OnBoardingScreenState createState() => _OnBoardingScreenState();
}

final _controller = PageController(
  initialPage: 0,
);

int _currentPage = 0;

List<Widget> _pages =[
  Column(
    children: <Widget>[
      Expanded(child: Image.asset('images/logo.png')),
      Text('Order Online from Your Favourite Store', style: kPageViewTextStyle,),
    ],
  ),
  Column(
    children: <Widget>[
      Expanded(child: Image.asset('images/logo.png')),
      Text('Set your Delivery Address', style: kPageViewTextStyle,),
    ],
  ),
  Column(
    children: <Widget>[
      Expanded(child: Image.asset('images/logo.png')),
      Text('Quick Deliver to your Doorstep', style: kPageViewTextStyle,),
    ],
  )


];

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(
            child: PageView(
              controller: _controller,
              children: _pages,
              onPageChanged: (index){
                setState(() {
                  _currentPage = index;
                });
              },
            ),
          ),
          SizedBox(height: 20,),
          DotsIndicator(
            dotsCount: _pages.length,
            position: _currentPage.toDouble(),
            decorator: DotsDecorator(
              color: Colors.black87, // Inactive color
              activeColor: Colors.blueAccent,
            ),
          ),
          SizedBox(height: 20,),
        ],
      ),
    );
  }
}
