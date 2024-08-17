import 'package:equatable/equatable.dart';

abstract class Error extends Equatable implements Exception {
  @override
  List<Object?> get props => [];
}

class NoMoreKeysToLoad extends Error {}
