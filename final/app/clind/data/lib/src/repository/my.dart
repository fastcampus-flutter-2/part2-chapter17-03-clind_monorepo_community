import 'package:data/data.dart';
import 'package:domain/domain.dart';

class MyRepository implements IMyRepository {
  final MyDataSource _myDataSource;

  MyRepository(this._myDataSource);

  @override
  Future<User> getMy() async {
    final dynamic json = await _myDataSource.getMy();
    return User.fromJson(json);
  }
}
