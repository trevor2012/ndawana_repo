import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:ndawana_app/providers/store_provider.dart';
import 'package:ndawana_app/services/store_service.dart';
import 'package:provider/provider.dart';

class NearByStores extends StatefulWidget {
  @override

  _NearByStoresState createState() => _NearByStoresState();
}

class _NearByStoresState extends State<NearByStores> {

  StoreService _storeService = StoreService();

  @override
  Widget build(BuildContext context) {
    final _storeData = Provider.of<StoreProvider>(context);
    _storeData.getUseLocationData(context);

    String getDistance(location){
      var distance = Geolocator.distanceBetween(_storeData.userLatitude, _storeData.userLongitude, location.latitude, location.longitude);
      var distanceInKm = distance / 1000;
      return distanceInKm.toStringAsFixed(2);
    }


    return Container(
      child: StreamBuilder<QuerySnapshot>(
        stream: _storeService.getTopPickedStore(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot>snapShot){
          if(!snapShot.hasData)
            return CircularProgressIndicator();
          List shopDistance = [];
          for(int i =0 ; i<=snapShot.data.docs.length-1; i++){
            var distance = Geolocator.distanceBetween(_storeData.userLatitude, _storeData.userLongitude, snapShot.data.docs[i]['location'].latitude, snapShot.data.docs[i]['location'].longitude);
            var distanceInKm = distance/1000;
            shopDistance.add(distanceInKm);
          }
          shopDistance.sort(); //this will sort by nearest distance if shop is more than 10km
          if(shopDistance[0]>10){
            return Container();
          }
          return Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

              ],
            ),
          );
        },
      ),
    );
  }
}
