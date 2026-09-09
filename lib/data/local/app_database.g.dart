// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $TasksTable extends Tasks with TableInfo<$TasksTable, Task> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TasksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _customerNameMeta = const VerificationMeta(
    'customerName',
  );
  @override
  late final GeneratedColumn<String> customerName = GeneratedColumn<String>(
    'customer_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _customerPhoneMeta = const VerificationMeta(
    'customerPhone',
  );
  @override
  late final GeneratedColumn<String> customerPhone = GeneratedColumn<String>(
    'customer_phone',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _serviceTypeMeta = const VerificationMeta(
    'serviceType',
  );
  @override
  late final GeneratedColumn<String> serviceType = GeneratedColumn<String>(
    'service_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _priorityMeta = const VerificationMeta(
    'priority',
  );
  @override
  late final GeneratedColumn<String> priority = GeneratedColumn<String>(
    'priority',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _taskDateTimeMeta = const VerificationMeta(
    'taskDateTime',
  );
  @override
  late final GeneratedColumn<DateTime> taskDateTime = GeneratedColumn<DateTime>(
    'task_date_time',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _addressMeta = const VerificationMeta(
    'address',
  );
  @override
  late final GeneratedColumn<String> address = GeneratedColumn<String>(
    'address',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _customerLatitudeMeta = const VerificationMeta(
    'customerLatitude',
  );
  @override
  late final GeneratedColumn<double> customerLatitude = GeneratedColumn<double>(
    'customer_latitude',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _customerLongitudeMeta = const VerificationMeta(
    'customerLongitude',
  );
  @override
  late final GeneratedColumn<double> customerLongitude =
      GeneratedColumn<double>(
        'customer_longitude',
        aliasedName,
        true,
        type: DriftSqlType.double,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _startLatitudeMeta = const VerificationMeta(
    'startLatitude',
  );
  @override
  late final GeneratedColumn<double> startLatitude = GeneratedColumn<double>(
    'start_latitude',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _startLongitudeMeta = const VerificationMeta(
    'startLongitude',
  );
  @override
  late final GeneratedColumn<double> startLongitude = GeneratedColumn<double>(
    'start_longitude',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _completionLatitudeMeta =
      const VerificationMeta('completionLatitude');
  @override
  late final GeneratedColumn<double> completionLatitude =
      GeneratedColumn<double>(
        'completion_latitude',
        aliasedName,
        true,
        type: DriftSqlType.double,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _completionLongitudeMeta =
      const VerificationMeta('completionLongitude');
  @override
  late final GeneratedColumn<double> completionLongitude =
      GeneratedColumn<double>(
        'completion_longitude',
        aliasedName,
        true,
        type: DriftSqlType.double,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _customerConfirmedMeta = const VerificationMeta(
    'customerConfirmed',
  );
  @override
  late final GeneratedColumn<bool> customerConfirmed = GeneratedColumn<bool>(
    'customer_confirmed',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("customer_confirmed" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _syncStatusMeta = const VerificationMeta(
    'syncStatus',
  );
  @override
  late final GeneratedColumn<String> syncStatus = GeneratedColumn<String>(
    'sync_status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('Synced'),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    customerName,
    customerPhone,
    serviceType,
    priority,
    taskDateTime,
    address,
    status,
    notes,
    customerLatitude,
    customerLongitude,
    startLatitude,
    startLongitude,
    completionLatitude,
    completionLongitude,
    customerConfirmed,
    syncStatus,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'tasks';
  @override
  VerificationContext validateIntegrity(
    Insertable<Task> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('customer_name')) {
      context.handle(
        _customerNameMeta,
        customerName.isAcceptableOrUnknown(
          data['customer_name']!,
          _customerNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_customerNameMeta);
    }
    if (data.containsKey('customer_phone')) {
      context.handle(
        _customerPhoneMeta,
        customerPhone.isAcceptableOrUnknown(
          data['customer_phone']!,
          _customerPhoneMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_customerPhoneMeta);
    }
    if (data.containsKey('service_type')) {
      context.handle(
        _serviceTypeMeta,
        serviceType.isAcceptableOrUnknown(
          data['service_type']!,
          _serviceTypeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_serviceTypeMeta);
    }
    if (data.containsKey('priority')) {
      context.handle(
        _priorityMeta,
        priority.isAcceptableOrUnknown(data['priority']!, _priorityMeta),
      );
    } else if (isInserting) {
      context.missing(_priorityMeta);
    }
    if (data.containsKey('task_date_time')) {
      context.handle(
        _taskDateTimeMeta,
        taskDateTime.isAcceptableOrUnknown(
          data['task_date_time']!,
          _taskDateTimeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_taskDateTimeMeta);
    }
    if (data.containsKey('address')) {
      context.handle(
        _addressMeta,
        address.isAcceptableOrUnknown(data['address']!, _addressMeta),
      );
    } else if (isInserting) {
      context.missing(_addressMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('customer_latitude')) {
      context.handle(
        _customerLatitudeMeta,
        customerLatitude.isAcceptableOrUnknown(
          data['customer_latitude']!,
          _customerLatitudeMeta,
        ),
      );
    }
    if (data.containsKey('customer_longitude')) {
      context.handle(
        _customerLongitudeMeta,
        customerLongitude.isAcceptableOrUnknown(
          data['customer_longitude']!,
          _customerLongitudeMeta,
        ),
      );
    }
    if (data.containsKey('start_latitude')) {
      context.handle(
        _startLatitudeMeta,
        startLatitude.isAcceptableOrUnknown(
          data['start_latitude']!,
          _startLatitudeMeta,
        ),
      );
    }
    if (data.containsKey('start_longitude')) {
      context.handle(
        _startLongitudeMeta,
        startLongitude.isAcceptableOrUnknown(
          data['start_longitude']!,
          _startLongitudeMeta,
        ),
      );
    }
    if (data.containsKey('completion_latitude')) {
      context.handle(
        _completionLatitudeMeta,
        completionLatitude.isAcceptableOrUnknown(
          data['completion_latitude']!,
          _completionLatitudeMeta,
        ),
      );
    }
    if (data.containsKey('completion_longitude')) {
      context.handle(
        _completionLongitudeMeta,
        completionLongitude.isAcceptableOrUnknown(
          data['completion_longitude']!,
          _completionLongitudeMeta,
        ),
      );
    }
    if (data.containsKey('customer_confirmed')) {
      context.handle(
        _customerConfirmedMeta,
        customerConfirmed.isAcceptableOrUnknown(
          data['customer_confirmed']!,
          _customerConfirmedMeta,
        ),
      );
    }
    if (data.containsKey('sync_status')) {
      context.handle(
        _syncStatusMeta,
        syncStatus.isAcceptableOrUnknown(data['sync_status']!, _syncStatusMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Task map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Task(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      customerName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}customer_name'],
      )!,
      customerPhone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}customer_phone'],
      )!,
      serviceType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}service_type'],
      )!,
      priority: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}priority'],
      )!,
      taskDateTime: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}task_date_time'],
      )!,
      address: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}address'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      customerLatitude: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}customer_latitude'],
      ),
      customerLongitude: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}customer_longitude'],
      ),
      startLatitude: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}start_latitude'],
      ),
      startLongitude: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}start_longitude'],
      ),
      completionLatitude: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}completion_latitude'],
      ),
      completionLongitude: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}completion_longitude'],
      ),
      customerConfirmed: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}customer_confirmed'],
      )!,
      syncStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sync_status'],
      )!,
    );
  }

  @override
  $TasksTable createAlias(String alias) {
    return $TasksTable(attachedDatabase, alias);
  }
}

