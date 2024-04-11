import 'package:core_util/util.dart';
import 'package:domain/domain.dart';

class GetPopularChannelsUseCase implements IUseCase<List<Channel>, void> {
  final ICommunityRepository _communityRepository;

  GetPopularChannelsUseCase(this._communityRepository);

  @override
  Future<List<Channel>> execute([void params]) {
    return _communityRepository.getPopularChannels();
  }
}

class GetPopularChannels2UseCase implements IUseCase<List<Channel>, void> {
  final ISearchRepository _searchRepository;

  GetPopularChannels2UseCase(this._searchRepository);

  @override
  Future<List<Channel>> execute([void params]) {
    return _searchRepository.getPopularChannels();
  }
}
