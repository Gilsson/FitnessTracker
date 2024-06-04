abstract class Convertable {
  Map<String, dynamic> toJson();
  Convertable fromJson(Map<String, dynamic> json);
}
