import 'package:drift/drift.dart';

class Tasks extends Table {
  IntColumn get id => integer()();

  TextColumn get customerName => text()();

  TextColumn get customerPhone => text()();

  TextColumn get serviceType => text()();

  TextColumn get priority => text()();

  DateTimeColumn get taskDateTime => dateTime()();

  TextColumn get address => text()();

  TextColumn get status => text()();

  TextColumn get notes => text().nullable()();

  RealColumn get customerLatitude => real().nullable()();

  RealColumn get customerLongitude => real().nullable()();

  RealColumn get startLatitude => real().nullable()();

  RealColumn get startLongitude => real().nullable()();

  RealColumn get completionLatitude => real().nullable()();

  RealColumn get completionLongitude => real().nullable()();

  BoolColumn get customerConfirmed =>
      boolean().withDefault(const Constant(false))();

  /// Pending / Synced / Failed
  TextColumn get syncStatus => text().withDefault(const Constant('Synced'))();

  @override
  Set<Column> get primaryKey => {id};
}
