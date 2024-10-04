import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_app/features/task/data/models/user_model.dart';

import '../main.dart';

abstract class PrefsRepository {
  UserModel? get user;

  Future<bool> clearUser();

  Future<bool> setUser(UserModel user);
}

@LazySingleton(as: PrefsRepository)
class PrefsRepositoryImpl extends PrefsRepository {
  PrefsRepositoryImpl(this._preferences);

  final SharedPreferences _preferences;

  @override
  @override
  Future<bool> setUser(UserModel user) {
    return _preferences.setString(userModelKey, json.encode(user.toJson()));
  }

  @override
  // TODO: implement user
  UserModel? get user {
    var model = _preferences.getString(userModelKey);
    if (model != null) {
      return UserModel.fromJson(json.decode(model));
    }
    return null;
  }

  @override
  Future<bool> clearUser() {
    return _preferences.remove(userModelKey);
  }
}
