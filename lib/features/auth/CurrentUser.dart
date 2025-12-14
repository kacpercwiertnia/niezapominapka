import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app_user.dart';

part "CurrentUser.g.dart";

@Riverpod(keepAlive: true)
class CurrentUser extends _$CurrentUser {
  @override
  AppUser? build(){
    return null;
  }

  void setUser(AppUser user){
    state = user;
  }
}