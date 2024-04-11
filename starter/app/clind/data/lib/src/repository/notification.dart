import 'package:data/data.dart';
import 'package:domain/domain.dart';

class NotificationRepository implements INotificationRepository {
  final NotificationDataSource _notificationDataSource;

  NotificationRepository(this._notificationDataSource);

  @override
  Future<List<ClindNotification>> getNotifications() async {
    final List<dynamic> jsonList = await _notificationDataSource.getNotifications();
    return jsonList.map((json) => ClindNotification.fromJson(json)).toList();
  }
}
