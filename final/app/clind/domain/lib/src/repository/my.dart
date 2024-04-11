import 'package:domain/domain.dart';

abstract class IMyRepository {
  Future<User> getMy();
}
