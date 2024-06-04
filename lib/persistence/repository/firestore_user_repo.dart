import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitness_sync/application/converters/convert_user.dart';
import 'package:fitness_sync/domain/entities/user/user_domain.dart';
import 'package:fitness_sync/domain/abstractions/repository.dart';

class FireStoreUserRepository extends Repository<UserDomain> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late ConvertUserService convertUserService;

  FireStoreUserRepository({required this.convertUserService});

  final String collectionPath = 'users';

  @override
  Future<List<UserDomain>> getAllList() async {
    QuerySnapshot querySnapshot =
        await _firestore.collection(collectionPath).get();
    return querySnapshot.docs
        .map((doc) => convertUserService
            .decode(jsonEncode(doc.data() as Map<String, dynamic>)))
        .toList();
  }

  @override
  Future<UserDomain> update(UserDomain user) async {
    await _firestore
        .collection(collectionPath)
        .doc(user.mail)
        .update(jsonDecode(convertUserService.encode(user)));
    return user;
  }

  @override
  Future<void> remove(UserDomain user) async {
    await _firestore.collection(collectionPath).doc(user.mail).delete();
  }

  @override
  Future<UserDomain> add(UserDomain user) async {
    await _firestore
        .collection(collectionPath)
        .doc(user.mail)
        .set(jsonDecode(convertUserService.encode(user)));
    return user;
  }

  @override
  Future<UserDomain?> getFirst(List<bool Function(UserDomain)> params) async {
    List<UserDomain> users = await getAllList();
    for (var user in users) {
      if (params.every((param) => param(user))) {
        return user;
      }
    }
    return null;
  }

  @override
  Future<UserDomain?> getLast(List<bool Function(UserDomain)> params) async {
    List<UserDomain> users = await getAllList();
    for (var user in users.reversed) {
      if (params.every((param) => param(user))) {
        return user;
      }
    }
    return null;
  }

  @override
  Future<List<UserDomain>> getAllListByParams(
      List<bool Function(UserDomain)> params) async {
    List<UserDomain> users = await getAllList();
    return users.where((user) => params.every((param) => param(user))).toList();
  }

  @override
  Future<UserDomain?> getByEmail(String email) async {
    DocumentSnapshot doc =
        await _firestore.collection(collectionPath).doc(email).get();
    if (doc.exists) {
      return convertUserService
          .decode(jsonEncode(doc.data() as Map<String, dynamic>));
    }
    return null;
  }
}
