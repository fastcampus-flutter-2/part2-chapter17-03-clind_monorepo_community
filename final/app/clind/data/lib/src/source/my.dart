import 'package:data/data.dart';

class MyDataSource {
  final IProfileRemoteDataSource _profileRemoteDataSource;

  MyDataSource(this._profileRemoteDataSource);

  Future<dynamic> getMy() {
    return _profileRemoteDataSource.getMy();
  }
}
