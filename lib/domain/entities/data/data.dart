import 'package:fitness_sync/domain/entities/entity.dart';

class Data extends Entity {
  late String userId;
  Data();
  Data.withId({required this.userId, required id}) : super.withId(id);
  Data.userId({required this.userId}) : super();
  Map<String, dynamic> toMap() {
    var map = super.toMap();
    map["userId"] = userId;
    return map;
  }
}
