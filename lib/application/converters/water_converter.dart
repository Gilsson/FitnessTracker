import 'dart:convert';

import 'package:fitness_sync/application/converters/json_converter.dart';
import 'package:fitness_sync/domain/entities/water/water.dart';

class ConvertWaterService implements JsonConverter<Water> {
  @override
  Water decode(String json) {
    return fromJson(jsonDecode(json));
  }

  @override
  String encode(Water object) {
    return jsonEncode(toJson(object));
  }

  Map<String, dynamic> toJson(Water water) {
    return {
      "userId": water.userId,
      "amount": water.amount,
      "dateTaken": water.dateTaken.toIso8601String(),
      "id": water.id,
      "isScheduled": water.isScheduled
    };
  }

  Water fromJson(Map<String, dynamic> json) {
    return Water.full(
        userId: json["userId"],
        amount: json["amount"],
        dateTaken: DateTime.parse(json["dateTaken"]),
        id: json["id"],
        isScheduled: json["isScheduled"]);
  }
}
