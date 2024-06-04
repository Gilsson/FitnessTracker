abstract class JsonConverter<T> {
  String encode(T object);
  T decode(String json);
}
