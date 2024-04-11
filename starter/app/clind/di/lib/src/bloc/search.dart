import 'package:core_flutter_bloc/flutter_bloc.dart';
import 'package:data/data.dart';
import 'package:domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:presentation/presentation.dart';
import 'package:tool_clind_network/network.dart';

class SearchBlocProvider extends StatelessWidget {
  final Widget child;

  const SearchBlocProvider({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return FlowMultiRepositoryProvider(
      providers: [
        FlowRepositoryProvider<IPreferenceLocalDataSource>(
          create: (context) => const PreferenceLocalDataSource(),
        ),
        FlowRepositoryProvider<IPostRemoteDataSource>(
          create: (context) => PostRemoteDataSource(PostApi(ClindRestClient())),
        ),
      ],
      child: FlowRepositoryProvider<SearchDataSource>(
        create: (context) => SearchDataSource(
          context.readFlowRepository<IPreferenceLocalDataSource>(),
          context.readFlowRepository<IPostRemoteDataSource>(),
        ),
        child: FlowRepositoryProvider<ISearchRepository>(
          create: (context) => SearchRepository(
            context.readFlowRepository<SearchDataSource>(),
          ),
          child: FlowMultiRepositoryProvider(
            providers: [
              FlowRepositoryProvider<SetRecentSearchChannelsUseCase>(
                create: (context) => SetRecentSearchChannelsUseCase(
                  context.readFlowRepository<ISearchRepository>(),
                ),
              ),
              FlowRepositoryProvider<GetRecentSearchChannelsUseCase>(
                create: (context) => GetRecentSearchChannelsUseCase(
                  context.readFlowRepository<ISearchRepository>(),
                ),
              ),
              FlowRepositoryProvider<GetPopularChannels2UseCase>(
                create: (context) => GetPopularChannels2UseCase(
                  context.readFlowRepository<ISearchRepository>(),
                ),
              ),
              FlowRepositoryProvider<GetSearchPostsUseCase>(
                create: (context) => GetSearchPostsUseCase(
                  context.readFlowRepository<ISearchRepository>(),
                ),
              ),
            ],
            child: FlowMultiBlocProvider(
              providers: [
                FlowBlocProvider<SearchQueryCubit>(
                  create: (context) => SearchQueryCubit(),
                ),
                FlowBlocProvider<SearchRecentChannelListCubit>(
                  create: (context) => SearchRecentChannelListCubit(
                    context.readFlowRepository<SetRecentSearchChannelsUseCase>(),
                    context.readFlowRepository<GetRecentSearchChannelsUseCase>(),
                  ),
                ),
                FlowBlocProvider<SearchPopularChannelListCubit>(
                  create: (context) => SearchPopularChannelListCubit(
                    context.readFlowRepository<GetPopularChannels2UseCase>(),
                  ),
                ),
                FlowBlocProvider<SearchPostListCubit>(
                  create: (context) => SearchPostListCubit(
                    context.readFlowRepository<GetSearchPostsUseCase>(),
                  ),
                ),
              ],
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}
