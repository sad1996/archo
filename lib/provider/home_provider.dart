import 'package:archo/controller/api.dart';
import 'package:archo/model/user.dart';
import 'package:archo/util/essentials.dart';
import 'package:flutter/material.dart';

class HomeProvider with ChangeNotifier {
  HomeProvider();

  List<User> users;

  init() async {
    await getUsers();
  }

  getUsers({bool forceRefresh}) async {
    await Api.getApiExample(forceRefresh: forceRefresh).then((response) {
      if (response != null)
        users = response['result']
            .map<User>((item) => User.fromJson(item))
            .toList();
      notifyListeners();
    });
  }
}
