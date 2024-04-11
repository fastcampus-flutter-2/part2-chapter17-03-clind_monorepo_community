import 'package:di/di.dart';
import 'package:flutter/material.dart';
import 'package:ui/ui.dart';

enum ClindRoute {
  root,
  notification,
  my,
  search,
  unknown;

  static String encode(ClindRoute value) => value.path;

  static ClindRoute decode(String value) => ClindRoute.values.firstWhere(
        (e) => e.path == value,
        orElse: () => ClindRoute.unknown,
      );
}

extension ClindRouteExtension on ClindRoute {
  String get path {
    const String root = '/';
    if (this == ClindRoute.root) return root;
    return '$root$name';
  }
}

abstract class IClindRoutes {
  static Route<dynamic> find(RouteSettings settings) {
    final Uri uri = Uri.tryParse(settings.name ?? '') ?? Uri();
    final Map<String, String> queryParameters = {...uri.queryParameters};
    final bool fullscreenDialog = bool.tryParse(queryParameters['fullscreenDialog'] ?? '') ?? false;
    return MaterialPageRoute(
      builder: (context) => findScreen(uri),
      settings: settings,
      fullscreenDialog: fullscreenDialog,
    );
  }

  static Widget findScreen(Uri uri) {
    final ClindRoute route = ClindRoute.decode(uri.path);
    switch (route) {
      case ClindRoute.root:
        return const HomeBlocProvider(
          child: HomeScreen(),
        );
      case ClindRoute.notification:
        return const NotificationBlocProvider(
          child: NotificationScreen(),
        );
      case ClindRoute.my:
        return const MyBlocProvider(
          child: MyScreen(),
        );
      case ClindRoute.search:
        return const SearchBlocProvider(
          child: SearchScreen(),
        );
      case ClindRoute.unknown:
        return const SizedBox();
    }
  }
}

abstract class IClindRouteTo {
  static Future<T?> pushNamed<T extends Object?>(
    BuildContext context, {
    required String path,
    Map<String, String>? queryParameters,
    bool fullscreenDialog = false,
  }) async {
    final Map<String, String> params = {
      if (queryParameters != null) ...queryParameters,
      'fullscreenDialog': fullscreenDialog.toString(),
    };

    final Uri uri = Uri(
      path: path,
      queryParameters: params,
    );

    final Object? result = await Navigator.of(context).pushNamed<Object?>(uri.toString());
    return result as T?;
  }

  static Future<T?> push<T extends Object?>(
    BuildContext context, {
    required ClindRoute route,
    Map<String, String>? queryParameters,
    bool fullscreenDialog = false,
  }) {
    return pushNamed<T>(
      context,
      path: route.path,
      queryParameters: queryParameters,
      fullscreenDialog: fullscreenDialog,
    );
  }

  static Future<void> root(BuildContext context) {
    return push<void>(
      context,
      route: ClindRoute.root,
    );
  }

  static Future<void> notification(BuildContext context) {
    return push<void>(
      context,
      route: ClindRoute.notification,
    );
  }

  static Future<void> my(BuildContext context) {
    return push<void>(
      context,
      route: ClindRoute.my,
    );
  }

  static Future<void> search(BuildContext context) {
    return push<void>(
      context,
      route: ClindRoute.search,
    );
  }
}
