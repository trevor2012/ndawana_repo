import 'package:flutter/material.dart';
import 'package:ndawana_app/widgets/top_pick_store.dart';
import 'package:ndawana_app/widgets/image_slider.dart';
import 'package:ndawana_app/widgets/my_appbar.dart';

class HomeScreen extends StatefulWidget {

  static const String id = 'home-screen';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(112),
        child: MyAppBar(),
      ),
      body: Center(
        child: Column(
          children: [
            ImageSlider(),
            Container(
              height: 160,
                child: TopPickStore()),

          ],
        ),
      ),
    );
  }
}
