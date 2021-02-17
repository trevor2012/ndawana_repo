import 'package:cloud_firestore/cloud_firestore.dart';

class StoreService{

  getTopPickedStore(){
    return FirebaseFirestore.instance.collection('vendors').where(
        'accVerified', isEqualTo: true).where('isTopPicked', isEqualTo: true).orderBy('shopName').snapshots();
  }






}

// shows verified vendors
// shows on top picked by admin
// shops will be ordered by alphabetical order