import 'package:domain/domain.dart';

abstract class INotificationRepository {
  Future<List<ClindNotification>> getNotifications();
}
