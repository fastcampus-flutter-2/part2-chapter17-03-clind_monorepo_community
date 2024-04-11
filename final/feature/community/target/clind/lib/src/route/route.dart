import 'package:community_di/di.dart';
import 'package:feature_community/clind.dart';
import 'package:flutter/material.dart';

enum CommunityRoute {
  community,
  post,
  write,
  unknown;

  static String encode(CommunityRoute value) => value.path;

  static CommunityRoute decode(String value) => CommunityRoute.values.firstWhere(
        (e) => e.path == value,
        orElse: () => CommunityRoute.unknown,
      );
}

extension CommunityRouteExtension on CommunityRoute {
  String get path {
    if (this == CommunityRoute.community) return '/$name';
    return '${CommunityRoute.community.path}/$name';
  }
}

abstract class ICommunityRoutes {
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
    final CommunityRoute route = CommunityRoute.decode(uri.path);
    final Map<String, String> queryParameters = {...uri.queryParameters};
    switch (route) {
      case CommunityRoute.community:
        return const CommunityBlocProvider(
          child: CommunityScreen(),
        );
      case CommunityRoute.post:
        final String id = queryParameters['id'] ?? '';
        return PostBlocProvider(
          child: PostScreen(
            id: id,
          ),
        );
      case CommunityRoute.write:
        return const WriteBlocProvider(
          child: WriteScreen(),
        );
      case CommunityRoute.unknown:
        return const SizedBox();
    }
  }
}

abstract class ICommunityRouteTo {
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
    required CommunityRoute route,
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

  static Future<void> community(BuildContext context) {
    return push<void>(
      context,
      route: CommunityRoute.community,
    );
  }

  static Future<void> post(
    BuildContext context, {
    required String id,
  }) {
    return push<void>(
      context,
      route: CommunityRoute.post,
      queryParameters: {
        'id': id,
      },
    );
  }

  static Future<void> write(BuildContext context) {
    return push<void>(
      context,
      route: CommunityRoute.write,
      fullscreenDialog: true,
    );
  }
}
