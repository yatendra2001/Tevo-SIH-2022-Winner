// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:equatable/equatable.dart';

import 'package:tevo/cubits/transaction_flow_type.dart';
import 'package:tevo/enums/currency_type.dart';
import 'package:tevo/enums/transaction_type.dart';

class WalletHistoryModel extends Equatable {
  final double amount;
  final String flowType;
  final String currencyType;
  final DateTime time;
  final String transactionType;
  const WalletHistoryModel({
    required this.amount,
    required this.flowType,
    required this.currencyType,
    required this.time,
    required this.transactionType,
  });

  WalletHistoryModel copyWith({
    double? amount,
    String? flowType,
    String? currencyType,
    DateTime? time,
    String? transactionType,
  }) {
    return WalletHistoryModel(
      amount: amount ?? this.amount,
      flowType: flowType ?? this.flowType,
      currencyType: currencyType ?? this.currencyType,
      time: time ?? this.time,
      transactionType: transactionType ?? this.transactionType,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'amount': amount,
      'flowType': flowType,
      'currencyType': currencyType,
      'time': time.millisecondsSinceEpoch,
      'transactionType': transactionType,
    };
  }

  factory WalletHistoryModel.fromMap(Map<String, dynamic> map) {
    return WalletHistoryModel(
      amount: map['amount'] as double,
      flowType: map['flowType'] as String,
      currencyType: map['currencyType'] as String,
      time: DateTime.fromMillisecondsSinceEpoch(map['time'] as int),
      transactionType: map['transactionType'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory WalletHistoryModel.fromJson(String source) =>
      WalletHistoryModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool get stringify => true;

  @override
  List<Object> get props {
    return [
      amount,
      flowType,
      currencyType,
      time,
      transactionType,
    ];
  }
}
