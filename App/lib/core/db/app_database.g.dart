// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $CategoriesTableTable extends CategoriesTable
    with TableInfo<$CategoriesTableTable, CategoriesTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CategoriesTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _serverIdMeta = const VerificationMeta(
    'serverId',
  );
  @override
  late final GeneratedColumn<int> serverId = GeneratedColumn<int>(
    'server_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 50,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _iconMeta = const VerificationMeta('icon');
  @override
  late final GeneratedColumn<String> icon = GeneratedColumn<String>(
    'icon',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _colorMeta = const VerificationMeta('color');
  @override
  late final GeneratedColumn<String> color = GeneratedColumn<String>(
    'color',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isDeletedMeta = const VerificationMeta(
    'isDeleted',
  );
  @override
  late final GeneratedColumn<bool> isDeleted = GeneratedColumn<bool>(
    'is_deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_deleted" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    serverId,
    name,
    icon,
    color,
    updatedAt,
    isDeleted,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'categories_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<CategoriesTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('server_id')) {
      context.handle(
        _serverIdMeta,
        serverId.isAcceptableOrUnknown(data['server_id']!, _serverIdMeta),
      );
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('icon')) {
      context.handle(
        _iconMeta,
        icon.isAcceptableOrUnknown(data['icon']!, _iconMeta),
      );
    } else if (isInserting) {
      context.missing(_iconMeta);
    }
    if (data.containsKey('color')) {
      context.handle(
        _colorMeta,
        color.isAcceptableOrUnknown(data['color']!, _colorMeta),
      );
    } else if (isInserting) {
      context.missing(_colorMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('is_deleted')) {
      context.handle(
        _isDeletedMeta,
        isDeleted.isAcceptableOrUnknown(data['is_deleted']!, _isDeletedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CategoriesTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CategoriesTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      serverId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}server_id'],
      ),
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      icon: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}icon'],
      )!,
      color: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}color'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      isDeleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_deleted'],
      )!,
    );
  }

  @override
  $CategoriesTableTable createAlias(String alias) {
    return $CategoriesTableTable(attachedDatabase, alias);
  }
}

