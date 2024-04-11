import 'package:core_flutter_bloc/flutter_bloc.dart';
import 'package:data/data.dart';
import 'package:domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:presentation/presentation.dart';
import 'package:tool_clind_network/network.dart';

class WriteBlocProvider extends StatelessWidget {
  final Widget child;

  const WriteBlocProvider({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return FlowMultiRepositoryProvider(
      providers: [
        FlowRepositoryProvider<IPostRemoteDataSource>(
          create: (context) => PostRemoteDataSource(PostApi(ClindRestClient())),
        ),
        FlowRepositoryProvider<IProfileRemoteDataSource>(
          create: (context) => ProfileRemoteDataSource(ProfileApi(ClindRestClient())),
        ),
      ],
      child: FlowRepositoryProvider<WriteDataSource>(
        create: (context) => WriteDataSource(
          context.readFlowRepository<IPostRemoteDataSource>(),
          context.readFlowRepository<IProfileRemoteDataSource>(),
        ),
        child: FlowRepositoryProvider<IWriteRepository>(
          create: (context) => WriteRepository(
            context.readFlowRepository<WriteDataSource>(),
          ),
          child: FlowMultiRepositoryProvider(
            providers: [
              FlowRepositoryProvider<CreatePostUseCase>(
                create: (context) => CreatePostUseCase(
                  context.readFlowRepository<IWriteRepository>(),
                ),
              ),
              FlowRepositoryProvider<GetMyUseCase>(
                create: (context) => GetMyUseCase(
                  context.readFlowRepository<IWriteRepository>(),
                ),
              ),
            ],
            child: FlowMultiBlocProvider(
              providers: [
                FlowBlocProvider<WritePostCubit>(
                  create: (context) => WritePostCubit(
                    context.readFlowRepository<CreatePostUseCase>(),
                  ),
                ),
                FlowBlocProvider<WriteMyCubit>(
                  create: (context) => WriteMyCubit(
                    context.readFlowRepository<GetMyUseCase>(),
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
