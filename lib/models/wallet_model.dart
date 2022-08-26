import 'package:equatable/equatable.dart';

class WalletKeys {
  WalletKeys._();
  static const username = 'username';
  static const balance = 'balance';
  static const earned = 'earned';
  static const spent = 'spent';
}

class Wallet extends Equatable {
  final String? username;
  final int? balance;
  final int? earned;
  final int? spent;

  Wallet({
    this.username,
    this.balance,
    this.earned,
    this.spent,
  });

  static Wallet fromJson(Map<String, dynamic> json) {
    return Wallet(
      balance: json[WalletKeys.balance],
      earned: json[WalletKeys.earned],
      spent: json[WalletKeys.spent],
      username: json[WalletKeys.username],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      WalletKeys.username: this.username,
      WalletKeys.earned: this.earned,
      WalletKeys.spent: this.spent,
      WalletKeys.balance: (this.earned ?? 0) - (this.spent ?? 0),
    };
  }

  @override
  List<Object?> get props => [balance, username, earned, spent];
}
