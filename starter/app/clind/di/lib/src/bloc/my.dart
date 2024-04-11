import 'package:core_flutter_bloc/flutter_bloc.dart';
import 'package:data/data.dart';
import 'package:domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:presentation/presentation.dart';
import 'package:tool_clind_network/network.dart';

class MyBlocProvider extends StatelessWidget {
  final Widget child;

  const MyBlocProvider({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return FlowRepositoryProvider<IProfileRemoteDataSource>(
      create: (context) => ProfileRemoteDataSource(ProfileApi(ClindRestClient())),
      child: FlowRepositoryProvider<MyDataSource>(
        create: (context) => MyDataSource(
          context.readFlowRepository<IProfileRemoteDataSource>(),
        ),
        child: FlowRepositoryProvider<IMyRepository>(
          create: (context) => MyRepository(
            context.readFlowRepository<MyDataSource>(),
          ),
          child: FlowRepositoryProvider<GetMy2UseCase>(
            create: (context) => GetMy2UseCase(
              context.readFlowRepository<IMyRepository>(),
            ),
            child: FlowBlocProvider<MyCubit>(
              create: (context) => MyCubit(
                context.readFlowRepository<GetMy2UseCase>(),
              ),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}
