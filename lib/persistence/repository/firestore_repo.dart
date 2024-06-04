import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitness_sync/domain/abstractions/repository.dart';
import 'package:fitness_sync/application/converters/json_converter.dart';
import 'package:fitness_sync/domain/entities/entity.dart';

class FireStoreTemplateRepo<T extends Entity> implements Repository<T> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late final JsonConverter<T> converter;
  late final String collectionPath;

  FireStoreTemplateRepo(
      {required this.converter, required this.collectionPath});

  @override
  Future<List<T>> getAllList() async {
    QuerySnapshot querySnapshot =
        await _firestore.collection(collectionPath).get();
    return querySnapshot.docs
        .map((doc) => converter.decode(jsonEncode(doc.data())))
        .toList();
  }

  @override
  Future<T> update(T object) async {
    await _firestore
        .collection(collectionPath)
        .doc(object.id)
        .update(jsonDecode(converter.encode(object)));
    return object;
  }

  @override
  Future<void> remove(T object) async {
    await _firestore.collection(collectionPath).doc(object.id).delete();
  }

  @override
  Future<T> add(T object) async {
    var doc = await _firestore.collection(collectionPath).doc();
    object.id = doc.id;
    doc.set(jsonDecode(converter.encode(object)));
    return object;
  }

  @override
  Future<T?> getFirst(List<bool Function(T)> params) async {
    List<T> users = await getAllList();

    for (var object in users) {
      if (params.every((param) => param(object))) {
        return object;
      }
    }
    return null;
  }

  @override
  Future<T?> getLast(List<bool Function(T)> params) async {
    List<T> users = await getAllList();
    for (var object in users.reversed) {
      if (params.every((param) => param(object))) {
        return object;
      }
    }
    return null;
  }

  @override
  Future<List<T>> getAllListByParams(List<bool Function(T)> params) async {
    List<T> users = await getAllList();
    return users
        .where((object) => params.every((param) => param(object)))
        .toList();
  }
}
