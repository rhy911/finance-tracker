import 'package:isar/isar.dart';

part 'bank_status.g.dart';

@collection
class BankStatus {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  late String packageName;

  bool isEnabled = true;
}
