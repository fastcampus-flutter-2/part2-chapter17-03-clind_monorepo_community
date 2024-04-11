import 'package:core_flutter_bloc/flutter_bloc.dart';
import 'package:core_util/util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:presentation/presentation.dart';
import 'package:tool_clind_component/component.dart';
import 'package:tool_clind_theme/theme.dart';
import 'package:ui/ui.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      SplashScreen.show(context);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colorScheme.darkBlack,
      body: FlowBlocBuilder<HomeTabCubit, int>.when(
        data: (context, state) => CoreTabSwitchingView(
          currentTabIndex: state.data,
          tabCount: ClindNavigationType.values.length,
          tabBuilder: (context, index) {
            final Uri uri = switch (index) {
              0 => Uri(path: ClindRoute.community.path),
              1 => Uri(path: ClindRoute.notification.path),
              2 => Uri(path: ClindRoute.my.path),
              _ => Uri(path: ClindRoute.unknown.path),
            };
            return IClindRoutes.findScreen(uri);
          },
        ),
      ),
      bottomNavigationBar: FlowBlocBuilder<HomeTabCubit, int>.when(
        data: (context, state) => ClindBottomNavigationBar(
          items: ClindNavigationType.values.map((e) => ClindBottomNavigationItem(type: e)).toList(),
          currentIndex: state.data,
          onTap: (index) => context.readFlowBloc<HomeTabCubit>().change(index: index),
        ),
      ),
      floatingActionButton: FlowBlocBuilder<HomeTabCubit, int>.when(
        data: (context, state) {
          switch (state.data) {
            case 0:
            case 1:
              return ClindWriteButton(
                onTap: () => IClindRouteTo.write(context),
              );
            default:
              return const SizedBox.shrink();
          }
        },
      ),
    );
  }
}
