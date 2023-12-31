import 'package:flutter/material.dart';

@immutable
abstract class UserEvent {}

class UserInitialEvent extends UserEvent {}

class ClickToEditUserEvent extends UserEvent {}

class ClickToRemoveUserEvent extends UserEvent {}

class ClickToLoadMoreUserEvent extends UserEvent {}

class ClickToReloadEvent extends UserEvent {}
