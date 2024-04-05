import 'package:fitness_sync/domain/entities/entity.dart';

class Water extends Entity {
  late int userId;
  int amount;

  DateTime dateTaken;

  Water({required this.amount, required this.dateTaken});

  Map<String, dynamic> toMap() {
    return {
      "userId": userId,
      "amount": amount,
      "dateTaken": dateTaken,
    };
  }
}
