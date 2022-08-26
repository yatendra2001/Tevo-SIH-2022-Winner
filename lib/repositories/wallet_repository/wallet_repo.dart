import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tevo/models/wallet_model.dart';
import 'package:tevo/utils/session_helper.dart';

class WalletNwRepository {
  CollectionReference wallet = FirebaseFirestore.instance.collection('wallet');

  Future<void> createWallet(String uid) async {
    try {
      log("Wallet it getting created" + (uid));

      await wallet.doc(uid).set(Wallet(
              username: SessionHelper.username, balance: 0, earned: 0, spent: 0)
          .toJson());
    } catch (e) {
      log(e.toString());
    }
  }

  Stream<Wallet> getWalletStream(String userId) async* {
    yield* wallet.doc(userId).snapshots().map((event) {
      return Wallet.fromJson(event.data() as Map<String, dynamic>);
    });
  }

  Future<Wallet> getWalletData(String userId) async {
    var _exception;
    try {
      var result = await wallet.doc(userId).get();
      var walletData = result.data();
      return Wallet.fromJson(walletData as Map<String, dynamic>);
    } catch (e) {
      _exception = e;
      log(e.toString());
    }
    throw _exception;
  }

  Future<Wallet> getWalletDataByUserId(String userId) async {
    var _exception;
    try {
      var result = await wallet.doc(userId).get();
      var walletData = result.data();
      return Wallet.fromJson(walletData as Map<String, dynamic>);
    } catch (e) {
      _exception = e;
      log(e.toString());
    }
    throw _exception;
  }

  Future<void> updateWallet(String userId, Wallet walletData) async {
    await wallet.doc(userId).update(walletData.toJson());
  }
}