class CategoriesTableData extends DataClass
    implements Insertable<CategoriesTableData> {
  final int id;
  final int? serverId;
  final String name;
  final String icon;
  final String color;
  final DateTime updatedAt;
  final bool isDeleted;
  const CategoriesTableData({
    required this.id,
    this.serverId,
    required this.name,
    required this.icon,
    required this.color,
    required this.updatedAt,
    required this.isDeleted,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || serverId != null) {
      map['server_id'] = Variable<int>(serverId);
    }
    map['name'] = Variable<String>(name);
    map['icon'] = Variable<String>(icon);
    map['color'] = Variable<String>(color);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['is_deleted'] = Variable<bool>(isDeleted);
    return map;
  }

  CategoriesTableCompanion toCompanion(bool nullToAbsent) {
    return CategoriesTableCompanion(
      id: Value(id),
      serverId: serverId == null && nullToAbsent
          ? const Value.absent()
          : Value(serverId),
      name: Value(name),
      icon: Value(icon),
      color: Value(color),
      updatedAt: Value(updatedAt),
      isDeleted: Value(isDeleted),
    );
  }

  factory CategoriesTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CategoriesTableData(
      id: serializer.fromJson<int>(json['id']),
      serverId: serializer.fromJson<int?>(json['serverId']),
      name: serializer.fromJson<String>(json['name']),
      icon: serializer.fromJson<String>(json['icon']),
      color: serializer.fromJson<String>(json['color']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      isDeleted: serializer.fromJson<bool>(json['isDeleted']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'serverId': serializer.toJson<int?>(serverId),
      'name': serializer.toJson<String>(name),
      'icon': serializer.toJson<String>(icon),
      'color': serializer.toJson<String>(color),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'isDeleted': serializer.toJson<bool>(isDeleted),
    };
  }

  CategoriesTableData copyWith({
    int? id,
    Value<int?> serverId = const Value.absent(),
    String? name,
    String? icon,
    String? color,
    DateTime? updatedAt,
    bool? isDeleted,
  }) => CategoriesTableData(
    id: id ?? this.id,
    serverId: serverId.present ? serverId.value : this.serverId,
    name: name ?? this.name,
    icon: icon ?? this.icon,
    color: color ?? this.color,
    updatedAt: updatedAt ?? this.updatedAt,
    isDeleted: isDeleted ?? this.isDeleted,
  );
  CategoriesTableData copyWithCompanion(CategoriesTableCompanion data) {
    return CategoriesTableData(
      id: data.id.present ? data.id.value : this.id,
      serverId: data.serverId.present ? data.serverId.value : this.serverId,
      name: data.name.present ? data.name.value : this.name,
      icon: data.icon.present ? data.icon.value : this.icon,
      color: data.color.present ? data.color.value : this.color,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CategoriesTableData(')
          ..write('id: $id, ')
          ..write('serverId: $serverId, ')
          ..write('name: $name, ')
          ..write('icon: $icon, ')
          ..write('color: $color, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('isDeleted: $isDeleted')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, serverId, name, icon, color, updatedAt, isDeleted);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CategoriesTableData &&
          other.id == this.id &&
          other.serverId == this.serverId &&
          other.name == this.name &&
          other.icon == this.icon &&
          other.color == this.color &&
          other.updatedAt == this.updatedAt &&
          other.isDeleted == this.isDeleted);
}

class CategoriesTableCompanion extends UpdateCompanion<CategoriesTableData> {
  final Value<int> id;
  final Value<int?> serverId;
  final Value<String> name;
  final Value<String> icon;
  final Value<String> color;
  final Value<DateTime> updatedAt;
  final Value<bool> isDeleted;
  const CategoriesTableCompanion({
    this.id = const Value.absent(),
    this.serverId = const Value.absent(),
    this.name = const Value.absent(),
    this.icon = const Value.absent(),
    this.color = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.isDeleted = const Value.absent(),
  });
  CategoriesTableCompanion.insert({
    this.id = const Value.absent(),
    this.serverId = const Value.absent(),
    required String name,
    required String icon,
    required String color,
    required DateTime updatedAt,
    this.isDeleted = const Value.absent(),
  }) : name = Value(name),
       icon = Value(icon),
       color = Value(color),
       updatedAt = Value(updatedAt);
  static Insertable<CategoriesTableData> custom({
    Expression<int>? id,
    Expression<int>? serverId,
    Expression<String>? name,
    Expression<String>? icon,
    Expression<String>? color,
    Expression<DateTime>? updatedAt,
    Expression<bool>? isDeleted,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (serverId != null) 'server_id': serverId,
      if (name != null) 'name': name,
      if (icon != null) 'icon': icon,
      if (color != null) 'color': color,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (isDeleted != null) 'is_deleted': isDeleted,
    });
  }

  CategoriesTableCompanion copyWith({
    Value<int>? id,
    Value<int?>? serverId,
    Value<String>? name,
    Value<String>? icon,
    Value<String>? color,
    Value<DateTime>? updatedAt,
    Value<bool>? isDeleted,
  }) {
    return CategoriesTableCompanion(
      id: id ?? this.id,
      serverId: serverId ?? this.serverId,
      name: name ?? this.name,
      icon: icon ?? this.icon,
      color: color ?? this.color,
      updatedAt: updatedAt ?? this.updatedAt,
      isDeleted: isDeleted ?? this.isDeleted,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (serverId.present) {
      map['server_id'] = Variable<int>(serverId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (icon.present) {
      map['icon'] = Variable<String>(icon.value);
    }
    if (color.present) {
      map['color'] = Variable<String>(color.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (isDeleted.present) {
      map['is_deleted'] = Variable<bool>(isDeleted.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CategoriesTableCompanion(')
          ..write('id: $id, ')
          ..write('serverId: $serverId, ')
          ..write('name: $name, ')
          ..write('icon: $icon, ')
          ..write('color: $color, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('isDeleted: $isDeleted')
          ..write(')'))
        .toString();
  }
}

class $HabitsTableTable extends HabitsTable
    with TableInfo<$HabitsTableTable, HabitsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $HabitsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _serverIdMeta = const VerificationMeta(
    'serverId',
  );
  @override
  late final GeneratedColumn<int> serverId = GeneratedColumn<int>(
    'server_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 50,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryIdMeta = const VerificationMeta(
    'categoryId',
  );
  @override
  late final GeneratedColumn<int> categoryId = GeneratedColumn<int>(
    'category_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES categories_table (id)',
    ),
  );
  static const VerificationMeta _frequencyTypeMeta = const VerificationMeta(
    'frequencyType',
  );
  @override
  late final GeneratedColumn<int> frequencyType = GeneratedColumn<int>(
    'frequency_type',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _intervalDaysMeta = const VerificationMeta(
    'intervalDays',
  );
  @override
  late final GeneratedColumn<int> intervalDays = GeneratedColumn<int>(
    'interval_days',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _dayOfMonthMeta = const VerificationMeta(
    'dayOfMonth',
  );
  @override
  late final GeneratedColumn<int> dayOfMonth = GeneratedColumn<int>(
    'day_of_month',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _dayOfWeekMeta = const VerificationMeta(
    'dayOfWeek',
  );
  @override
  late final GeneratedColumn<int> dayOfWeek = GeneratedColumn<int>(
    'day_of_week',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _startDateMeta = const VerificationMeta(
    'startDate',
  );
  @override
  late final GeneratedColumn<DateTime> startDate = GeneratedColumn<DateTime>(
    'start_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isDeletedMeta = const VerificationMeta(
    'isDeleted',
  );
  @override
  late final GeneratedColumn<bool> isDeleted = GeneratedColumn<bool>(
    'is_deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_deleted" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    serverId,
    name,
    categoryId,
    frequencyType,
    intervalDays,
    dayOfMonth,
    dayOfWeek,
    startDate,
    updatedAt,
    isDeleted,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'habits_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<HabitsTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('server_id')) {
      context.handle(
        _serverIdMeta,
        serverId.isAcceptableOrUnknown(data['server_id']!, _serverIdMeta),
      );
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('category_id')) {
      context.handle(
        _categoryIdMeta,
        categoryId.isAcceptableOrUnknown(data['category_id']!, _categoryIdMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryIdMeta);
    }
    if (data.containsKey('frequency_type')) {
      context.handle(
        _frequencyTypeMeta,
        frequencyType.isAcceptableOrUnknown(
          data['frequency_type']!,
          _frequencyTypeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_frequencyTypeMeta);
    }
    if (data.containsKey('interval_days')) {
      context.handle(
        _intervalDaysMeta,
        intervalDays.isAcceptableOrUnknown(
          data['interval_days']!,
          _intervalDaysMeta,
        ),
      );
    }
    if (data.containsKey('day_of_month')) {
      context.handle(
        _dayOfMonthMeta,
        dayOfMonth.isAcceptableOrUnknown(
          data['day_of_month']!,
          _dayOfMonthMeta,
        ),
      );
    }
    if (data.containsKey('day_of_week')) {
      context.handle(
        _dayOfWeekMeta,
        dayOfWeek.isAcceptableOrUnknown(data['day_of_week']!, _dayOfWeekMeta),
      );
    }
    if (data.containsKey('start_date')) {
      context.handle(
        _startDateMeta,
        startDate.isAcceptableOrUnknown(data['start_date']!, _startDateMeta),
      );
    } else if (isInserting) {
      context.missing(_startDateMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('is_deleted')) {
      context.handle(
        _isDeletedMeta,
        isDeleted.isAcceptableOrUnknown(data['is_deleted']!, _isDeletedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  HabitsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return HabitsTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      serverId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}server_id'],
      ),
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      categoryId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}category_id'],
      )!,
      frequencyType: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}frequency_type'],
      )!,
      intervalDays: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}interval_days'],
      ),
      dayOfMonth: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}day_of_month'],
      ),
      dayOfWeek: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}day_of_week'],
      ),
      startDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}start_date'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      isDeleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_deleted'],
      )!,
    );
  }

  @override
  $HabitsTableTable createAlias(String alias) {
    return $HabitsTableTable(attachedDatabase, alias);
  }
}

class HabitsTableData extends DataClass implements Insertable<HabitsTableData> {
  final int id;
  final int? serverId;
  final String name;
  final int categoryId;

  /// Matches Core's HabitFrequencyType enum values (EveryNDays=1, DayOfMonth=2, DayOfWeek=3).
  final int frequencyType;
  final int? intervalDays;
  final int? dayOfMonth;

  /// .NET DayOfWeek encoding (Sunday=0..Saturday=6), matching Core's wire format.
  final int? dayOfWeek;
  final DateTime startDate;
  final DateTime updatedAt;
  final bool isDeleted;
  const HabitsTableData({
    required this.id,
    this.serverId,
    required this.name,
    required this.categoryId,
    required this.frequencyType,
    this.intervalDays,
    this.dayOfMonth,
    this.dayOfWeek,
    required this.startDate,
    required this.updatedAt,
    required this.isDeleted,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || serverId != null) {
      map['server_id'] = Variable<int>(serverId);
    }
    map['name'] = Variable<String>(name);
    map['category_id'] = Variable<int>(categoryId);
    map['frequency_type'] = Variable<int>(frequencyType);
    if (!nullToAbsent || intervalDays != null) {
      map['interval_days'] = Variable<int>(intervalDays);
    }
    if (!nullToAbsent || dayOfMonth != null) {
      map['day_of_month'] = Variable<int>(dayOfMonth);
    }
    if (!nullToAbsent || dayOfWeek != null) {
      map['day_of_week'] = Variable<int>(dayOfWeek);
    }
    map['start_date'] = Variable<DateTime>(startDate);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['is_deleted'] = Variable<bool>(isDeleted);
    return map;
  }

  HabitsTableCompanion toCompanion(bool nullToAbsent) {
    return HabitsTableCompanion(
      id: Value(id),
      serverId: serverId == null && nullToAbsent
          ? const Value.absent()
          : Value(serverId),
      name: Value(name),
      categoryId: Value(categoryId),
      frequencyType: Value(frequencyType),
      intervalDays: intervalDays == null && nullToAbsent
          ? const Value.absent()
          : Value(intervalDays),
      dayOfMonth: dayOfMonth == null && nullToAbsent
          ? const Value.absent()
          : Value(dayOfMonth),
      dayOfWeek: dayOfWeek == null && nullToAbsent
          ? const Value.absent()
          : Value(dayOfWeek),
      startDate: Value(startDate),
      updatedAt: Value(updatedAt),
      isDeleted: Value(isDeleted),
    );
  }

  factory HabitsTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return HabitsTableData(
      id: serializer.fromJson<int>(json['id']),
      serverId: serializer.fromJson<int?>(json['serverId']),
      name: serializer.fromJson<String>(json['name']),
      categoryId: serializer.fromJson<int>(json['categoryId']),
      frequencyType: serializer.fromJson<int>(json['frequencyType']),
      intervalDays: serializer.fromJson<int?>(json['intervalDays']),
      dayOfMonth: serializer.fromJson<int?>(json['dayOfMonth']),
      dayOfWeek: serializer.fromJson<int?>(json['dayOfWeek']),
      startDate: serializer.fromJson<DateTime>(json['startDate']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      isDeleted: serializer.fromJson<bool>(json['isDeleted']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'serverId': serializer.toJson<int?>(serverId),
      'name': serializer.toJson<String>(name),
      'categoryId': serializer.toJson<int>(categoryId),
      'frequencyType': serializer.toJson<int>(frequencyType),
      'intervalDays': serializer.toJson<int?>(intervalDays),
      'dayOfMonth': serializer.toJson<int?>(dayOfMonth),
      'dayOfWeek': serializer.toJson<int?>(dayOfWeek),
      'startDate': serializer.toJson<DateTime>(startDate),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'isDeleted': serializer.toJson<bool>(isDeleted),
    };
  }

  HabitsTableData copyWith({
    int? id,
    Value<int?> serverId = const Value.absent(),
    String? name,
    int? categoryId,
    int? frequencyType,
    Value<int?> intervalDays = const Value.absent(),
    Value<int?> dayOfMonth = const Value.absent(),
    Value<int?> dayOfWeek = const Value.absent(),
    DateTime? startDate,
    DateTime? updatedAt,
    bool? isDeleted,
  }) => HabitsTableData(
    id: id ?? this.id,
    serverId: serverId.present ? serverId.value : this.serverId,
    name: name ?? this.name,
    categoryId: categoryId ?? this.categoryId,
    frequencyType: frequencyType ?? this.frequencyType,
    intervalDays: intervalDays.present ? intervalDays.value : this.intervalDays,
    dayOfMonth: dayOfMonth.present ? dayOfMonth.value : this.dayOfMonth,
    dayOfWeek: dayOfWeek.present ? dayOfWeek.value : this.dayOfWeek,
    startDate: startDate ?? this.startDate,
    updatedAt: updatedAt ?? this.updatedAt,
    isDeleted: isDeleted ?? this.isDeleted,
  );
  HabitsTableData copyWithCompanion(HabitsTableCompanion data) {
    return HabitsTableData(
      id: data.id.present ? data.id.value : this.id,
      serverId: data.serverId.present ? data.serverId.value : this.serverId,
      name: data.name.present ? data.name.value : this.name,
      categoryId: data.categoryId.present
          ? data.categoryId.value
          : this.categoryId,
      frequencyType: data.frequencyType.present
          ? data.frequencyType.value
          : this.frequencyType,
      intervalDays: data.intervalDays.present
          ? data.intervalDays.value
          : this.intervalDays,
      dayOfMonth: data.dayOfMonth.present
          ? data.dayOfMonth.value
          : this.dayOfMonth,
      dayOfWeek: data.dayOfWeek.present ? data.dayOfWeek.value : this.dayOfWeek,
      startDate: data.startDate.present ? data.startDate.value : this.startDate,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,
    );
  }

  @override
  String toString() {
    return (StringBuffer('HabitsTableData(')
          ..write('id: $id, ')
          ..write('serverId: $serverId, ')
          ..write('name: $name, ')
          ..write('categoryId: $categoryId, ')
          ..write('frequencyType: $frequencyType, ')
          ..write('intervalDays: $intervalDays, ')
          ..write('dayOfMonth: $dayOfMonth, ')
          ..write('dayOfWeek: $dayOfWeek, ')
          ..write('startDate: $startDate, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('isDeleted: $isDeleted')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    serverId,
    name,
    categoryId,
    frequencyType,
    intervalDays,
    dayOfMonth,
    dayOfWeek,
    startDate,
    updatedAt,
    isDeleted,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is HabitsTableData &&
          other.id == this.id &&
          other.serverId == this.serverId &&
          other.name == this.name &&
          other.categoryId == this.categoryId &&
          other.frequencyType == this.frequencyType &&
          other.intervalDays == this.intervalDays &&
          other.dayOfMonth == this.dayOfMonth &&
          other.dayOfWeek == this.dayOfWeek &&
          other.startDate == this.startDate &&
          other.updatedAt == this.updatedAt &&
          other.isDeleted == this.isDeleted);
}

class HabitsTableCompanion extends UpdateCompanion<HabitsTableData> {
  final Value<int> id;
  final Value<int?> serverId;
  final Value<String> name;
  final Value<int> categoryId;
  final Value<int> frequencyType;
  final Value<int?> intervalDays;
  final Value<int?> dayOfMonth;
  final Value<int?> dayOfWeek;
  final Value<DateTime> startDate;
  final Value<DateTime> updatedAt;
  final Value<bool> isDeleted;
  const HabitsTableCompanion({
    this.id = const Value.absent(),
    this.serverId = const Value.absent(),
    this.name = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.frequencyType = const Value.absent(),
    this.intervalDays = const Value.absent(),
    this.dayOfMonth = const Value.absent(),
    this.dayOfWeek = const Value.absent(),
    this.startDate = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.isDeleted = const Value.absent(),
  });
  HabitsTableCompanion.insert({
    this.id = const Value.absent(),
    this.serverId = const Value.absent(),
    required String name,
    required int categoryId,
    required int frequencyType,
    this.intervalDays = const Value.absent(),
    this.dayOfMonth = const Value.absent(),
    this.dayOfWeek = const Value.absent(),
    required DateTime startDate,
    required DateTime updatedAt,
    this.isDeleted = const Value.absent(),
  }) : name = Value(name),
       categoryId = Value(categoryId),
       frequencyType = Value(frequencyType),
       startDate = Value(startDate),
       updatedAt = Value(updatedAt);
  static Insertable<HabitsTableData> custom({
    Expression<int>? id,
    Expression<int>? serverId,
    Expression<String>? name,
    Expression<int>? categoryId,
    Expression<int>? frequencyType,
    Expression<int>? intervalDays,
    Expression<int>? dayOfMonth,
    Expression<int>? dayOfWeek,
    Expression<DateTime>? startDate,
    Expression<DateTime>? updatedAt,
    Expression<bool>? isDeleted,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (serverId != null) 'server_id': serverId,
      if (name != null) 'name': name,
      if (categoryId != null) 'category_id': categoryId,
      if (frequencyType != null) 'frequency_type': frequencyType,
      if (intervalDays != null) 'interval_days': intervalDays,
      if (dayOfMonth != null) 'day_of_month': dayOfMonth,
      if (dayOfWeek != null) 'day_of_week': dayOfWeek,
      if (startDate != null) 'start_date': startDate,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (isDeleted != null) 'is_deleted': isDeleted,
    });
  }

  HabitsTableCompanion copyWith({
    Value<int>? id,
    Value<int?>? serverId,
    Value<String>? name,
    Value<int>? categoryId,
    Value<int>? frequencyType,
    Value<int?>? intervalDays,
    Value<int?>? dayOfMonth,
    Value<int?>? dayOfWeek,
    Value<DateTime>? startDate,
    Value<DateTime>? updatedAt,
    Value<bool>? isDeleted,
  }) {
    return HabitsTableCompanion(
      id: id ?? this.id,
      serverId: serverId ?? this.serverId,
      name: name ?? this.name,
      categoryId: categoryId ?? this.categoryId,
      frequencyType: frequencyType ?? this.frequencyType,
      intervalDays: intervalDays ?? this.intervalDays,
      dayOfMonth: dayOfMonth ?? this.dayOfMonth,
      dayOfWeek: dayOfWeek ?? this.dayOfWeek,
      startDate: startDate ?? this.startDate,
      updatedAt: updatedAt ?? this.updatedAt,
      isDeleted: isDeleted ?? this.isDeleted,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (serverId.present) {
      map['server_id'] = Variable<int>(serverId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<int>(categoryId.value);
    }
    if (frequencyType.present) {
      map['frequency_type'] = Variable<int>(frequencyType.value);
    }
    if (intervalDays.present) {
      map['interval_days'] = Variable<int>(intervalDays.value);
    }
    if (dayOfMonth.present) {
      map['day_of_month'] = Variable<int>(dayOfMonth.value);
    }
    if (dayOfWeek.present) {
      map['day_of_week'] = Variable<int>(dayOfWeek.value);
    }
    if (startDate.present) {
      map['start_date'] = Variable<DateTime>(startDate.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (isDeleted.present) {
      map['is_deleted'] = Variable<bool>(isDeleted.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('HabitsTableCompanion(')
          ..write('id: $id, ')
          ..write('serverId: $serverId, ')
          ..write('name: $name, ')
          ..write('categoryId: $categoryId, ')
          ..write('frequencyType: $frequencyType, ')
          ..write('intervalDays: $intervalDays, ')
          ..write('dayOfMonth: $dayOfMonth, ')
          ..write('dayOfWeek: $dayOfWeek, ')
          ..write('startDate: $startDate, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('isDeleted: $isDeleted')
          ..write(')'))
        .toString();
  }
}

class $HabitEntriesTableTable extends HabitEntriesTable
    with TableInfo<$HabitEntriesTableTable, HabitEntriesTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $HabitEntriesTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _serverIdMeta = const VerificationMeta(
    'serverId',
  );
  @override
  late final GeneratedColumn<int> serverId = GeneratedColumn<int>(
    'server_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _habitIdMeta = const VerificationMeta(
    'habitId',
  );
  @override
  late final GeneratedColumn<int> habitId = GeneratedColumn<int>(
    'habit_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES habits_table (id)',
    ),
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
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
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isDeletedMeta = const VerificationMeta(
    'isDeleted',
  );
  @override
  late final GeneratedColumn<bool> isDeleted = GeneratedColumn<bool>(
    'is_deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_deleted" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    serverId,
    habitId,
    date,
    status,
    updatedAt,
    isDeleted,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'habit_entries_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<HabitEntriesTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('server_id')) {
      context.handle(
        _serverIdMeta,
        serverId.isAcceptableOrUnknown(data['server_id']!, _serverIdMeta),
      );
    }
    if (data.containsKey('habit_id')) {
      context.handle(
        _habitIdMeta,
        habitId.isAcceptableOrUnknown(data['habit_id']!, _habitIdMeta),
      );
    } else if (isInserting) {
      context.missing(_habitIdMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('is_deleted')) {
      context.handle(
        _isDeletedMeta,
        isDeleted.isAcceptableOrUnknown(data['is_deleted']!, _isDeletedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {habitId, date},
  ];
  @override
  HabitEntriesTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return HabitEntriesTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      serverId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}server_id'],
      ),
      habitId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}habit_id'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      isDeleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_deleted'],
      )!,
    );
  }

  @override
  $HabitEntriesTableTable createAlias(String alias) {
    return $HabitEntriesTableTable(attachedDatabase, alias);
  }
}

class HabitEntriesTableData extends DataClass
    implements Insertable<HabitEntriesTableData> {
  final int id;
  final int? serverId;
  final int habitId;
  final DateTime date;

  /// "Done" or "NotDone", matching Core's HabitEntryStatus.ToString().
  final String status;
  final DateTime updatedAt;
  final bool isDeleted;
  const HabitEntriesTableData({
    required this.id,
    this.serverId,
    required this.habitId,
    required this.date,
    required this.status,
    required this.updatedAt,
    required this.isDeleted,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || serverId != null) {
      map['server_id'] = Variable<int>(serverId);
    }
    map['habit_id'] = Variable<int>(habitId);
    map['date'] = Variable<DateTime>(date);
    map['status'] = Variable<String>(status);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['is_deleted'] = Variable<bool>(isDeleted);
    return map;
  }

  HabitEntriesTableCompanion toCompanion(bool nullToAbsent) {
    return HabitEntriesTableCompanion(
      id: Value(id),
      serverId: serverId == null && nullToAbsent
          ? const Value.absent()
          : Value(serverId),
      habitId: Value(habitId),
      date: Value(date),
      status: Value(status),
      updatedAt: Value(updatedAt),
      isDeleted: Value(isDeleted),
    );
  }

  factory HabitEntriesTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return HabitEntriesTableData(
      id: serializer.fromJson<int>(json['id']),
      serverId: serializer.fromJson<int?>(json['serverId']),
      habitId: serializer.fromJson<int>(json['habitId']),
      date: serializer.fromJson<DateTime>(json['date']),
      status: serializer.fromJson<String>(json['status']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      isDeleted: serializer.fromJson<bool>(json['isDeleted']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'serverId': serializer.toJson<int?>(serverId),
      'habitId': serializer.toJson<int>(habitId),
      'date': serializer.toJson<DateTime>(date),
      'status': serializer.toJson<String>(status),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'isDeleted': serializer.toJson<bool>(isDeleted),
    };
  }

  HabitEntriesTableData copyWith({
    int? id,
    Value<int?> serverId = const Value.absent(),
    int? habitId,
    DateTime? date,
    String? status,
    DateTime? updatedAt,
    bool? isDeleted,
  }) => HabitEntriesTableData(
    id: id ?? this.id,
    serverId: serverId.present ? serverId.value : this.serverId,
    habitId: habitId ?? this.habitId,
    date: date ?? this.date,
    status: status ?? this.status,
    updatedAt: updatedAt ?? this.updatedAt,
    isDeleted: isDeleted ?? this.isDeleted,
  );
  HabitEntriesTableData copyWithCompanion(HabitEntriesTableCompanion data) {
    return HabitEntriesTableData(
      id: data.id.present ? data.id.value : this.id,
      serverId: data.serverId.present ? data.serverId.value : this.serverId,
      habitId: data.habitId.present ? data.habitId.value : this.habitId,
      date: data.date.present ? data.date.value : this.date,
      status: data.status.present ? data.status.value : this.status,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,
    );
  }

  @override
  String toString() {
    return (StringBuffer('HabitEntriesTableData(')
          ..write('id: $id, ')
          ..write('serverId: $serverId, ')
          ..write('habitId: $habitId, ')
          ..write('date: $date, ')
          ..write('status: $status, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('isDeleted: $isDeleted')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, serverId, habitId, date, status, updatedAt, isDeleted);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is HabitEntriesTableData &&
          other.id == this.id &&
          other.serverId == this.serverId &&
          other.habitId == this.habitId &&
          other.date == this.date &&
          other.status == this.status &&
          other.updatedAt == this.updatedAt &&
          other.isDeleted == this.isDeleted);
}

class HabitEntriesTableCompanion
    extends UpdateCompanion<HabitEntriesTableData> {
  final Value<int> id;
  final Value<int?> serverId;
  final Value<int> habitId;
  final Value<DateTime> date;
  final Value<String> status;
  final Value<DateTime> updatedAt;
  final Value<bool> isDeleted;
  const HabitEntriesTableCompanion({
    this.id = const Value.absent(),
    this.serverId = const Value.absent(),
    this.habitId = const Value.absent(),
    this.date = const Value.absent(),
    this.status = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.isDeleted = const Value.absent(),
  });
  HabitEntriesTableCompanion.insert({
    this.id = const Value.absent(),
    this.serverId = const Value.absent(),
    required int habitId,
    required DateTime date,
    required String status,
    required DateTime updatedAt,
    this.isDeleted = const Value.absent(),
  }) : habitId = Value(habitId),
       date = Value(date),
       status = Value(status),
       updatedAt = Value(updatedAt);
  static Insertable<HabitEntriesTableData> custom({
    Expression<int>? id,
    Expression<int>? serverId,
    Expression<int>? habitId,
    Expression<DateTime>? date,
    Expression<String>? status,
    Expression<DateTime>? updatedAt,
    Expression<bool>? isDeleted,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (serverId != null) 'server_id': serverId,
      if (habitId != null) 'habit_id': habitId,
      if (date != null) 'date': date,
      if (status != null) 'status': status,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (isDeleted != null) 'is_deleted': isDeleted,
    });
  }

  HabitEntriesTableCompanion copyWith({
    Value<int>? id,
    Value<int?>? serverId,
    Value<int>? habitId,
    Value<DateTime>? date,
    Value<String>? status,
    Value<DateTime>? updatedAt,
    Value<bool>? isDeleted,
  }) {
    return HabitEntriesTableCompanion(
      id: id ?? this.id,
      serverId: serverId ?? this.serverId,
      habitId: habitId ?? this.habitId,
      date: date ?? this.date,
      status: status ?? this.status,
      updatedAt: updatedAt ?? this.updatedAt,
      isDeleted: isDeleted ?? this.isDeleted,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (serverId.present) {
      map['server_id'] = Variable<int>(serverId.value);
    }
    if (habitId.present) {
      map['habit_id'] = Variable<int>(habitId.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (isDeleted.present) {
      map['is_deleted'] = Variable<bool>(isDeleted.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('HabitEntriesTableCompanion(')
          ..write('id: $id, ')
          ..write('serverId: $serverId, ')
          ..write('habitId: $habitId, ')
          ..write('date: $date, ')
          ..write('status: $status, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('isDeleted: $isDeleted')
          ..write(')'))
        .toString();
  }
}

class $SyncStateTableTable extends SyncStateTable
    with TableInfo<$SyncStateTableTable, SyncStateTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SyncStateTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _lastSyncedAtMeta = const VerificationMeta(
    'lastSyncedAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastSyncedAt = GeneratedColumn<DateTime>(
    'last_synced_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _cachedIconsJsonMeta = const VerificationMeta(
    'cachedIconsJson',
  );
  @override
  late final GeneratedColumn<String> cachedIconsJson = GeneratedColumn<String>(
    'cached_icons_json',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _cachedColorsJsonMeta = const VerificationMeta(
    'cachedColorsJson',
  );
  @override
  late final GeneratedColumn<String> cachedColorsJson = GeneratedColumn<String>(
    'cached_colors_json',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _hasCompletedInitialSyncMeta =
      const VerificationMeta('hasCompletedInitialSync');
  @override
  late final GeneratedColumn<bool> hasCompletedInitialSync =
      GeneratedColumn<bool>(
        'has_completed_initial_sync',
        aliasedName,
        false,
        type: DriftSqlType.bool,
        requiredDuringInsert: false,
        defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("has_completed_initial_sync" IN (0, 1))',
        ),
        defaultValue: const Constant(false),
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    lastSyncedAt,
    cachedIconsJson,
    cachedColorsJson,
    hasCompletedInitialSync,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sync_state_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<SyncStateTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('last_synced_at')) {
      context.handle(
        _lastSyncedAtMeta,
        lastSyncedAt.isAcceptableOrUnknown(
          data['last_synced_at']!,
          _lastSyncedAtMeta,
        ),
      );
    }
    if (data.containsKey('cached_icons_json')) {
      context.handle(
        _cachedIconsJsonMeta,
        cachedIconsJson.isAcceptableOrUnknown(
          data['cached_icons_json']!,
          _cachedIconsJsonMeta,
        ),
      );
    }
    if (data.containsKey('cached_colors_json')) {
      context.handle(
        _cachedColorsJsonMeta,
        cachedColorsJson.isAcceptableOrUnknown(
          data['cached_colors_json']!,
          _cachedColorsJsonMeta,
        ),
      );
    }
    if (data.containsKey('has_completed_initial_sync')) {
      context.handle(
        _hasCompletedInitialSyncMeta,
        hasCompletedInitialSync.isAcceptableOrUnknown(
          data['has_completed_initial_sync']!,
          _hasCompletedInitialSyncMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SyncStateTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SyncStateTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      lastSyncedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_synced_at'],
      ),
      cachedIconsJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}cached_icons_json'],
      ),
      cachedColorsJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}cached_colors_json'],
      ),
      hasCompletedInitialSync: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}has_completed_initial_sync'],
      )!,
    );
  }

  @override
  $SyncStateTableTable createAlias(String alias) {
    return $SyncStateTableTable(attachedDatabase, alias);
  }
}

class SyncStateTableData extends DataClass
    implements Insertable<SyncStateTableData> {
  final int id;
  final DateTime? lastSyncedAt;
  final String? cachedIconsJson;
  final String? cachedColorsJson;
  final bool hasCompletedInitialSync;
  const SyncStateTableData({
    required this.id,
    this.lastSyncedAt,
    this.cachedIconsJson,
    this.cachedColorsJson,
    required this.hasCompletedInitialSync,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || lastSyncedAt != null) {
      map['last_synced_at'] = Variable<DateTime>(lastSyncedAt);
    }
    if (!nullToAbsent || cachedIconsJson != null) {
      map['cached_icons_json'] = Variable<String>(cachedIconsJson);
    }
    if (!nullToAbsent || cachedColorsJson != null) {
      map['cached_colors_json'] = Variable<String>(cachedColorsJson);
    }
    map['has_completed_initial_sync'] = Variable<bool>(hasCompletedInitialSync);
    return map;
  }

  SyncStateTableCompanion toCompanion(bool nullToAbsent) {
    return SyncStateTableCompanion(
      id: Value(id),
      lastSyncedAt: lastSyncedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastSyncedAt),
      cachedIconsJson: cachedIconsJson == null && nullToAbsent
          ? const Value.absent()
          : Value(cachedIconsJson),
      cachedColorsJson: cachedColorsJson == null && nullToAbsent
          ? const Value.absent()
          : Value(cachedColorsJson),
      hasCompletedInitialSync: Value(hasCompletedInitialSync),
    );
  }

  factory SyncStateTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SyncStateTableData(
      id: serializer.fromJson<int>(json['id']),
      lastSyncedAt: serializer.fromJson<DateTime?>(json['lastSyncedAt']),
      cachedIconsJson: serializer.fromJson<String?>(json['cachedIconsJson']),
      cachedColorsJson: serializer.fromJson<String?>(json['cachedColorsJson']),
      hasCompletedInitialSync: serializer.fromJson<bool>(
        json['hasCompletedInitialSync'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'lastSyncedAt': serializer.toJson<DateTime?>(lastSyncedAt),
      'cachedIconsJson': serializer.toJson<String?>(cachedIconsJson),
      'cachedColorsJson': serializer.toJson<String?>(cachedColorsJson),
      'hasCompletedInitialSync': serializer.toJson<bool>(
        hasCompletedInitialSync,
      ),
    };
  }

  SyncStateTableData copyWith({
    int? id,
    Value<DateTime?> lastSyncedAt = const Value.absent(),
    Value<String?> cachedIconsJson = const Value.absent(),
    Value<String?> cachedColorsJson = const Value.absent(),
    bool? hasCompletedInitialSync,
  }) => SyncStateTableData(
    id: id ?? this.id,
    lastSyncedAt: lastSyncedAt.present ? lastSyncedAt.value : this.lastSyncedAt,
    cachedIconsJson: cachedIconsJson.present
        ? cachedIconsJson.value
        : this.cachedIconsJson,
    cachedColorsJson: cachedColorsJson.present
        ? cachedColorsJson.value
        : this.cachedColorsJson,
    hasCompletedInitialSync:
        hasCompletedInitialSync ?? this.hasCompletedInitialSync,
  );
  SyncStateTableData copyWithCompanion(SyncStateTableCompanion data) {
    return SyncStateTableData(
      id: data.id.present ? data.id.value : this.id,
      lastSyncedAt: data.lastSyncedAt.present
          ? data.lastSyncedAt.value
          : this.lastSyncedAt,
      cachedIconsJson: data.cachedIconsJson.present
          ? data.cachedIconsJson.value
          : this.cachedIconsJson,
      cachedColorsJson: data.cachedColorsJson.present
          ? data.cachedColorsJson.value
          : this.cachedColorsJson,
      hasCompletedInitialSync: data.hasCompletedInitialSync.present
          ? data.hasCompletedInitialSync.value
          : this.hasCompletedInitialSync,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SyncStateTableData(')
          ..write('id: $id, ')
          ..write('lastSyncedAt: $lastSyncedAt, ')
          ..write('cachedIconsJson: $cachedIconsJson, ')
          ..write('cachedColorsJson: $cachedColorsJson, ')
          ..write('hasCompletedInitialSync: $hasCompletedInitialSync')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    lastSyncedAt,
    cachedIconsJson,
    cachedColorsJson,
    hasCompletedInitialSync,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SyncStateTableData &&
          other.id == this.id &&
          other.lastSyncedAt == this.lastSyncedAt &&
          other.cachedIconsJson == this.cachedIconsJson &&
          other.cachedColorsJson == this.cachedColorsJson &&
          other.hasCompletedInitialSync == this.hasCompletedInitialSync);
}

class SyncStateTableCompanion extends UpdateCompanion<SyncStateTableData> {
  final Value<int> id;
  final Value<DateTime?> lastSyncedAt;
  final Value<String?> cachedIconsJson;
  final Value<String?> cachedColorsJson;
  final Value<bool> hasCompletedInitialSync;
  const SyncStateTableCompanion({
    this.id = const Value.absent(),
    this.lastSyncedAt = const Value.absent(),
    this.cachedIconsJson = const Value.absent(),
    this.cachedColorsJson = const Value.absent(),
    this.hasCompletedInitialSync = const Value.absent(),
  });
  SyncStateTableCompanion.insert({
    this.id = const Value.absent(),
    this.lastSyncedAt = const Value.absent(),
    this.cachedIconsJson = const Value.absent(),
    this.cachedColorsJson = const Value.absent(),
    this.hasCompletedInitialSync = const Value.absent(),
  });
  static Insertable<SyncStateTableData> custom({
    Expression<int>? id,
    Expression<DateTime>? lastSyncedAt,
    Expression<String>? cachedIconsJson,
    Expression<String>? cachedColorsJson,
    Expression<bool>? hasCompletedInitialSync,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (lastSyncedAt != null) 'last_synced_at': lastSyncedAt,
      if (cachedIconsJson != null) 'cached_icons_json': cachedIconsJson,
      if (cachedColorsJson != null) 'cached_colors_json': cachedColorsJson,
      if (hasCompletedInitialSync != null)
        'has_completed_initial_sync': hasCompletedInitialSync,
    });
  }

  SyncStateTableCompanion copyWith({
    Value<int>? id,
    Value<DateTime?>? lastSyncedAt,
    Value<String?>? cachedIconsJson,
    Value<String?>? cachedColorsJson,
    Value<bool>? hasCompletedInitialSync,
  }) {
    return SyncStateTableCompanion(
      id: id ?? this.id,
      lastSyncedAt: lastSyncedAt ?? this.lastSyncedAt,
      cachedIconsJson: cachedIconsJson ?? this.cachedIconsJson,
      cachedColorsJson: cachedColorsJson ?? this.cachedColorsJson,
      hasCompletedInitialSync:
          hasCompletedInitialSync ?? this.hasCompletedInitialSync,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (lastSyncedAt.present) {
      map['last_synced_at'] = Variable<DateTime>(lastSyncedAt.value);
    }
    if (cachedIconsJson.present) {
      map['cached_icons_json'] = Variable<String>(cachedIconsJson.value);
    }
    if (cachedColorsJson.present) {
      map['cached_colors_json'] = Variable<String>(cachedColorsJson.value);
    }
    if (hasCompletedInitialSync.present) {
      map['has_completed_initial_sync'] = Variable<bool>(
        hasCompletedInitialSync.value,
      );
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SyncStateTableCompanion(')
          ..write('id: $id, ')
          ..write('lastSyncedAt: $lastSyncedAt, ')
          ..write('cachedIconsJson: $cachedIconsJson, ')
          ..write('cachedColorsJson: $cachedColorsJson, ')
          ..write('hasCompletedInitialSync: $hasCompletedInitialSync')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $CategoriesTableTable categoriesTable = $CategoriesTableTable(
    this,
  );
  late final $HabitsTableTable habitsTable = $HabitsTableTable(this);
  late final $HabitEntriesTableTable habitEntriesTable =
      $HabitEntriesTableTable(this);
  late final $SyncStateTableTable syncStateTable = $SyncStateTableTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    categoriesTable,
    habitsTable,
    habitEntriesTable,
    syncStateTable,
  ];
}

typedef $$CategoriesTableTableCreateCompanionBuilder =
    CategoriesTableCompanion Function({
      Value<int> id,
      Value<int?> serverId,
      required String name,
      required String icon,
      required String color,
      required DateTime updatedAt,
      Value<bool> isDeleted,
    });
typedef $$CategoriesTableTableUpdateCompanionBuilder =
    CategoriesTableCompanion Function({
      Value<int> id,
      Value<int?> serverId,
      Value<String> name,
      Value<String> icon,
      Value<String> color,
      Value<DateTime> updatedAt,
      Value<bool> isDeleted,
    });

final class $$CategoriesTableTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $CategoriesTableTable,
          CategoriesTableData
        > {
  $$CategoriesTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<$HabitsTableTable, List<HabitsTableData>>
  _habitsTableRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.habitsTable,
    aliasName: 'categories_table__id__habits_table__category_id',
  );

  $$HabitsTableTableProcessedTableManager get habitsTableRefs {
    final manager = $$HabitsTableTableTableManager(
      $_db,
      $_db.habitsTable,
    ).filter((f) => f.categoryId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_habitsTableRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$CategoriesTableTableFilterComposer
    extends Composer<_$AppDatabase, $CategoriesTableTable> {
  $$CategoriesTableTableFilterComposer({
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

  ColumnFilters<int> get serverId => $composableBuilder(
    column: $table.serverId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get icon => $composableBuilder(
    column: $table.icon,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> habitsTableRefs(
    Expression<bool> Function($$HabitsTableTableFilterComposer f) f,
  ) {
    final $$HabitsTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.habitsTable,
      getReferencedColumn: (t) => t.categoryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$HabitsTableTableFilterComposer(
            $db: $db,
            $table: $db.habitsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CategoriesTableTableOrderingComposer
    extends Composer<_$AppDatabase, $CategoriesTableTable> {
  $$CategoriesTableTableOrderingComposer({
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

  ColumnOrderings<int> get serverId => $composableBuilder(
    column: $table.serverId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get icon => $composableBuilder(
    column: $table.icon,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CategoriesTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $CategoriesTableTable> {
  $$CategoriesTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get serverId =>
      $composableBuilder(column: $table.serverId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get icon =>
      $composableBuilder(column: $table.icon, builder: (column) => column);

  GeneratedColumn<String> get color =>
      $composableBuilder(column: $table.color, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<bool> get isDeleted =>
      $composableBuilder(column: $table.isDeleted, builder: (column) => column);

  Expression<T> habitsTableRefs<T extends Object>(
    Expression<T> Function($$HabitsTableTableAnnotationComposer a) f,
  ) {
    final $$HabitsTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.habitsTable,
      getReferencedColumn: (t) => t.categoryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$HabitsTableTableAnnotationComposer(
            $db: $db,
            $table: $db.habitsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CategoriesTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CategoriesTableTable,
          CategoriesTableData,
          $$CategoriesTableTableFilterComposer,
          $$CategoriesTableTableOrderingComposer,
          $$CategoriesTableTableAnnotationComposer,
          $$CategoriesTableTableCreateCompanionBuilder,
          $$CategoriesTableTableUpdateCompanionBuilder,
          (CategoriesTableData, $$CategoriesTableTableReferences),
          CategoriesTableData,
          PrefetchHooks Function({bool habitsTableRefs})
        > {
  $$CategoriesTableTableTableManager(
    _$AppDatabase db,
    $CategoriesTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CategoriesTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CategoriesTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CategoriesTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int?> serverId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> icon = const Value.absent(),
                Value<String> color = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<bool> isDeleted = const Value.absent(),
              }) => CategoriesTableCompanion(
                id: id,
                serverId: serverId,
                name: name,
                icon: icon,
                color: color,
                updatedAt: updatedAt,
                isDeleted: isDeleted,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int?> serverId = const Value.absent(),
                required String name,
                required String icon,
                required String color,
                required DateTime updatedAt,
                Value<bool> isDeleted = const Value.absent(),
              }) => CategoriesTableCompanion.insert(
                id: id,
                serverId: serverId,
                name: name,
                icon: icon,
                color: color,
                updatedAt: updatedAt,
                isDeleted: isDeleted,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$CategoriesTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({habitsTableRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (habitsTableRefs) db.habitsTable],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (habitsTableRefs)
                    await $_getPrefetchedData<
                      CategoriesTableData,
                      $CategoriesTableTable,
                      HabitsTableData
                    >(
                      currentTable: table,
                      referencedTable: $$CategoriesTableTableReferences
                          ._habitsTableRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$CategoriesTableTableReferences(
                            db,
                            table,
                            p0,
                          ).habitsTableRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.categoryId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$CategoriesTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CategoriesTableTable,
      CategoriesTableData,
      $$CategoriesTableTableFilterComposer,
      $$CategoriesTableTableOrderingComposer,
      $$CategoriesTableTableAnnotationComposer,
      $$CategoriesTableTableCreateCompanionBuilder,
      $$CategoriesTableTableUpdateCompanionBuilder,
      (CategoriesTableData, $$CategoriesTableTableReferences),
      CategoriesTableData,
      PrefetchHooks Function({bool habitsTableRefs})
    >;
typedef $$HabitsTableTableCreateCompanionBuilder =
    HabitsTableCompanion Function({
      Value<int> id,
      Value<int?> serverId,
      required String name,
      required int categoryId,
      required int frequencyType,
      Value<int?> intervalDays,
      Value<int?> dayOfMonth,
      Value<int?> dayOfWeek,
      required DateTime startDate,
      required DateTime updatedAt,
      Value<bool> isDeleted,
    });
typedef $$HabitsTableTableUpdateCompanionBuilder =
    HabitsTableCompanion Function({
      Value<int> id,
      Value<int?> serverId,
      Value<String> name,
      Value<int> categoryId,
      Value<int> frequencyType,
      Value<int?> intervalDays,
      Value<int?> dayOfMonth,
      Value<int?> dayOfWeek,
      Value<DateTime> startDate,
      Value<DateTime> updatedAt,
      Value<bool> isDeleted,
    });

final class $$HabitsTableTableReferences
    extends BaseReferences<_$AppDatabase, $HabitsTableTable, HabitsTableData> {
  $$HabitsTableTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $CategoriesTableTable _categoryIdTable(_$AppDatabase db) => db
      .categoriesTable
      .createAlias('habits_table__category_id__categories_table__id');

  $$CategoriesTableTableProcessedTableManager get categoryId {
    final $_column = $_itemColumn<int>('category_id')!;

    final manager = $$CategoriesTableTableTableManager(
      $_db,
      $_db.categoriesTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_categoryIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<
    $HabitEntriesTableTable,
    List<HabitEntriesTableData>
  >
  _habitEntriesTableRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.habitEntriesTable,
        aliasName: 'habits_table__id__habit_entries_table__habit_id',
      );

  $$HabitEntriesTableTableProcessedTableManager get habitEntriesTableRefs {
    final manager = $$HabitEntriesTableTableTableManager(
      $_db,
      $_db.habitEntriesTable,
    ).filter((f) => f.habitId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _habitEntriesTableRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$HabitsTableTableFilterComposer
    extends Composer<_$AppDatabase, $HabitsTableTable> {
  $$HabitsTableTableFilterComposer({
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

  ColumnFilters<int> get serverId => $composableBuilder(
    column: $table.serverId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get frequencyType => $composableBuilder(
    column: $table.frequencyType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get intervalDays => $composableBuilder(
    column: $table.intervalDays,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get dayOfMonth => $composableBuilder(
    column: $table.dayOfMonth,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get dayOfWeek => $composableBuilder(
    column: $table.dayOfWeek,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnFilters(column),
  );

  $$CategoriesTableTableFilterComposer get categoryId {
    final $$CategoriesTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categoriesTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableTableFilterComposer(
            $db: $db,
            $table: $db.categoriesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> habitEntriesTableRefs(
    Expression<bool> Function($$HabitEntriesTableTableFilterComposer f) f,
  ) {
    final $$HabitEntriesTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.habitEntriesTable,
      getReferencedColumn: (t) => t.habitId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$HabitEntriesTableTableFilterComposer(
            $db: $db,
            $table: $db.habitEntriesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$HabitsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $HabitsTableTable> {
  $$HabitsTableTableOrderingComposer({
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

  ColumnOrderings<int> get serverId => $composableBuilder(
    column: $table.serverId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get frequencyType => $composableBuilder(
    column: $table.frequencyType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get intervalDays => $composableBuilder(
    column: $table.intervalDays,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get dayOfMonth => $composableBuilder(
    column: $table.dayOfMonth,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get dayOfWeek => $composableBuilder(
    column: $table.dayOfWeek,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnOrderings(column),
  );

  $$CategoriesTableTableOrderingComposer get categoryId {
    final $$CategoriesTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categoriesTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableTableOrderingComposer(
            $db: $db,
            $table: $db.categoriesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$HabitsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $HabitsTableTable> {
  $$HabitsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get serverId =>
      $composableBuilder(column: $table.serverId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get frequencyType => $composableBuilder(
    column: $table.frequencyType,
    builder: (column) => column,
  );

  GeneratedColumn<int> get intervalDays => $composableBuilder(
    column: $table.intervalDays,
    builder: (column) => column,
  );

  GeneratedColumn<int> get dayOfMonth => $composableBuilder(
    column: $table.dayOfMonth,
    builder: (column) => column,
  );

  GeneratedColumn<int> get dayOfWeek =>
      $composableBuilder(column: $table.dayOfWeek, builder: (column) => column);

  GeneratedColumn<DateTime> get startDate =>
      $composableBuilder(column: $table.startDate, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<bool> get isDeleted =>
      $composableBuilder(column: $table.isDeleted, builder: (column) => column);

  $$CategoriesTableTableAnnotationComposer get categoryId {
    final $$CategoriesTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categoriesTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableTableAnnotationComposer(
            $db: $db,
            $table: $db.categoriesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> habitEntriesTableRefs<T extends Object>(
    Expression<T> Function($$HabitEntriesTableTableAnnotationComposer a) f,
  ) {
    final $$HabitEntriesTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.habitEntriesTable,
          getReferencedColumn: (t) => t.habitId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$HabitEntriesTableTableAnnotationComposer(
                $db: $db,
                $table: $db.habitEntriesTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$HabitsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $HabitsTableTable,
          HabitsTableData,
          $$HabitsTableTableFilterComposer,
          $$HabitsTableTableOrderingComposer,
          $$HabitsTableTableAnnotationComposer,
          $$HabitsTableTableCreateCompanionBuilder,
          $$HabitsTableTableUpdateCompanionBuilder,
          (HabitsTableData, $$HabitsTableTableReferences),
          HabitsTableData,
          PrefetchHooks Function({bool categoryId, bool habitEntriesTableRefs})
        > {
  $$HabitsTableTableTableManager(_$AppDatabase db, $HabitsTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$HabitsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$HabitsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$HabitsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int?> serverId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> categoryId = const Value.absent(),
                Value<int> frequencyType = const Value.absent(),
                Value<int?> intervalDays = const Value.absent(),
                Value<int?> dayOfMonth = const Value.absent(),
                Value<int?> dayOfWeek = const Value.absent(),
                Value<DateTime> startDate = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<bool> isDeleted = const Value.absent(),
              }) => HabitsTableCompanion(
                id: id,
                serverId: serverId,
                name: name,
                categoryId: categoryId,
                frequencyType: frequencyType,
                intervalDays: intervalDays,
                dayOfMonth: dayOfMonth,
                dayOfWeek: dayOfWeek,
                startDate: startDate,
                updatedAt: updatedAt,
                isDeleted: isDeleted,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int?> serverId = const Value.absent(),
                required String name,
                required int categoryId,
                required int frequencyType,
                Value<int?> intervalDays = const Value.absent(),
                Value<int?> dayOfMonth = const Value.absent(),
                Value<int?> dayOfWeek = const Value.absent(),
                required DateTime startDate,
                required DateTime updatedAt,
                Value<bool> isDeleted = const Value.absent(),
              }) => HabitsTableCompanion.insert(
                id: id,
                serverId: serverId,
                name: name,
                categoryId: categoryId,
                frequencyType: frequencyType,
                intervalDays: intervalDays,
                dayOfMonth: dayOfMonth,
                dayOfWeek: dayOfWeek,
                startDate: startDate,
                updatedAt: updatedAt,
                isDeleted: isDeleted,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$HabitsTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({categoryId = false, habitEntriesTableRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (habitEntriesTableRefs) db.habitEntriesTable,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (categoryId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.categoryId,
                            referencedTable: $$HabitsTableTableReferences
                                ._categoryIdTable(db),
                            referencedColumn: $$HabitsTableTableReferences
                                ._categoryIdTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (habitEntriesTableRefs)
                        await $_getPrefetchedData<
                          HabitsTableData,
                          $HabitsTableTable,
                          HabitEntriesTableData
                        >(
                          currentTable: table,
                          referencedTable: $$HabitsTableTableReferences
                              ._habitEntriesTableRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$HabitsTableTableReferences(
                                db,
                                table,
                                p0,
                              ).habitEntriesTableRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.habitId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$HabitsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $HabitsTableTable,
      HabitsTableData,
      $$HabitsTableTableFilterComposer,
      $$HabitsTableTableOrderingComposer,
      $$HabitsTableTableAnnotationComposer,
      $$HabitsTableTableCreateCompanionBuilder,
      $$HabitsTableTableUpdateCompanionBuilder,
      (HabitsTableData, $$HabitsTableTableReferences),
      HabitsTableData,
      PrefetchHooks Function({bool categoryId, bool habitEntriesTableRefs})
    >;
typedef $$HabitEntriesTableTableCreateCompanionBuilder =
    HabitEntriesTableCompanion Function({
      Value<int> id,
      Value<int?> serverId,
      required int habitId,
      required DateTime date,
      required String status,
      required DateTime updatedAt,
      Value<bool> isDeleted,
    });
typedef $$HabitEntriesTableTableUpdateCompanionBuilder =
    HabitEntriesTableCompanion Function({
      Value<int> id,
      Value<int?> serverId,
      Value<int> habitId,
      Value<DateTime> date,
      Value<String> status,
      Value<DateTime> updatedAt,
      Value<bool> isDeleted,
    });

final class $$HabitEntriesTableTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $HabitEntriesTableTable,
          HabitEntriesTableData
        > {
  $$HabitEntriesTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $HabitsTableTable _habitIdTable(_$AppDatabase db) => db.habitsTable
      .createAlias('habit_entries_table__habit_id__habits_table__id');

  $$HabitsTableTableProcessedTableManager get habitId {
    final $_column = $_itemColumn<int>('habit_id')!;

    final manager = $$HabitsTableTableTableManager(
      $_db,
      $_db.habitsTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_habitIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$HabitEntriesTableTableFilterComposer
    extends Composer<_$AppDatabase, $HabitEntriesTableTable> {
  $$HabitEntriesTableTableFilterComposer({
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

  ColumnFilters<int> get serverId => $composableBuilder(
    column: $table.serverId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnFilters(column),
  );

  $$HabitsTableTableFilterComposer get habitId {
    final $$HabitsTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.habitId,
      referencedTable: $db.habitsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$HabitsTableTableFilterComposer(
            $db: $db,
            $table: $db.habitsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$HabitEntriesTableTableOrderingComposer
    extends Composer<_$AppDatabase, $HabitEntriesTableTable> {
  $$HabitEntriesTableTableOrderingComposer({
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

  ColumnOrderings<int> get serverId => $composableBuilder(
    column: $table.serverId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnOrderings(column),
  );

  $$HabitsTableTableOrderingComposer get habitId {
    final $$HabitsTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.habitId,
      referencedTable: $db.habitsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$HabitsTableTableOrderingComposer(
            $db: $db,
            $table: $db.habitsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$HabitEntriesTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $HabitEntriesTableTable> {
  $$HabitEntriesTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get serverId =>
      $composableBuilder(column: $table.serverId, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<bool> get isDeleted =>
      $composableBuilder(column: $table.isDeleted, builder: (column) => column);

  $$HabitsTableTableAnnotationComposer get habitId {
    final $$HabitsTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.habitId,
      referencedTable: $db.habitsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$HabitsTableTableAnnotationComposer(
            $db: $db,
            $table: $db.habitsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$HabitEntriesTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $HabitEntriesTableTable,
          HabitEntriesTableData,
          $$HabitEntriesTableTableFilterComposer,
          $$HabitEntriesTableTableOrderingComposer,
          $$HabitEntriesTableTableAnnotationComposer,
          $$HabitEntriesTableTableCreateCompanionBuilder,
          $$HabitEntriesTableTableUpdateCompanionBuilder,
          (HabitEntriesTableData, $$HabitEntriesTableTableReferences),
          HabitEntriesTableData,
          PrefetchHooks Function({bool habitId})
        > {
  $$HabitEntriesTableTableTableManager(
    _$AppDatabase db,
    $HabitEntriesTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$HabitEntriesTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$HabitEntriesTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$HabitEntriesTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int?> serverId = const Value.absent(),
                Value<int> habitId = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<bool> isDeleted = const Value.absent(),
              }) => HabitEntriesTableCompanion(
                id: id,
                serverId: serverId,
                habitId: habitId,
                date: date,
                status: status,
                updatedAt: updatedAt,
                isDeleted: isDeleted,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int?> serverId = const Value.absent(),
                required int habitId,
                required DateTime date,
                required String status,
                required DateTime updatedAt,
                Value<bool> isDeleted = const Value.absent(),
              }) => HabitEntriesTableCompanion.insert(
                id: id,
                serverId: serverId,
                habitId: habitId,
                date: date,
                status: status,
                updatedAt: updatedAt,
                isDeleted: isDeleted,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$HabitEntriesTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({habitId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (habitId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.habitId,
                        referencedTable: $$HabitEntriesTableTableReferences
                            ._habitIdTable(db),
                        referencedColumn: $$HabitEntriesTableTableReferences
                            ._habitIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$HabitEntriesTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $HabitEntriesTableTable,
      HabitEntriesTableData,
      $$HabitEntriesTableTableFilterComposer,
      $$HabitEntriesTableTableOrderingComposer,
      $$HabitEntriesTableTableAnnotationComposer,
      $$HabitEntriesTableTableCreateCompanionBuilder,
      $$HabitEntriesTableTableUpdateCompanionBuilder,
      (HabitEntriesTableData, $$HabitEntriesTableTableReferences),
      HabitEntriesTableData,
      PrefetchHooks Function({bool habitId})
    >;
typedef $$SyncStateTableTableCreateCompanionBuilder =
    SyncStateTableCompanion Function({
      Value<int> id,
      Value<DateTime?> lastSyncedAt,
      Value<String?> cachedIconsJson,
      Value<String?> cachedColorsJson,
      Value<bool> hasCompletedInitialSync,
    });
typedef $$SyncStateTableTableUpdateCompanionBuilder =
    SyncStateTableCompanion Function({
      Value<int> id,
      Value<DateTime?> lastSyncedAt,
      Value<String?> cachedIconsJson,
      Value<String?> cachedColorsJson,
      Value<bool> hasCompletedInitialSync,
    });

class $$SyncStateTableTableFilterComposer
    extends Composer<_$AppDatabase, $SyncStateTableTable> {
  $$SyncStateTableTableFilterComposer({
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

  ColumnFilters<DateTime> get lastSyncedAt => $composableBuilder(
    column: $table.lastSyncedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get cachedIconsJson => $composableBuilder(
    column: $table.cachedIconsJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get cachedColorsJson => $composableBuilder(
    column: $table.cachedColorsJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get hasCompletedInitialSync => $composableBuilder(
    column: $table.hasCompletedInitialSync,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SyncStateTableTableOrderingComposer
    extends Composer<_$AppDatabase, $SyncStateTableTable> {
  $$SyncStateTableTableOrderingComposer({
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

  ColumnOrderings<DateTime> get lastSyncedAt => $composableBuilder(
    column: $table.lastSyncedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get cachedIconsJson => $composableBuilder(
    column: $table.cachedIconsJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get cachedColorsJson => $composableBuilder(
    column: $table.cachedColorsJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get hasCompletedInitialSync => $composableBuilder(
    column: $table.hasCompletedInitialSync,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SyncStateTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $SyncStateTableTable> {
  $$SyncStateTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get lastSyncedAt => $composableBuilder(
    column: $table.lastSyncedAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get cachedIconsJson => $composableBuilder(
    column: $table.cachedIconsJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get cachedColorsJson => $composableBuilder(
    column: $table.cachedColorsJson,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get hasCompletedInitialSync => $composableBuilder(
    column: $table.hasCompletedInitialSync,
    builder: (column) => column,
  );
}

class $$SyncStateTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SyncStateTableTable,
          SyncStateTableData,
          $$SyncStateTableTableFilterComposer,
          $$SyncStateTableTableOrderingComposer,
          $$SyncStateTableTableAnnotationComposer,
          $$SyncStateTableTableCreateCompanionBuilder,
          $$SyncStateTableTableUpdateCompanionBuilder,
          (
            SyncStateTableData,
            BaseReferences<
              _$AppDatabase,
              $SyncStateTableTable,
              SyncStateTableData
            >,
          ),
          SyncStateTableData,
          PrefetchHooks Function()
        > {
  $$SyncStateTableTableTableManager(
    _$AppDatabase db,
    $SyncStateTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SyncStateTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SyncStateTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SyncStateTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DateTime?> lastSyncedAt = const Value.absent(),
                Value<String?> cachedIconsJson = const Value.absent(),
                Value<String?> cachedColorsJson = const Value.absent(),
                Value<bool> hasCompletedInitialSync = const Value.absent(),
              }) => SyncStateTableCompanion(
                id: id,
                lastSyncedAt: lastSyncedAt,
                cachedIconsJson: cachedIconsJson,
                cachedColorsJson: cachedColorsJson,
                hasCompletedInitialSync: hasCompletedInitialSync,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DateTime?> lastSyncedAt = const Value.absent(),
                Value<String?> cachedIconsJson = const Value.absent(),
                Value<String?> cachedColorsJson = const Value.absent(),
                Value<bool> hasCompletedInitialSync = const Value.absent(),
              }) => SyncStateTableCompanion.insert(
                id: id,
                lastSyncedAt: lastSyncedAt,
                cachedIconsJson: cachedIconsJson,
                cachedColorsJson: cachedColorsJson,
                hasCompletedInitialSync: hasCompletedInitialSync,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SyncStateTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SyncStateTableTable,
      SyncStateTableData,
      $$SyncStateTableTableFilterComposer,
      $$SyncStateTableTableOrderingComposer,
      $$SyncStateTableTableAnnotationComposer,
      $$SyncStateTableTableCreateCompanionBuilder,
      $$SyncStateTableTableUpdateCompanionBuilder,
      (
        SyncStateTableData,
        BaseReferences<_$AppDatabase, $SyncStateTableTable, SyncStateTableData>,
      ),
      SyncStateTableData,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$CategoriesTableTableTableManager get categoriesTable =>
      $$CategoriesTableTableTableManager(_db, _db.categoriesTable);
  $$HabitsTableTableTableManager get habitsTable =>
      $$HabitsTableTableTableManager(_db, _db.habitsTable);
  $$HabitEntriesTableTableTableManager get habitEntriesTable =>
      $$HabitEntriesTableTableTableManager(_db, _db.habitEntriesTable);
  $$SyncStateTableTableTableManager get syncStateTable =>
      $$SyncStateTableTableTableManager(_db, _db.syncStateTable);
}