class Task extends DataClass implements Insertable<Task> {
  final int id;
  final String customerName;
  final String customerPhone;
  final String serviceType;
  final String priority;
  final DateTime taskDateTime;
  final String address;
  final String status;
  final String? notes;
  final double? customerLatitude;
  final double? customerLongitude;
  final double? startLatitude;
  final double? startLongitude;
  final double? completionLatitude;
  final double? completionLongitude;
  final bool customerConfirmed;

  /// Pending / Synced / Failed
  final String syncStatus;
  const Task({
    required this.id,
    required this.customerName,
    required this.customerPhone,
    required this.serviceType,
    required this.priority,
    required this.taskDateTime,
    required this.address,
    required this.status,
    this.notes,
    this.customerLatitude,
    this.customerLongitude,
    this.startLatitude,
    this.startLongitude,
    this.completionLatitude,
    this.completionLongitude,
    required this.customerConfirmed,
    required this.syncStatus,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['customer_name'] = Variable<String>(customerName);
    map['customer_phone'] = Variable<String>(customerPhone);
    map['service_type'] = Variable<String>(serviceType);
    map['priority'] = Variable<String>(priority);
    map['task_date_time'] = Variable<DateTime>(taskDateTime);
    map['address'] = Variable<String>(address);
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    if (!nullToAbsent || customerLatitude != null) {
      map['customer_latitude'] = Variable<double>(customerLatitude);
    }
    if (!nullToAbsent || customerLongitude != null) {
      map['customer_longitude'] = Variable<double>(customerLongitude);
    }
    if (!nullToAbsent || startLatitude != null) {
      map['start_latitude'] = Variable<double>(startLatitude);
    }
    if (!nullToAbsent || startLongitude != null) {
      map['start_longitude'] = Variable<double>(startLongitude);
    }
    if (!nullToAbsent || completionLatitude != null) {
      map['completion_latitude'] = Variable<double>(completionLatitude);
    }
    if (!nullToAbsent || completionLongitude != null) {
      map['completion_longitude'] = Variable<double>(completionLongitude);
    }
    map['customer_confirmed'] = Variable<bool>(customerConfirmed);
    map['sync_status'] = Variable<String>(syncStatus);
    return map;
  }

  TasksCompanion toCompanion(bool nullToAbsent) {
    return TasksCompanion(
      id: Value(id),
      customerName: Value(customerName),
      customerPhone: Value(customerPhone),
      serviceType: Value(serviceType),
      priority: Value(priority),
      taskDateTime: Value(taskDateTime),
      address: Value(address),
      status: Value(status),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      customerLatitude: customerLatitude == null && nullToAbsent
          ? const Value.absent()
          : Value(customerLatitude),
      customerLongitude: customerLongitude == null && nullToAbsent
          ? const Value.absent()
          : Value(customerLongitude),
      startLatitude: startLatitude == null && nullToAbsent
          ? const Value.absent()
          : Value(startLatitude),
      startLongitude: startLongitude == null && nullToAbsent
          ? const Value.absent()
          : Value(startLongitude),
      completionLatitude: completionLatitude == null && nullToAbsent
          ? const Value.absent()
          : Value(completionLatitude),
      completionLongitude: completionLongitude == null && nullToAbsent
          ? const Value.absent()
          : Value(completionLongitude),
      customerConfirmed: Value(customerConfirmed),
      syncStatus: Value(syncStatus),
    );
  }

  factory Task.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Task(
      id: serializer.fromJson<int>(json['id']),
      customerName: serializer.fromJson<String>(json['customerName']),
      customerPhone: serializer.fromJson<String>(json['customerPhone']),
      serviceType: serializer.fromJson<String>(json['serviceType']),
      priority: serializer.fromJson<String>(json['priority']),
      taskDateTime: serializer.fromJson<DateTime>(json['taskDateTime']),
      address: serializer.fromJson<String>(json['address']),
      status: serializer.fromJson<String>(json['status']),
      notes: serializer.fromJson<String?>(json['notes']),
      customerLatitude: serializer.fromJson<double?>(json['customerLatitude']),
      customerLongitude: serializer.fromJson<double?>(
        json['customerLongitude'],
      ),
      startLatitude: serializer.fromJson<double?>(json['startLatitude']),
      startLongitude: serializer.fromJson<double?>(json['startLongitude']),
      completionLatitude: serializer.fromJson<double?>(
        json['completionLatitude'],
      ),
      completionLongitude: serializer.fromJson<double?>(
        json['completionLongitude'],
      ),
      customerConfirmed: serializer.fromJson<bool>(json['customerConfirmed']),
      syncStatus: serializer.fromJson<String>(json['syncStatus']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'customerName': serializer.toJson<String>(customerName),
      'customerPhone': serializer.toJson<String>(customerPhone),
      'serviceType': serializer.toJson<String>(serviceType),
      'priority': serializer.toJson<String>(priority),
      'taskDateTime': serializer.toJson<DateTime>(taskDateTime),
      'address': serializer.toJson<String>(address),
      'status': serializer.toJson<String>(status),
      'notes': serializer.toJson<String?>(notes),
      'customerLatitude': serializer.toJson<double?>(customerLatitude),
      'customerLongitude': serializer.toJson<double?>(customerLongitude),
      'startLatitude': serializer.toJson<double?>(startLatitude),
      'startLongitude': serializer.toJson<double?>(startLongitude),
      'completionLatitude': serializer.toJson<double?>(completionLatitude),
      'completionLongitude': serializer.toJson<double?>(completionLongitude),
      'customerConfirmed': serializer.toJson<bool>(customerConfirmed),
      'syncStatus': serializer.toJson<String>(syncStatus),
    };
  }

  Task copyWith({
    int? id,
    String? customerName,
    String? customerPhone,
    String? serviceType,
    String? priority,
    DateTime? taskDateTime,
    String? address,
    String? status,
    Value<String?> notes = const Value.absent(),
    Value<double?> customerLatitude = const Value.absent(),
    Value<double?> customerLongitude = const Value.absent(),
    Value<double?> startLatitude = const Value.absent(),
    Value<double?> startLongitude = const Value.absent(),
    Value<double?> completionLatitude = const Value.absent(),
    Value<double?> completionLongitude = const Value.absent(),
    bool? customerConfirmed,
    String? syncStatus,
  }) => Task(
    id: id ?? this.id,
    customerName: customerName ?? this.customerName,
    customerPhone: customerPhone ?? this.customerPhone,
    serviceType: serviceType ?? this.serviceType,
    priority: priority ?? this.priority,
    taskDateTime: taskDateTime ?? this.taskDateTime,
    address: address ?? this.address,
    status: status ?? this.status,
    notes: notes.present ? notes.value : this.notes,
    customerLatitude: customerLatitude.present
        ? customerLatitude.value
        : this.customerLatitude,
    customerLongitude: customerLongitude.present
        ? customerLongitude.value
        : this.customerLongitude,
    startLatitude: startLatitude.present
        ? startLatitude.value
        : this.startLatitude,
    startLongitude: startLongitude.present
        ? startLongitude.value
        : this.startLongitude,
    completionLatitude: completionLatitude.present
        ? completionLatitude.value
        : this.completionLatitude,
    completionLongitude: completionLongitude.present
        ? completionLongitude.value
        : this.completionLongitude,
    customerConfirmed: customerConfirmed ?? this.customerConfirmed,
    syncStatus: syncStatus ?? this.syncStatus,
  );
  Task copyWithCompanion(TasksCompanion data) {
    return Task(
      id: data.id.present ? data.id.value : this.id,
      customerName: data.customerName.present
          ? data.customerName.value
          : this.customerName,
      customerPhone: data.customerPhone.present
          ? data.customerPhone.value
          : this.customerPhone,
      serviceType: data.serviceType.present
          ? data.serviceType.value
          : this.serviceType,
      priority: data.priority.present ? data.priority.value : this.priority,
      taskDateTime: data.taskDateTime.present
          ? data.taskDateTime.value
          : this.taskDateTime,
      address: data.address.present ? data.address.value : this.address,
      status: data.status.present ? data.status.value : this.status,
      notes: data.notes.present ? data.notes.value : this.notes,
      customerLatitude: data.customerLatitude.present
          ? data.customerLatitude.value
          : this.customerLatitude,
      customerLongitude: data.customerLongitude.present
          ? data.customerLongitude.value
          : this.customerLongitude,
      startLatitude: data.startLatitude.present
          ? data.startLatitude.value
          : this.startLatitude,
      startLongitude: data.startLongitude.present
          ? data.startLongitude.value
          : this.startLongitude,
      completionLatitude: data.completionLatitude.present
          ? data.completionLatitude.value
          : this.completionLatitude,
      completionLongitude: data.completionLongitude.present
          ? data.completionLongitude.value
          : this.completionLongitude,
      customerConfirmed: data.customerConfirmed.present
          ? data.customerConfirmed.value
          : this.customerConfirmed,
      syncStatus: data.syncStatus.present
          ? data.syncStatus.value
          : this.syncStatus,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Task(')
          ..write('id: $id, ')
          ..write('customerName: $customerName, ')
          ..write('customerPhone: $customerPhone, ')
          ..write('serviceType: $serviceType, ')
          ..write('priority: $priority, ')
          ..write('taskDateTime: $taskDateTime, ')
          ..write('address: $address, ')
          ..write('status: $status, ')
          ..write('notes: $notes, ')
          ..write('customerLatitude: $customerLatitude, ')
          ..write('customerLongitude: $customerLongitude, ')
          ..write('startLatitude: $startLatitude, ')
          ..write('startLongitude: $startLongitude, ')
          ..write('completionLatitude: $completionLatitude, ')
          ..write('completionLongitude: $completionLongitude, ')
          ..write('customerConfirmed: $customerConfirmed, ')
          ..write('syncStatus: $syncStatus')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    customerName,
    customerPhone,
    serviceType,
    priority,
    taskDateTime,
    address,
    status,
    notes,
    customerLatitude,
    customerLongitude,
    startLatitude,
    startLongitude,
    completionLatitude,
    completionLongitude,
    customerConfirmed,
    syncStatus,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Task &&
          other.id == this.id &&
          other.customerName == this.customerName &&
          other.customerPhone == this.customerPhone &&
          other.serviceType == this.serviceType &&
          other.priority == this.priority &&
          other.taskDateTime == this.taskDateTime &&
          other.address == this.address &&
          other.status == this.status &&
          other.notes == this.notes &&
          other.customerLatitude == this.customerLatitude &&
          other.customerLongitude == this.customerLongitude &&
          other.startLatitude == this.startLatitude &&
          other.startLongitude == this.startLongitude &&
          other.completionLatitude == this.completionLatitude &&
          other.completionLongitude == this.completionLongitude &&
          other.customerConfirmed == this.customerConfirmed &&
          other.syncStatus == this.syncStatus);
}

class TasksCompanion extends UpdateCompanion<Task> {
  final Value<int> id;
  final Value<String> customerName;
  final Value<String> customerPhone;
  final Value<String> serviceType;
  final Value<String> priority;
  final Value<DateTime> taskDateTime;
  final Value<String> address;
  final Value<String> status;
  final Value<String?> notes;
  final Value<double?> customerLatitude;
  final Value<double?> customerLongitude;
  final Value<double?> startLatitude;
  final Value<double?> startLongitude;
  final Value<double?> completionLatitude;
  final Value<double?> completionLongitude;
  final Value<bool> customerConfirmed;
  final Value<String> syncStatus;
  const TasksCompanion({
    this.id = const Value.absent(),
    this.customerName = const Value.absent(),
    this.customerPhone = const Value.absent(),
    this.serviceType = const Value.absent(),
    this.priority = const Value.absent(),
    this.taskDateTime = const Value.absent(),
    this.address = const Value.absent(),
    this.status = const Value.absent(),
    this.notes = const Value.absent(),
    this.customerLatitude = const Value.absent(),
    this.customerLongitude = const Value.absent(),
    this.startLatitude = const Value.absent(),
    this.startLongitude = const Value.absent(),
    this.completionLatitude = const Value.absent(),
    this.completionLongitude = const Value.absent(),
    this.customerConfirmed = const Value.absent(),
    this.syncStatus = const Value.absent(),
  });
  TasksCompanion.insert({
    this.id = const Value.absent(),
    required String customerName,
    required String customerPhone,
    required String serviceType,
    required String priority,
    required DateTime taskDateTime,
    required String address,
    required String status,
    this.notes = const Value.absent(),
    this.customerLatitude = const Value.absent(),
    this.customerLongitude = const Value.absent(),
    this.startLatitude = const Value.absent(),
    this.startLongitude = const Value.absent(),
    this.completionLatitude = const Value.absent(),
    this.completionLongitude = const Value.absent(),
    this.customerConfirmed = const Value.absent(),
    this.syncStatus = const Value.absent(),
  }) : customerName = Value(customerName),
       customerPhone = Value(customerPhone),
       serviceType = Value(serviceType),
       priority = Value(priority),
       taskDateTime = Value(taskDateTime),
       address = Value(address),
       status = Value(status);
  static Insertable<Task> custom({
    Expression<int>? id,
    Expression<String>? customerName,
    Expression<String>? customerPhone,
    Expression<String>? serviceType,
    Expression<String>? priority,
    Expression<DateTime>? taskDateTime,
    Expression<String>? address,
    Expression<String>? status,
    Expression<String>? notes,
    Expression<double>? customerLatitude,
    Expression<double>? customerLongitude,
    Expression<double>? startLatitude,
    Expression<double>? startLongitude,
    Expression<double>? completionLatitude,
    Expression<double>? completionLongitude,
    Expression<bool>? customerConfirmed,
    Expression<String>? syncStatus,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (customerName != null) 'customer_name': customerName,
      if (customerPhone != null) 'customer_phone': customerPhone,
      if (serviceType != null) 'service_type': serviceType,
      if (priority != null) 'priority': priority,
      if (taskDateTime != null) 'task_date_time': taskDateTime,
      if (address != null) 'address': address,
      if (status != null) 'status': status,
      if (notes != null) 'notes': notes,
      if (customerLatitude != null) 'customer_latitude': customerLatitude,
      if (customerLongitude != null) 'customer_longitude': customerLongitude,
      if (startLatitude != null) 'start_latitude': startLatitude,
      if (startLongitude != null) 'start_longitude': startLongitude,
      if (completionLatitude != null) 'completion_latitude': completionLatitude,
      if (completionLongitude != null)
        'completion_longitude': completionLongitude,
      if (customerConfirmed != null) 'customer_confirmed': customerConfirmed,
      if (syncStatus != null) 'sync_status': syncStatus,
    });
  }

  TasksCompanion copyWith({
    Value<int>? id,
    Value<String>? customerName,
    Value<String>? customerPhone,
    Value<String>? serviceType,
    Value<String>? priority,
    Value<DateTime>? taskDateTime,
    Value<String>? address,
    Value<String>? status,
    Value<String?>? notes,
    Value<double?>? customerLatitude,
    Value<double?>? customerLongitude,
    Value<double?>? startLatitude,
    Value<double?>? startLongitude,
    Value<double?>? completionLatitude,
    Value<double?>? completionLongitude,
    Value<bool>? customerConfirmed,
    Value<String>? syncStatus,
  }) {
    return TasksCompanion(
      id: id ?? this.id,
      customerName: customerName ?? this.customerName,
      customerPhone: customerPhone ?? this.customerPhone,
      serviceType: serviceType ?? this.serviceType,
      priority: priority ?? this.priority,
      taskDateTime: taskDateTime ?? this.taskDateTime,
      address: address ?? this.address,
      status: status ?? this.status,
      notes: notes ?? this.notes,
      customerLatitude: customerLatitude ?? this.customerLatitude,
      customerLongitude: customerLongitude ?? this.customerLongitude,
      startLatitude: startLatitude ?? this.startLatitude,
      startLongitude: startLongitude ?? this.startLongitude,
      completionLatitude: completionLatitude ?? this.completionLatitude,
      completionLongitude: completionLongitude ?? this.completionLongitude,
      customerConfirmed: customerConfirmed ?? this.customerConfirmed,
      syncStatus: syncStatus ?? this.syncStatus,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (customerName.present) {
      map['customer_name'] = Variable<String>(customerName.value);
    }
    if (customerPhone.present) {
      map['customer_phone'] = Variable<String>(customerPhone.value);
    }
    if (serviceType.present) {
      map['service_type'] = Variable<String>(serviceType.value);
    }
    if (priority.present) {
      map['priority'] = Variable<String>(priority.value);
    }
    if (taskDateTime.present) {
      map['task_date_time'] = Variable<DateTime>(taskDateTime.value);
    }
    if (address.present) {
      map['address'] = Variable<String>(address.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (customerLatitude.present) {
      map['customer_latitude'] = Variable<double>(customerLatitude.value);
    }
    if (customerLongitude.present) {
      map['customer_longitude'] = Variable<double>(customerLongitude.value);
    }
    if (startLatitude.present) {
      map['start_latitude'] = Variable<double>(startLatitude.value);
    }
    if (startLongitude.present) {
      map['start_longitude'] = Variable<double>(startLongitude.value);
    }
    if (completionLatitude.present) {
      map['completion_latitude'] = Variable<double>(completionLatitude.value);
    }
    if (completionLongitude.present) {
      map['completion_longitude'] = Variable<double>(completionLongitude.value);
    }
    if (customerConfirmed.present) {
      map['customer_confirmed'] = Variable<bool>(customerConfirmed.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<String>(syncStatus.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TasksCompanion(')
          ..write('id: $id, ')
          ..write('customerName: $customerName, ')
          ..write('customerPhone: $customerPhone, ')
          ..write('serviceType: $serviceType, ')
          ..write('priority: $priority, ')
          ..write('taskDateTime: $taskDateTime, ')
          ..write('address: $address, ')
          ..write('status: $status, ')
          ..write('notes: $notes, ')
          ..write('customerLatitude: $customerLatitude, ')
          ..write('customerLongitude: $customerLongitude, ')
          ..write('startLatitude: $startLatitude, ')
          ..write('startLongitude: $startLongitude, ')
          ..write('completionLatitude: $completionLatitude, ')
          ..write('completionLongitude: $completionLongitude, ')
          ..write('customerConfirmed: $customerConfirmed, ')
          ..write('syncStatus: $syncStatus')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $TasksTable tasks = $TasksTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [tasks];
}

typedef $$TasksTableCreateCompanionBuilder =
    TasksCompanion Function({
      Value<int> id,
      required String customerName,
      required String customerPhone,
      required String serviceType,
      required String priority,
      required DateTime taskDateTime,
      required String address,
      required String status,
      Value<String?> notes,
      Value<double?> customerLatitude,
      Value<double?> customerLongitude,
      Value<double?> startLatitude,
      Value<double?> startLongitude,
      Value<double?> completionLatitude,
      Value<double?> completionLongitude,
      Value<bool> customerConfirmed,
      Value<String> syncStatus,
    });
typedef $$TasksTableUpdateCompanionBuilder =
    TasksCompanion Function({
      Value<int> id,
      Value<String> customerName,
      Value<String> customerPhone,
      Value<String> serviceType,
      Value<String> priority,
      Value<DateTime> taskDateTime,
      Value<String> address,
      Value<String> status,
      Value<String?> notes,
      Value<double?> customerLatitude,
      Value<double?> customerLongitude,
      Value<double?> startLatitude,
      Value<double?> startLongitude,
      Value<double?> completionLatitude,
      Value<double?> completionLongitude,
      Value<bool> customerConfirmed,
      Value<String> syncStatus,
    });

class $$TasksTableFilterComposer extends Composer<_$AppDatabase, $TasksTable> {
  $$TasksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get customerName => $composableBuilder(
    column: $table.customerName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get customerPhone => $composableBuilder(
    column: $table.customerPhone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get serviceType => $composableBuilder(
    column: $table.serviceType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get priority => $composableBuilder(
    column: $table.priority,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get taskDateTime => $composableBuilder(
    column: $table.taskDateTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get address => $composableBuilder(
    column: $table.address,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get customerLatitude => $composableBuilder(
    column: $table.customerLatitude,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get customerLongitude => $composableBuilder(
    column: $table.customerLongitude,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get startLatitude => $composableBuilder(
    column: $table.startLatitude,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get startLongitude => $composableBuilder(
    column: $table.startLongitude,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get completionLatitude => $composableBuilder(
    column: $table.completionLatitude,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get completionLongitude => $composableBuilder(
    column: $table.completionLongitude,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get customerConfirmed => $composableBuilder(
    column: $table.customerConfirmed,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnFilters(column),
  );
}

class $$TasksTableOrderingComposer
    extends Composer<_$AppDatabase, $TasksTable> {
  $$TasksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get customerName => $composableBuilder(
    column: $table.customerName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get customerPhone => $composableBuilder(
    column: $table.customerPhone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get serviceType => $composableBuilder(
    column: $table.serviceType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get priority => $composableBuilder(
    column: $table.priority,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get taskDateTime => $composableBuilder(
    column: $table.taskDateTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get address => $composableBuilder(
    column: $table.address,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get customerLatitude => $composableBuilder(
    column: $table.customerLatitude,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get customerLongitude => $composableBuilder(
    column: $table.customerLongitude,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get startLatitude => $composableBuilder(
    column: $table.startLatitude,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get startLongitude => $composableBuilder(
    column: $table.startLongitude,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get completionLatitude => $composableBuilder(
    column: $table.completionLatitude,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get completionLongitude => $composableBuilder(
    column: $table.completionLongitude,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get customerConfirmed => $composableBuilder(
    column: $table.customerConfirmed,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TasksTableAnnotationComposer
    extends Composer<_$AppDatabase, $TasksTable> {
  $$TasksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get customerName => $composableBuilder(
    column: $table.customerName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get customerPhone => $composableBuilder(
    column: $table.customerPhone,
    builder: (column) => column,
  );

  GeneratedColumn<String> get serviceType => $composableBuilder(
    column: $table.serviceType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get priority =>
      $composableBuilder(column: $table.priority, builder: (column) => column);

  GeneratedColumn<DateTime> get taskDateTime => $composableBuilder(
    column: $table.taskDateTime,
    builder: (column) => column,
  );

  GeneratedColumn<String> get address =>
      $composableBuilder(column: $table.address, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<double> get customerLatitude => $composableBuilder(
    column: $table.customerLatitude,
    builder: (column) => column,
  );

  GeneratedColumn<double> get customerLongitude => $composableBuilder(
    column: $table.customerLongitude,
    builder: (column) => column,
  );

  GeneratedColumn<double> get startLatitude => $composableBuilder(
    column: $table.startLatitude,
    builder: (column) => column,
  );

  GeneratedColumn<double> get startLongitude => $composableBuilder(
    column: $table.startLongitude,
    builder: (column) => column,
  );

  GeneratedColumn<double> get completionLatitude => $composableBuilder(
    column: $table.completionLatitude,
    builder: (column) => column,
  );

  GeneratedColumn<double> get completionLongitude => $composableBuilder(
    column: $table.completionLongitude,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get customerConfirmed => $composableBuilder(
    column: $table.customerConfirmed,
    builder: (column) => column,
  );

  GeneratedColumn<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => column,
  );
}

class $$TasksTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TasksTable,
          Task,
          $$TasksTableFilterComposer,
          $$TasksTableOrderingComposer,
          $$TasksTableAnnotationComposer,
          $$TasksTableCreateCompanionBuilder,
          $$TasksTableUpdateCompanionBuilder,
          (Task, BaseReferences<_$AppDatabase, $TasksTable, Task>),
          Task,
          PrefetchHooks Function()
        > {
  $$TasksTableTableManager(_$AppDatabase db, $TasksTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TasksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TasksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TasksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> customerName = const Value.absent(),
                Value<String> customerPhone = const Value.absent(),
                Value<String> serviceType = const Value.absent(),
                Value<String> priority = const Value.absent(),
                Value<DateTime> taskDateTime = const Value.absent(),
                Value<String> address = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<double?> customerLatitude = const Value.absent(),
                Value<double?> customerLongitude = const Value.absent(),
                Value<double?> startLatitude = const Value.absent(),
                Value<double?> startLongitude = const Value.absent(),
                Value<double?> completionLatitude = const Value.absent(),
                Value<double?> completionLongitude = const Value.absent(),
                Value<bool> customerConfirmed = const Value.absent(),
                Value<String> syncStatus = const Value.absent(),
              }) => TasksCompanion(
                id: id,
                customerName: customerName,
                customerPhone: customerPhone,
                serviceType: serviceType,
                priority: priority,
                taskDateTime: taskDateTime,
                address: address,
                status: status,
                notes: notes,
                customerLatitude: customerLatitude,
                customerLongitude: customerLongitude,
                startLatitude: startLatitude,
                startLongitude: startLongitude,
                completionLatitude: completionLatitude,
                completionLongitude: completionLongitude,
                customerConfirmed: customerConfirmed,
                syncStatus: syncStatus,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String customerName,
                required String customerPhone,
                required String serviceType,
                required String priority,
                required DateTime taskDateTime,
                required String address,
                required String status,
                Value<String?> notes = const Value.absent(),
                Value<double?> customerLatitude = const Value.absent(),
                Value<double?> customerLongitude = const Value.absent(),
                Value<double?> startLatitude = const Value.absent(),
                Value<double?> startLongitude = const Value.absent(),
                Value<double?> completionLatitude = const Value.absent(),
                Value<double?> completionLongitude = const Value.absent(),
                Value<bool> customerConfirmed = const Value.absent(),
                Value<String> syncStatus = const Value.absent(),
              }) => TasksCompanion.insert(
                id: id,
                customerName: customerName,
                customerPhone: customerPhone,
                serviceType: serviceType,
                priority: priority,
                taskDateTime: taskDateTime,
                address: address,
                status: status,
                notes: notes,
                customerLatitude: customerLatitude,
                customerLongitude: customerLongitude,
                startLatitude: startLatitude,
                startLongitude: startLongitude,
                completionLatitude: completionLatitude,
                completionLongitude: completionLongitude,
                customerConfirmed: customerConfirmed,
                syncStatus: syncStatus,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$TasksTable, Task>(table),
                  BaseReferences<_$AppDatabase, $TasksTable, Task>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$TasksTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TasksTable,
      Task,
      $$TasksTableFilterComposer,
      $$TasksTableOrderingComposer,
      $$TasksTableAnnotationComposer,
      $$TasksTableCreateCompanionBuilder,
      $$TasksTableUpdateCompanionBuilder,
      (Task, BaseReferences<_$AppDatabase, $TasksTable, Task>),
      Task,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$TasksTableTableManager get tasks =>
      $$TasksTableTableManager(_db, _db.tasks);
}
