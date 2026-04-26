import 'package:isar/isar.dart';

part 'raw_notification.g.dart';

@Collection()
class RawNotification {
  Id id = Isar.autoIncrement;
  late String packageName;
  late String text;
  @Index()
  late DateTime timestamp;
}
