abstract class Entity {
  String id = "";
  Entity.withId(this.id);
  Entity();

  Map<String, dynamic> toMap() {
    return {"id": id};
  }
}
