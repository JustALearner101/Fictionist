// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $ProjectsTable extends Projects
    with TableInfo<$ProjectsTable, ProjectRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProjectsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 36, maxTextLength: 36),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 200),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _coverImagePathMeta =
      const VerificationMeta('coverImagePath');
  @override
  late final GeneratedColumn<String> coverImagePath = GeneratedColumn<String>(
      'cover_image_path', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _lastAccessedAtMeta =
      const VerificationMeta('lastAccessedAt');
  @override
  late final GeneratedColumn<DateTime> lastAccessedAt =
      GeneratedColumn<DateTime>('last_accessed_at', aliasedName, false,
          type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _isDeletedMeta =
      const VerificationMeta('isDeleted');
  @override
  late final GeneratedColumn<bool> isDeleted = GeneratedColumn<bool>(
      'is_deleted', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_deleted" IN (0, 1))'),
      defaultValue: const Constant(false));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        name,
        description,
        coverImagePath,
        lastAccessedAt,
        createdAt,
        updatedAt,
        isDeleted
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'projects';
  @override
  VerificationContext validateIntegrity(Insertable<ProjectRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    }
    if (data.containsKey('cover_image_path')) {
      context.handle(
          _coverImagePathMeta,
          coverImagePath.isAcceptableOrUnknown(
              data['cover_image_path']!, _coverImagePathMeta));
    }
    if (data.containsKey('last_accessed_at')) {
      context.handle(
          _lastAccessedAtMeta,
          lastAccessedAt.isAcceptableOrUnknown(
              data['last_accessed_at']!, _lastAccessedAtMeta));
    } else if (isInserting) {
      context.missing(_lastAccessedAtMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('is_deleted')) {
      context.handle(_isDeletedMeta,
          isDeleted.isAcceptableOrUnknown(data['is_deleted']!, _isDeletedMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ProjectRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ProjectRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description']),
      coverImagePath: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}cover_image_path']),
      lastAccessedAt: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}last_accessed_at'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
      isDeleted: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_deleted'])!,
    );
  }

  @override
  $ProjectsTable createAlias(String alias) {
    return $ProjectsTable(attachedDatabase, alias);
  }
}

class ProjectRow extends DataClass implements Insertable<ProjectRow> {
  final String id;
  final String name;
  final String? description;
  final String? coverImagePath;
  final DateTime lastAccessedAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isDeleted;
  const ProjectRow(
      {required this.id,
      required this.name,
      this.description,
      this.coverImagePath,
      required this.lastAccessedAt,
      required this.createdAt,
      required this.updatedAt,
      required this.isDeleted});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    if (!nullToAbsent || coverImagePath != null) {
      map['cover_image_path'] = Variable<String>(coverImagePath);
    }
    map['last_accessed_at'] = Variable<DateTime>(lastAccessedAt);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['is_deleted'] = Variable<bool>(isDeleted);
    return map;
  }

  ProjectsCompanion toCompanion(bool nullToAbsent) {
    return ProjectsCompanion(
      id: Value(id),
      name: Value(name),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      coverImagePath: coverImagePath == null && nullToAbsent
          ? const Value.absent()
          : Value(coverImagePath),
      lastAccessedAt: Value(lastAccessedAt),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      isDeleted: Value(isDeleted),
    );
  }

  factory ProjectRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ProjectRow(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      description: serializer.fromJson<String?>(json['description']),
      coverImagePath: serializer.fromJson<String?>(json['coverImagePath']),
      lastAccessedAt: serializer.fromJson<DateTime>(json['lastAccessedAt']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      isDeleted: serializer.fromJson<bool>(json['isDeleted']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'description': serializer.toJson<String?>(description),
      'coverImagePath': serializer.toJson<String?>(coverImagePath),
      'lastAccessedAt': serializer.toJson<DateTime>(lastAccessedAt),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'isDeleted': serializer.toJson<bool>(isDeleted),
    };
  }

  ProjectRow copyWith(
          {String? id,
          String? name,
          Value<String?> description = const Value.absent(),
          Value<String?> coverImagePath = const Value.absent(),
          DateTime? lastAccessedAt,
          DateTime? createdAt,
          DateTime? updatedAt,
          bool? isDeleted}) =>
      ProjectRow(
        id: id ?? this.id,
        name: name ?? this.name,
        description: description.present ? description.value : this.description,
        coverImagePath:
            coverImagePath.present ? coverImagePath.value : this.coverImagePath,
        lastAccessedAt: lastAccessedAt ?? this.lastAccessedAt,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        isDeleted: isDeleted ?? this.isDeleted,
      );
  ProjectRow copyWithCompanion(ProjectsCompanion data) {
    return ProjectRow(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      description:
          data.description.present ? data.description.value : this.description,
      coverImagePath: data.coverImagePath.present
          ? data.coverImagePath.value
          : this.coverImagePath,
      lastAccessedAt: data.lastAccessedAt.present
          ? data.lastAccessedAt.value
          : this.lastAccessedAt,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ProjectRow(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('coverImagePath: $coverImagePath, ')
          ..write('lastAccessedAt: $lastAccessedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('isDeleted: $isDeleted')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, description, coverImagePath,
      lastAccessedAt, createdAt, updatedAt, isDeleted);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ProjectRow &&
          other.id == this.id &&
          other.name == this.name &&
          other.description == this.description &&
          other.coverImagePath == this.coverImagePath &&
          other.lastAccessedAt == this.lastAccessedAt &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.isDeleted == this.isDeleted);
}

class ProjectsCompanion extends UpdateCompanion<ProjectRow> {
  final Value<String> id;
  final Value<String> name;
  final Value<String?> description;
  final Value<String?> coverImagePath;
  final Value<DateTime> lastAccessedAt;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<bool> isDeleted;
  final Value<int> rowid;
  const ProjectsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.description = const Value.absent(),
    this.coverImagePath = const Value.absent(),
    this.lastAccessedAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ProjectsCompanion.insert({
    required String id,
    required String name,
    this.description = const Value.absent(),
    this.coverImagePath = const Value.absent(),
    required DateTime lastAccessedAt,
    required DateTime createdAt,
    required DateTime updatedAt,
    this.isDeleted = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        name = Value(name),
        lastAccessedAt = Value(lastAccessedAt),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<ProjectRow> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? description,
    Expression<String>? coverImagePath,
    Expression<DateTime>? lastAccessedAt,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<bool>? isDeleted,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (coverImagePath != null) 'cover_image_path': coverImagePath,
      if (lastAccessedAt != null) 'last_accessed_at': lastAccessedAt,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (isDeleted != null) 'is_deleted': isDeleted,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ProjectsCompanion copyWith(
      {Value<String>? id,
      Value<String>? name,
      Value<String?>? description,
      Value<String?>? coverImagePath,
      Value<DateTime>? lastAccessedAt,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<bool>? isDeleted,
      Value<int>? rowid}) {
    return ProjectsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      coverImagePath: coverImagePath ?? this.coverImagePath,
      lastAccessedAt: lastAccessedAt ?? this.lastAccessedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isDeleted: isDeleted ?? this.isDeleted,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (coverImagePath.present) {
      map['cover_image_path'] = Variable<String>(coverImagePath.value);
    }
    if (lastAccessedAt.present) {
      map['last_accessed_at'] = Variable<DateTime>(lastAccessedAt.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (isDeleted.present) {
      map['is_deleted'] = Variable<bool>(isDeleted.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProjectsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('coverImagePath: $coverImagePath, ')
          ..write('lastAccessedAt: $lastAccessedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $EntitiesTable extends Entities
    with TableInfo<$EntitiesTable, EntityRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EntitiesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _projectIdMeta =
      const VerificationMeta('projectId');
  @override
  late final GeneratedColumn<String> projectId = GeneratedColumn<String>(
      'project_id', aliasedName, true,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES projects (id) ON DELETE CASCADE'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 200),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _entityTypeMeta =
      const VerificationMeta('entityType');
  @override
  late final GeneratedColumn<String> entityType = GeneratedColumn<String>(
      'entity_type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('draft'));
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _customFieldsMeta =
      const VerificationMeta('customFields');
  @override
  late final GeneratedColumn<String> customFields = GeneratedColumn<String>(
      'custom_fields', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('[]'));
  static const VerificationMeta _iconColorMeta =
      const VerificationMeta('iconColor');
  @override
  late final GeneratedColumn<int> iconColor = GeneratedColumn<int>(
      'icon_color', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _isDeletedMeta =
      const VerificationMeta('isDeleted');
  @override
  late final GeneratedColumn<bool> isDeleted = GeneratedColumn<bool>(
      'is_deleted', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_deleted" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        projectId,
        name,
        entityType,
        status,
        description,
        customFields,
        iconColor,
        isDeleted,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'entities';
  @override
  VerificationContext validateIntegrity(Insertable<EntityRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('project_id')) {
      context.handle(_projectIdMeta,
          projectId.isAcceptableOrUnknown(data['project_id']!, _projectIdMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('entity_type')) {
      context.handle(
          _entityTypeMeta,
          entityType.isAcceptableOrUnknown(
              data['entity_type']!, _entityTypeMeta));
    } else if (isInserting) {
      context.missing(_entityTypeMeta);
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    }
    if (data.containsKey('custom_fields')) {
      context.handle(
          _customFieldsMeta,
          customFields.isAcceptableOrUnknown(
              data['custom_fields']!, _customFieldsMeta));
    }
    if (data.containsKey('icon_color')) {
      context.handle(_iconColorMeta,
          iconColor.isAcceptableOrUnknown(data['icon_color']!, _iconColorMeta));
    } else if (isInserting) {
      context.missing(_iconColorMeta);
    }
    if (data.containsKey('is_deleted')) {
      context.handle(_isDeletedMeta,
          isDeleted.isAcceptableOrUnknown(data['is_deleted']!, _isDeletedMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  EntityRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return EntityRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      projectId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}project_id']),
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      entityType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}entity_type'])!,
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description']),
      customFields: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}custom_fields'])!,
      iconColor: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}icon_color'])!,
      isDeleted: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_deleted'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $EntitiesTable createAlias(String alias) {
    return $EntitiesTable(attachedDatabase, alias);
  }
}

class EntityRow extends DataClass implements Insertable<EntityRow> {
  final String id;
  final String? projectId;
  final String name;
  final String entityType;
  final String status;
  final String? description;
  final String customFields;
  final int iconColor;
  final bool isDeleted;
  final DateTime createdAt;
  final DateTime updatedAt;
  const EntityRow(
      {required this.id,
      this.projectId,
      required this.name,
      required this.entityType,
      required this.status,
      this.description,
      required this.customFields,
      required this.iconColor,
      required this.isDeleted,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || projectId != null) {
      map['project_id'] = Variable<String>(projectId);
    }
    map['name'] = Variable<String>(name);
    map['entity_type'] = Variable<String>(entityType);
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['custom_fields'] = Variable<String>(customFields);
    map['icon_color'] = Variable<int>(iconColor);
    map['is_deleted'] = Variable<bool>(isDeleted);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  EntitiesCompanion toCompanion(bool nullToAbsent) {
    return EntitiesCompanion(
      id: Value(id),
      projectId: projectId == null && nullToAbsent
          ? const Value.absent()
          : Value(projectId),
      name: Value(name),
      entityType: Value(entityType),
      status: Value(status),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      customFields: Value(customFields),
      iconColor: Value(iconColor),
      isDeleted: Value(isDeleted),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory EntityRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return EntityRow(
      id: serializer.fromJson<String>(json['id']),
      projectId: serializer.fromJson<String?>(json['projectId']),
      name: serializer.fromJson<String>(json['name']),
      entityType: serializer.fromJson<String>(json['entityType']),
      status: serializer.fromJson<String>(json['status']),
      description: serializer.fromJson<String?>(json['description']),
      customFields: serializer.fromJson<String>(json['customFields']),
      iconColor: serializer.fromJson<int>(json['iconColor']),
      isDeleted: serializer.fromJson<bool>(json['isDeleted']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'projectId': serializer.toJson<String?>(projectId),
      'name': serializer.toJson<String>(name),
      'entityType': serializer.toJson<String>(entityType),
      'status': serializer.toJson<String>(status),
      'description': serializer.toJson<String?>(description),
      'customFields': serializer.toJson<String>(customFields),
      'iconColor': serializer.toJson<int>(iconColor),
      'isDeleted': serializer.toJson<bool>(isDeleted),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  EntityRow copyWith(
          {String? id,
          Value<String?> projectId = const Value.absent(),
          String? name,
          String? entityType,
          String? status,
          Value<String?> description = const Value.absent(),
          String? customFields,
          int? iconColor,
          bool? isDeleted,
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      EntityRow(
        id: id ?? this.id,
        projectId: projectId.present ? projectId.value : this.projectId,
        name: name ?? this.name,
        entityType: entityType ?? this.entityType,
        status: status ?? this.status,
        description: description.present ? description.value : this.description,
        customFields: customFields ?? this.customFields,
        iconColor: iconColor ?? this.iconColor,
        isDeleted: isDeleted ?? this.isDeleted,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  EntityRow copyWithCompanion(EntitiesCompanion data) {
    return EntityRow(
      id: data.id.present ? data.id.value : this.id,
      projectId: data.projectId.present ? data.projectId.value : this.projectId,
      name: data.name.present ? data.name.value : this.name,
      entityType:
          data.entityType.present ? data.entityType.value : this.entityType,
      status: data.status.present ? data.status.value : this.status,
      description:
          data.description.present ? data.description.value : this.description,
      customFields: data.customFields.present
          ? data.customFields.value
          : this.customFields,
      iconColor: data.iconColor.present ? data.iconColor.value : this.iconColor,
      isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('EntityRow(')
          ..write('id: $id, ')
          ..write('projectId: $projectId, ')
          ..write('name: $name, ')
          ..write('entityType: $entityType, ')
          ..write('status: $status, ')
          ..write('description: $description, ')
          ..write('customFields: $customFields, ')
          ..write('iconColor: $iconColor, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, projectId, name, entityType, status,
      description, customFields, iconColor, isDeleted, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is EntityRow &&
          other.id == this.id &&
          other.projectId == this.projectId &&
          other.name == this.name &&
          other.entityType == this.entityType &&
          other.status == this.status &&
          other.description == this.description &&
          other.customFields == this.customFields &&
          other.iconColor == this.iconColor &&
          other.isDeleted == this.isDeleted &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class EntitiesCompanion extends UpdateCompanion<EntityRow> {
  final Value<String> id;
  final Value<String?> projectId;
  final Value<String> name;
  final Value<String> entityType;
  final Value<String> status;
  final Value<String?> description;
  final Value<String> customFields;
  final Value<int> iconColor;
  final Value<bool> isDeleted;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const EntitiesCompanion({
    this.id = const Value.absent(),
    this.projectId = const Value.absent(),
    this.name = const Value.absent(),
    this.entityType = const Value.absent(),
    this.status = const Value.absent(),
    this.description = const Value.absent(),
    this.customFields = const Value.absent(),
    this.iconColor = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  EntitiesCompanion.insert({
    required String id,
    this.projectId = const Value.absent(),
    required String name,
    required String entityType,
    this.status = const Value.absent(),
    this.description = const Value.absent(),
    this.customFields = const Value.absent(),
    required int iconColor,
    this.isDeleted = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        name = Value(name),
        entityType = Value(entityType),
        iconColor = Value(iconColor),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<EntityRow> custom({
    Expression<String>? id,
    Expression<String>? projectId,
    Expression<String>? name,
    Expression<String>? entityType,
    Expression<String>? status,
    Expression<String>? description,
    Expression<String>? customFields,
    Expression<int>? iconColor,
    Expression<bool>? isDeleted,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (projectId != null) 'project_id': projectId,
      if (name != null) 'name': name,
      if (entityType != null) 'entity_type': entityType,
      if (status != null) 'status': status,
      if (description != null) 'description': description,
      if (customFields != null) 'custom_fields': customFields,
      if (iconColor != null) 'icon_color': iconColor,
      if (isDeleted != null) 'is_deleted': isDeleted,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  EntitiesCompanion copyWith(
      {Value<String>? id,
      Value<String?>? projectId,
      Value<String>? name,
      Value<String>? entityType,
      Value<String>? status,
      Value<String?>? description,
      Value<String>? customFields,
      Value<int>? iconColor,
      Value<bool>? isDeleted,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<int>? rowid}) {
    return EntitiesCompanion(
      id: id ?? this.id,
      projectId: projectId ?? this.projectId,
      name: name ?? this.name,
      entityType: entityType ?? this.entityType,
      status: status ?? this.status,
      description: description ?? this.description,
      customFields: customFields ?? this.customFields,
      iconColor: iconColor ?? this.iconColor,
      isDeleted: isDeleted ?? this.isDeleted,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (projectId.present) {
      map['project_id'] = Variable<String>(projectId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (entityType.present) {
      map['entity_type'] = Variable<String>(entityType.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (customFields.present) {
      map['custom_fields'] = Variable<String>(customFields.value);
    }
    if (iconColor.present) {
      map['icon_color'] = Variable<int>(iconColor.value);
    }
    if (isDeleted.present) {
      map['is_deleted'] = Variable<bool>(isDeleted.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EntitiesCompanion(')
          ..write('id: $id, ')
          ..write('projectId: $projectId, ')
          ..write('name: $name, ')
          ..write('entityType: $entityType, ')
          ..write('status: $status, ')
          ..write('description: $description, ')
          ..write('customFields: $customFields, ')
          ..write('iconColor: $iconColor, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RelationshipsTable extends Relationships
    with TableInfo<$RelationshipsTable, RelationshipRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RelationshipsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _sourceIdMeta =
      const VerificationMeta('sourceId');
  @override
  late final GeneratedColumn<String> sourceId = GeneratedColumn<String>(
      'source_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES entities (id) ON DELETE CASCADE'));
  static const VerificationMeta _targetIdMeta =
      const VerificationMeta('targetId');
  @override
  late final GeneratedColumn<String> targetId = GeneratedColumn<String>(
      'target_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES entities (id) ON DELETE CASCADE'));
  static const VerificationMeta _typeKeyMeta =
      const VerificationMeta('typeKey');
  @override
  late final GeneratedColumn<String> typeKey = GeneratedColumn<String>(
      'type_key', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _weightMeta = const VerificationMeta('weight');
  @override
  late final GeneratedColumn<int> weight = GeneratedColumn<int>(
      'weight', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(5));
  static const VerificationMeta _isDeletedMeta =
      const VerificationMeta('isDeleted');
  @override
  late final GeneratedColumn<bool> isDeleted = GeneratedColumn<bool>(
      'is_deleted', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_deleted" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        sourceId,
        targetId,
        typeKey,
        description,
        weight,
        isDeleted,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'relationships';
  @override
  VerificationContext validateIntegrity(Insertable<RelationshipRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('source_id')) {
      context.handle(_sourceIdMeta,
          sourceId.isAcceptableOrUnknown(data['source_id']!, _sourceIdMeta));
    } else if (isInserting) {
      context.missing(_sourceIdMeta);
    }
    if (data.containsKey('target_id')) {
      context.handle(_targetIdMeta,
          targetId.isAcceptableOrUnknown(data['target_id']!, _targetIdMeta));
    } else if (isInserting) {
      context.missing(_targetIdMeta);
    }
    if (data.containsKey('type_key')) {
      context.handle(_typeKeyMeta,
          typeKey.isAcceptableOrUnknown(data['type_key']!, _typeKeyMeta));
    } else if (isInserting) {
      context.missing(_typeKeyMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    }
    if (data.containsKey('weight')) {
      context.handle(_weightMeta,
          weight.isAcceptableOrUnknown(data['weight']!, _weightMeta));
    }
    if (data.containsKey('is_deleted')) {
      context.handle(_isDeletedMeta,
          isDeleted.isAcceptableOrUnknown(data['is_deleted']!, _isDeletedMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RelationshipRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RelationshipRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      sourceId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}source_id'])!,
      targetId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}target_id'])!,
      typeKey: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type_key'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description']),
      weight: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}weight'])!,
      isDeleted: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_deleted'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $RelationshipsTable createAlias(String alias) {
    return $RelationshipsTable(attachedDatabase, alias);
  }
}

class RelationshipRow extends DataClass implements Insertable<RelationshipRow> {
  final String id;
  final String sourceId;
  final String targetId;
  final String typeKey;
  final String? description;
  final int weight;
  final bool isDeleted;
  final DateTime createdAt;
  final DateTime updatedAt;
  const RelationshipRow(
      {required this.id,
      required this.sourceId,
      required this.targetId,
      required this.typeKey,
      this.description,
      required this.weight,
      required this.isDeleted,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['source_id'] = Variable<String>(sourceId);
    map['target_id'] = Variable<String>(targetId);
    map['type_key'] = Variable<String>(typeKey);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['weight'] = Variable<int>(weight);
    map['is_deleted'] = Variable<bool>(isDeleted);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  RelationshipsCompanion toCompanion(bool nullToAbsent) {
    return RelationshipsCompanion(
      id: Value(id),
      sourceId: Value(sourceId),
      targetId: Value(targetId),
      typeKey: Value(typeKey),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      weight: Value(weight),
      isDeleted: Value(isDeleted),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory RelationshipRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RelationshipRow(
      id: serializer.fromJson<String>(json['id']),
      sourceId: serializer.fromJson<String>(json['sourceId']),
      targetId: serializer.fromJson<String>(json['targetId']),
      typeKey: serializer.fromJson<String>(json['typeKey']),
      description: serializer.fromJson<String?>(json['description']),
      weight: serializer.fromJson<int>(json['weight']),
      isDeleted: serializer.fromJson<bool>(json['isDeleted']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'sourceId': serializer.toJson<String>(sourceId),
      'targetId': serializer.toJson<String>(targetId),
      'typeKey': serializer.toJson<String>(typeKey),
      'description': serializer.toJson<String?>(description),
      'weight': serializer.toJson<int>(weight),
      'isDeleted': serializer.toJson<bool>(isDeleted),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  RelationshipRow copyWith(
          {String? id,
          String? sourceId,
          String? targetId,
          String? typeKey,
          Value<String?> description = const Value.absent(),
          int? weight,
          bool? isDeleted,
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      RelationshipRow(
        id: id ?? this.id,
        sourceId: sourceId ?? this.sourceId,
        targetId: targetId ?? this.targetId,
        typeKey: typeKey ?? this.typeKey,
        description: description.present ? description.value : this.description,
        weight: weight ?? this.weight,
        isDeleted: isDeleted ?? this.isDeleted,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  RelationshipRow copyWithCompanion(RelationshipsCompanion data) {
    return RelationshipRow(
      id: data.id.present ? data.id.value : this.id,
      sourceId: data.sourceId.present ? data.sourceId.value : this.sourceId,
      targetId: data.targetId.present ? data.targetId.value : this.targetId,
      typeKey: data.typeKey.present ? data.typeKey.value : this.typeKey,
      description:
          data.description.present ? data.description.value : this.description,
      weight: data.weight.present ? data.weight.value : this.weight,
      isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RelationshipRow(')
          ..write('id: $id, ')
          ..write('sourceId: $sourceId, ')
          ..write('targetId: $targetId, ')
          ..write('typeKey: $typeKey, ')
          ..write('description: $description, ')
          ..write('weight: $weight, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, sourceId, targetId, typeKey, description,
      weight, isDeleted, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RelationshipRow &&
          other.id == this.id &&
          other.sourceId == this.sourceId &&
          other.targetId == this.targetId &&
          other.typeKey == this.typeKey &&
          other.description == this.description &&
          other.weight == this.weight &&
          other.isDeleted == this.isDeleted &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class RelationshipsCompanion extends UpdateCompanion<RelationshipRow> {
  final Value<String> id;
  final Value<String> sourceId;
  final Value<String> targetId;
  final Value<String> typeKey;
  final Value<String?> description;
  final Value<int> weight;
  final Value<bool> isDeleted;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const RelationshipsCompanion({
    this.id = const Value.absent(),
    this.sourceId = const Value.absent(),
    this.targetId = const Value.absent(),
    this.typeKey = const Value.absent(),
    this.description = const Value.absent(),
    this.weight = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RelationshipsCompanion.insert({
    required String id,
    required String sourceId,
    required String targetId,
    required String typeKey,
    this.description = const Value.absent(),
    this.weight = const Value.absent(),
    this.isDeleted = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        sourceId = Value(sourceId),
        targetId = Value(targetId),
        typeKey = Value(typeKey),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<RelationshipRow> custom({
    Expression<String>? id,
    Expression<String>? sourceId,
    Expression<String>? targetId,
    Expression<String>? typeKey,
    Expression<String>? description,
    Expression<int>? weight,
    Expression<bool>? isDeleted,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (sourceId != null) 'source_id': sourceId,
      if (targetId != null) 'target_id': targetId,
      if (typeKey != null) 'type_key': typeKey,
      if (description != null) 'description': description,
      if (weight != null) 'weight': weight,
      if (isDeleted != null) 'is_deleted': isDeleted,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RelationshipsCompanion copyWith(
      {Value<String>? id,
      Value<String>? sourceId,
      Value<String>? targetId,
      Value<String>? typeKey,
      Value<String?>? description,
      Value<int>? weight,
      Value<bool>? isDeleted,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<int>? rowid}) {
    return RelationshipsCompanion(
      id: id ?? this.id,
      sourceId: sourceId ?? this.sourceId,
      targetId: targetId ?? this.targetId,
      typeKey: typeKey ?? this.typeKey,
      description: description ?? this.description,
      weight: weight ?? this.weight,
      isDeleted: isDeleted ?? this.isDeleted,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (sourceId.present) {
      map['source_id'] = Variable<String>(sourceId.value);
    }
    if (targetId.present) {
      map['target_id'] = Variable<String>(targetId.value);
    }
    if (typeKey.present) {
      map['type_key'] = Variable<String>(typeKey.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (weight.present) {
      map['weight'] = Variable<int>(weight.value);
    }
    if (isDeleted.present) {
      map['is_deleted'] = Variable<bool>(isDeleted.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RelationshipsCompanion(')
          ..write('id: $id, ')
          ..write('sourceId: $sourceId, ')
          ..write('targetId: $targetId, ')
          ..write('typeKey: $typeKey, ')
          ..write('description: $description, ')
          ..write('weight: $weight, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TagsTable extends Tags with TableInfo<$TagsTable, TagRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TagsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _projectIdMeta =
      const VerificationMeta('projectId');
  @override
  late final GeneratedColumn<String> projectId = GeneratedColumn<String>(
      'project_id', aliasedName, true,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES projects (id) ON DELETE CASCADE'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 100),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _colorMeta = const VerificationMeta('color');
  @override
  late final GeneratedColumn<int> color = GeneratedColumn<int>(
      'color', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, projectId, name, color];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'tags';
  @override
  VerificationContext validateIntegrity(Insertable<TagRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('project_id')) {
      context.handle(_projectIdMeta,
          projectId.isAcceptableOrUnknown(data['project_id']!, _projectIdMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('color')) {
      context.handle(
          _colorMeta, color.isAcceptableOrUnknown(data['color']!, _colorMeta));
    } else if (isInserting) {
      context.missing(_colorMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TagRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TagRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      projectId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}project_id']),
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      color: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}color'])!,
    );
  }

  @override
  $TagsTable createAlias(String alias) {
    return $TagsTable(attachedDatabase, alias);
  }
}

class TagRow extends DataClass implements Insertable<TagRow> {
  final String id;
  final String? projectId;
  final String name;
  final int color;
  const TagRow(
      {required this.id,
      this.projectId,
      required this.name,
      required this.color});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || projectId != null) {
      map['project_id'] = Variable<String>(projectId);
    }
    map['name'] = Variable<String>(name);
    map['color'] = Variable<int>(color);
    return map;
  }

  TagsCompanion toCompanion(bool nullToAbsent) {
    return TagsCompanion(
      id: Value(id),
      projectId: projectId == null && nullToAbsent
          ? const Value.absent()
          : Value(projectId),
      name: Value(name),
      color: Value(color),
    );
  }

  factory TagRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TagRow(
      id: serializer.fromJson<String>(json['id']),
      projectId: serializer.fromJson<String?>(json['projectId']),
      name: serializer.fromJson<String>(json['name']),
      color: serializer.fromJson<int>(json['color']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'projectId': serializer.toJson<String?>(projectId),
      'name': serializer.toJson<String>(name),
      'color': serializer.toJson<int>(color),
    };
  }

  TagRow copyWith(
          {String? id,
          Value<String?> projectId = const Value.absent(),
          String? name,
          int? color}) =>
      TagRow(
        id: id ?? this.id,
        projectId: projectId.present ? projectId.value : this.projectId,
        name: name ?? this.name,
        color: color ?? this.color,
      );
  TagRow copyWithCompanion(TagsCompanion data) {
    return TagRow(
      id: data.id.present ? data.id.value : this.id,
      projectId: data.projectId.present ? data.projectId.value : this.projectId,
      name: data.name.present ? data.name.value : this.name,
      color: data.color.present ? data.color.value : this.color,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TagRow(')
          ..write('id: $id, ')
          ..write('projectId: $projectId, ')
          ..write('name: $name, ')
          ..write('color: $color')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, projectId, name, color);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TagRow &&
          other.id == this.id &&
          other.projectId == this.projectId &&
          other.name == this.name &&
          other.color == this.color);
}

class TagsCompanion extends UpdateCompanion<TagRow> {
  final Value<String> id;
  final Value<String?> projectId;
  final Value<String> name;
  final Value<int> color;
  final Value<int> rowid;
  const TagsCompanion({
    this.id = const Value.absent(),
    this.projectId = const Value.absent(),
    this.name = const Value.absent(),
    this.color = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TagsCompanion.insert({
    required String id,
    this.projectId = const Value.absent(),
    required String name,
    required int color,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        name = Value(name),
        color = Value(color);
  static Insertable<TagRow> custom({
    Expression<String>? id,
    Expression<String>? projectId,
    Expression<String>? name,
    Expression<int>? color,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (projectId != null) 'project_id': projectId,
      if (name != null) 'name': name,
      if (color != null) 'color': color,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TagsCompanion copyWith(
      {Value<String>? id,
      Value<String?>? projectId,
      Value<String>? name,
      Value<int>? color,
      Value<int>? rowid}) {
    return TagsCompanion(
      id: id ?? this.id,
      projectId: projectId ?? this.projectId,
      name: name ?? this.name,
      color: color ?? this.color,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (projectId.present) {
      map['project_id'] = Variable<String>(projectId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (color.present) {
      map['color'] = Variable<int>(color.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TagsCompanion(')
          ..write('id: $id, ')
          ..write('projectId: $projectId, ')
          ..write('name: $name, ')
          ..write('color: $color, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $EntityTagsTable extends EntityTags
    with TableInfo<$EntityTagsTable, EntityTagRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EntityTagsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _entityIdMeta =
      const VerificationMeta('entityId');
  @override
  late final GeneratedColumn<String> entityId = GeneratedColumn<String>(
      'entity_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES entities (id) ON DELETE CASCADE'));
  static const VerificationMeta _tagIdMeta = const VerificationMeta('tagId');
  @override
  late final GeneratedColumn<String> tagId = GeneratedColumn<String>(
      'tag_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES tags (id) ON DELETE CASCADE'));
  @override
  List<GeneratedColumn> get $columns => [entityId, tagId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'entity_tags';
  @override
  VerificationContext validateIntegrity(Insertable<EntityTagRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('entity_id')) {
      context.handle(_entityIdMeta,
          entityId.isAcceptableOrUnknown(data['entity_id']!, _entityIdMeta));
    } else if (isInserting) {
      context.missing(_entityIdMeta);
    }
    if (data.containsKey('tag_id')) {
      context.handle(
          _tagIdMeta, tagId.isAcceptableOrUnknown(data['tag_id']!, _tagIdMeta));
    } else if (isInserting) {
      context.missing(_tagIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {entityId, tagId};
  @override
  EntityTagRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return EntityTagRow(
      entityId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}entity_id'])!,
      tagId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}tag_id'])!,
    );
  }

  @override
  $EntityTagsTable createAlias(String alias) {
    return $EntityTagsTable(attachedDatabase, alias);
  }
}

class EntityTagRow extends DataClass implements Insertable<EntityTagRow> {
  final String entityId;
  final String tagId;
  const EntityTagRow({required this.entityId, required this.tagId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['entity_id'] = Variable<String>(entityId);
    map['tag_id'] = Variable<String>(tagId);
    return map;
  }

  EntityTagsCompanion toCompanion(bool nullToAbsent) {
    return EntityTagsCompanion(
      entityId: Value(entityId),
      tagId: Value(tagId),
    );
  }

  factory EntityTagRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return EntityTagRow(
      entityId: serializer.fromJson<String>(json['entityId']),
      tagId: serializer.fromJson<String>(json['tagId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'entityId': serializer.toJson<String>(entityId),
      'tagId': serializer.toJson<String>(tagId),
    };
  }

  EntityTagRow copyWith({String? entityId, String? tagId}) => EntityTagRow(
        entityId: entityId ?? this.entityId,
        tagId: tagId ?? this.tagId,
      );
  EntityTagRow copyWithCompanion(EntityTagsCompanion data) {
    return EntityTagRow(
      entityId: data.entityId.present ? data.entityId.value : this.entityId,
      tagId: data.tagId.present ? data.tagId.value : this.tagId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('EntityTagRow(')
          ..write('entityId: $entityId, ')
          ..write('tagId: $tagId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(entityId, tagId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is EntityTagRow &&
          other.entityId == this.entityId &&
          other.tagId == this.tagId);
}

class EntityTagsCompanion extends UpdateCompanion<EntityTagRow> {
  final Value<String> entityId;
  final Value<String> tagId;
  final Value<int> rowid;
  const EntityTagsCompanion({
    this.entityId = const Value.absent(),
    this.tagId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  EntityTagsCompanion.insert({
    required String entityId,
    required String tagId,
    this.rowid = const Value.absent(),
  })  : entityId = Value(entityId),
        tagId = Value(tagId);
  static Insertable<EntityTagRow> custom({
    Expression<String>? entityId,
    Expression<String>? tagId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (entityId != null) 'entity_id': entityId,
      if (tagId != null) 'tag_id': tagId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  EntityTagsCompanion copyWith(
      {Value<String>? entityId, Value<String>? tagId, Value<int>? rowid}) {
    return EntityTagsCompanion(
      entityId: entityId ?? this.entityId,
      tagId: tagId ?? this.tagId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (entityId.present) {
      map['entity_id'] = Variable<String>(entityId.value);
    }
    if (tagId.present) {
      map['tag_id'] = Variable<String>(tagId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EntityTagsCompanion(')
          ..write('entityId: $entityId, ')
          ..write('tagId: $tagId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TimelineEntriesTable extends TimelineEntries
    with TableInfo<$TimelineEntriesTable, TimelineEntryRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TimelineEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _projectIdMeta =
      const VerificationMeta('projectId');
  @override
  late final GeneratedColumn<String> projectId = GeneratedColumn<String>(
      'project_id', aliasedName, true,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES projects (id) ON DELETE CASCADE'));
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 500),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _dateLabelMeta =
      const VerificationMeta('dateLabel');
  @override
  late final GeneratedColumn<String> dateLabel = GeneratedColumn<String>(
      'date_label', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _eraLabelMeta =
      const VerificationMeta('eraLabel');
  @override
  late final GeneratedColumn<String> eraLabel = GeneratedColumn<String>(
      'era_label', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _sortOrderMeta =
      const VerificationMeta('sortOrder');
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
      'sort_order', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _entityIdMeta =
      const VerificationMeta('entityId');
  @override
  late final GeneratedColumn<String> entityId = GeneratedColumn<String>(
      'entity_id', aliasedName, true,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES entities (id) ON DELETE SET NULL'));
  static const VerificationMeta _isDeletedMeta =
      const VerificationMeta('isDeleted');
  @override
  late final GeneratedColumn<bool> isDeleted = GeneratedColumn<bool>(
      'is_deleted', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_deleted" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        projectId,
        title,
        description,
        dateLabel,
        eraLabel,
        sortOrder,
        entityId,
        isDeleted,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'timeline_entries';
  @override
  VerificationContext validateIntegrity(Insertable<TimelineEntryRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('project_id')) {
      context.handle(_projectIdMeta,
          projectId.isAcceptableOrUnknown(data['project_id']!, _projectIdMeta));
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    }
    if (data.containsKey('date_label')) {
      context.handle(_dateLabelMeta,
          dateLabel.isAcceptableOrUnknown(data['date_label']!, _dateLabelMeta));
    }
    if (data.containsKey('era_label')) {
      context.handle(_eraLabelMeta,
          eraLabel.isAcceptableOrUnknown(data['era_label']!, _eraLabelMeta));
    }
    if (data.containsKey('sort_order')) {
      context.handle(_sortOrderMeta,
          sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta));
    } else if (isInserting) {
      context.missing(_sortOrderMeta);
    }
    if (data.containsKey('entity_id')) {
      context.handle(_entityIdMeta,
          entityId.isAcceptableOrUnknown(data['entity_id']!, _entityIdMeta));
    }
    if (data.containsKey('is_deleted')) {
      context.handle(_isDeletedMeta,
          isDeleted.isAcceptableOrUnknown(data['is_deleted']!, _isDeletedMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TimelineEntryRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TimelineEntryRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      projectId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}project_id']),
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description']),
      dateLabel: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}date_label']),
      eraLabel: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}era_label']),
      sortOrder: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}sort_order'])!,
      entityId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}entity_id']),
      isDeleted: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_deleted'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $TimelineEntriesTable createAlias(String alias) {
    return $TimelineEntriesTable(attachedDatabase, alias);
  }
}

class TimelineEntryRow extends DataClass
    implements Insertable<TimelineEntryRow> {
  final String id;
  final String? projectId;
  final String title;
  final String? description;
  final String? dateLabel;
  final String? eraLabel;
  final int sortOrder;
  final String? entityId;
  final bool isDeleted;
  final DateTime createdAt;
  final DateTime updatedAt;
  const TimelineEntryRow(
      {required this.id,
      this.projectId,
      required this.title,
      this.description,
      this.dateLabel,
      this.eraLabel,
      required this.sortOrder,
      this.entityId,
      required this.isDeleted,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || projectId != null) {
      map['project_id'] = Variable<String>(projectId);
    }
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    if (!nullToAbsent || dateLabel != null) {
      map['date_label'] = Variable<String>(dateLabel);
    }
    if (!nullToAbsent || eraLabel != null) {
      map['era_label'] = Variable<String>(eraLabel);
    }
    map['sort_order'] = Variable<int>(sortOrder);
    if (!nullToAbsent || entityId != null) {
      map['entity_id'] = Variable<String>(entityId);
    }
    map['is_deleted'] = Variable<bool>(isDeleted);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  TimelineEntriesCompanion toCompanion(bool nullToAbsent) {
    return TimelineEntriesCompanion(
      id: Value(id),
      projectId: projectId == null && nullToAbsent
          ? const Value.absent()
          : Value(projectId),
      title: Value(title),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      dateLabel: dateLabel == null && nullToAbsent
          ? const Value.absent()
          : Value(dateLabel),
      eraLabel: eraLabel == null && nullToAbsent
          ? const Value.absent()
          : Value(eraLabel),
      sortOrder: Value(sortOrder),
      entityId: entityId == null && nullToAbsent
          ? const Value.absent()
          : Value(entityId),
      isDeleted: Value(isDeleted),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory TimelineEntryRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TimelineEntryRow(
      id: serializer.fromJson<String>(json['id']),
      projectId: serializer.fromJson<String?>(json['projectId']),
      title: serializer.fromJson<String>(json['title']),
      description: serializer.fromJson<String?>(json['description']),
      dateLabel: serializer.fromJson<String?>(json['dateLabel']),
      eraLabel: serializer.fromJson<String?>(json['eraLabel']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
      entityId: serializer.fromJson<String?>(json['entityId']),
      isDeleted: serializer.fromJson<bool>(json['isDeleted']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'projectId': serializer.toJson<String?>(projectId),
      'title': serializer.toJson<String>(title),
      'description': serializer.toJson<String?>(description),
      'dateLabel': serializer.toJson<String?>(dateLabel),
      'eraLabel': serializer.toJson<String?>(eraLabel),
      'sortOrder': serializer.toJson<int>(sortOrder),
      'entityId': serializer.toJson<String?>(entityId),
      'isDeleted': serializer.toJson<bool>(isDeleted),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  TimelineEntryRow copyWith(
          {String? id,
          Value<String?> projectId = const Value.absent(),
          String? title,
          Value<String?> description = const Value.absent(),
          Value<String?> dateLabel = const Value.absent(),
          Value<String?> eraLabel = const Value.absent(),
          int? sortOrder,
          Value<String?> entityId = const Value.absent(),
          bool? isDeleted,
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      TimelineEntryRow(
        id: id ?? this.id,
        projectId: projectId.present ? projectId.value : this.projectId,
        title: title ?? this.title,
        description: description.present ? description.value : this.description,
        dateLabel: dateLabel.present ? dateLabel.value : this.dateLabel,
        eraLabel: eraLabel.present ? eraLabel.value : this.eraLabel,
        sortOrder: sortOrder ?? this.sortOrder,
        entityId: entityId.present ? entityId.value : this.entityId,
        isDeleted: isDeleted ?? this.isDeleted,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  TimelineEntryRow copyWithCompanion(TimelineEntriesCompanion data) {
    return TimelineEntryRow(
      id: data.id.present ? data.id.value : this.id,
      projectId: data.projectId.present ? data.projectId.value : this.projectId,
      title: data.title.present ? data.title.value : this.title,
      description:
          data.description.present ? data.description.value : this.description,
      dateLabel: data.dateLabel.present ? data.dateLabel.value : this.dateLabel,
      eraLabel: data.eraLabel.present ? data.eraLabel.value : this.eraLabel,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
      entityId: data.entityId.present ? data.entityId.value : this.entityId,
      isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TimelineEntryRow(')
          ..write('id: $id, ')
          ..write('projectId: $projectId, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('dateLabel: $dateLabel, ')
          ..write('eraLabel: $eraLabel, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('entityId: $entityId, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, projectId, title, description, dateLabel,
      eraLabel, sortOrder, entityId, isDeleted, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TimelineEntryRow &&
          other.id == this.id &&
          other.projectId == this.projectId &&
          other.title == this.title &&
          other.description == this.description &&
          other.dateLabel == this.dateLabel &&
          other.eraLabel == this.eraLabel &&
          other.sortOrder == this.sortOrder &&
          other.entityId == this.entityId &&
          other.isDeleted == this.isDeleted &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class TimelineEntriesCompanion extends UpdateCompanion<TimelineEntryRow> {
  final Value<String> id;
  final Value<String?> projectId;
  final Value<String> title;
  final Value<String?> description;
  final Value<String?> dateLabel;
  final Value<String?> eraLabel;
  final Value<int> sortOrder;
  final Value<String?> entityId;
  final Value<bool> isDeleted;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const TimelineEntriesCompanion({
    this.id = const Value.absent(),
    this.projectId = const Value.absent(),
    this.title = const Value.absent(),
    this.description = const Value.absent(),
    this.dateLabel = const Value.absent(),
    this.eraLabel = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.entityId = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TimelineEntriesCompanion.insert({
    required String id,
    this.projectId = const Value.absent(),
    required String title,
    this.description = const Value.absent(),
    this.dateLabel = const Value.absent(),
    this.eraLabel = const Value.absent(),
    required int sortOrder,
    this.entityId = const Value.absent(),
    this.isDeleted = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        title = Value(title),
        sortOrder = Value(sortOrder),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<TimelineEntryRow> custom({
    Expression<String>? id,
    Expression<String>? projectId,
    Expression<String>? title,
    Expression<String>? description,
    Expression<String>? dateLabel,
    Expression<String>? eraLabel,
    Expression<int>? sortOrder,
    Expression<String>? entityId,
    Expression<bool>? isDeleted,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (projectId != null) 'project_id': projectId,
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      if (dateLabel != null) 'date_label': dateLabel,
      if (eraLabel != null) 'era_label': eraLabel,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (entityId != null) 'entity_id': entityId,
      if (isDeleted != null) 'is_deleted': isDeleted,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TimelineEntriesCompanion copyWith(
      {Value<String>? id,
      Value<String?>? projectId,
      Value<String>? title,
      Value<String?>? description,
      Value<String?>? dateLabel,
      Value<String?>? eraLabel,
      Value<int>? sortOrder,
      Value<String?>? entityId,
      Value<bool>? isDeleted,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<int>? rowid}) {
    return TimelineEntriesCompanion(
      id: id ?? this.id,
      projectId: projectId ?? this.projectId,
      title: title ?? this.title,
      description: description ?? this.description,
      dateLabel: dateLabel ?? this.dateLabel,
      eraLabel: eraLabel ?? this.eraLabel,
      sortOrder: sortOrder ?? this.sortOrder,
      entityId: entityId ?? this.entityId,
      isDeleted: isDeleted ?? this.isDeleted,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (projectId.present) {
      map['project_id'] = Variable<String>(projectId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (dateLabel.present) {
      map['date_label'] = Variable<String>(dateLabel.value);
    }
    if (eraLabel.present) {
      map['era_label'] = Variable<String>(eraLabel.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (entityId.present) {
      map['entity_id'] = Variable<String>(entityId.value);
    }
    if (isDeleted.present) {
      map['is_deleted'] = Variable<bool>(isDeleted.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TimelineEntriesCompanion(')
          ..write('id: $id, ')
          ..write('projectId: $projectId, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('dateLabel: $dateLabel, ')
          ..write('eraLabel: $eraLabel, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('entityId: $entityId, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $EntityVersionsTable extends EntityVersions
    with TableInfo<$EntityVersionsTable, EntityVersionRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EntityVersionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _entityIdMeta =
      const VerificationMeta('entityId');
  @override
  late final GeneratedColumn<String> entityId = GeneratedColumn<String>(
      'entity_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES entities (id) ON DELETE CASCADE'));
  static const VerificationMeta _snapshotJsonMeta =
      const VerificationMeta('snapshotJson');
  @override
  late final GeneratedColumn<String> snapshotJson = GeneratedColumn<String>(
      'snapshot_json', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _changedAtMeta =
      const VerificationMeta('changedAt');
  @override
  late final GeneratedColumn<DateTime> changedAt = GeneratedColumn<DateTime>(
      'changed_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _changeNoteMeta =
      const VerificationMeta('changeNote');
  @override
  late final GeneratedColumn<String> changeNote = GeneratedColumn<String>(
      'change_note', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, entityId, snapshotJson, changedAt, changeNote];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'entity_versions';
  @override
  VerificationContext validateIntegrity(Insertable<EntityVersionRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('entity_id')) {
      context.handle(_entityIdMeta,
          entityId.isAcceptableOrUnknown(data['entity_id']!, _entityIdMeta));
    } else if (isInserting) {
      context.missing(_entityIdMeta);
    }
    if (data.containsKey('snapshot_json')) {
      context.handle(
          _snapshotJsonMeta,
          snapshotJson.isAcceptableOrUnknown(
              data['snapshot_json']!, _snapshotJsonMeta));
    } else if (isInserting) {
      context.missing(_snapshotJsonMeta);
    }
    if (data.containsKey('changed_at')) {
      context.handle(_changedAtMeta,
          changedAt.isAcceptableOrUnknown(data['changed_at']!, _changedAtMeta));
    } else if (isInserting) {
      context.missing(_changedAtMeta);
    }
    if (data.containsKey('change_note')) {
      context.handle(
          _changeNoteMeta,
          changeNote.isAcceptableOrUnknown(
              data['change_note']!, _changeNoteMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  EntityVersionRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return EntityVersionRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      entityId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}entity_id'])!,
      snapshotJson: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}snapshot_json'])!,
      changedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}changed_at'])!,
      changeNote: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}change_note']),
    );
  }

  @override
  $EntityVersionsTable createAlias(String alias) {
    return $EntityVersionsTable(attachedDatabase, alias);
  }
}

class EntityVersionRow extends DataClass
    implements Insertable<EntityVersionRow> {
  final String id;
  final String entityId;
  final String snapshotJson;
  final DateTime changedAt;
  final String? changeNote;
  const EntityVersionRow(
      {required this.id,
      required this.entityId,
      required this.snapshotJson,
      required this.changedAt,
      this.changeNote});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['entity_id'] = Variable<String>(entityId);
    map['snapshot_json'] = Variable<String>(snapshotJson);
    map['changed_at'] = Variable<DateTime>(changedAt);
    if (!nullToAbsent || changeNote != null) {
      map['change_note'] = Variable<String>(changeNote);
    }
    return map;
  }

  EntityVersionsCompanion toCompanion(bool nullToAbsent) {
    return EntityVersionsCompanion(
      id: Value(id),
      entityId: Value(entityId),
      snapshotJson: Value(snapshotJson),
      changedAt: Value(changedAt),
      changeNote: changeNote == null && nullToAbsent
          ? const Value.absent()
          : Value(changeNote),
    );
  }

  factory EntityVersionRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return EntityVersionRow(
      id: serializer.fromJson<String>(json['id']),
      entityId: serializer.fromJson<String>(json['entityId']),
      snapshotJson: serializer.fromJson<String>(json['snapshotJson']),
      changedAt: serializer.fromJson<DateTime>(json['changedAt']),
      changeNote: serializer.fromJson<String?>(json['changeNote']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'entityId': serializer.toJson<String>(entityId),
      'snapshotJson': serializer.toJson<String>(snapshotJson),
      'changedAt': serializer.toJson<DateTime>(changedAt),
      'changeNote': serializer.toJson<String?>(changeNote),
    };
  }

  EntityVersionRow copyWith(
          {String? id,
          String? entityId,
          String? snapshotJson,
          DateTime? changedAt,
          Value<String?> changeNote = const Value.absent()}) =>
      EntityVersionRow(
        id: id ?? this.id,
        entityId: entityId ?? this.entityId,
        snapshotJson: snapshotJson ?? this.snapshotJson,
        changedAt: changedAt ?? this.changedAt,
        changeNote: changeNote.present ? changeNote.value : this.changeNote,
      );
  EntityVersionRow copyWithCompanion(EntityVersionsCompanion data) {
    return EntityVersionRow(
      id: data.id.present ? data.id.value : this.id,
      entityId: data.entityId.present ? data.entityId.value : this.entityId,
      snapshotJson: data.snapshotJson.present
          ? data.snapshotJson.value
          : this.snapshotJson,
      changedAt: data.changedAt.present ? data.changedAt.value : this.changedAt,
      changeNote:
          data.changeNote.present ? data.changeNote.value : this.changeNote,
    );
  }

  @override
  String toString() {
    return (StringBuffer('EntityVersionRow(')
          ..write('id: $id, ')
          ..write('entityId: $entityId, ')
          ..write('snapshotJson: $snapshotJson, ')
          ..write('changedAt: $changedAt, ')
          ..write('changeNote: $changeNote')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, entityId, snapshotJson, changedAt, changeNote);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is EntityVersionRow &&
          other.id == this.id &&
          other.entityId == this.entityId &&
          other.snapshotJson == this.snapshotJson &&
          other.changedAt == this.changedAt &&
          other.changeNote == this.changeNote);
}

class EntityVersionsCompanion extends UpdateCompanion<EntityVersionRow> {
  final Value<String> id;
  final Value<String> entityId;
  final Value<String> snapshotJson;
  final Value<DateTime> changedAt;
  final Value<String?> changeNote;
  final Value<int> rowid;
  const EntityVersionsCompanion({
    this.id = const Value.absent(),
    this.entityId = const Value.absent(),
    this.snapshotJson = const Value.absent(),
    this.changedAt = const Value.absent(),
    this.changeNote = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  EntityVersionsCompanion.insert({
    required String id,
    required String entityId,
    required String snapshotJson,
    required DateTime changedAt,
    this.changeNote = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        entityId = Value(entityId),
        snapshotJson = Value(snapshotJson),
        changedAt = Value(changedAt);
  static Insertable<EntityVersionRow> custom({
    Expression<String>? id,
    Expression<String>? entityId,
    Expression<String>? snapshotJson,
    Expression<DateTime>? changedAt,
    Expression<String>? changeNote,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (entityId != null) 'entity_id': entityId,
      if (snapshotJson != null) 'snapshot_json': snapshotJson,
      if (changedAt != null) 'changed_at': changedAt,
      if (changeNote != null) 'change_note': changeNote,
      if (rowid != null) 'rowid': rowid,
    });
  }

  EntityVersionsCompanion copyWith(
      {Value<String>? id,
      Value<String>? entityId,
      Value<String>? snapshotJson,
      Value<DateTime>? changedAt,
      Value<String?>? changeNote,
      Value<int>? rowid}) {
    return EntityVersionsCompanion(
      id: id ?? this.id,
      entityId: entityId ?? this.entityId,
      snapshotJson: snapshotJson ?? this.snapshotJson,
      changedAt: changedAt ?? this.changedAt,
      changeNote: changeNote ?? this.changeNote,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (entityId.present) {
      map['entity_id'] = Variable<String>(entityId.value);
    }
    if (snapshotJson.present) {
      map['snapshot_json'] = Variable<String>(snapshotJson.value);
    }
    if (changedAt.present) {
      map['changed_at'] = Variable<DateTime>(changedAt.value);
    }
    if (changeNote.present) {
      map['change_note'] = Variable<String>(changeNote.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EntityVersionsCompanion(')
          ..write('id: $id, ')
          ..write('entityId: $entityId, ')
          ..write('snapshotJson: $snapshotJson, ')
          ..write('changedAt: $changedAt, ')
          ..write('changeNote: $changeNote, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TemplatesTable extends Templates
    with TableInfo<$TemplatesTable, TemplateRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TemplatesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 200),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _entityTypeMeta =
      const VerificationMeta('entityType');
  @override
  late final GeneratedColumn<String> entityType = GeneratedColumn<String>(
      'entity_type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _customFieldsSchemaMeta =
      const VerificationMeta('customFieldsSchema');
  @override
  late final GeneratedColumn<String> customFieldsSchema =
      GeneratedColumn<String>('custom_fields_schema', aliasedName, false,
          type: DriftSqlType.string,
          requiredDuringInsert: false,
          defaultValue: const Constant('[]'));
  static const VerificationMeta _isBuiltInMeta =
      const VerificationMeta('isBuiltIn');
  @override
  late final GeneratedColumn<bool> isBuiltIn = GeneratedColumn<bool>(
      'is_built_in', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_built_in" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        name,
        entityType,
        customFieldsSchema,
        isBuiltIn,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'templates';
  @override
  VerificationContext validateIntegrity(Insertable<TemplateRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('entity_type')) {
      context.handle(
          _entityTypeMeta,
          entityType.isAcceptableOrUnknown(
              data['entity_type']!, _entityTypeMeta));
    } else if (isInserting) {
      context.missing(_entityTypeMeta);
    }
    if (data.containsKey('custom_fields_schema')) {
      context.handle(
          _customFieldsSchemaMeta,
          customFieldsSchema.isAcceptableOrUnknown(
              data['custom_fields_schema']!, _customFieldsSchemaMeta));
    }
    if (data.containsKey('is_built_in')) {
      context.handle(
          _isBuiltInMeta,
          isBuiltIn.isAcceptableOrUnknown(
              data['is_built_in']!, _isBuiltInMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TemplateRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TemplateRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      entityType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}entity_type'])!,
      customFieldsSchema: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}custom_fields_schema'])!,
      isBuiltIn: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_built_in'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $TemplatesTable createAlias(String alias) {
    return $TemplatesTable(attachedDatabase, alias);
  }
}

class TemplateRow extends DataClass implements Insertable<TemplateRow> {
  final String id;
  final String name;
  final String entityType;
  final String customFieldsSchema;
  final bool isBuiltIn;
  final DateTime createdAt;
  final DateTime updatedAt;
  const TemplateRow(
      {required this.id,
      required this.name,
      required this.entityType,
      required this.customFieldsSchema,
      required this.isBuiltIn,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['entity_type'] = Variable<String>(entityType);
    map['custom_fields_schema'] = Variable<String>(customFieldsSchema);
    map['is_built_in'] = Variable<bool>(isBuiltIn);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  TemplatesCompanion toCompanion(bool nullToAbsent) {
    return TemplatesCompanion(
      id: Value(id),
      name: Value(name),
      entityType: Value(entityType),
      customFieldsSchema: Value(customFieldsSchema),
      isBuiltIn: Value(isBuiltIn),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory TemplateRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TemplateRow(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      entityType: serializer.fromJson<String>(json['entityType']),
      customFieldsSchema:
          serializer.fromJson<String>(json['customFieldsSchema']),
      isBuiltIn: serializer.fromJson<bool>(json['isBuiltIn']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'entityType': serializer.toJson<String>(entityType),
      'customFieldsSchema': serializer.toJson<String>(customFieldsSchema),
      'isBuiltIn': serializer.toJson<bool>(isBuiltIn),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  TemplateRow copyWith(
          {String? id,
          String? name,
          String? entityType,
          String? customFieldsSchema,
          bool? isBuiltIn,
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      TemplateRow(
        id: id ?? this.id,
        name: name ?? this.name,
        entityType: entityType ?? this.entityType,
        customFieldsSchema: customFieldsSchema ?? this.customFieldsSchema,
        isBuiltIn: isBuiltIn ?? this.isBuiltIn,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  TemplateRow copyWithCompanion(TemplatesCompanion data) {
    return TemplateRow(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      entityType:
          data.entityType.present ? data.entityType.value : this.entityType,
      customFieldsSchema: data.customFieldsSchema.present
          ? data.customFieldsSchema.value
          : this.customFieldsSchema,
      isBuiltIn: data.isBuiltIn.present ? data.isBuiltIn.value : this.isBuiltIn,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TemplateRow(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('entityType: $entityType, ')
          ..write('customFieldsSchema: $customFieldsSchema, ')
          ..write('isBuiltIn: $isBuiltIn, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, entityType, customFieldsSchema,
      isBuiltIn, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TemplateRow &&
          other.id == this.id &&
          other.name == this.name &&
          other.entityType == this.entityType &&
          other.customFieldsSchema == this.customFieldsSchema &&
          other.isBuiltIn == this.isBuiltIn &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class TemplatesCompanion extends UpdateCompanion<TemplateRow> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> entityType;
  final Value<String> customFieldsSchema;
  final Value<bool> isBuiltIn;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const TemplatesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.entityType = const Value.absent(),
    this.customFieldsSchema = const Value.absent(),
    this.isBuiltIn = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TemplatesCompanion.insert({
    required String id,
    required String name,
    required String entityType,
    this.customFieldsSchema = const Value.absent(),
    this.isBuiltIn = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        name = Value(name),
        entityType = Value(entityType),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<TemplateRow> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? entityType,
    Expression<String>? customFieldsSchema,
    Expression<bool>? isBuiltIn,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (entityType != null) 'entity_type': entityType,
      if (customFieldsSchema != null)
        'custom_fields_schema': customFieldsSchema,
      if (isBuiltIn != null) 'is_built_in': isBuiltIn,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TemplatesCompanion copyWith(
      {Value<String>? id,
      Value<String>? name,
      Value<String>? entityType,
      Value<String>? customFieldsSchema,
      Value<bool>? isBuiltIn,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<int>? rowid}) {
    return TemplatesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      entityType: entityType ?? this.entityType,
      customFieldsSchema: customFieldsSchema ?? this.customFieldsSchema,
      isBuiltIn: isBuiltIn ?? this.isBuiltIn,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (entityType.present) {
      map['entity_type'] = Variable<String>(entityType.value);
    }
    if (customFieldsSchema.present) {
      map['custom_fields_schema'] = Variable<String>(customFieldsSchema.value);
    }
    if (isBuiltIn.present) {
      map['is_built_in'] = Variable<bool>(isBuiltIn.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TemplatesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('entityType: $entityType, ')
          ..write('customFieldsSchema: $customFieldsSchema, ')
          ..write('isBuiltIn: $isBuiltIn, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ManuscriptChaptersTable extends ManuscriptChapters
    with TableInfo<$ManuscriptChaptersTable, ManuscriptChapterRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ManuscriptChaptersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 36, maxTextLength: 36),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _projectIdMeta =
      const VerificationMeta('projectId');
  @override
  late final GeneratedColumn<String> projectId = GeneratedColumn<String>(
      'project_id', aliasedName, true,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES projects (id) ON DELETE CASCADE'));
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 500),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _contentMeta =
      const VerificationMeta('content');
  @override
  late final GeneratedColumn<String> content = GeneratedColumn<String>(
      'content', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _sortOrderMeta =
      const VerificationMeta('sortOrder');
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
      'sort_order', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _dateLabelMeta =
      const VerificationMeta('dateLabel');
  @override
  late final GeneratedColumn<String> dateLabel = GeneratedColumn<String>(
      'date_label', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _eraLabelMeta =
      const VerificationMeta('eraLabel');
  @override
  late final GeneratedColumn<String> eraLabel = GeneratedColumn<String>(
      'era_label', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _synopsisMeta =
      const VerificationMeta('synopsis');
  @override
  late final GeneratedColumn<String> synopsis = GeneratedColumn<String>(
      'synopsis', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _povCharacterIdMeta =
      const VerificationMeta('povCharacterId');
  @override
  late final GeneratedColumn<String> povCharacterId = GeneratedColumn<String>(
      'pov_character_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _locationIdMeta =
      const VerificationMeta('locationId');
  @override
  late final GeneratedColumn<String> locationId = GeneratedColumn<String>(
      'location_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('draft'));
  static const VerificationMeta _isDeletedMeta =
      const VerificationMeta('isDeleted');
  @override
  late final GeneratedColumn<bool> isDeleted = GeneratedColumn<bool>(
      'is_deleted', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_deleted" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        projectId,
        title,
        content,
        sortOrder,
        dateLabel,
        eraLabel,
        synopsis,
        povCharacterId,
        locationId,
        status,
        isDeleted,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'manuscript_chapters';
  @override
  VerificationContext validateIntegrity(
      Insertable<ManuscriptChapterRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('project_id')) {
      context.handle(_projectIdMeta,
          projectId.isAcceptableOrUnknown(data['project_id']!, _projectIdMeta));
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('content')) {
      context.handle(_contentMeta,
          content.isAcceptableOrUnknown(data['content']!, _contentMeta));
    }
    if (data.containsKey('sort_order')) {
      context.handle(_sortOrderMeta,
          sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta));
    }
    if (data.containsKey('date_label')) {
      context.handle(_dateLabelMeta,
          dateLabel.isAcceptableOrUnknown(data['date_label']!, _dateLabelMeta));
    }
    if (data.containsKey('era_label')) {
      context.handle(_eraLabelMeta,
          eraLabel.isAcceptableOrUnknown(data['era_label']!, _eraLabelMeta));
    }
    if (data.containsKey('synopsis')) {
      context.handle(_synopsisMeta,
          synopsis.isAcceptableOrUnknown(data['synopsis']!, _synopsisMeta));
    }
    if (data.containsKey('pov_character_id')) {
      context.handle(
          _povCharacterIdMeta,
          povCharacterId.isAcceptableOrUnknown(
              data['pov_character_id']!, _povCharacterIdMeta));
    }
    if (data.containsKey('location_id')) {
      context.handle(
          _locationIdMeta,
          locationId.isAcceptableOrUnknown(
              data['location_id']!, _locationIdMeta));
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    }
    if (data.containsKey('is_deleted')) {
      context.handle(_isDeletedMeta,
          isDeleted.isAcceptableOrUnknown(data['is_deleted']!, _isDeletedMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ManuscriptChapterRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ManuscriptChapterRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      projectId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}project_id']),
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      content: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}content'])!,
      sortOrder: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}sort_order'])!,
      dateLabel: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}date_label']),
      eraLabel: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}era_label']),
      synopsis: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}synopsis']),
      povCharacterId: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}pov_character_id']),
      locationId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}location_id']),
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      isDeleted: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_deleted'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $ManuscriptChaptersTable createAlias(String alias) {
    return $ManuscriptChaptersTable(attachedDatabase, alias);
  }
}

class ManuscriptChapterRow extends DataClass
    implements Insertable<ManuscriptChapterRow> {
  final String id;
  final String? projectId;
  final String title;
  final String content;
  final int sortOrder;
  final String? dateLabel;
  final String? eraLabel;
  final String? synopsis;
  final String? povCharacterId;
  final String? locationId;
  final String status;
  final bool isDeleted;
  final DateTime createdAt;
  final DateTime updatedAt;
  const ManuscriptChapterRow(
      {required this.id,
      this.projectId,
      required this.title,
      required this.content,
      required this.sortOrder,
      this.dateLabel,
      this.eraLabel,
      this.synopsis,
      this.povCharacterId,
      this.locationId,
      required this.status,
      required this.isDeleted,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || projectId != null) {
      map['project_id'] = Variable<String>(projectId);
    }
    map['title'] = Variable<String>(title);
    map['content'] = Variable<String>(content);
    map['sort_order'] = Variable<int>(sortOrder);
    if (!nullToAbsent || dateLabel != null) {
      map['date_label'] = Variable<String>(dateLabel);
    }
    if (!nullToAbsent || eraLabel != null) {
      map['era_label'] = Variable<String>(eraLabel);
    }
    if (!nullToAbsent || synopsis != null) {
      map['synopsis'] = Variable<String>(synopsis);
    }
    if (!nullToAbsent || povCharacterId != null) {
      map['pov_character_id'] = Variable<String>(povCharacterId);
    }
    if (!nullToAbsent || locationId != null) {
      map['location_id'] = Variable<String>(locationId);
    }
    map['status'] = Variable<String>(status);
    map['is_deleted'] = Variable<bool>(isDeleted);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  ManuscriptChaptersCompanion toCompanion(bool nullToAbsent) {
    return ManuscriptChaptersCompanion(
      id: Value(id),
      projectId: projectId == null && nullToAbsent
          ? const Value.absent()
          : Value(projectId),
      title: Value(title),
      content: Value(content),
      sortOrder: Value(sortOrder),
      dateLabel: dateLabel == null && nullToAbsent
          ? const Value.absent()
          : Value(dateLabel),
      eraLabel: eraLabel == null && nullToAbsent
          ? const Value.absent()
          : Value(eraLabel),
      synopsis: synopsis == null && nullToAbsent
          ? const Value.absent()
          : Value(synopsis),
      povCharacterId: povCharacterId == null && nullToAbsent
          ? const Value.absent()
          : Value(povCharacterId),
      locationId: locationId == null && nullToAbsent
          ? const Value.absent()
          : Value(locationId),
      status: Value(status),
      isDeleted: Value(isDeleted),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory ManuscriptChapterRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ManuscriptChapterRow(
      id: serializer.fromJson<String>(json['id']),
      projectId: serializer.fromJson<String?>(json['projectId']),
      title: serializer.fromJson<String>(json['title']),
      content: serializer.fromJson<String>(json['content']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
      dateLabel: serializer.fromJson<String?>(json['dateLabel']),
      eraLabel: serializer.fromJson<String?>(json['eraLabel']),
      synopsis: serializer.fromJson<String?>(json['synopsis']),
      povCharacterId: serializer.fromJson<String?>(json['povCharacterId']),
      locationId: serializer.fromJson<String?>(json['locationId']),
      status: serializer.fromJson<String>(json['status']),
      isDeleted: serializer.fromJson<bool>(json['isDeleted']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'projectId': serializer.toJson<String?>(projectId),
      'title': serializer.toJson<String>(title),
      'content': serializer.toJson<String>(content),
      'sortOrder': serializer.toJson<int>(sortOrder),
      'dateLabel': serializer.toJson<String?>(dateLabel),
      'eraLabel': serializer.toJson<String?>(eraLabel),
      'synopsis': serializer.toJson<String?>(synopsis),
      'povCharacterId': serializer.toJson<String?>(povCharacterId),
      'locationId': serializer.toJson<String?>(locationId),
      'status': serializer.toJson<String>(status),
      'isDeleted': serializer.toJson<bool>(isDeleted),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  ManuscriptChapterRow copyWith(
          {String? id,
          Value<String?> projectId = const Value.absent(),
          String? title,
          String? content,
          int? sortOrder,
          Value<String?> dateLabel = const Value.absent(),
          Value<String?> eraLabel = const Value.absent(),
          Value<String?> synopsis = const Value.absent(),
          Value<String?> povCharacterId = const Value.absent(),
          Value<String?> locationId = const Value.absent(),
          String? status,
          bool? isDeleted,
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      ManuscriptChapterRow(
        id: id ?? this.id,
        projectId: projectId.present ? projectId.value : this.projectId,
        title: title ?? this.title,
        content: content ?? this.content,
        sortOrder: sortOrder ?? this.sortOrder,
        dateLabel: dateLabel.present ? dateLabel.value : this.dateLabel,
        eraLabel: eraLabel.present ? eraLabel.value : this.eraLabel,
        synopsis: synopsis.present ? synopsis.value : this.synopsis,
        povCharacterId:
            povCharacterId.present ? povCharacterId.value : this.povCharacterId,
        locationId: locationId.present ? locationId.value : this.locationId,
        status: status ?? this.status,
        isDeleted: isDeleted ?? this.isDeleted,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  ManuscriptChapterRow copyWithCompanion(ManuscriptChaptersCompanion data) {
    return ManuscriptChapterRow(
      id: data.id.present ? data.id.value : this.id,
      projectId: data.projectId.present ? data.projectId.value : this.projectId,
      title: data.title.present ? data.title.value : this.title,
      content: data.content.present ? data.content.value : this.content,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
      dateLabel: data.dateLabel.present ? data.dateLabel.value : this.dateLabel,
      eraLabel: data.eraLabel.present ? data.eraLabel.value : this.eraLabel,
      synopsis: data.synopsis.present ? data.synopsis.value : this.synopsis,
      povCharacterId: data.povCharacterId.present
          ? data.povCharacterId.value
          : this.povCharacterId,
      locationId:
          data.locationId.present ? data.locationId.value : this.locationId,
      status: data.status.present ? data.status.value : this.status,
      isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ManuscriptChapterRow(')
          ..write('id: $id, ')
          ..write('projectId: $projectId, ')
          ..write('title: $title, ')
          ..write('content: $content, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('dateLabel: $dateLabel, ')
          ..write('eraLabel: $eraLabel, ')
          ..write('synopsis: $synopsis, ')
          ..write('povCharacterId: $povCharacterId, ')
          ..write('locationId: $locationId, ')
          ..write('status: $status, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      projectId,
      title,
      content,
      sortOrder,
      dateLabel,
      eraLabel,
      synopsis,
      povCharacterId,
      locationId,
      status,
      isDeleted,
      createdAt,
      updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ManuscriptChapterRow &&
          other.id == this.id &&
          other.projectId == this.projectId &&
          other.title == this.title &&
          other.content == this.content &&
          other.sortOrder == this.sortOrder &&
          other.dateLabel == this.dateLabel &&
          other.eraLabel == this.eraLabel &&
          other.synopsis == this.synopsis &&
          other.povCharacterId == this.povCharacterId &&
          other.locationId == this.locationId &&
          other.status == this.status &&
          other.isDeleted == this.isDeleted &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class ManuscriptChaptersCompanion
    extends UpdateCompanion<ManuscriptChapterRow> {
  final Value<String> id;
  final Value<String?> projectId;
  final Value<String> title;
  final Value<String> content;
  final Value<int> sortOrder;
  final Value<String?> dateLabel;
  final Value<String?> eraLabel;
  final Value<String?> synopsis;
  final Value<String?> povCharacterId;
  final Value<String?> locationId;
  final Value<String> status;
  final Value<bool> isDeleted;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const ManuscriptChaptersCompanion({
    this.id = const Value.absent(),
    this.projectId = const Value.absent(),
    this.title = const Value.absent(),
    this.content = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.dateLabel = const Value.absent(),
    this.eraLabel = const Value.absent(),
    this.synopsis = const Value.absent(),
    this.povCharacterId = const Value.absent(),
    this.locationId = const Value.absent(),
    this.status = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ManuscriptChaptersCompanion.insert({
    required String id,
    this.projectId = const Value.absent(),
    required String title,
    this.content = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.dateLabel = const Value.absent(),
    this.eraLabel = const Value.absent(),
    this.synopsis = const Value.absent(),
    this.povCharacterId = const Value.absent(),
    this.locationId = const Value.absent(),
    this.status = const Value.absent(),
    this.isDeleted = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        title = Value(title),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<ManuscriptChapterRow> custom({
    Expression<String>? id,
    Expression<String>? projectId,
    Expression<String>? title,
    Expression<String>? content,
    Expression<int>? sortOrder,
    Expression<String>? dateLabel,
    Expression<String>? eraLabel,
    Expression<String>? synopsis,
    Expression<String>? povCharacterId,
    Expression<String>? locationId,
    Expression<String>? status,
    Expression<bool>? isDeleted,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (projectId != null) 'project_id': projectId,
      if (title != null) 'title': title,
      if (content != null) 'content': content,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (dateLabel != null) 'date_label': dateLabel,
      if (eraLabel != null) 'era_label': eraLabel,
      if (synopsis != null) 'synopsis': synopsis,
      if (povCharacterId != null) 'pov_character_id': povCharacterId,
      if (locationId != null) 'location_id': locationId,
      if (status != null) 'status': status,
      if (isDeleted != null) 'is_deleted': isDeleted,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ManuscriptChaptersCompanion copyWith(
      {Value<String>? id,
      Value<String?>? projectId,
      Value<String>? title,
      Value<String>? content,
      Value<int>? sortOrder,
      Value<String?>? dateLabel,
      Value<String?>? eraLabel,
      Value<String?>? synopsis,
      Value<String?>? povCharacterId,
      Value<String?>? locationId,
      Value<String>? status,
      Value<bool>? isDeleted,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<int>? rowid}) {
    return ManuscriptChaptersCompanion(
      id: id ?? this.id,
      projectId: projectId ?? this.projectId,
      title: title ?? this.title,
      content: content ?? this.content,
      sortOrder: sortOrder ?? this.sortOrder,
      dateLabel: dateLabel ?? this.dateLabel,
      eraLabel: eraLabel ?? this.eraLabel,
      synopsis: synopsis ?? this.synopsis,
      povCharacterId: povCharacterId ?? this.povCharacterId,
      locationId: locationId ?? this.locationId,
      status: status ?? this.status,
      isDeleted: isDeleted ?? this.isDeleted,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (projectId.present) {
      map['project_id'] = Variable<String>(projectId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(content.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (dateLabel.present) {
      map['date_label'] = Variable<String>(dateLabel.value);
    }
    if (eraLabel.present) {
      map['era_label'] = Variable<String>(eraLabel.value);
    }
    if (synopsis.present) {
      map['synopsis'] = Variable<String>(synopsis.value);
    }
    if (povCharacterId.present) {
      map['pov_character_id'] = Variable<String>(povCharacterId.value);
    }
    if (locationId.present) {
      map['location_id'] = Variable<String>(locationId.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (isDeleted.present) {
      map['is_deleted'] = Variable<bool>(isDeleted.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ManuscriptChaptersCompanion(')
          ..write('id: $id, ')
          ..write('projectId: $projectId, ')
          ..write('title: $title, ')
          ..write('content: $content, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('dateLabel: $dateLabel, ')
          ..write('eraLabel: $eraLabel, ')
          ..write('synopsis: $synopsis, ')
          ..write('povCharacterId: $povCharacterId, ')
          ..write('locationId: $locationId, ')
          ..write('status: $status, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ChapterSnapshotsTable extends ChapterSnapshots
    with TableInfo<$ChapterSnapshotsTable, ChapterSnapshotRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ChapterSnapshotsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 36, maxTextLength: 36),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _chapterIdMeta =
      const VerificationMeta('chapterId');
  @override
  late final GeneratedColumn<String> chapterId = GeneratedColumn<String>(
      'chapter_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES manuscript_chapters (id) ON DELETE CASCADE'));
  static const VerificationMeta _contentMeta =
      const VerificationMeta('content');
  @override
  late final GeneratedColumn<String> content = GeneratedColumn<String>(
      'content', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, chapterId, content, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'chapter_snapshots';
  @override
  VerificationContext validateIntegrity(Insertable<ChapterSnapshotRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('chapter_id')) {
      context.handle(_chapterIdMeta,
          chapterId.isAcceptableOrUnknown(data['chapter_id']!, _chapterIdMeta));
    } else if (isInserting) {
      context.missing(_chapterIdMeta);
    }
    if (data.containsKey('content')) {
      context.handle(_contentMeta,
          content.isAcceptableOrUnknown(data['content']!, _contentMeta));
    } else if (isInserting) {
      context.missing(_contentMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ChapterSnapshotRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ChapterSnapshotRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      chapterId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}chapter_id'])!,
      content: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}content'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $ChapterSnapshotsTable createAlias(String alias) {
    return $ChapterSnapshotsTable(attachedDatabase, alias);
  }
}

class ChapterSnapshotRow extends DataClass
    implements Insertable<ChapterSnapshotRow> {
  final String id;
  final String chapterId;
  final String content;
  final DateTime createdAt;
  const ChapterSnapshotRow(
      {required this.id,
      required this.chapterId,
      required this.content,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['chapter_id'] = Variable<String>(chapterId);
    map['content'] = Variable<String>(content);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  ChapterSnapshotsCompanion toCompanion(bool nullToAbsent) {
    return ChapterSnapshotsCompanion(
      id: Value(id),
      chapterId: Value(chapterId),
      content: Value(content),
      createdAt: Value(createdAt),
    );
  }

  factory ChapterSnapshotRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ChapterSnapshotRow(
      id: serializer.fromJson<String>(json['id']),
      chapterId: serializer.fromJson<String>(json['chapterId']),
      content: serializer.fromJson<String>(json['content']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'chapterId': serializer.toJson<String>(chapterId),
      'content': serializer.toJson<String>(content),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  ChapterSnapshotRow copyWith(
          {String? id,
          String? chapterId,
          String? content,
          DateTime? createdAt}) =>
      ChapterSnapshotRow(
        id: id ?? this.id,
        chapterId: chapterId ?? this.chapterId,
        content: content ?? this.content,
        createdAt: createdAt ?? this.createdAt,
      );
  ChapterSnapshotRow copyWithCompanion(ChapterSnapshotsCompanion data) {
    return ChapterSnapshotRow(
      id: data.id.present ? data.id.value : this.id,
      chapterId: data.chapterId.present ? data.chapterId.value : this.chapterId,
      content: data.content.present ? data.content.value : this.content,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ChapterSnapshotRow(')
          ..write('id: $id, ')
          ..write('chapterId: $chapterId, ')
          ..write('content: $content, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, chapterId, content, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ChapterSnapshotRow &&
          other.id == this.id &&
          other.chapterId == this.chapterId &&
          other.content == this.content &&
          other.createdAt == this.createdAt);
}

class ChapterSnapshotsCompanion extends UpdateCompanion<ChapterSnapshotRow> {
  final Value<String> id;
  final Value<String> chapterId;
  final Value<String> content;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const ChapterSnapshotsCompanion({
    this.id = const Value.absent(),
    this.chapterId = const Value.absent(),
    this.content = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ChapterSnapshotsCompanion.insert({
    required String id,
    required String chapterId,
    required String content,
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        chapterId = Value(chapterId),
        content = Value(content),
        createdAt = Value(createdAt);
  static Insertable<ChapterSnapshotRow> custom({
    Expression<String>? id,
    Expression<String>? chapterId,
    Expression<String>? content,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (chapterId != null) 'chapter_id': chapterId,
      if (content != null) 'content': content,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ChapterSnapshotsCompanion copyWith(
      {Value<String>? id,
      Value<String>? chapterId,
      Value<String>? content,
      Value<DateTime>? createdAt,
      Value<int>? rowid}) {
    return ChapterSnapshotsCompanion(
      id: id ?? this.id,
      chapterId: chapterId ?? this.chapterId,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (chapterId.present) {
      map['chapter_id'] = Variable<String>(chapterId.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(content.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ChapterSnapshotsCompanion(')
          ..write('id: $id, ')
          ..write('chapterId: $chapterId, ')
          ..write('content: $content, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PlotCardsTable extends PlotCards
    with TableInfo<$PlotCardsTable, PlotCardRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PlotCardsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 36, maxTextLength: 36),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _projectIdMeta =
      const VerificationMeta('projectId');
  @override
  late final GeneratedColumn<String> projectId = GeneratedColumn<String>(
      'project_id', aliasedName, true,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES projects (id) ON DELETE CASCADE'));
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 300),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _summaryMeta =
      const VerificationMeta('summary');
  @override
  late final GeneratedColumn<String> summary = GeneratedColumn<String>(
      'summary', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _xPositionMeta =
      const VerificationMeta('xPosition');
  @override
  late final GeneratedColumn<double> xPosition = GeneratedColumn<double>(
      'x_position', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _yPositionMeta =
      const VerificationMeta('yPosition');
  @override
  late final GeneratedColumn<double> yPosition = GeneratedColumn<double>(
      'y_position', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _colorHexMeta =
      const VerificationMeta('colorHex');
  @override
  late final GeneratedColumn<int> colorHex = GeneratedColumn<int>(
      'color_hex', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0xFFA78BFA));
  static const VerificationMeta _isDeletedMeta =
      const VerificationMeta('isDeleted');
  @override
  late final GeneratedColumn<bool> isDeleted = GeneratedColumn<bool>(
      'is_deleted', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_deleted" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        projectId,
        title,
        summary,
        xPosition,
        yPosition,
        colorHex,
        isDeleted,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'plot_cards';
  @override
  VerificationContext validateIntegrity(Insertable<PlotCardRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('project_id')) {
      context.handle(_projectIdMeta,
          projectId.isAcceptableOrUnknown(data['project_id']!, _projectIdMeta));
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('summary')) {
      context.handle(_summaryMeta,
          summary.isAcceptableOrUnknown(data['summary']!, _summaryMeta));
    }
    if (data.containsKey('x_position')) {
      context.handle(_xPositionMeta,
          xPosition.isAcceptableOrUnknown(data['x_position']!, _xPositionMeta));
    } else if (isInserting) {
      context.missing(_xPositionMeta);
    }
    if (data.containsKey('y_position')) {
      context.handle(_yPositionMeta,
          yPosition.isAcceptableOrUnknown(data['y_position']!, _yPositionMeta));
    } else if (isInserting) {
      context.missing(_yPositionMeta);
    }
    if (data.containsKey('color_hex')) {
      context.handle(_colorHexMeta,
          colorHex.isAcceptableOrUnknown(data['color_hex']!, _colorHexMeta));
    }
    if (data.containsKey('is_deleted')) {
      context.handle(_isDeletedMeta,
          isDeleted.isAcceptableOrUnknown(data['is_deleted']!, _isDeletedMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PlotCardRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PlotCardRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      projectId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}project_id']),
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      summary: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}summary']),
      xPosition: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}x_position'])!,
      yPosition: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}y_position'])!,
      colorHex: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}color_hex'])!,
      isDeleted: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_deleted'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $PlotCardsTable createAlias(String alias) {
    return $PlotCardsTable(attachedDatabase, alias);
  }
}

class PlotCardRow extends DataClass implements Insertable<PlotCardRow> {
  final String id;
  final String? projectId;
  final String title;
  final String? summary;
  final double xPosition;
  final double yPosition;
  final int colorHex;
  final bool isDeleted;
  final DateTime createdAt;
  final DateTime updatedAt;
  const PlotCardRow(
      {required this.id,
      this.projectId,
      required this.title,
      this.summary,
      required this.xPosition,
      required this.yPosition,
      required this.colorHex,
      required this.isDeleted,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || projectId != null) {
      map['project_id'] = Variable<String>(projectId);
    }
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || summary != null) {
      map['summary'] = Variable<String>(summary);
    }
    map['x_position'] = Variable<double>(xPosition);
    map['y_position'] = Variable<double>(yPosition);
    map['color_hex'] = Variable<int>(colorHex);
    map['is_deleted'] = Variable<bool>(isDeleted);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  PlotCardsCompanion toCompanion(bool nullToAbsent) {
    return PlotCardsCompanion(
      id: Value(id),
      projectId: projectId == null && nullToAbsent
          ? const Value.absent()
          : Value(projectId),
      title: Value(title),
      summary: summary == null && nullToAbsent
          ? const Value.absent()
          : Value(summary),
      xPosition: Value(xPosition),
      yPosition: Value(yPosition),
      colorHex: Value(colorHex),
      isDeleted: Value(isDeleted),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory PlotCardRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PlotCardRow(
      id: serializer.fromJson<String>(json['id']),
      projectId: serializer.fromJson<String?>(json['projectId']),
      title: serializer.fromJson<String>(json['title']),
      summary: serializer.fromJson<String?>(json['summary']),
      xPosition: serializer.fromJson<double>(json['xPosition']),
      yPosition: serializer.fromJson<double>(json['yPosition']),
      colorHex: serializer.fromJson<int>(json['colorHex']),
      isDeleted: serializer.fromJson<bool>(json['isDeleted']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'projectId': serializer.toJson<String?>(projectId),
      'title': serializer.toJson<String>(title),
      'summary': serializer.toJson<String?>(summary),
      'xPosition': serializer.toJson<double>(xPosition),
      'yPosition': serializer.toJson<double>(yPosition),
      'colorHex': serializer.toJson<int>(colorHex),
      'isDeleted': serializer.toJson<bool>(isDeleted),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  PlotCardRow copyWith(
          {String? id,
          Value<String?> projectId = const Value.absent(),
          String? title,
          Value<String?> summary = const Value.absent(),
          double? xPosition,
          double? yPosition,
          int? colorHex,
          bool? isDeleted,
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      PlotCardRow(
        id: id ?? this.id,
        projectId: projectId.present ? projectId.value : this.projectId,
        title: title ?? this.title,
        summary: summary.present ? summary.value : this.summary,
        xPosition: xPosition ?? this.xPosition,
        yPosition: yPosition ?? this.yPosition,
        colorHex: colorHex ?? this.colorHex,
        isDeleted: isDeleted ?? this.isDeleted,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  PlotCardRow copyWithCompanion(PlotCardsCompanion data) {
    return PlotCardRow(
      id: data.id.present ? data.id.value : this.id,
      projectId: data.projectId.present ? data.projectId.value : this.projectId,
      title: data.title.present ? data.title.value : this.title,
      summary: data.summary.present ? data.summary.value : this.summary,
      xPosition: data.xPosition.present ? data.xPosition.value : this.xPosition,
      yPosition: data.yPosition.present ? data.yPosition.value : this.yPosition,
      colorHex: data.colorHex.present ? data.colorHex.value : this.colorHex,
      isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PlotCardRow(')
          ..write('id: $id, ')
          ..write('projectId: $projectId, ')
          ..write('title: $title, ')
          ..write('summary: $summary, ')
          ..write('xPosition: $xPosition, ')
          ..write('yPosition: $yPosition, ')
          ..write('colorHex: $colorHex, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, projectId, title, summary, xPosition,
      yPosition, colorHex, isDeleted, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PlotCardRow &&
          other.id == this.id &&
          other.projectId == this.projectId &&
          other.title == this.title &&
          other.summary == this.summary &&
          other.xPosition == this.xPosition &&
          other.yPosition == this.yPosition &&
          other.colorHex == this.colorHex &&
          other.isDeleted == this.isDeleted &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class PlotCardsCompanion extends UpdateCompanion<PlotCardRow> {
  final Value<String> id;
  final Value<String?> projectId;
  final Value<String> title;
  final Value<String?> summary;
  final Value<double> xPosition;
  final Value<double> yPosition;
  final Value<int> colorHex;
  final Value<bool> isDeleted;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const PlotCardsCompanion({
    this.id = const Value.absent(),
    this.projectId = const Value.absent(),
    this.title = const Value.absent(),
    this.summary = const Value.absent(),
    this.xPosition = const Value.absent(),
    this.yPosition = const Value.absent(),
    this.colorHex = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PlotCardsCompanion.insert({
    required String id,
    this.projectId = const Value.absent(),
    required String title,
    this.summary = const Value.absent(),
    required double xPosition,
    required double yPosition,
    this.colorHex = const Value.absent(),
    this.isDeleted = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        title = Value(title),
        xPosition = Value(xPosition),
        yPosition = Value(yPosition),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<PlotCardRow> custom({
    Expression<String>? id,
    Expression<String>? projectId,
    Expression<String>? title,
    Expression<String>? summary,
    Expression<double>? xPosition,
    Expression<double>? yPosition,
    Expression<int>? colorHex,
    Expression<bool>? isDeleted,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (projectId != null) 'project_id': projectId,
      if (title != null) 'title': title,
      if (summary != null) 'summary': summary,
      if (xPosition != null) 'x_position': xPosition,
      if (yPosition != null) 'y_position': yPosition,
      if (colorHex != null) 'color_hex': colorHex,
      if (isDeleted != null) 'is_deleted': isDeleted,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PlotCardsCompanion copyWith(
      {Value<String>? id,
      Value<String?>? projectId,
      Value<String>? title,
      Value<String?>? summary,
      Value<double>? xPosition,
      Value<double>? yPosition,
      Value<int>? colorHex,
      Value<bool>? isDeleted,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<int>? rowid}) {
    return PlotCardsCompanion(
      id: id ?? this.id,
      projectId: projectId ?? this.projectId,
      title: title ?? this.title,
      summary: summary ?? this.summary,
      xPosition: xPosition ?? this.xPosition,
      yPosition: yPosition ?? this.yPosition,
      colorHex: colorHex ?? this.colorHex,
      isDeleted: isDeleted ?? this.isDeleted,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (projectId.present) {
      map['project_id'] = Variable<String>(projectId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (summary.present) {
      map['summary'] = Variable<String>(summary.value);
    }
    if (xPosition.present) {
      map['x_position'] = Variable<double>(xPosition.value);
    }
    if (yPosition.present) {
      map['y_position'] = Variable<double>(yPosition.value);
    }
    if (colorHex.present) {
      map['color_hex'] = Variable<int>(colorHex.value);
    }
    if (isDeleted.present) {
      map['is_deleted'] = Variable<bool>(isDeleted.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PlotCardsCompanion(')
          ..write('id: $id, ')
          ..write('projectId: $projectId, ')
          ..write('title: $title, ')
          ..write('summary: $summary, ')
          ..write('xPosition: $xPosition, ')
          ..write('yPosition: $yPosition, ')
          ..write('colorHex: $colorHex, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PlotConnectionsTable extends PlotConnections
    with TableInfo<$PlotConnectionsTable, PlotConnectionRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PlotConnectionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 36, maxTextLength: 36),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _projectIdMeta =
      const VerificationMeta('projectId');
  @override
  late final GeneratedColumn<String> projectId = GeneratedColumn<String>(
      'project_id', aliasedName, true,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES projects (id) ON DELETE CASCADE'));
  static const VerificationMeta _sourceIdMeta =
      const VerificationMeta('sourceId');
  @override
  late final GeneratedColumn<String> sourceId = GeneratedColumn<String>(
      'source_id', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 36, maxTextLength: 36),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _targetIdMeta =
      const VerificationMeta('targetId');
  @override
  late final GeneratedColumn<String> targetId = GeneratedColumn<String>(
      'target_id', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 36, maxTextLength: 36),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _labelMeta = const VerificationMeta('label');
  @override
  late final GeneratedColumn<String> label = GeneratedColumn<String>(
      'label', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _isDeletedMeta =
      const VerificationMeta('isDeleted');
  @override
  late final GeneratedColumn<bool> isDeleted = GeneratedColumn<bool>(
      'is_deleted', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_deleted" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, projectId, sourceId, targetId, label, isDeleted, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'plot_connections';
  @override
  VerificationContext validateIntegrity(Insertable<PlotConnectionRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('project_id')) {
      context.handle(_projectIdMeta,
          projectId.isAcceptableOrUnknown(data['project_id']!, _projectIdMeta));
    }
    if (data.containsKey('source_id')) {
      context.handle(_sourceIdMeta,
          sourceId.isAcceptableOrUnknown(data['source_id']!, _sourceIdMeta));
    } else if (isInserting) {
      context.missing(_sourceIdMeta);
    }
    if (data.containsKey('target_id')) {
      context.handle(_targetIdMeta,
          targetId.isAcceptableOrUnknown(data['target_id']!, _targetIdMeta));
    } else if (isInserting) {
      context.missing(_targetIdMeta);
    }
    if (data.containsKey('label')) {
      context.handle(
          _labelMeta, label.isAcceptableOrUnknown(data['label']!, _labelMeta));
    }
    if (data.containsKey('is_deleted')) {
      context.handle(_isDeletedMeta,
          isDeleted.isAcceptableOrUnknown(data['is_deleted']!, _isDeletedMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PlotConnectionRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PlotConnectionRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      projectId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}project_id']),
      sourceId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}source_id'])!,
      targetId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}target_id'])!,
      label: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}label']),
      isDeleted: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_deleted'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $PlotConnectionsTable createAlias(String alias) {
    return $PlotConnectionsTable(attachedDatabase, alias);
  }
}

class PlotConnectionRow extends DataClass
    implements Insertable<PlotConnectionRow> {
  final String id;
  final String? projectId;
  final String sourceId;
  final String targetId;
  final String? label;
  final bool isDeleted;
  final DateTime createdAt;
  const PlotConnectionRow(
      {required this.id,
      this.projectId,
      required this.sourceId,
      required this.targetId,
      this.label,
      required this.isDeleted,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || projectId != null) {
      map['project_id'] = Variable<String>(projectId);
    }
    map['source_id'] = Variable<String>(sourceId);
    map['target_id'] = Variable<String>(targetId);
    if (!nullToAbsent || label != null) {
      map['label'] = Variable<String>(label);
    }
    map['is_deleted'] = Variable<bool>(isDeleted);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  PlotConnectionsCompanion toCompanion(bool nullToAbsent) {
    return PlotConnectionsCompanion(
      id: Value(id),
      projectId: projectId == null && nullToAbsent
          ? const Value.absent()
          : Value(projectId),
      sourceId: Value(sourceId),
      targetId: Value(targetId),
      label:
          label == null && nullToAbsent ? const Value.absent() : Value(label),
      isDeleted: Value(isDeleted),
      createdAt: Value(createdAt),
    );
  }

  factory PlotConnectionRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PlotConnectionRow(
      id: serializer.fromJson<String>(json['id']),
      projectId: serializer.fromJson<String?>(json['projectId']),
      sourceId: serializer.fromJson<String>(json['sourceId']),
      targetId: serializer.fromJson<String>(json['targetId']),
      label: serializer.fromJson<String?>(json['label']),
      isDeleted: serializer.fromJson<bool>(json['isDeleted']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'projectId': serializer.toJson<String?>(projectId),
      'sourceId': serializer.toJson<String>(sourceId),
      'targetId': serializer.toJson<String>(targetId),
      'label': serializer.toJson<String?>(label),
      'isDeleted': serializer.toJson<bool>(isDeleted),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  PlotConnectionRow copyWith(
          {String? id,
          Value<String?> projectId = const Value.absent(),
          String? sourceId,
          String? targetId,
          Value<String?> label = const Value.absent(),
          bool? isDeleted,
          DateTime? createdAt}) =>
      PlotConnectionRow(
        id: id ?? this.id,
        projectId: projectId.present ? projectId.value : this.projectId,
        sourceId: sourceId ?? this.sourceId,
        targetId: targetId ?? this.targetId,
        label: label.present ? label.value : this.label,
        isDeleted: isDeleted ?? this.isDeleted,
        createdAt: createdAt ?? this.createdAt,
      );
  PlotConnectionRow copyWithCompanion(PlotConnectionsCompanion data) {
    return PlotConnectionRow(
      id: data.id.present ? data.id.value : this.id,
      projectId: data.projectId.present ? data.projectId.value : this.projectId,
      sourceId: data.sourceId.present ? data.sourceId.value : this.sourceId,
      targetId: data.targetId.present ? data.targetId.value : this.targetId,
      label: data.label.present ? data.label.value : this.label,
      isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PlotConnectionRow(')
          ..write('id: $id, ')
          ..write('projectId: $projectId, ')
          ..write('sourceId: $sourceId, ')
          ..write('targetId: $targetId, ')
          ..write('label: $label, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, projectId, sourceId, targetId, label, isDeleted, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PlotConnectionRow &&
          other.id == this.id &&
          other.projectId == this.projectId &&
          other.sourceId == this.sourceId &&
          other.targetId == this.targetId &&
          other.label == this.label &&
          other.isDeleted == this.isDeleted &&
          other.createdAt == this.createdAt);
}

class PlotConnectionsCompanion extends UpdateCompanion<PlotConnectionRow> {
  final Value<String> id;
  final Value<String?> projectId;
  final Value<String> sourceId;
  final Value<String> targetId;
  final Value<String?> label;
  final Value<bool> isDeleted;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const PlotConnectionsCompanion({
    this.id = const Value.absent(),
    this.projectId = const Value.absent(),
    this.sourceId = const Value.absent(),
    this.targetId = const Value.absent(),
    this.label = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PlotConnectionsCompanion.insert({
    required String id,
    this.projectId = const Value.absent(),
    required String sourceId,
    required String targetId,
    this.label = const Value.absent(),
    this.isDeleted = const Value.absent(),
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        sourceId = Value(sourceId),
        targetId = Value(targetId),
        createdAt = Value(createdAt);
  static Insertable<PlotConnectionRow> custom({
    Expression<String>? id,
    Expression<String>? projectId,
    Expression<String>? sourceId,
    Expression<String>? targetId,
    Expression<String>? label,
    Expression<bool>? isDeleted,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (projectId != null) 'project_id': projectId,
      if (sourceId != null) 'source_id': sourceId,
      if (targetId != null) 'target_id': targetId,
      if (label != null) 'label': label,
      if (isDeleted != null) 'is_deleted': isDeleted,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PlotConnectionsCompanion copyWith(
      {Value<String>? id,
      Value<String?>? projectId,
      Value<String>? sourceId,
      Value<String>? targetId,
      Value<String?>? label,
      Value<bool>? isDeleted,
      Value<DateTime>? createdAt,
      Value<int>? rowid}) {
    return PlotConnectionsCompanion(
      id: id ?? this.id,
      projectId: projectId ?? this.projectId,
      sourceId: sourceId ?? this.sourceId,
      targetId: targetId ?? this.targetId,
      label: label ?? this.label,
      isDeleted: isDeleted ?? this.isDeleted,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (projectId.present) {
      map['project_id'] = Variable<String>(projectId.value);
    }
    if (sourceId.present) {
      map['source_id'] = Variable<String>(sourceId.value);
    }
    if (targetId.present) {
      map['target_id'] = Variable<String>(targetId.value);
    }
    if (label.present) {
      map['label'] = Variable<String>(label.value);
    }
    if (isDeleted.present) {
      map['is_deleted'] = Variable<bool>(isDeleted.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PlotConnectionsCompanion(')
          ..write('id: $id, ')
          ..write('projectId: $projectId, ')
          ..write('sourceId: $sourceId, ')
          ..write('targetId: $targetId, ')
          ..write('label: $label, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $WorldMapsTable extends WorldMaps
    with TableInfo<$WorldMapsTable, WorldMapRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WorldMapsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _projectIdMeta =
      const VerificationMeta('projectId');
  @override
  late final GeneratedColumn<String> projectId = GeneratedColumn<String>(
      'project_id', aliasedName, true,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES projects (id) ON DELETE CASCADE'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 200),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _imagePathMeta =
      const VerificationMeta('imagePath');
  @override
  late final GeneratedColumn<String> imagePath = GeneratedColumn<String>(
      'image_path', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, projectId, name, imagePath];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'world_maps';
  @override
  VerificationContext validateIntegrity(Insertable<WorldMapRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('project_id')) {
      context.handle(_projectIdMeta,
          projectId.isAcceptableOrUnknown(data['project_id']!, _projectIdMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('image_path')) {
      context.handle(_imagePathMeta,
          imagePath.isAcceptableOrUnknown(data['image_path']!, _imagePathMeta));
    } else if (isInserting) {
      context.missing(_imagePathMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WorldMapRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WorldMapRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      projectId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}project_id']),
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      imagePath: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}image_path'])!,
    );
  }

  @override
  $WorldMapsTable createAlias(String alias) {
    return $WorldMapsTable(attachedDatabase, alias);
  }
}

class WorldMapRow extends DataClass implements Insertable<WorldMapRow> {
  final String id;
  final String? projectId;
  final String name;
  final String imagePath;
  const WorldMapRow(
      {required this.id,
      this.projectId,
      required this.name,
      required this.imagePath});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || projectId != null) {
      map['project_id'] = Variable<String>(projectId);
    }
    map['name'] = Variable<String>(name);
    map['image_path'] = Variable<String>(imagePath);
    return map;
  }

  WorldMapsCompanion toCompanion(bool nullToAbsent) {
    return WorldMapsCompanion(
      id: Value(id),
      projectId: projectId == null && nullToAbsent
          ? const Value.absent()
          : Value(projectId),
      name: Value(name),
      imagePath: Value(imagePath),
    );
  }

  factory WorldMapRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WorldMapRow(
      id: serializer.fromJson<String>(json['id']),
      projectId: serializer.fromJson<String?>(json['projectId']),
      name: serializer.fromJson<String>(json['name']),
      imagePath: serializer.fromJson<String>(json['imagePath']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'projectId': serializer.toJson<String?>(projectId),
      'name': serializer.toJson<String>(name),
      'imagePath': serializer.toJson<String>(imagePath),
    };
  }

  WorldMapRow copyWith(
          {String? id,
          Value<String?> projectId = const Value.absent(),
          String? name,
          String? imagePath}) =>
      WorldMapRow(
        id: id ?? this.id,
        projectId: projectId.present ? projectId.value : this.projectId,
        name: name ?? this.name,
        imagePath: imagePath ?? this.imagePath,
      );
  WorldMapRow copyWithCompanion(WorldMapsCompanion data) {
    return WorldMapRow(
      id: data.id.present ? data.id.value : this.id,
      projectId: data.projectId.present ? data.projectId.value : this.projectId,
      name: data.name.present ? data.name.value : this.name,
      imagePath: data.imagePath.present ? data.imagePath.value : this.imagePath,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WorldMapRow(')
          ..write('id: $id, ')
          ..write('projectId: $projectId, ')
          ..write('name: $name, ')
          ..write('imagePath: $imagePath')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, projectId, name, imagePath);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WorldMapRow &&
          other.id == this.id &&
          other.projectId == this.projectId &&
          other.name == this.name &&
          other.imagePath == this.imagePath);
}

class WorldMapsCompanion extends UpdateCompanion<WorldMapRow> {
  final Value<String> id;
  final Value<String?> projectId;
  final Value<String> name;
  final Value<String> imagePath;
  final Value<int> rowid;
  const WorldMapsCompanion({
    this.id = const Value.absent(),
    this.projectId = const Value.absent(),
    this.name = const Value.absent(),
    this.imagePath = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  WorldMapsCompanion.insert({
    required String id,
    this.projectId = const Value.absent(),
    required String name,
    required String imagePath,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        name = Value(name),
        imagePath = Value(imagePath);
  static Insertable<WorldMapRow> custom({
    Expression<String>? id,
    Expression<String>? projectId,
    Expression<String>? name,
    Expression<String>? imagePath,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (projectId != null) 'project_id': projectId,
      if (name != null) 'name': name,
      if (imagePath != null) 'image_path': imagePath,
      if (rowid != null) 'rowid': rowid,
    });
  }

  WorldMapsCompanion copyWith(
      {Value<String>? id,
      Value<String?>? projectId,
      Value<String>? name,
      Value<String>? imagePath,
      Value<int>? rowid}) {
    return WorldMapsCompanion(
      id: id ?? this.id,
      projectId: projectId ?? this.projectId,
      name: name ?? this.name,
      imagePath: imagePath ?? this.imagePath,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (projectId.present) {
      map['project_id'] = Variable<String>(projectId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (imagePath.present) {
      map['image_path'] = Variable<String>(imagePath.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WorldMapsCompanion(')
          ..write('id: $id, ')
          ..write('projectId: $projectId, ')
          ..write('name: $name, ')
          ..write('imagePath: $imagePath, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MapPinsTable extends MapPins with TableInfo<$MapPinsTable, MapPinRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MapPinsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _mapIdMeta = const VerificationMeta('mapId');
  @override
  late final GeneratedColumn<String> mapId = GeneratedColumn<String>(
      'map_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES world_maps (id) ON DELETE CASCADE'));
  static const VerificationMeta _entityIdMeta =
      const VerificationMeta('entityId');
  @override
  late final GeneratedColumn<String> entityId = GeneratedColumn<String>(
      'entity_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES entities (id) ON DELETE CASCADE'));
  static const VerificationMeta _xPercentMeta =
      const VerificationMeta('xPercent');
  @override
  late final GeneratedColumn<double> xPercent = GeneratedColumn<double>(
      'x_percent', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _yPercentMeta =
      const VerificationMeta('yPercent');
  @override
  late final GeneratedColumn<double> yPercent = GeneratedColumn<double>(
      'y_percent', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _labelMeta = const VerificationMeta('label');
  @override
  late final GeneratedColumn<String> label = GeneratedColumn<String>(
      'label', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, mapId, entityId, xPercent, yPercent, label];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'map_pins';
  @override
  VerificationContext validateIntegrity(Insertable<MapPinRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('map_id')) {
      context.handle(
          _mapIdMeta, mapId.isAcceptableOrUnknown(data['map_id']!, _mapIdMeta));
    } else if (isInserting) {
      context.missing(_mapIdMeta);
    }
    if (data.containsKey('entity_id')) {
      context.handle(_entityIdMeta,
          entityId.isAcceptableOrUnknown(data['entity_id']!, _entityIdMeta));
    } else if (isInserting) {
      context.missing(_entityIdMeta);
    }
    if (data.containsKey('x_percent')) {
      context.handle(_xPercentMeta,
          xPercent.isAcceptableOrUnknown(data['x_percent']!, _xPercentMeta));
    } else if (isInserting) {
      context.missing(_xPercentMeta);
    }
    if (data.containsKey('y_percent')) {
      context.handle(_yPercentMeta,
          yPercent.isAcceptableOrUnknown(data['y_percent']!, _yPercentMeta));
    } else if (isInserting) {
      context.missing(_yPercentMeta);
    }
    if (data.containsKey('label')) {
      context.handle(
          _labelMeta, label.isAcceptableOrUnknown(data['label']!, _labelMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MapPinRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MapPinRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      mapId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}map_id'])!,
      entityId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}entity_id'])!,
      xPercent: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}x_percent'])!,
      yPercent: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}y_percent'])!,
      label: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}label']),
    );
  }

  @override
  $MapPinsTable createAlias(String alias) {
    return $MapPinsTable(attachedDatabase, alias);
  }
}

class MapPinRow extends DataClass implements Insertable<MapPinRow> {
  final String id;
  final String mapId;
  final String entityId;
  final double xPercent;
  final double yPercent;
  final String? label;
  const MapPinRow(
      {required this.id,
      required this.mapId,
      required this.entityId,
      required this.xPercent,
      required this.yPercent,
      this.label});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['map_id'] = Variable<String>(mapId);
    map['entity_id'] = Variable<String>(entityId);
    map['x_percent'] = Variable<double>(xPercent);
    map['y_percent'] = Variable<double>(yPercent);
    if (!nullToAbsent || label != null) {
      map['label'] = Variable<String>(label);
    }
    return map;
  }

  MapPinsCompanion toCompanion(bool nullToAbsent) {
    return MapPinsCompanion(
      id: Value(id),
      mapId: Value(mapId),
      entityId: Value(entityId),
      xPercent: Value(xPercent),
      yPercent: Value(yPercent),
      label:
          label == null && nullToAbsent ? const Value.absent() : Value(label),
    );
  }

  factory MapPinRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MapPinRow(
      id: serializer.fromJson<String>(json['id']),
      mapId: serializer.fromJson<String>(json['mapId']),
      entityId: serializer.fromJson<String>(json['entityId']),
      xPercent: serializer.fromJson<double>(json['xPercent']),
      yPercent: serializer.fromJson<double>(json['yPercent']),
      label: serializer.fromJson<String?>(json['label']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'mapId': serializer.toJson<String>(mapId),
      'entityId': serializer.toJson<String>(entityId),
      'xPercent': serializer.toJson<double>(xPercent),
      'yPercent': serializer.toJson<double>(yPercent),
      'label': serializer.toJson<String?>(label),
    };
  }

  MapPinRow copyWith(
          {String? id,
          String? mapId,
          String? entityId,
          double? xPercent,
          double? yPercent,
          Value<String?> label = const Value.absent()}) =>
      MapPinRow(
        id: id ?? this.id,
        mapId: mapId ?? this.mapId,
        entityId: entityId ?? this.entityId,
        xPercent: xPercent ?? this.xPercent,
        yPercent: yPercent ?? this.yPercent,
        label: label.present ? label.value : this.label,
      );
  MapPinRow copyWithCompanion(MapPinsCompanion data) {
    return MapPinRow(
      id: data.id.present ? data.id.value : this.id,
      mapId: data.mapId.present ? data.mapId.value : this.mapId,
      entityId: data.entityId.present ? data.entityId.value : this.entityId,
      xPercent: data.xPercent.present ? data.xPercent.value : this.xPercent,
      yPercent: data.yPercent.present ? data.yPercent.value : this.yPercent,
      label: data.label.present ? data.label.value : this.label,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MapPinRow(')
          ..write('id: $id, ')
          ..write('mapId: $mapId, ')
          ..write('entityId: $entityId, ')
          ..write('xPercent: $xPercent, ')
          ..write('yPercent: $yPercent, ')
          ..write('label: $label')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, mapId, entityId, xPercent, yPercent, label);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MapPinRow &&
          other.id == this.id &&
          other.mapId == this.mapId &&
          other.entityId == this.entityId &&
          other.xPercent == this.xPercent &&
          other.yPercent == this.yPercent &&
          other.label == this.label);
}

class MapPinsCompanion extends UpdateCompanion<MapPinRow> {
  final Value<String> id;
  final Value<String> mapId;
  final Value<String> entityId;
  final Value<double> xPercent;
  final Value<double> yPercent;
  final Value<String?> label;
  final Value<int> rowid;
  const MapPinsCompanion({
    this.id = const Value.absent(),
    this.mapId = const Value.absent(),
    this.entityId = const Value.absent(),
    this.xPercent = const Value.absent(),
    this.yPercent = const Value.absent(),
    this.label = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MapPinsCompanion.insert({
    required String id,
    required String mapId,
    required String entityId,
    required double xPercent,
    required double yPercent,
    this.label = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        mapId = Value(mapId),
        entityId = Value(entityId),
        xPercent = Value(xPercent),
        yPercent = Value(yPercent);
  static Insertable<MapPinRow> custom({
    Expression<String>? id,
    Expression<String>? mapId,
    Expression<String>? entityId,
    Expression<double>? xPercent,
    Expression<double>? yPercent,
    Expression<String>? label,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (mapId != null) 'map_id': mapId,
      if (entityId != null) 'entity_id': entityId,
      if (xPercent != null) 'x_percent': xPercent,
      if (yPercent != null) 'y_percent': yPercent,
      if (label != null) 'label': label,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MapPinsCompanion copyWith(
      {Value<String>? id,
      Value<String>? mapId,
      Value<String>? entityId,
      Value<double>? xPercent,
      Value<double>? yPercent,
      Value<String?>? label,
      Value<int>? rowid}) {
    return MapPinsCompanion(
      id: id ?? this.id,
      mapId: mapId ?? this.mapId,
      entityId: entityId ?? this.entityId,
      xPercent: xPercent ?? this.xPercent,
      yPercent: yPercent ?? this.yPercent,
      label: label ?? this.label,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (mapId.present) {
      map['map_id'] = Variable<String>(mapId.value);
    }
    if (entityId.present) {
      map['entity_id'] = Variable<String>(entityId.value);
    }
    if (xPercent.present) {
      map['x_percent'] = Variable<double>(xPercent.value);
    }
    if (yPercent.present) {
      map['y_percent'] = Variable<double>(yPercent.value);
    }
    if (label.present) {
      map['label'] = Variable<String>(label.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MapPinsCompanion(')
          ..write('id: $id, ')
          ..write('mapId: $mapId, ')
          ..write('entityId: $entityId, ')
          ..write('xPercent: $xPercent, ')
          ..write('yPercent: $yPercent, ')
          ..write('label: $label, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SetupPayoffsTable extends SetupPayoffs
    with TableInfo<$SetupPayoffsTable, SetupPayoffRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SetupPayoffsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 36, maxTextLength: 36),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _projectIdMeta =
      const VerificationMeta('projectId');
  @override
  late final GeneratedColumn<String> projectId = GeneratedColumn<String>(
      'project_id', aliasedName, true,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES projects (id) ON DELETE CASCADE'));
  static const VerificationMeta _setupChapterIdMeta =
      const VerificationMeta('setupChapterId');
  @override
  late final GeneratedColumn<String> setupChapterId = GeneratedColumn<String>(
      'setup_chapter_id', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 36, maxTextLength: 36),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _setupDescriptionMeta =
      const VerificationMeta('setupDescription');
  @override
  late final GeneratedColumn<String> setupDescription = GeneratedColumn<String>(
      'setup_description', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _payoffChapterIdMeta =
      const VerificationMeta('payoffChapterId');
  @override
  late final GeneratedColumn<String> payoffChapterId = GeneratedColumn<String>(
      'payoff_chapter_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _payoffDescriptionMeta =
      const VerificationMeta('payoffDescription');
  @override
  late final GeneratedColumn<String> payoffDescription =
      GeneratedColumn<String>('payoff_description', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _entityIdMeta =
      const VerificationMeta('entityId');
  @override
  late final GeneratedColumn<String> entityId = GeneratedColumn<String>(
      'entity_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _isResolvedMeta =
      const VerificationMeta('isResolved');
  @override
  late final GeneratedColumn<bool> isResolved = GeneratedColumn<bool>(
      'is_resolved', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_resolved" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        projectId,
        setupChapterId,
        setupDescription,
        payoffChapterId,
        payoffDescription,
        entityId,
        isResolved,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'setup_payoffs';
  @override
  VerificationContext validateIntegrity(Insertable<SetupPayoffRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('project_id')) {
      context.handle(_projectIdMeta,
          projectId.isAcceptableOrUnknown(data['project_id']!, _projectIdMeta));
    }
    if (data.containsKey('setup_chapter_id')) {
      context.handle(
          _setupChapterIdMeta,
          setupChapterId.isAcceptableOrUnknown(
              data['setup_chapter_id']!, _setupChapterIdMeta));
    } else if (isInserting) {
      context.missing(_setupChapterIdMeta);
    }
    if (data.containsKey('setup_description')) {
      context.handle(
          _setupDescriptionMeta,
          setupDescription.isAcceptableOrUnknown(
              data['setup_description']!, _setupDescriptionMeta));
    } else if (isInserting) {
      context.missing(_setupDescriptionMeta);
    }
    if (data.containsKey('payoff_chapter_id')) {
      context.handle(
          _payoffChapterIdMeta,
          payoffChapterId.isAcceptableOrUnknown(
              data['payoff_chapter_id']!, _payoffChapterIdMeta));
    }
    if (data.containsKey('payoff_description')) {
      context.handle(
          _payoffDescriptionMeta,
          payoffDescription.isAcceptableOrUnknown(
              data['payoff_description']!, _payoffDescriptionMeta));
    }
    if (data.containsKey('entity_id')) {
      context.handle(_entityIdMeta,
          entityId.isAcceptableOrUnknown(data['entity_id']!, _entityIdMeta));
    }
    if (data.containsKey('is_resolved')) {
      context.handle(
          _isResolvedMeta,
          isResolved.isAcceptableOrUnknown(
              data['is_resolved']!, _isResolvedMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SetupPayoffRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SetupPayoffRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      projectId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}project_id']),
      setupChapterId: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}setup_chapter_id'])!,
      setupDescription: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}setup_description'])!,
      payoffChapterId: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}payoff_chapter_id']),
      payoffDescription: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}payoff_description']),
      entityId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}entity_id']),
      isResolved: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_resolved'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $SetupPayoffsTable createAlias(String alias) {
    return $SetupPayoffsTable(attachedDatabase, alias);
  }
}

class SetupPayoffRow extends DataClass implements Insertable<SetupPayoffRow> {
  final String id;
  final String? projectId;
  final String setupChapterId;
  final String setupDescription;
  final String? payoffChapterId;
  final String? payoffDescription;
  final String? entityId;
  final bool isResolved;
  final DateTime createdAt;
  final DateTime updatedAt;
  const SetupPayoffRow(
      {required this.id,
      this.projectId,
      required this.setupChapterId,
      required this.setupDescription,
      this.payoffChapterId,
      this.payoffDescription,
      this.entityId,
      required this.isResolved,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || projectId != null) {
      map['project_id'] = Variable<String>(projectId);
    }
    map['setup_chapter_id'] = Variable<String>(setupChapterId);
    map['setup_description'] = Variable<String>(setupDescription);
    if (!nullToAbsent || payoffChapterId != null) {
      map['payoff_chapter_id'] = Variable<String>(payoffChapterId);
    }
    if (!nullToAbsent || payoffDescription != null) {
      map['payoff_description'] = Variable<String>(payoffDescription);
    }
    if (!nullToAbsent || entityId != null) {
      map['entity_id'] = Variable<String>(entityId);
    }
    map['is_resolved'] = Variable<bool>(isResolved);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  SetupPayoffsCompanion toCompanion(bool nullToAbsent) {
    return SetupPayoffsCompanion(
      id: Value(id),
      projectId: projectId == null && nullToAbsent
          ? const Value.absent()
          : Value(projectId),
      setupChapterId: Value(setupChapterId),
      setupDescription: Value(setupDescription),
      payoffChapterId: payoffChapterId == null && nullToAbsent
          ? const Value.absent()
          : Value(payoffChapterId),
      payoffDescription: payoffDescription == null && nullToAbsent
          ? const Value.absent()
          : Value(payoffDescription),
      entityId: entityId == null && nullToAbsent
          ? const Value.absent()
          : Value(entityId),
      isResolved: Value(isResolved),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory SetupPayoffRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SetupPayoffRow(
      id: serializer.fromJson<String>(json['id']),
      projectId: serializer.fromJson<String?>(json['projectId']),
      setupChapterId: serializer.fromJson<String>(json['setupChapterId']),
      setupDescription: serializer.fromJson<String>(json['setupDescription']),
      payoffChapterId: serializer.fromJson<String?>(json['payoffChapterId']),
      payoffDescription:
          serializer.fromJson<String?>(json['payoffDescription']),
      entityId: serializer.fromJson<String?>(json['entityId']),
      isResolved: serializer.fromJson<bool>(json['isResolved']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'projectId': serializer.toJson<String?>(projectId),
      'setupChapterId': serializer.toJson<String>(setupChapterId),
      'setupDescription': serializer.toJson<String>(setupDescription),
      'payoffChapterId': serializer.toJson<String?>(payoffChapterId),
      'payoffDescription': serializer.toJson<String?>(payoffDescription),
      'entityId': serializer.toJson<String?>(entityId),
      'isResolved': serializer.toJson<bool>(isResolved),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  SetupPayoffRow copyWith(
          {String? id,
          Value<String?> projectId = const Value.absent(),
          String? setupChapterId,
          String? setupDescription,
          Value<String?> payoffChapterId = const Value.absent(),
          Value<String?> payoffDescription = const Value.absent(),
          Value<String?> entityId = const Value.absent(),
          bool? isResolved,
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      SetupPayoffRow(
        id: id ?? this.id,
        projectId: projectId.present ? projectId.value : this.projectId,
        setupChapterId: setupChapterId ?? this.setupChapterId,
        setupDescription: setupDescription ?? this.setupDescription,
        payoffChapterId: payoffChapterId.present
            ? payoffChapterId.value
            : this.payoffChapterId,
        payoffDescription: payoffDescription.present
            ? payoffDescription.value
            : this.payoffDescription,
        entityId: entityId.present ? entityId.value : this.entityId,
        isResolved: isResolved ?? this.isResolved,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  SetupPayoffRow copyWithCompanion(SetupPayoffsCompanion data) {
    return SetupPayoffRow(
      id: data.id.present ? data.id.value : this.id,
      projectId: data.projectId.present ? data.projectId.value : this.projectId,
      setupChapterId: data.setupChapterId.present
          ? data.setupChapterId.value
          : this.setupChapterId,
      setupDescription: data.setupDescription.present
          ? data.setupDescription.value
          : this.setupDescription,
      payoffChapterId: data.payoffChapterId.present
          ? data.payoffChapterId.value
          : this.payoffChapterId,
      payoffDescription: data.payoffDescription.present
          ? data.payoffDescription.value
          : this.payoffDescription,
      entityId: data.entityId.present ? data.entityId.value : this.entityId,
      isResolved:
          data.isResolved.present ? data.isResolved.value : this.isResolved,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SetupPayoffRow(')
          ..write('id: $id, ')
          ..write('projectId: $projectId, ')
          ..write('setupChapterId: $setupChapterId, ')
          ..write('setupDescription: $setupDescription, ')
          ..write('payoffChapterId: $payoffChapterId, ')
          ..write('payoffDescription: $payoffDescription, ')
          ..write('entityId: $entityId, ')
          ..write('isResolved: $isResolved, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      projectId,
      setupChapterId,
      setupDescription,
      payoffChapterId,
      payoffDescription,
      entityId,
      isResolved,
      createdAt,
      updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SetupPayoffRow &&
          other.id == this.id &&
          other.projectId == this.projectId &&
          other.setupChapterId == this.setupChapterId &&
          other.setupDescription == this.setupDescription &&
          other.payoffChapterId == this.payoffChapterId &&
          other.payoffDescription == this.payoffDescription &&
          other.entityId == this.entityId &&
          other.isResolved == this.isResolved &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class SetupPayoffsCompanion extends UpdateCompanion<SetupPayoffRow> {
  final Value<String> id;
  final Value<String?> projectId;
  final Value<String> setupChapterId;
  final Value<String> setupDescription;
  final Value<String?> payoffChapterId;
  final Value<String?> payoffDescription;
  final Value<String?> entityId;
  final Value<bool> isResolved;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const SetupPayoffsCompanion({
    this.id = const Value.absent(),
    this.projectId = const Value.absent(),
    this.setupChapterId = const Value.absent(),
    this.setupDescription = const Value.absent(),
    this.payoffChapterId = const Value.absent(),
    this.payoffDescription = const Value.absent(),
    this.entityId = const Value.absent(),
    this.isResolved = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SetupPayoffsCompanion.insert({
    required String id,
    this.projectId = const Value.absent(),
    required String setupChapterId,
    required String setupDescription,
    this.payoffChapterId = const Value.absent(),
    this.payoffDescription = const Value.absent(),
    this.entityId = const Value.absent(),
    this.isResolved = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        setupChapterId = Value(setupChapterId),
        setupDescription = Value(setupDescription),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<SetupPayoffRow> custom({
    Expression<String>? id,
    Expression<String>? projectId,
    Expression<String>? setupChapterId,
    Expression<String>? setupDescription,
    Expression<String>? payoffChapterId,
    Expression<String>? payoffDescription,
    Expression<String>? entityId,
    Expression<bool>? isResolved,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (projectId != null) 'project_id': projectId,
      if (setupChapterId != null) 'setup_chapter_id': setupChapterId,
      if (setupDescription != null) 'setup_description': setupDescription,
      if (payoffChapterId != null) 'payoff_chapter_id': payoffChapterId,
      if (payoffDescription != null) 'payoff_description': payoffDescription,
      if (entityId != null) 'entity_id': entityId,
      if (isResolved != null) 'is_resolved': isResolved,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SetupPayoffsCompanion copyWith(
      {Value<String>? id,
      Value<String?>? projectId,
      Value<String>? setupChapterId,
      Value<String>? setupDescription,
      Value<String?>? payoffChapterId,
      Value<String?>? payoffDescription,
      Value<String?>? entityId,
      Value<bool>? isResolved,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<int>? rowid}) {
    return SetupPayoffsCompanion(
      id: id ?? this.id,
      projectId: projectId ?? this.projectId,
      setupChapterId: setupChapterId ?? this.setupChapterId,
      setupDescription: setupDescription ?? this.setupDescription,
      payoffChapterId: payoffChapterId ?? this.payoffChapterId,
      payoffDescription: payoffDescription ?? this.payoffDescription,
      entityId: entityId ?? this.entityId,
      isResolved: isResolved ?? this.isResolved,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (projectId.present) {
      map['project_id'] = Variable<String>(projectId.value);
    }
    if (setupChapterId.present) {
      map['setup_chapter_id'] = Variable<String>(setupChapterId.value);
    }
    if (setupDescription.present) {
      map['setup_description'] = Variable<String>(setupDescription.value);
    }
    if (payoffChapterId.present) {
      map['payoff_chapter_id'] = Variable<String>(payoffChapterId.value);
    }
    if (payoffDescription.present) {
      map['payoff_description'] = Variable<String>(payoffDescription.value);
    }
    if (entityId.present) {
      map['entity_id'] = Variable<String>(entityId.value);
    }
    if (isResolved.present) {
      map['is_resolved'] = Variable<bool>(isResolved.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SetupPayoffsCompanion(')
          ..write('id: $id, ')
          ..write('projectId: $projectId, ')
          ..write('setupChapterId: $setupChapterId, ')
          ..write('setupDescription: $setupDescription, ')
          ..write('payoffChapterId: $payoffChapterId, ')
          ..write('payoffDescription: $payoffDescription, ')
          ..write('entityId: $entityId, ')
          ..write('isResolved: $isResolved, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $ProjectsTable projects = $ProjectsTable(this);
  late final $EntitiesTable entities = $EntitiesTable(this);
  late final $RelationshipsTable relationships = $RelationshipsTable(this);
  late final $TagsTable tags = $TagsTable(this);
  late final $EntityTagsTable entityTags = $EntityTagsTable(this);
  late final $TimelineEntriesTable timelineEntries =
      $TimelineEntriesTable(this);
  late final $EntityVersionsTable entityVersions = $EntityVersionsTable(this);
  late final $TemplatesTable templates = $TemplatesTable(this);
  late final $ManuscriptChaptersTable manuscriptChapters =
      $ManuscriptChaptersTable(this);
  late final $ChapterSnapshotsTable chapterSnapshots =
      $ChapterSnapshotsTable(this);
  late final $PlotCardsTable plotCards = $PlotCardsTable(this);
  late final $PlotConnectionsTable plotConnections =
      $PlotConnectionsTable(this);
  late final $WorldMapsTable worldMaps = $WorldMapsTable(this);
  late final $MapPinsTable mapPins = $MapPinsTable(this);
  late final $SetupPayoffsTable setupPayoffs = $SetupPayoffsTable(this);
  late final ProjectDao projectDao = ProjectDao(this as AppDatabase);
  late final EntityDao entityDao = EntityDao(this as AppDatabase);
  late final RelationshipDao relationshipDao =
      RelationshipDao(this as AppDatabase);
  late final TagDao tagDao = TagDao(this as AppDatabase);
  late final TimelineDao timelineDao = TimelineDao(this as AppDatabase);
  late final EntityVersionDao entityVersionDao =
      EntityVersionDao(this as AppDatabase);
  late final TemplateDao templateDao = TemplateDao(this as AppDatabase);
  late final MapDao mapDao = MapDao(this as AppDatabase);
  late final ManuscriptDao manuscriptDao = ManuscriptDao(this as AppDatabase);
  late final SnapshotDao snapshotDao = SnapshotDao(this as AppDatabase);
  late final PlotDao plotDao = PlotDao(this as AppDatabase);
  late final SetupPayoffDao setupPayoffDao =
      SetupPayoffDao(this as AppDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        projects,
        entities,
        relationships,
        tags,
        entityTags,
        timelineEntries,
        entityVersions,
        templates,
        manuscriptChapters,
        chapterSnapshots,
        plotCards,
        plotConnections,
        worldMaps,
        mapPins,
        setupPayoffs
      ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules(
        [
          WritePropagation(
            on: TableUpdateQuery.onTableName('projects',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('entities', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('entities',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('relationships', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('entities',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('relationships', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('projects',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('tags', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('entities',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('entity_tags', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('tags',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('entity_tags', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('projects',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('timeline_entries', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('entities',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('timeline_entries', kind: UpdateKind.update),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('entities',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('entity_versions', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('projects',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('manuscript_chapters', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('manuscript_chapters',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('chapter_snapshots', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('projects',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('plot_cards', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('projects',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('plot_connections', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('projects',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('world_maps', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('world_maps',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('map_pins', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('entities',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('map_pins', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('projects',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('setup_payoffs', kind: UpdateKind.delete),
            ],
          ),
        ],
      );
  @override
  DriftDatabaseOptions get options =>
      const DriftDatabaseOptions(storeDateTimeAsText: true);
}

typedef $$ProjectsTableCreateCompanionBuilder = ProjectsCompanion Function({
  required String id,
  required String name,
  Value<String?> description,
  Value<String?> coverImagePath,
  required DateTime lastAccessedAt,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<bool> isDeleted,
  Value<int> rowid,
});
typedef $$ProjectsTableUpdateCompanionBuilder = ProjectsCompanion Function({
  Value<String> id,
  Value<String> name,
  Value<String?> description,
  Value<String?> coverImagePath,
  Value<DateTime> lastAccessedAt,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<bool> isDeleted,
  Value<int> rowid,
});

final class $$ProjectsTableReferences
    extends BaseReferences<_$AppDatabase, $ProjectsTable, ProjectRow> {
  $$ProjectsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$EntitiesTable, List<EntityRow>>
      _entitiesRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.entities,
              aliasName:
                  $_aliasNameGenerator(db.projects.id, db.entities.projectId));

  $$EntitiesTableProcessedTableManager get entitiesRefs {
    final manager = $$EntitiesTableTableManager($_db, $_db.entities)
        .filter((f) => f.projectId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_entitiesRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$TagsTable, List<TagRow>> _tagsRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.tags,
          aliasName: $_aliasNameGenerator(db.projects.id, db.tags.projectId));

  $$TagsTableProcessedTableManager get tagsRefs {
    final manager = $$TagsTableTableManager($_db, $_db.tags)
        .filter((f) => f.projectId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_tagsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$TimelineEntriesTable, List<TimelineEntryRow>>
      _timelineEntriesRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.timelineEntries,
              aliasName: $_aliasNameGenerator(
                  db.projects.id, db.timelineEntries.projectId));

  $$TimelineEntriesTableProcessedTableManager get timelineEntriesRefs {
    final manager = $$TimelineEntriesTableTableManager(
            $_db, $_db.timelineEntries)
        .filter((f) => f.projectId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_timelineEntriesRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$ManuscriptChaptersTable,
      List<ManuscriptChapterRow>> _manuscriptChaptersRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.manuscriptChapters,
          aliasName: $_aliasNameGenerator(
              db.projects.id, db.manuscriptChapters.projectId));

  $$ManuscriptChaptersTableProcessedTableManager get manuscriptChaptersRefs {
    final manager = $$ManuscriptChaptersTableTableManager(
            $_db, $_db.manuscriptChapters)
        .filter((f) => f.projectId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_manuscriptChaptersRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$PlotCardsTable, List<PlotCardRow>>
      _plotCardsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.plotCards,
              aliasName:
                  $_aliasNameGenerator(db.projects.id, db.plotCards.projectId));

  $$PlotCardsTableProcessedTableManager get plotCardsRefs {
    final manager = $$PlotCardsTableTableManager($_db, $_db.plotCards)
        .filter((f) => f.projectId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_plotCardsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$PlotConnectionsTable, List<PlotConnectionRow>>
      _plotConnectionsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.plotConnections,
              aliasName: $_aliasNameGenerator(
                  db.projects.id, db.plotConnections.projectId));

  $$PlotConnectionsTableProcessedTableManager get plotConnectionsRefs {
    final manager = $$PlotConnectionsTableTableManager(
            $_db, $_db.plotConnections)
        .filter((f) => f.projectId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_plotConnectionsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$WorldMapsTable, List<WorldMapRow>>
      _worldMapsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.worldMaps,
              aliasName:
                  $_aliasNameGenerator(db.projects.id, db.worldMaps.projectId));

  $$WorldMapsTableProcessedTableManager get worldMapsRefs {
    final manager = $$WorldMapsTableTableManager($_db, $_db.worldMaps)
        .filter((f) => f.projectId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_worldMapsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$SetupPayoffsTable, List<SetupPayoffRow>>
      _setupPayoffsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
          db.setupPayoffs,
          aliasName:
              $_aliasNameGenerator(db.projects.id, db.setupPayoffs.projectId));

  $$SetupPayoffsTableProcessedTableManager get setupPayoffsRefs {
    final manager = $$SetupPayoffsTableTableManager($_db, $_db.setupPayoffs)
        .filter((f) => f.projectId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_setupPayoffsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$ProjectsTableFilterComposer
    extends Composer<_$AppDatabase, $ProjectsTable> {
  $$ProjectsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get coverImagePath => $composableBuilder(
      column: $table.coverImagePath,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get lastAccessedAt => $composableBuilder(
      column: $table.lastAccessedAt,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isDeleted => $composableBuilder(
      column: $table.isDeleted, builder: (column) => ColumnFilters(column));

  Expression<bool> entitiesRefs(
      Expression<bool> Function($$EntitiesTableFilterComposer f) f) {
    final $$EntitiesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.entities,
        getReferencedColumn: (t) => t.projectId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$EntitiesTableFilterComposer(
              $db: $db,
              $table: $db.entities,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> tagsRefs(
      Expression<bool> Function($$TagsTableFilterComposer f) f) {
    final $$TagsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.tags,
        getReferencedColumn: (t) => t.projectId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TagsTableFilterComposer(
              $db: $db,
              $table: $db.tags,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> timelineEntriesRefs(
      Expression<bool> Function($$TimelineEntriesTableFilterComposer f) f) {
    final $$TimelineEntriesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.timelineEntries,
        getReferencedColumn: (t) => t.projectId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TimelineEntriesTableFilterComposer(
              $db: $db,
              $table: $db.timelineEntries,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> manuscriptChaptersRefs(
      Expression<bool> Function($$ManuscriptChaptersTableFilterComposer f) f) {
    final $$ManuscriptChaptersTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.manuscriptChapters,
        getReferencedColumn: (t) => t.projectId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ManuscriptChaptersTableFilterComposer(
              $db: $db,
              $table: $db.manuscriptChapters,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> plotCardsRefs(
      Expression<bool> Function($$PlotCardsTableFilterComposer f) f) {
    final $$PlotCardsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.plotCards,
        getReferencedColumn: (t) => t.projectId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PlotCardsTableFilterComposer(
              $db: $db,
              $table: $db.plotCards,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> plotConnectionsRefs(
      Expression<bool> Function($$PlotConnectionsTableFilterComposer f) f) {
    final $$PlotConnectionsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.plotConnections,
        getReferencedColumn: (t) => t.projectId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PlotConnectionsTableFilterComposer(
              $db: $db,
              $table: $db.plotConnections,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> worldMapsRefs(
      Expression<bool> Function($$WorldMapsTableFilterComposer f) f) {
    final $$WorldMapsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.worldMaps,
        getReferencedColumn: (t) => t.projectId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$WorldMapsTableFilterComposer(
              $db: $db,
              $table: $db.worldMaps,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> setupPayoffsRefs(
      Expression<bool> Function($$SetupPayoffsTableFilterComposer f) f) {
    final $$SetupPayoffsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.setupPayoffs,
        getReferencedColumn: (t) => t.projectId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SetupPayoffsTableFilterComposer(
              $db: $db,
              $table: $db.setupPayoffs,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$ProjectsTableOrderingComposer
    extends Composer<_$AppDatabase, $ProjectsTable> {
  $$ProjectsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get coverImagePath => $composableBuilder(
      column: $table.coverImagePath,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get lastAccessedAt => $composableBuilder(
      column: $table.lastAccessedAt,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isDeleted => $composableBuilder(
      column: $table.isDeleted, builder: (column) => ColumnOrderings(column));
}

class $$ProjectsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProjectsTable> {
  $$ProjectsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => column);

  GeneratedColumn<String> get coverImagePath => $composableBuilder(
      column: $table.coverImagePath, builder: (column) => column);

  GeneratedColumn<DateTime> get lastAccessedAt => $composableBuilder(
      column: $table.lastAccessedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<bool> get isDeleted =>
      $composableBuilder(column: $table.isDeleted, builder: (column) => column);

  Expression<T> entitiesRefs<T extends Object>(
      Expression<T> Function($$EntitiesTableAnnotationComposer a) f) {
    final $$EntitiesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.entities,
        getReferencedColumn: (t) => t.projectId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$EntitiesTableAnnotationComposer(
              $db: $db,
              $table: $db.entities,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> tagsRefs<T extends Object>(
      Expression<T> Function($$TagsTableAnnotationComposer a) f) {
    final $$TagsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.tags,
        getReferencedColumn: (t) => t.projectId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TagsTableAnnotationComposer(
              $db: $db,
              $table: $db.tags,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> timelineEntriesRefs<T extends Object>(
      Expression<T> Function($$TimelineEntriesTableAnnotationComposer a) f) {
    final $$TimelineEntriesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.timelineEntries,
        getReferencedColumn: (t) => t.projectId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TimelineEntriesTableAnnotationComposer(
              $db: $db,
              $table: $db.timelineEntries,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> manuscriptChaptersRefs<T extends Object>(
      Expression<T> Function($$ManuscriptChaptersTableAnnotationComposer a) f) {
    final $$ManuscriptChaptersTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.manuscriptChapters,
            getReferencedColumn: (t) => t.projectId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$ManuscriptChaptersTableAnnotationComposer(
                  $db: $db,
                  $table: $db.manuscriptChapters,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }

  Expression<T> plotCardsRefs<T extends Object>(
      Expression<T> Function($$PlotCardsTableAnnotationComposer a) f) {
    final $$PlotCardsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.plotCards,
        getReferencedColumn: (t) => t.projectId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PlotCardsTableAnnotationComposer(
              $db: $db,
              $table: $db.plotCards,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> plotConnectionsRefs<T extends Object>(
      Expression<T> Function($$PlotConnectionsTableAnnotationComposer a) f) {
    final $$PlotConnectionsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.plotConnections,
        getReferencedColumn: (t) => t.projectId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$PlotConnectionsTableAnnotationComposer(
              $db: $db,
              $table: $db.plotConnections,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> worldMapsRefs<T extends Object>(
      Expression<T> Function($$WorldMapsTableAnnotationComposer a) f) {
    final $$WorldMapsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.worldMaps,
        getReferencedColumn: (t) => t.projectId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$WorldMapsTableAnnotationComposer(
              $db: $db,
              $table: $db.worldMaps,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> setupPayoffsRefs<T extends Object>(
      Expression<T> Function($$SetupPayoffsTableAnnotationComposer a) f) {
    final $$SetupPayoffsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.setupPayoffs,
        getReferencedColumn: (t) => t.projectId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SetupPayoffsTableAnnotationComposer(
              $db: $db,
              $table: $db.setupPayoffs,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$ProjectsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ProjectsTable,
    ProjectRow,
    $$ProjectsTableFilterComposer,
    $$ProjectsTableOrderingComposer,
    $$ProjectsTableAnnotationComposer,
    $$ProjectsTableCreateCompanionBuilder,
    $$ProjectsTableUpdateCompanionBuilder,
    (ProjectRow, $$ProjectsTableReferences),
    ProjectRow,
    PrefetchHooks Function(
        {bool entitiesRefs,
        bool tagsRefs,
        bool timelineEntriesRefs,
        bool manuscriptChaptersRefs,
        bool plotCardsRefs,
        bool plotConnectionsRefs,
        bool worldMapsRefs,
        bool setupPayoffsRefs})> {
  $$ProjectsTableTableManager(_$AppDatabase db, $ProjectsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProjectsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProjectsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProjectsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String?> description = const Value.absent(),
            Value<String?> coverImagePath = const Value.absent(),
            Value<DateTime> lastAccessedAt = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<bool> isDeleted = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ProjectsCompanion(
            id: id,
            name: name,
            description: description,
            coverImagePath: coverImagePath,
            lastAccessedAt: lastAccessedAt,
            createdAt: createdAt,
            updatedAt: updatedAt,
            isDeleted: isDeleted,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String name,
            Value<String?> description = const Value.absent(),
            Value<String?> coverImagePath = const Value.absent(),
            required DateTime lastAccessedAt,
            required DateTime createdAt,
            required DateTime updatedAt,
            Value<bool> isDeleted = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ProjectsCompanion.insert(
            id: id,
            name: name,
            description: description,
            coverImagePath: coverImagePath,
            lastAccessedAt: lastAccessedAt,
            createdAt: createdAt,
            updatedAt: updatedAt,
            isDeleted: isDeleted,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$ProjectsTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: (
              {entitiesRefs = false,
              tagsRefs = false,
              timelineEntriesRefs = false,
              manuscriptChaptersRefs = false,
              plotCardsRefs = false,
              plotConnectionsRefs = false,
              worldMapsRefs = false,
              setupPayoffsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (entitiesRefs) db.entities,
                if (tagsRefs) db.tags,
                if (timelineEntriesRefs) db.timelineEntries,
                if (manuscriptChaptersRefs) db.manuscriptChapters,
                if (plotCardsRefs) db.plotCards,
                if (plotConnectionsRefs) db.plotConnections,
                if (worldMapsRefs) db.worldMaps,
                if (setupPayoffsRefs) db.setupPayoffs
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (entitiesRefs)
                    await $_getPrefetchedData<ProjectRow, $ProjectsTable,
                            EntityRow>(
                        currentTable: table,
                        referencedTable:
                            $$ProjectsTableReferences._entitiesRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$ProjectsTableReferences(db, table, p0)
                                .entitiesRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.projectId == item.id),
                        typedResults: items),
                  if (tagsRefs)
                    await $_getPrefetchedData<ProjectRow, $ProjectsTable,
                            TagRow>(
                        currentTable: table,
                        referencedTable:
                            $$ProjectsTableReferences._tagsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$ProjectsTableReferences(db, table, p0).tagsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.projectId == item.id),
                        typedResults: items),
                  if (timelineEntriesRefs)
                    await $_getPrefetchedData<ProjectRow, $ProjectsTable,
                            TimelineEntryRow>(
                        currentTable: table,
                        referencedTable: $$ProjectsTableReferences
                            ._timelineEntriesRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$ProjectsTableReferences(db, table, p0)
                                .timelineEntriesRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.projectId == item.id),
                        typedResults: items),
                  if (manuscriptChaptersRefs)
                    await $_getPrefetchedData<ProjectRow, $ProjectsTable,
                            ManuscriptChapterRow>(
                        currentTable: table,
                        referencedTable: $$ProjectsTableReferences
                            ._manuscriptChaptersRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$ProjectsTableReferences(db, table, p0)
                                .manuscriptChaptersRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.projectId == item.id),
                        typedResults: items),
                  if (plotCardsRefs)
                    await $_getPrefetchedData<ProjectRow, $ProjectsTable,
                            PlotCardRow>(
                        currentTable: table,
                        referencedTable:
                            $$ProjectsTableReferences._plotCardsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$ProjectsTableReferences(db, table, p0)
                                .plotCardsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.projectId == item.id),
                        typedResults: items),
                  if (plotConnectionsRefs)
                    await $_getPrefetchedData<ProjectRow, $ProjectsTable,
                            PlotConnectionRow>(
                        currentTable: table,
                        referencedTable: $$ProjectsTableReferences
                            ._plotConnectionsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$ProjectsTableReferences(db, table, p0)
                                .plotConnectionsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.projectId == item.id),
                        typedResults: items),
                  if (worldMapsRefs)
                    await $_getPrefetchedData<ProjectRow, $ProjectsTable,
                            WorldMapRow>(
                        currentTable: table,
                        referencedTable:
                            $$ProjectsTableReferences._worldMapsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$ProjectsTableReferences(db, table, p0)
                                .worldMapsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.projectId == item.id),
                        typedResults: items),
                  if (setupPayoffsRefs)
                    await $_getPrefetchedData<ProjectRow, $ProjectsTable,
                            SetupPayoffRow>(
                        currentTable: table,
                        referencedTable: $$ProjectsTableReferences
                            ._setupPayoffsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$ProjectsTableReferences(db, table, p0)
                                .setupPayoffsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.projectId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$ProjectsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ProjectsTable,
    ProjectRow,
    $$ProjectsTableFilterComposer,
    $$ProjectsTableOrderingComposer,
    $$ProjectsTableAnnotationComposer,
    $$ProjectsTableCreateCompanionBuilder,
    $$ProjectsTableUpdateCompanionBuilder,
    (ProjectRow, $$ProjectsTableReferences),
    ProjectRow,
    PrefetchHooks Function(
        {bool entitiesRefs,
        bool tagsRefs,
        bool timelineEntriesRefs,
        bool manuscriptChaptersRefs,
        bool plotCardsRefs,
        bool plotConnectionsRefs,
        bool worldMapsRefs,
        bool setupPayoffsRefs})>;
typedef $$EntitiesTableCreateCompanionBuilder = EntitiesCompanion Function({
  required String id,
  Value<String?> projectId,
  required String name,
  required String entityType,
  Value<String> status,
  Value<String?> description,
  Value<String> customFields,
  required int iconColor,
  Value<bool> isDeleted,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<int> rowid,
});
typedef $$EntitiesTableUpdateCompanionBuilder = EntitiesCompanion Function({
  Value<String> id,
  Value<String?> projectId,
  Value<String> name,
  Value<String> entityType,
  Value<String> status,
  Value<String?> description,
  Value<String> customFields,
  Value<int> iconColor,
  Value<bool> isDeleted,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

final class $$EntitiesTableReferences
    extends BaseReferences<_$AppDatabase, $EntitiesTable, EntityRow> {
  $$EntitiesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ProjectsTable _projectIdTable(_$AppDatabase db) => db.projects
      .createAlias($_aliasNameGenerator(db.entities.projectId, db.projects.id));

  $$ProjectsTableProcessedTableManager? get projectId {
    final $_column = $_itemColumn<String>('project_id');
    if ($_column == null) return null;
    final manager = $$ProjectsTableTableManager($_db, $_db.projects)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_projectIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static MultiTypedResultKey<$RelationshipsTable, List<RelationshipRow>>
      _sourceRelationshipsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.relationships,
              aliasName: $_aliasNameGenerator(
                  db.entities.id, db.relationships.sourceId));

  $$RelationshipsTableProcessedTableManager get sourceRelationships {
    final manager = $$RelationshipsTableTableManager($_db, $_db.relationships)
        .filter((f) => f.sourceId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_sourceRelationshipsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$RelationshipsTable, List<RelationshipRow>>
      _targetRelationshipsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.relationships,
              aliasName: $_aliasNameGenerator(
                  db.entities.id, db.relationships.targetId));

  $$RelationshipsTableProcessedTableManager get targetRelationships {
    final manager = $$RelationshipsTableTableManager($_db, $_db.relationships)
        .filter((f) => f.targetId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_targetRelationshipsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$EntityTagsTable, List<EntityTagRow>>
      _entityTagsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.entityTags,
              aliasName:
                  $_aliasNameGenerator(db.entities.id, db.entityTags.entityId));

  $$EntityTagsTableProcessedTableManager get entityTagsRefs {
    final manager = $$EntityTagsTableTableManager($_db, $_db.entityTags)
        .filter((f) => f.entityId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_entityTagsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$TimelineEntriesTable, List<TimelineEntryRow>>
      _timelineEntriesRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.timelineEntries,
              aliasName: $_aliasNameGenerator(
                  db.entities.id, db.timelineEntries.entityId));

  $$TimelineEntriesTableProcessedTableManager get timelineEntriesRefs {
    final manager = $$TimelineEntriesTableTableManager(
            $_db, $_db.timelineEntries)
        .filter((f) => f.entityId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_timelineEntriesRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$EntityVersionsTable, List<EntityVersionRow>>
      _entityVersionsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.entityVersions,
              aliasName: $_aliasNameGenerator(
                  db.entities.id, db.entityVersions.entityId));

  $$EntityVersionsTableProcessedTableManager get entityVersionsRefs {
    final manager = $$EntityVersionsTableTableManager($_db, $_db.entityVersions)
        .filter((f) => f.entityId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_entityVersionsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$MapPinsTable, List<MapPinRow>> _mapPinsRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.mapPins,
          aliasName: $_aliasNameGenerator(db.entities.id, db.mapPins.entityId));

  $$MapPinsTableProcessedTableManager get mapPinsRefs {
    final manager = $$MapPinsTableTableManager($_db, $_db.mapPins)
        .filter((f) => f.entityId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_mapPinsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$EntitiesTableFilterComposer
    extends Composer<_$AppDatabase, $EntitiesTable> {
  $$EntitiesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get entityType => $composableBuilder(
      column: $table.entityType, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get customFields => $composableBuilder(
      column: $table.customFields, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get iconColor => $composableBuilder(
      column: $table.iconColor, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isDeleted => $composableBuilder(
      column: $table.isDeleted, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  $$ProjectsTableFilterComposer get projectId {
    final $$ProjectsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.projectId,
        referencedTable: $db.projects,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ProjectsTableFilterComposer(
              $db: $db,
              $table: $db.projects,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<bool> sourceRelationships(
      Expression<bool> Function($$RelationshipsTableFilterComposer f) f) {
    final $$RelationshipsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.relationships,
        getReferencedColumn: (t) => t.sourceId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$RelationshipsTableFilterComposer(
              $db: $db,
              $table: $db.relationships,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> targetRelationships(
      Expression<bool> Function($$RelationshipsTableFilterComposer f) f) {
    final $$RelationshipsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.relationships,
        getReferencedColumn: (t) => t.targetId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$RelationshipsTableFilterComposer(
              $db: $db,
              $table: $db.relationships,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> entityTagsRefs(
      Expression<bool> Function($$EntityTagsTableFilterComposer f) f) {
    final $$EntityTagsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.entityTags,
        getReferencedColumn: (t) => t.entityId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$EntityTagsTableFilterComposer(
              $db: $db,
              $table: $db.entityTags,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> timelineEntriesRefs(
      Expression<bool> Function($$TimelineEntriesTableFilterComposer f) f) {
    final $$TimelineEntriesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.timelineEntries,
        getReferencedColumn: (t) => t.entityId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TimelineEntriesTableFilterComposer(
              $db: $db,
              $table: $db.timelineEntries,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> entityVersionsRefs(
      Expression<bool> Function($$EntityVersionsTableFilterComposer f) f) {
    final $$EntityVersionsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.entityVersions,
        getReferencedColumn: (t) => t.entityId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$EntityVersionsTableFilterComposer(
              $db: $db,
              $table: $db.entityVersions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> mapPinsRefs(
      Expression<bool> Function($$MapPinsTableFilterComposer f) f) {
    final $$MapPinsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.mapPins,
        getReferencedColumn: (t) => t.entityId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MapPinsTableFilterComposer(
              $db: $db,
              $table: $db.mapPins,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$EntitiesTableOrderingComposer
    extends Composer<_$AppDatabase, $EntitiesTable> {
  $$EntitiesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get entityType => $composableBuilder(
      column: $table.entityType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get customFields => $composableBuilder(
      column: $table.customFields,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get iconColor => $composableBuilder(
      column: $table.iconColor, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isDeleted => $composableBuilder(
      column: $table.isDeleted, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  $$ProjectsTableOrderingComposer get projectId {
    final $$ProjectsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.projectId,
        referencedTable: $db.projects,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ProjectsTableOrderingComposer(
              $db: $db,
              $table: $db.projects,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$EntitiesTableAnnotationComposer
    extends Composer<_$AppDatabase, $EntitiesTable> {
  $$EntitiesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get entityType => $composableBuilder(
      column: $table.entityType, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => column);

  GeneratedColumn<String> get customFields => $composableBuilder(
      column: $table.customFields, builder: (column) => column);

  GeneratedColumn<int> get iconColor =>
      $composableBuilder(column: $table.iconColor, builder: (column) => column);

  GeneratedColumn<bool> get isDeleted =>
      $composableBuilder(column: $table.isDeleted, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$ProjectsTableAnnotationComposer get projectId {
    final $$ProjectsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.projectId,
        referencedTable: $db.projects,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ProjectsTableAnnotationComposer(
              $db: $db,
              $table: $db.projects,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<T> sourceRelationships<T extends Object>(
      Expression<T> Function($$RelationshipsTableAnnotationComposer a) f) {
    final $$RelationshipsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.relationships,
        getReferencedColumn: (t) => t.sourceId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$RelationshipsTableAnnotationComposer(
              $db: $db,
              $table: $db.relationships,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> targetRelationships<T extends Object>(
      Expression<T> Function($$RelationshipsTableAnnotationComposer a) f) {
    final $$RelationshipsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.relationships,
        getReferencedColumn: (t) => t.targetId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$RelationshipsTableAnnotationComposer(
              $db: $db,
              $table: $db.relationships,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> entityTagsRefs<T extends Object>(
      Expression<T> Function($$EntityTagsTableAnnotationComposer a) f) {
    final $$EntityTagsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.entityTags,
        getReferencedColumn: (t) => t.entityId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$EntityTagsTableAnnotationComposer(
              $db: $db,
              $table: $db.entityTags,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> timelineEntriesRefs<T extends Object>(
      Expression<T> Function($$TimelineEntriesTableAnnotationComposer a) f) {
    final $$TimelineEntriesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.timelineEntries,
        getReferencedColumn: (t) => t.entityId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TimelineEntriesTableAnnotationComposer(
              $db: $db,
              $table: $db.timelineEntries,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> entityVersionsRefs<T extends Object>(
      Expression<T> Function($$EntityVersionsTableAnnotationComposer a) f) {
    final $$EntityVersionsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.entityVersions,
        getReferencedColumn: (t) => t.entityId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$EntityVersionsTableAnnotationComposer(
              $db: $db,
              $table: $db.entityVersions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> mapPinsRefs<T extends Object>(
      Expression<T> Function($$MapPinsTableAnnotationComposer a) f) {
    final $$MapPinsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.mapPins,
        getReferencedColumn: (t) => t.entityId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MapPinsTableAnnotationComposer(
              $db: $db,
              $table: $db.mapPins,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$EntitiesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $EntitiesTable,
    EntityRow,
    $$EntitiesTableFilterComposer,
    $$EntitiesTableOrderingComposer,
    $$EntitiesTableAnnotationComposer,
    $$EntitiesTableCreateCompanionBuilder,
    $$EntitiesTableUpdateCompanionBuilder,
    (EntityRow, $$EntitiesTableReferences),
    EntityRow,
    PrefetchHooks Function(
        {bool projectId,
        bool sourceRelationships,
        bool targetRelationships,
        bool entityTagsRefs,
        bool timelineEntriesRefs,
        bool entityVersionsRefs,
        bool mapPinsRefs})> {
  $$EntitiesTableTableManager(_$AppDatabase db, $EntitiesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EntitiesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$EntitiesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$EntitiesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String?> projectId = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> entityType = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<String?> description = const Value.absent(),
            Value<String> customFields = const Value.absent(),
            Value<int> iconColor = const Value.absent(),
            Value<bool> isDeleted = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              EntitiesCompanion(
            id: id,
            projectId: projectId,
            name: name,
            entityType: entityType,
            status: status,
            description: description,
            customFields: customFields,
            iconColor: iconColor,
            isDeleted: isDeleted,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            Value<String?> projectId = const Value.absent(),
            required String name,
            required String entityType,
            Value<String> status = const Value.absent(),
            Value<String?> description = const Value.absent(),
            Value<String> customFields = const Value.absent(),
            required int iconColor,
            Value<bool> isDeleted = const Value.absent(),
            required DateTime createdAt,
            required DateTime updatedAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              EntitiesCompanion.insert(
            id: id,
            projectId: projectId,
            name: name,
            entityType: entityType,
            status: status,
            description: description,
            customFields: customFields,
            iconColor: iconColor,
            isDeleted: isDeleted,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$EntitiesTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: (
              {projectId = false,
              sourceRelationships = false,
              targetRelationships = false,
              entityTagsRefs = false,
              timelineEntriesRefs = false,
              entityVersionsRefs = false,
              mapPinsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (sourceRelationships) db.relationships,
                if (targetRelationships) db.relationships,
                if (entityTagsRefs) db.entityTags,
                if (timelineEntriesRefs) db.timelineEntries,
                if (entityVersionsRefs) db.entityVersions,
                if (mapPinsRefs) db.mapPins
              ],
              addJoins: <
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
                      dynamic>>(state) {
                if (projectId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.projectId,
                    referencedTable:
                        $$EntitiesTableReferences._projectIdTable(db),
                    referencedColumn:
                        $$EntitiesTableReferences._projectIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (sourceRelationships)
                    await $_getPrefetchedData<EntityRow, $EntitiesTable,
                            RelationshipRow>(
                        currentTable: table,
                        referencedTable: $$EntitiesTableReferences
                            ._sourceRelationshipsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$EntitiesTableReferences(db, table, p0)
                                .sourceRelationships,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.sourceId == item.id),
                        typedResults: items),
                  if (targetRelationships)
                    await $_getPrefetchedData<EntityRow, $EntitiesTable,
                            RelationshipRow>(
                        currentTable: table,
                        referencedTable: $$EntitiesTableReferences
                            ._targetRelationshipsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$EntitiesTableReferences(db, table, p0)
                                .targetRelationships,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.targetId == item.id),
                        typedResults: items),
                  if (entityTagsRefs)
                    await $_getPrefetchedData<EntityRow, $EntitiesTable,
                            EntityTagRow>(
                        currentTable: table,
                        referencedTable:
                            $$EntitiesTableReferences._entityTagsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$EntitiesTableReferences(db, table, p0)
                                .entityTagsRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.entityId == item.id),
                        typedResults: items),
                  if (timelineEntriesRefs)
                    await $_getPrefetchedData<EntityRow, $EntitiesTable,
                            TimelineEntryRow>(
                        currentTable: table,
                        referencedTable: $$EntitiesTableReferences
                            ._timelineEntriesRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$EntitiesTableReferences(db, table, p0)
                                .timelineEntriesRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.entityId == item.id),
                        typedResults: items),
                  if (entityVersionsRefs)
                    await $_getPrefetchedData<EntityRow, $EntitiesTable,
                            EntityVersionRow>(
                        currentTable: table,
                        referencedTable: $$EntitiesTableReferences
                            ._entityVersionsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$EntitiesTableReferences(db, table, p0)
                                .entityVersionsRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.entityId == item.id),
                        typedResults: items),
                  if (mapPinsRefs)
                    await $_getPrefetchedData<EntityRow, $EntitiesTable,
                            MapPinRow>(
                        currentTable: table,
                        referencedTable:
                            $$EntitiesTableReferences._mapPinsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$EntitiesTableReferences(db, table, p0)
                                .mapPinsRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.entityId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$EntitiesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $EntitiesTable,
    EntityRow,
    $$EntitiesTableFilterComposer,
    $$EntitiesTableOrderingComposer,
    $$EntitiesTableAnnotationComposer,
    $$EntitiesTableCreateCompanionBuilder,
    $$EntitiesTableUpdateCompanionBuilder,
    (EntityRow, $$EntitiesTableReferences),
    EntityRow,
    PrefetchHooks Function(
        {bool projectId,
        bool sourceRelationships,
        bool targetRelationships,
        bool entityTagsRefs,
        bool timelineEntriesRefs,
        bool entityVersionsRefs,
        bool mapPinsRefs})>;
typedef $$RelationshipsTableCreateCompanionBuilder = RelationshipsCompanion
    Function({
  required String id,
  required String sourceId,
  required String targetId,
  required String typeKey,
  Value<String?> description,
  Value<int> weight,
  Value<bool> isDeleted,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<int> rowid,
});
typedef $$RelationshipsTableUpdateCompanionBuilder = RelationshipsCompanion
    Function({
  Value<String> id,
  Value<String> sourceId,
  Value<String> targetId,
  Value<String> typeKey,
  Value<String?> description,
  Value<int> weight,
  Value<bool> isDeleted,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

final class $$RelationshipsTableReferences extends BaseReferences<_$AppDatabase,
    $RelationshipsTable, RelationshipRow> {
  $$RelationshipsTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $EntitiesTable _sourceIdTable(_$AppDatabase db) =>
      db.entities.createAlias(
          $_aliasNameGenerator(db.relationships.sourceId, db.entities.id));

  $$EntitiesTableProcessedTableManager get sourceId {
    final $_column = $_itemColumn<String>('source_id')!;

    final manager = $$EntitiesTableTableManager($_db, $_db.entities)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_sourceIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $EntitiesTable _targetIdTable(_$AppDatabase db) =>
      db.entities.createAlias(
          $_aliasNameGenerator(db.relationships.targetId, db.entities.id));

  $$EntitiesTableProcessedTableManager get targetId {
    final $_column = $_itemColumn<String>('target_id')!;

    final manager = $$EntitiesTableTableManager($_db, $_db.entities)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_targetIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$RelationshipsTableFilterComposer
    extends Composer<_$AppDatabase, $RelationshipsTable> {
  $$RelationshipsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get typeKey => $composableBuilder(
      column: $table.typeKey, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get weight => $composableBuilder(
      column: $table.weight, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isDeleted => $composableBuilder(
      column: $table.isDeleted, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  $$EntitiesTableFilterComposer get sourceId {
    final $$EntitiesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.sourceId,
        referencedTable: $db.entities,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$EntitiesTableFilterComposer(
              $db: $db,
              $table: $db.entities,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$EntitiesTableFilterComposer get targetId {
    final $$EntitiesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.targetId,
        referencedTable: $db.entities,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$EntitiesTableFilterComposer(
              $db: $db,
              $table: $db.entities,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$RelationshipsTableOrderingComposer
    extends Composer<_$AppDatabase, $RelationshipsTable> {
  $$RelationshipsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get typeKey => $composableBuilder(
      column: $table.typeKey, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get weight => $composableBuilder(
      column: $table.weight, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isDeleted => $composableBuilder(
      column: $table.isDeleted, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  $$EntitiesTableOrderingComposer get sourceId {
    final $$EntitiesTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.sourceId,
        referencedTable: $db.entities,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$EntitiesTableOrderingComposer(
              $db: $db,
              $table: $db.entities,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$EntitiesTableOrderingComposer get targetId {
    final $$EntitiesTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.targetId,
        referencedTable: $db.entities,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$EntitiesTableOrderingComposer(
              $db: $db,
              $table: $db.entities,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$RelationshipsTableAnnotationComposer
    extends Composer<_$AppDatabase, $RelationshipsTable> {
  $$RelationshipsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get typeKey =>
      $composableBuilder(column: $table.typeKey, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => column);

  GeneratedColumn<int> get weight =>
      $composableBuilder(column: $table.weight, builder: (column) => column);

  GeneratedColumn<bool> get isDeleted =>
      $composableBuilder(column: $table.isDeleted, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$EntitiesTableAnnotationComposer get sourceId {
    final $$EntitiesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.sourceId,
        referencedTable: $db.entities,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$EntitiesTableAnnotationComposer(
              $db: $db,
              $table: $db.entities,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$EntitiesTableAnnotationComposer get targetId {
    final $$EntitiesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.targetId,
        referencedTable: $db.entities,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$EntitiesTableAnnotationComposer(
              $db: $db,
              $table: $db.entities,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$RelationshipsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $RelationshipsTable,
    RelationshipRow,
    $$RelationshipsTableFilterComposer,
    $$RelationshipsTableOrderingComposer,
    $$RelationshipsTableAnnotationComposer,
    $$RelationshipsTableCreateCompanionBuilder,
    $$RelationshipsTableUpdateCompanionBuilder,
    (RelationshipRow, $$RelationshipsTableReferences),
    RelationshipRow,
    PrefetchHooks Function({bool sourceId, bool targetId})> {
  $$RelationshipsTableTableManager(_$AppDatabase db, $RelationshipsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RelationshipsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RelationshipsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RelationshipsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> sourceId = const Value.absent(),
            Value<String> targetId = const Value.absent(),
            Value<String> typeKey = const Value.absent(),
            Value<String?> description = const Value.absent(),
            Value<int> weight = const Value.absent(),
            Value<bool> isDeleted = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              RelationshipsCompanion(
            id: id,
            sourceId: sourceId,
            targetId: targetId,
            typeKey: typeKey,
            description: description,
            weight: weight,
            isDeleted: isDeleted,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String sourceId,
            required String targetId,
            required String typeKey,
            Value<String?> description = const Value.absent(),
            Value<int> weight = const Value.absent(),
            Value<bool> isDeleted = const Value.absent(),
            required DateTime createdAt,
            required DateTime updatedAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              RelationshipsCompanion.insert(
            id: id,
            sourceId: sourceId,
            targetId: targetId,
            typeKey: typeKey,
            description: description,
            weight: weight,
            isDeleted: isDeleted,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$RelationshipsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({sourceId = false, targetId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
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
                      dynamic>>(state) {
                if (sourceId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.sourceId,
                    referencedTable:
                        $$RelationshipsTableReferences._sourceIdTable(db),
                    referencedColumn:
                        $$RelationshipsTableReferences._sourceIdTable(db).id,
                  ) as T;
                }
                if (targetId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.targetId,
                    referencedTable:
                        $$RelationshipsTableReferences._targetIdTable(db),
                    referencedColumn:
                        $$RelationshipsTableReferences._targetIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$RelationshipsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $RelationshipsTable,
    RelationshipRow,
    $$RelationshipsTableFilterComposer,
    $$RelationshipsTableOrderingComposer,
    $$RelationshipsTableAnnotationComposer,
    $$RelationshipsTableCreateCompanionBuilder,
    $$RelationshipsTableUpdateCompanionBuilder,
    (RelationshipRow, $$RelationshipsTableReferences),
    RelationshipRow,
    PrefetchHooks Function({bool sourceId, bool targetId})>;
typedef $$TagsTableCreateCompanionBuilder = TagsCompanion Function({
  required String id,
  Value<String?> projectId,
  required String name,
  required int color,
  Value<int> rowid,
});
typedef $$TagsTableUpdateCompanionBuilder = TagsCompanion Function({
  Value<String> id,
  Value<String?> projectId,
  Value<String> name,
  Value<int> color,
  Value<int> rowid,
});

final class $$TagsTableReferences
    extends BaseReferences<_$AppDatabase, $TagsTable, TagRow> {
  $$TagsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ProjectsTable _projectIdTable(_$AppDatabase db) => db.projects
      .createAlias($_aliasNameGenerator(db.tags.projectId, db.projects.id));

  $$ProjectsTableProcessedTableManager? get projectId {
    final $_column = $_itemColumn<String>('project_id');
    if ($_column == null) return null;
    final manager = $$ProjectsTableTableManager($_db, $_db.projects)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_projectIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static MultiTypedResultKey<$EntityTagsTable, List<EntityTagRow>>
      _entityTagsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.entityTags,
              aliasName: $_aliasNameGenerator(db.tags.id, db.entityTags.tagId));

  $$EntityTagsTableProcessedTableManager get entityTagsRefs {
    final manager = $$EntityTagsTableTableManager($_db, $_db.entityTags)
        .filter((f) => f.tagId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_entityTagsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$TagsTableFilterComposer extends Composer<_$AppDatabase, $TagsTable> {
  $$TagsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get color => $composableBuilder(
      column: $table.color, builder: (column) => ColumnFilters(column));

  $$ProjectsTableFilterComposer get projectId {
    final $$ProjectsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.projectId,
        referencedTable: $db.projects,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ProjectsTableFilterComposer(
              $db: $db,
              $table: $db.projects,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<bool> entityTagsRefs(
      Expression<bool> Function($$EntityTagsTableFilterComposer f) f) {
    final $$EntityTagsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.entityTags,
        getReferencedColumn: (t) => t.tagId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$EntityTagsTableFilterComposer(
              $db: $db,
              $table: $db.entityTags,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$TagsTableOrderingComposer extends Composer<_$AppDatabase, $TagsTable> {
  $$TagsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get color => $composableBuilder(
      column: $table.color, builder: (column) => ColumnOrderings(column));

  $$ProjectsTableOrderingComposer get projectId {
    final $$ProjectsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.projectId,
        referencedTable: $db.projects,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ProjectsTableOrderingComposer(
              $db: $db,
              $table: $db.projects,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$TagsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TagsTable> {
  $$TagsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get color =>
      $composableBuilder(column: $table.color, builder: (column) => column);

  $$ProjectsTableAnnotationComposer get projectId {
    final $$ProjectsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.projectId,
        referencedTable: $db.projects,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ProjectsTableAnnotationComposer(
              $db: $db,
              $table: $db.projects,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<T> entityTagsRefs<T extends Object>(
      Expression<T> Function($$EntityTagsTableAnnotationComposer a) f) {
    final $$EntityTagsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.entityTags,
        getReferencedColumn: (t) => t.tagId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$EntityTagsTableAnnotationComposer(
              $db: $db,
              $table: $db.entityTags,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$TagsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $TagsTable,
    TagRow,
    $$TagsTableFilterComposer,
    $$TagsTableOrderingComposer,
    $$TagsTableAnnotationComposer,
    $$TagsTableCreateCompanionBuilder,
    $$TagsTableUpdateCompanionBuilder,
    (TagRow, $$TagsTableReferences),
    TagRow,
    PrefetchHooks Function({bool projectId, bool entityTagsRefs})> {
  $$TagsTableTableManager(_$AppDatabase db, $TagsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TagsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TagsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TagsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String?> projectId = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<int> color = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              TagsCompanion(
            id: id,
            projectId: projectId,
            name: name,
            color: color,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            Value<String?> projectId = const Value.absent(),
            required String name,
            required int color,
            Value<int> rowid = const Value.absent(),
          }) =>
              TagsCompanion.insert(
            id: id,
            projectId: projectId,
            name: name,
            color: color,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$TagsTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: ({projectId = false, entityTagsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (entityTagsRefs) db.entityTags],
              addJoins: <
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
                      dynamic>>(state) {
                if (projectId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.projectId,
                    referencedTable: $$TagsTableReferences._projectIdTable(db),
                    referencedColumn:
                        $$TagsTableReferences._projectIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (entityTagsRefs)
                    await $_getPrefetchedData<TagRow, $TagsTable, EntityTagRow>(
                        currentTable: table,
                        referencedTable:
                            $$TagsTableReferences._entityTagsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$TagsTableReferences(db, table, p0).entityTagsRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.tagId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$TagsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $TagsTable,
    TagRow,
    $$TagsTableFilterComposer,
    $$TagsTableOrderingComposer,
    $$TagsTableAnnotationComposer,
    $$TagsTableCreateCompanionBuilder,
    $$TagsTableUpdateCompanionBuilder,
    (TagRow, $$TagsTableReferences),
    TagRow,
    PrefetchHooks Function({bool projectId, bool entityTagsRefs})>;
typedef $$EntityTagsTableCreateCompanionBuilder = EntityTagsCompanion Function({
  required String entityId,
  required String tagId,
  Value<int> rowid,
});
typedef $$EntityTagsTableUpdateCompanionBuilder = EntityTagsCompanion Function({
  Value<String> entityId,
  Value<String> tagId,
  Value<int> rowid,
});

final class $$EntityTagsTableReferences
    extends BaseReferences<_$AppDatabase, $EntityTagsTable, EntityTagRow> {
  $$EntityTagsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $EntitiesTable _entityIdTable(_$AppDatabase db) =>
      db.entities.createAlias(
          $_aliasNameGenerator(db.entityTags.entityId, db.entities.id));

  $$EntitiesTableProcessedTableManager get entityId {
    final $_column = $_itemColumn<String>('entity_id')!;

    final manager = $$EntitiesTableTableManager($_db, $_db.entities)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_entityIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $TagsTable _tagIdTable(_$AppDatabase db) => db.tags
      .createAlias($_aliasNameGenerator(db.entityTags.tagId, db.tags.id));

  $$TagsTableProcessedTableManager get tagId {
    final $_column = $_itemColumn<String>('tag_id')!;

    final manager = $$TagsTableTableManager($_db, $_db.tags)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_tagIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$EntityTagsTableFilterComposer
    extends Composer<_$AppDatabase, $EntityTagsTable> {
  $$EntityTagsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$EntitiesTableFilterComposer get entityId {
    final $$EntitiesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.entityId,
        referencedTable: $db.entities,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$EntitiesTableFilterComposer(
              $db: $db,
              $table: $db.entities,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$TagsTableFilterComposer get tagId {
    final $$TagsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.tagId,
        referencedTable: $db.tags,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TagsTableFilterComposer(
              $db: $db,
              $table: $db.tags,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$EntityTagsTableOrderingComposer
    extends Composer<_$AppDatabase, $EntityTagsTable> {
  $$EntityTagsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$EntitiesTableOrderingComposer get entityId {
    final $$EntitiesTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.entityId,
        referencedTable: $db.entities,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$EntitiesTableOrderingComposer(
              $db: $db,
              $table: $db.entities,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$TagsTableOrderingComposer get tagId {
    final $$TagsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.tagId,
        referencedTable: $db.tags,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TagsTableOrderingComposer(
              $db: $db,
              $table: $db.tags,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$EntityTagsTableAnnotationComposer
    extends Composer<_$AppDatabase, $EntityTagsTable> {
  $$EntityTagsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$EntitiesTableAnnotationComposer get entityId {
    final $$EntitiesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.entityId,
        referencedTable: $db.entities,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$EntitiesTableAnnotationComposer(
              $db: $db,
              $table: $db.entities,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$TagsTableAnnotationComposer get tagId {
    final $$TagsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.tagId,
        referencedTable: $db.tags,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TagsTableAnnotationComposer(
              $db: $db,
              $table: $db.tags,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$EntityTagsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $EntityTagsTable,
    EntityTagRow,
    $$EntityTagsTableFilterComposer,
    $$EntityTagsTableOrderingComposer,
    $$EntityTagsTableAnnotationComposer,
    $$EntityTagsTableCreateCompanionBuilder,
    $$EntityTagsTableUpdateCompanionBuilder,
    (EntityTagRow, $$EntityTagsTableReferences),
    EntityTagRow,
    PrefetchHooks Function({bool entityId, bool tagId})> {
  $$EntityTagsTableTableManager(_$AppDatabase db, $EntityTagsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EntityTagsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$EntityTagsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$EntityTagsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> entityId = const Value.absent(),
            Value<String> tagId = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              EntityTagsCompanion(
            entityId: entityId,
            tagId: tagId,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String entityId,
            required String tagId,
            Value<int> rowid = const Value.absent(),
          }) =>
              EntityTagsCompanion.insert(
            entityId: entityId,
            tagId: tagId,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$EntityTagsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({entityId = false, tagId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
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
                      dynamic>>(state) {
                if (entityId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.entityId,
                    referencedTable:
                        $$EntityTagsTableReferences._entityIdTable(db),
                    referencedColumn:
                        $$EntityTagsTableReferences._entityIdTable(db).id,
                  ) as T;
                }
                if (tagId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.tagId,
                    referencedTable:
                        $$EntityTagsTableReferences._tagIdTable(db),
                    referencedColumn:
                        $$EntityTagsTableReferences._tagIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$EntityTagsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $EntityTagsTable,
    EntityTagRow,
    $$EntityTagsTableFilterComposer,
    $$EntityTagsTableOrderingComposer,
    $$EntityTagsTableAnnotationComposer,
    $$EntityTagsTableCreateCompanionBuilder,
    $$EntityTagsTableUpdateCompanionBuilder,
    (EntityTagRow, $$EntityTagsTableReferences),
    EntityTagRow,
    PrefetchHooks Function({bool entityId, bool tagId})>;
typedef $$TimelineEntriesTableCreateCompanionBuilder = TimelineEntriesCompanion
    Function({
  required String id,
  Value<String?> projectId,
  required String title,
  Value<String?> description,
  Value<String?> dateLabel,
  Value<String?> eraLabel,
  required int sortOrder,
  Value<String?> entityId,
  Value<bool> isDeleted,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<int> rowid,
});
typedef $$TimelineEntriesTableUpdateCompanionBuilder = TimelineEntriesCompanion
    Function({
  Value<String> id,
  Value<String?> projectId,
  Value<String> title,
  Value<String?> description,
  Value<String?> dateLabel,
  Value<String?> eraLabel,
  Value<int> sortOrder,
  Value<String?> entityId,
  Value<bool> isDeleted,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

final class $$TimelineEntriesTableReferences extends BaseReferences<
    _$AppDatabase, $TimelineEntriesTable, TimelineEntryRow> {
  $$TimelineEntriesTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $ProjectsTable _projectIdTable(_$AppDatabase db) =>
      db.projects.createAlias(
          $_aliasNameGenerator(db.timelineEntries.projectId, db.projects.id));

  $$ProjectsTableProcessedTableManager? get projectId {
    final $_column = $_itemColumn<String>('project_id');
    if ($_column == null) return null;
    final manager = $$ProjectsTableTableManager($_db, $_db.projects)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_projectIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $EntitiesTable _entityIdTable(_$AppDatabase db) =>
      db.entities.createAlias(
          $_aliasNameGenerator(db.timelineEntries.entityId, db.entities.id));

  $$EntitiesTableProcessedTableManager? get entityId {
    final $_column = $_itemColumn<String>('entity_id');
    if ($_column == null) return null;
    final manager = $$EntitiesTableTableManager($_db, $_db.entities)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_entityIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$TimelineEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $TimelineEntriesTable> {
  $$TimelineEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get dateLabel => $composableBuilder(
      column: $table.dateLabel, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get eraLabel => $composableBuilder(
      column: $table.eraLabel, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get sortOrder => $composableBuilder(
      column: $table.sortOrder, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isDeleted => $composableBuilder(
      column: $table.isDeleted, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  $$ProjectsTableFilterComposer get projectId {
    final $$ProjectsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.projectId,
        referencedTable: $db.projects,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ProjectsTableFilterComposer(
              $db: $db,
              $table: $db.projects,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$EntitiesTableFilterComposer get entityId {
    final $$EntitiesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.entityId,
        referencedTable: $db.entities,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$EntitiesTableFilterComposer(
              $db: $db,
              $table: $db.entities,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$TimelineEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $TimelineEntriesTable> {
  $$TimelineEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get dateLabel => $composableBuilder(
      column: $table.dateLabel, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get eraLabel => $composableBuilder(
      column: $table.eraLabel, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get sortOrder => $composableBuilder(
      column: $table.sortOrder, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isDeleted => $composableBuilder(
      column: $table.isDeleted, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  $$ProjectsTableOrderingComposer get projectId {
    final $$ProjectsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.projectId,
        referencedTable: $db.projects,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ProjectsTableOrderingComposer(
              $db: $db,
              $table: $db.projects,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$EntitiesTableOrderingComposer get entityId {
    final $$EntitiesTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.entityId,
        referencedTable: $db.entities,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$EntitiesTableOrderingComposer(
              $db: $db,
              $table: $db.entities,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$TimelineEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $TimelineEntriesTable> {
  $$TimelineEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => column);

  GeneratedColumn<String> get dateLabel =>
      $composableBuilder(column: $table.dateLabel, builder: (column) => column);

  GeneratedColumn<String> get eraLabel =>
      $composableBuilder(column: $table.eraLabel, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  GeneratedColumn<bool> get isDeleted =>
      $composableBuilder(column: $table.isDeleted, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$ProjectsTableAnnotationComposer get projectId {
    final $$ProjectsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.projectId,
        referencedTable: $db.projects,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ProjectsTableAnnotationComposer(
              $db: $db,
              $table: $db.projects,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$EntitiesTableAnnotationComposer get entityId {
    final $$EntitiesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.entityId,
        referencedTable: $db.entities,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$EntitiesTableAnnotationComposer(
              $db: $db,
              $table: $db.entities,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$TimelineEntriesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $TimelineEntriesTable,
    TimelineEntryRow,
    $$TimelineEntriesTableFilterComposer,
    $$TimelineEntriesTableOrderingComposer,
    $$TimelineEntriesTableAnnotationComposer,
    $$TimelineEntriesTableCreateCompanionBuilder,
    $$TimelineEntriesTableUpdateCompanionBuilder,
    (TimelineEntryRow, $$TimelineEntriesTableReferences),
    TimelineEntryRow,
    PrefetchHooks Function({bool projectId, bool entityId})> {
  $$TimelineEntriesTableTableManager(
      _$AppDatabase db, $TimelineEntriesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TimelineEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TimelineEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TimelineEntriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String?> projectId = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<String?> description = const Value.absent(),
            Value<String?> dateLabel = const Value.absent(),
            Value<String?> eraLabel = const Value.absent(),
            Value<int> sortOrder = const Value.absent(),
            Value<String?> entityId = const Value.absent(),
            Value<bool> isDeleted = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              TimelineEntriesCompanion(
            id: id,
            projectId: projectId,
            title: title,
            description: description,
            dateLabel: dateLabel,
            eraLabel: eraLabel,
            sortOrder: sortOrder,
            entityId: entityId,
            isDeleted: isDeleted,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            Value<String?> projectId = const Value.absent(),
            required String title,
            Value<String?> description = const Value.absent(),
            Value<String?> dateLabel = const Value.absent(),
            Value<String?> eraLabel = const Value.absent(),
            required int sortOrder,
            Value<String?> entityId = const Value.absent(),
            Value<bool> isDeleted = const Value.absent(),
            required DateTime createdAt,
            required DateTime updatedAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              TimelineEntriesCompanion.insert(
            id: id,
            projectId: projectId,
            title: title,
            description: description,
            dateLabel: dateLabel,
            eraLabel: eraLabel,
            sortOrder: sortOrder,
            entityId: entityId,
            isDeleted: isDeleted,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$TimelineEntriesTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({projectId = false, entityId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
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
                      dynamic>>(state) {
                if (projectId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.projectId,
                    referencedTable:
                        $$TimelineEntriesTableReferences._projectIdTable(db),
                    referencedColumn:
                        $$TimelineEntriesTableReferences._projectIdTable(db).id,
                  ) as T;
                }
                if (entityId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.entityId,
                    referencedTable:
                        $$TimelineEntriesTableReferences._entityIdTable(db),
                    referencedColumn:
                        $$TimelineEntriesTableReferences._entityIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$TimelineEntriesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $TimelineEntriesTable,
    TimelineEntryRow,
    $$TimelineEntriesTableFilterComposer,
    $$TimelineEntriesTableOrderingComposer,
    $$TimelineEntriesTableAnnotationComposer,
    $$TimelineEntriesTableCreateCompanionBuilder,
    $$TimelineEntriesTableUpdateCompanionBuilder,
    (TimelineEntryRow, $$TimelineEntriesTableReferences),
    TimelineEntryRow,
    PrefetchHooks Function({bool projectId, bool entityId})>;
typedef $$EntityVersionsTableCreateCompanionBuilder = EntityVersionsCompanion
    Function({
  required String id,
  required String entityId,
  required String snapshotJson,
  required DateTime changedAt,
  Value<String?> changeNote,
  Value<int> rowid,
});
typedef $$EntityVersionsTableUpdateCompanionBuilder = EntityVersionsCompanion
    Function({
  Value<String> id,
  Value<String> entityId,
  Value<String> snapshotJson,
  Value<DateTime> changedAt,
  Value<String?> changeNote,
  Value<int> rowid,
});

final class $$EntityVersionsTableReferences extends BaseReferences<
    _$AppDatabase, $EntityVersionsTable, EntityVersionRow> {
  $$EntityVersionsTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $EntitiesTable _entityIdTable(_$AppDatabase db) =>
      db.entities.createAlias(
          $_aliasNameGenerator(db.entityVersions.entityId, db.entities.id));

  $$EntitiesTableProcessedTableManager get entityId {
    final $_column = $_itemColumn<String>('entity_id')!;

    final manager = $$EntitiesTableTableManager($_db, $_db.entities)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_entityIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$EntityVersionsTableFilterComposer
    extends Composer<_$AppDatabase, $EntityVersionsTable> {
  $$EntityVersionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get snapshotJson => $composableBuilder(
      column: $table.snapshotJson, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get changedAt => $composableBuilder(
      column: $table.changedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get changeNote => $composableBuilder(
      column: $table.changeNote, builder: (column) => ColumnFilters(column));

  $$EntitiesTableFilterComposer get entityId {
    final $$EntitiesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.entityId,
        referencedTable: $db.entities,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$EntitiesTableFilterComposer(
              $db: $db,
              $table: $db.entities,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$EntityVersionsTableOrderingComposer
    extends Composer<_$AppDatabase, $EntityVersionsTable> {
  $$EntityVersionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get snapshotJson => $composableBuilder(
      column: $table.snapshotJson,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get changedAt => $composableBuilder(
      column: $table.changedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get changeNote => $composableBuilder(
      column: $table.changeNote, builder: (column) => ColumnOrderings(column));

  $$EntitiesTableOrderingComposer get entityId {
    final $$EntitiesTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.entityId,
        referencedTable: $db.entities,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$EntitiesTableOrderingComposer(
              $db: $db,
              $table: $db.entities,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$EntityVersionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $EntityVersionsTable> {
  $$EntityVersionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get snapshotJson => $composableBuilder(
      column: $table.snapshotJson, builder: (column) => column);

  GeneratedColumn<DateTime> get changedAt =>
      $composableBuilder(column: $table.changedAt, builder: (column) => column);

  GeneratedColumn<String> get changeNote => $composableBuilder(
      column: $table.changeNote, builder: (column) => column);

  $$EntitiesTableAnnotationComposer get entityId {
    final $$EntitiesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.entityId,
        referencedTable: $db.entities,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$EntitiesTableAnnotationComposer(
              $db: $db,
              $table: $db.entities,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$EntityVersionsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $EntityVersionsTable,
    EntityVersionRow,
    $$EntityVersionsTableFilterComposer,
    $$EntityVersionsTableOrderingComposer,
    $$EntityVersionsTableAnnotationComposer,
    $$EntityVersionsTableCreateCompanionBuilder,
    $$EntityVersionsTableUpdateCompanionBuilder,
    (EntityVersionRow, $$EntityVersionsTableReferences),
    EntityVersionRow,
    PrefetchHooks Function({bool entityId})> {
  $$EntityVersionsTableTableManager(
      _$AppDatabase db, $EntityVersionsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EntityVersionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$EntityVersionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$EntityVersionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> entityId = const Value.absent(),
            Value<String> snapshotJson = const Value.absent(),
            Value<DateTime> changedAt = const Value.absent(),
            Value<String?> changeNote = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              EntityVersionsCompanion(
            id: id,
            entityId: entityId,
            snapshotJson: snapshotJson,
            changedAt: changedAt,
            changeNote: changeNote,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String entityId,
            required String snapshotJson,
            required DateTime changedAt,
            Value<String?> changeNote = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              EntityVersionsCompanion.insert(
            id: id,
            entityId: entityId,
            snapshotJson: snapshotJson,
            changedAt: changedAt,
            changeNote: changeNote,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$EntityVersionsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({entityId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
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
                      dynamic>>(state) {
                if (entityId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.entityId,
                    referencedTable:
                        $$EntityVersionsTableReferences._entityIdTable(db),
                    referencedColumn:
                        $$EntityVersionsTableReferences._entityIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$EntityVersionsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $EntityVersionsTable,
    EntityVersionRow,
    $$EntityVersionsTableFilterComposer,
    $$EntityVersionsTableOrderingComposer,
    $$EntityVersionsTableAnnotationComposer,
    $$EntityVersionsTableCreateCompanionBuilder,
    $$EntityVersionsTableUpdateCompanionBuilder,
    (EntityVersionRow, $$EntityVersionsTableReferences),
    EntityVersionRow,
    PrefetchHooks Function({bool entityId})>;
typedef $$TemplatesTableCreateCompanionBuilder = TemplatesCompanion Function({
  required String id,
  required String name,
  required String entityType,
  Value<String> customFieldsSchema,
  Value<bool> isBuiltIn,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<int> rowid,
});
typedef $$TemplatesTableUpdateCompanionBuilder = TemplatesCompanion Function({
  Value<String> id,
  Value<String> name,
  Value<String> entityType,
  Value<String> customFieldsSchema,
  Value<bool> isBuiltIn,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

class $$TemplatesTableFilterComposer
    extends Composer<_$AppDatabase, $TemplatesTable> {
  $$TemplatesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get entityType => $composableBuilder(
      column: $table.entityType, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get customFieldsSchema => $composableBuilder(
      column: $table.customFieldsSchema,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isBuiltIn => $composableBuilder(
      column: $table.isBuiltIn, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$TemplatesTableOrderingComposer
    extends Composer<_$AppDatabase, $TemplatesTable> {
  $$TemplatesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get entityType => $composableBuilder(
      column: $table.entityType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get customFieldsSchema => $composableBuilder(
      column: $table.customFieldsSchema,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isBuiltIn => $composableBuilder(
      column: $table.isBuiltIn, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$TemplatesTableAnnotationComposer
    extends Composer<_$AppDatabase, $TemplatesTable> {
  $$TemplatesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get entityType => $composableBuilder(
      column: $table.entityType, builder: (column) => column);

  GeneratedColumn<String> get customFieldsSchema => $composableBuilder(
      column: $table.customFieldsSchema, builder: (column) => column);

  GeneratedColumn<bool> get isBuiltIn =>
      $composableBuilder(column: $table.isBuiltIn, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$TemplatesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $TemplatesTable,
    TemplateRow,
    $$TemplatesTableFilterComposer,
    $$TemplatesTableOrderingComposer,
    $$TemplatesTableAnnotationComposer,
    $$TemplatesTableCreateCompanionBuilder,
    $$TemplatesTableUpdateCompanionBuilder,
    (TemplateRow, BaseReferences<_$AppDatabase, $TemplatesTable, TemplateRow>),
    TemplateRow,
    PrefetchHooks Function()> {
  $$TemplatesTableTableManager(_$AppDatabase db, $TemplatesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TemplatesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TemplatesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TemplatesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> entityType = const Value.absent(),
            Value<String> customFieldsSchema = const Value.absent(),
            Value<bool> isBuiltIn = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              TemplatesCompanion(
            id: id,
            name: name,
            entityType: entityType,
            customFieldsSchema: customFieldsSchema,
            isBuiltIn: isBuiltIn,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String name,
            required String entityType,
            Value<String> customFieldsSchema = const Value.absent(),
            Value<bool> isBuiltIn = const Value.absent(),
            required DateTime createdAt,
            required DateTime updatedAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              TemplatesCompanion.insert(
            id: id,
            name: name,
            entityType: entityType,
            customFieldsSchema: customFieldsSchema,
            isBuiltIn: isBuiltIn,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$TemplatesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $TemplatesTable,
    TemplateRow,
    $$TemplatesTableFilterComposer,
    $$TemplatesTableOrderingComposer,
    $$TemplatesTableAnnotationComposer,
    $$TemplatesTableCreateCompanionBuilder,
    $$TemplatesTableUpdateCompanionBuilder,
    (TemplateRow, BaseReferences<_$AppDatabase, $TemplatesTable, TemplateRow>),
    TemplateRow,
    PrefetchHooks Function()>;
typedef $$ManuscriptChaptersTableCreateCompanionBuilder
    = ManuscriptChaptersCompanion Function({
  required String id,
  Value<String?> projectId,
  required String title,
  Value<String> content,
  Value<int> sortOrder,
  Value<String?> dateLabel,
  Value<String?> eraLabel,
  Value<String?> synopsis,
  Value<String?> povCharacterId,
  Value<String?> locationId,
  Value<String> status,
  Value<bool> isDeleted,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<int> rowid,
});
typedef $$ManuscriptChaptersTableUpdateCompanionBuilder
    = ManuscriptChaptersCompanion Function({
  Value<String> id,
  Value<String?> projectId,
  Value<String> title,
  Value<String> content,
  Value<int> sortOrder,
  Value<String?> dateLabel,
  Value<String?> eraLabel,
  Value<String?> synopsis,
  Value<String?> povCharacterId,
  Value<String?> locationId,
  Value<String> status,
  Value<bool> isDeleted,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

final class $$ManuscriptChaptersTableReferences extends BaseReferences<
    _$AppDatabase, $ManuscriptChaptersTable, ManuscriptChapterRow> {
  $$ManuscriptChaptersTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $ProjectsTable _projectIdTable(_$AppDatabase db) =>
      db.projects.createAlias($_aliasNameGenerator(
          db.manuscriptChapters.projectId, db.projects.id));

  $$ProjectsTableProcessedTableManager? get projectId {
    final $_column = $_itemColumn<String>('project_id');
    if ($_column == null) return null;
    final manager = $$ProjectsTableTableManager($_db, $_db.projects)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_projectIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static MultiTypedResultKey<$ChapterSnapshotsTable, List<ChapterSnapshotRow>>
      _chapterSnapshotsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.chapterSnapshots,
              aliasName: $_aliasNameGenerator(
                  db.manuscriptChapters.id, db.chapterSnapshots.chapterId));

  $$ChapterSnapshotsTableProcessedTableManager get chapterSnapshotsRefs {
    final manager = $$ChapterSnapshotsTableTableManager(
            $_db, $_db.chapterSnapshots)
        .filter((f) => f.chapterId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_chapterSnapshotsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$ManuscriptChaptersTableFilterComposer
    extends Composer<_$AppDatabase, $ManuscriptChaptersTable> {
  $$ManuscriptChaptersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get content => $composableBuilder(
      column: $table.content, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get sortOrder => $composableBuilder(
      column: $table.sortOrder, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get dateLabel => $composableBuilder(
      column: $table.dateLabel, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get eraLabel => $composableBuilder(
      column: $table.eraLabel, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get synopsis => $composableBuilder(
      column: $table.synopsis, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get povCharacterId => $composableBuilder(
      column: $table.povCharacterId,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get locationId => $composableBuilder(
      column: $table.locationId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isDeleted => $composableBuilder(
      column: $table.isDeleted, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  $$ProjectsTableFilterComposer get projectId {
    final $$ProjectsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.projectId,
        referencedTable: $db.projects,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ProjectsTableFilterComposer(
              $db: $db,
              $table: $db.projects,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<bool> chapterSnapshotsRefs(
      Expression<bool> Function($$ChapterSnapshotsTableFilterComposer f) f) {
    final $$ChapterSnapshotsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.chapterSnapshots,
        getReferencedColumn: (t) => t.chapterId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ChapterSnapshotsTableFilterComposer(
              $db: $db,
              $table: $db.chapterSnapshots,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$ManuscriptChaptersTableOrderingComposer
    extends Composer<_$AppDatabase, $ManuscriptChaptersTable> {
  $$ManuscriptChaptersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get content => $composableBuilder(
      column: $table.content, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get sortOrder => $composableBuilder(
      column: $table.sortOrder, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get dateLabel => $composableBuilder(
      column: $table.dateLabel, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get eraLabel => $composableBuilder(
      column: $table.eraLabel, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get synopsis => $composableBuilder(
      column: $table.synopsis, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get povCharacterId => $composableBuilder(
      column: $table.povCharacterId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get locationId => $composableBuilder(
      column: $table.locationId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isDeleted => $composableBuilder(
      column: $table.isDeleted, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  $$ProjectsTableOrderingComposer get projectId {
    final $$ProjectsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.projectId,
        referencedTable: $db.projects,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ProjectsTableOrderingComposer(
              $db: $db,
              $table: $db.projects,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ManuscriptChaptersTableAnnotationComposer
    extends Composer<_$AppDatabase, $ManuscriptChaptersTable> {
  $$ManuscriptChaptersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get content =>
      $composableBuilder(column: $table.content, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  GeneratedColumn<String> get dateLabel =>
      $composableBuilder(column: $table.dateLabel, builder: (column) => column);

  GeneratedColumn<String> get eraLabel =>
      $composableBuilder(column: $table.eraLabel, builder: (column) => column);

  GeneratedColumn<String> get synopsis =>
      $composableBuilder(column: $table.synopsis, builder: (column) => column);

  GeneratedColumn<String> get povCharacterId => $composableBuilder(
      column: $table.povCharacterId, builder: (column) => column);

  GeneratedColumn<String> get locationId => $composableBuilder(
      column: $table.locationId, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<bool> get isDeleted =>
      $composableBuilder(column: $table.isDeleted, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$ProjectsTableAnnotationComposer get projectId {
    final $$ProjectsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.projectId,
        referencedTable: $db.projects,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ProjectsTableAnnotationComposer(
              $db: $db,
              $table: $db.projects,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<T> chapterSnapshotsRefs<T extends Object>(
      Expression<T> Function($$ChapterSnapshotsTableAnnotationComposer a) f) {
    final $$ChapterSnapshotsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.chapterSnapshots,
        getReferencedColumn: (t) => t.chapterId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ChapterSnapshotsTableAnnotationComposer(
              $db: $db,
              $table: $db.chapterSnapshots,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$ManuscriptChaptersTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ManuscriptChaptersTable,
    ManuscriptChapterRow,
    $$ManuscriptChaptersTableFilterComposer,
    $$ManuscriptChaptersTableOrderingComposer,
    $$ManuscriptChaptersTableAnnotationComposer,
    $$ManuscriptChaptersTableCreateCompanionBuilder,
    $$ManuscriptChaptersTableUpdateCompanionBuilder,
    (ManuscriptChapterRow, $$ManuscriptChaptersTableReferences),
    ManuscriptChapterRow,
    PrefetchHooks Function({bool projectId, bool chapterSnapshotsRefs})> {
  $$ManuscriptChaptersTableTableManager(
      _$AppDatabase db, $ManuscriptChaptersTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ManuscriptChaptersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ManuscriptChaptersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ManuscriptChaptersTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String?> projectId = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<String> content = const Value.absent(),
            Value<int> sortOrder = const Value.absent(),
            Value<String?> dateLabel = const Value.absent(),
            Value<String?> eraLabel = const Value.absent(),
            Value<String?> synopsis = const Value.absent(),
            Value<String?> povCharacterId = const Value.absent(),
            Value<String?> locationId = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<bool> isDeleted = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ManuscriptChaptersCompanion(
            id: id,
            projectId: projectId,
            title: title,
            content: content,
            sortOrder: sortOrder,
            dateLabel: dateLabel,
            eraLabel: eraLabel,
            synopsis: synopsis,
            povCharacterId: povCharacterId,
            locationId: locationId,
            status: status,
            isDeleted: isDeleted,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            Value<String?> projectId = const Value.absent(),
            required String title,
            Value<String> content = const Value.absent(),
            Value<int> sortOrder = const Value.absent(),
            Value<String?> dateLabel = const Value.absent(),
            Value<String?> eraLabel = const Value.absent(),
            Value<String?> synopsis = const Value.absent(),
            Value<String?> povCharacterId = const Value.absent(),
            Value<String?> locationId = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<bool> isDeleted = const Value.absent(),
            required DateTime createdAt,
            required DateTime updatedAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              ManuscriptChaptersCompanion.insert(
            id: id,
            projectId: projectId,
            title: title,
            content: content,
            sortOrder: sortOrder,
            dateLabel: dateLabel,
            eraLabel: eraLabel,
            synopsis: synopsis,
            povCharacterId: povCharacterId,
            locationId: locationId,
            status: status,
            isDeleted: isDeleted,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$ManuscriptChaptersTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {projectId = false, chapterSnapshotsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (chapterSnapshotsRefs) db.chapterSnapshots
              ],
              addJoins: <
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
                      dynamic>>(state) {
                if (projectId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.projectId,
                    referencedTable:
                        $$ManuscriptChaptersTableReferences._projectIdTable(db),
                    referencedColumn: $$ManuscriptChaptersTableReferences
                        ._projectIdTable(db)
                        .id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (chapterSnapshotsRefs)
                    await $_getPrefetchedData<ManuscriptChapterRow,
                            $ManuscriptChaptersTable, ChapterSnapshotRow>(
                        currentTable: table,
                        referencedTable: $$ManuscriptChaptersTableReferences
                            ._chapterSnapshotsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$ManuscriptChaptersTableReferences(db, table, p0)
                                .chapterSnapshotsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.chapterId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$ManuscriptChaptersTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ManuscriptChaptersTable,
    ManuscriptChapterRow,
    $$ManuscriptChaptersTableFilterComposer,
    $$ManuscriptChaptersTableOrderingComposer,
    $$ManuscriptChaptersTableAnnotationComposer,
    $$ManuscriptChaptersTableCreateCompanionBuilder,
    $$ManuscriptChaptersTableUpdateCompanionBuilder,
    (ManuscriptChapterRow, $$ManuscriptChaptersTableReferences),
    ManuscriptChapterRow,
    PrefetchHooks Function({bool projectId, bool chapterSnapshotsRefs})>;
typedef $$ChapterSnapshotsTableCreateCompanionBuilder
    = ChapterSnapshotsCompanion Function({
  required String id,
  required String chapterId,
  required String content,
  required DateTime createdAt,
  Value<int> rowid,
});
typedef $$ChapterSnapshotsTableUpdateCompanionBuilder
    = ChapterSnapshotsCompanion Function({
  Value<String> id,
  Value<String> chapterId,
  Value<String> content,
  Value<DateTime> createdAt,
  Value<int> rowid,
});

final class $$ChapterSnapshotsTableReferences extends BaseReferences<
    _$AppDatabase, $ChapterSnapshotsTable, ChapterSnapshotRow> {
  $$ChapterSnapshotsTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $ManuscriptChaptersTable _chapterIdTable(_$AppDatabase db) =>
      db.manuscriptChapters.createAlias($_aliasNameGenerator(
          db.chapterSnapshots.chapterId, db.manuscriptChapters.id));

  $$ManuscriptChaptersTableProcessedTableManager get chapterId {
    final $_column = $_itemColumn<String>('chapter_id')!;

    final manager =
        $$ManuscriptChaptersTableTableManager($_db, $_db.manuscriptChapters)
            .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_chapterIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$ChapterSnapshotsTableFilterComposer
    extends Composer<_$AppDatabase, $ChapterSnapshotsTable> {
  $$ChapterSnapshotsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get content => $composableBuilder(
      column: $table.content, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  $$ManuscriptChaptersTableFilterComposer get chapterId {
    final $$ManuscriptChaptersTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.chapterId,
        referencedTable: $db.manuscriptChapters,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ManuscriptChaptersTableFilterComposer(
              $db: $db,
              $table: $db.manuscriptChapters,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ChapterSnapshotsTableOrderingComposer
    extends Composer<_$AppDatabase, $ChapterSnapshotsTable> {
  $$ChapterSnapshotsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get content => $composableBuilder(
      column: $table.content, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  $$ManuscriptChaptersTableOrderingComposer get chapterId {
    final $$ManuscriptChaptersTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.chapterId,
        referencedTable: $db.manuscriptChapters,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ManuscriptChaptersTableOrderingComposer(
              $db: $db,
              $table: $db.manuscriptChapters,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ChapterSnapshotsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ChapterSnapshotsTable> {
  $$ChapterSnapshotsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get content =>
      $composableBuilder(column: $table.content, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$ManuscriptChaptersTableAnnotationComposer get chapterId {
    final $$ManuscriptChaptersTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.chapterId,
            referencedTable: $db.manuscriptChapters,
            getReferencedColumn: (t) => t.id,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$ManuscriptChaptersTableAnnotationComposer(
                  $db: $db,
                  $table: $db.manuscriptChapters,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return composer;
  }
}

class $$ChapterSnapshotsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ChapterSnapshotsTable,
    ChapterSnapshotRow,
    $$ChapterSnapshotsTableFilterComposer,
    $$ChapterSnapshotsTableOrderingComposer,
    $$ChapterSnapshotsTableAnnotationComposer,
    $$ChapterSnapshotsTableCreateCompanionBuilder,
    $$ChapterSnapshotsTableUpdateCompanionBuilder,
    (ChapterSnapshotRow, $$ChapterSnapshotsTableReferences),
    ChapterSnapshotRow,
    PrefetchHooks Function({bool chapterId})> {
  $$ChapterSnapshotsTableTableManager(
      _$AppDatabase db, $ChapterSnapshotsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ChapterSnapshotsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ChapterSnapshotsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ChapterSnapshotsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> chapterId = const Value.absent(),
            Value<String> content = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ChapterSnapshotsCompanion(
            id: id,
            chapterId: chapterId,
            content: content,
            createdAt: createdAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String chapterId,
            required String content,
            required DateTime createdAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              ChapterSnapshotsCompanion.insert(
            id: id,
            chapterId: chapterId,
            content: content,
            createdAt: createdAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$ChapterSnapshotsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({chapterId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
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
                      dynamic>>(state) {
                if (chapterId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.chapterId,
                    referencedTable:
                        $$ChapterSnapshotsTableReferences._chapterIdTable(db),
                    referencedColumn: $$ChapterSnapshotsTableReferences
                        ._chapterIdTable(db)
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
        ));
}

typedef $$ChapterSnapshotsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ChapterSnapshotsTable,
    ChapterSnapshotRow,
    $$ChapterSnapshotsTableFilterComposer,
    $$ChapterSnapshotsTableOrderingComposer,
    $$ChapterSnapshotsTableAnnotationComposer,
    $$ChapterSnapshotsTableCreateCompanionBuilder,
    $$ChapterSnapshotsTableUpdateCompanionBuilder,
    (ChapterSnapshotRow, $$ChapterSnapshotsTableReferences),
    ChapterSnapshotRow,
    PrefetchHooks Function({bool chapterId})>;
typedef $$PlotCardsTableCreateCompanionBuilder = PlotCardsCompanion Function({
  required String id,
  Value<String?> projectId,
  required String title,
  Value<String?> summary,
  required double xPosition,
  required double yPosition,
  Value<int> colorHex,
  Value<bool> isDeleted,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<int> rowid,
});
typedef $$PlotCardsTableUpdateCompanionBuilder = PlotCardsCompanion Function({
  Value<String> id,
  Value<String?> projectId,
  Value<String> title,
  Value<String?> summary,
  Value<double> xPosition,
  Value<double> yPosition,
  Value<int> colorHex,
  Value<bool> isDeleted,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

final class $$PlotCardsTableReferences
    extends BaseReferences<_$AppDatabase, $PlotCardsTable, PlotCardRow> {
  $$PlotCardsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ProjectsTable _projectIdTable(_$AppDatabase db) =>
      db.projects.createAlias(
          $_aliasNameGenerator(db.plotCards.projectId, db.projects.id));

  $$ProjectsTableProcessedTableManager? get projectId {
    final $_column = $_itemColumn<String>('project_id');
    if ($_column == null) return null;
    final manager = $$ProjectsTableTableManager($_db, $_db.projects)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_projectIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$PlotCardsTableFilterComposer
    extends Composer<_$AppDatabase, $PlotCardsTable> {
  $$PlotCardsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get summary => $composableBuilder(
      column: $table.summary, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get xPosition => $composableBuilder(
      column: $table.xPosition, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get yPosition => $composableBuilder(
      column: $table.yPosition, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get colorHex => $composableBuilder(
      column: $table.colorHex, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isDeleted => $composableBuilder(
      column: $table.isDeleted, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  $$ProjectsTableFilterComposer get projectId {
    final $$ProjectsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.projectId,
        referencedTable: $db.projects,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ProjectsTableFilterComposer(
              $db: $db,
              $table: $db.projects,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$PlotCardsTableOrderingComposer
    extends Composer<_$AppDatabase, $PlotCardsTable> {
  $$PlotCardsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get summary => $composableBuilder(
      column: $table.summary, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get xPosition => $composableBuilder(
      column: $table.xPosition, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get yPosition => $composableBuilder(
      column: $table.yPosition, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get colorHex => $composableBuilder(
      column: $table.colorHex, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isDeleted => $composableBuilder(
      column: $table.isDeleted, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  $$ProjectsTableOrderingComposer get projectId {
    final $$ProjectsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.projectId,
        referencedTable: $db.projects,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ProjectsTableOrderingComposer(
              $db: $db,
              $table: $db.projects,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$PlotCardsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PlotCardsTable> {
  $$PlotCardsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get summary =>
      $composableBuilder(column: $table.summary, builder: (column) => column);

  GeneratedColumn<double> get xPosition =>
      $composableBuilder(column: $table.xPosition, builder: (column) => column);

  GeneratedColumn<double> get yPosition =>
      $composableBuilder(column: $table.yPosition, builder: (column) => column);

  GeneratedColumn<int> get colorHex =>
      $composableBuilder(column: $table.colorHex, builder: (column) => column);

  GeneratedColumn<bool> get isDeleted =>
      $composableBuilder(column: $table.isDeleted, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$ProjectsTableAnnotationComposer get projectId {
    final $$ProjectsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.projectId,
        referencedTable: $db.projects,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ProjectsTableAnnotationComposer(
              $db: $db,
              $table: $db.projects,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$PlotCardsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $PlotCardsTable,
    PlotCardRow,
    $$PlotCardsTableFilterComposer,
    $$PlotCardsTableOrderingComposer,
    $$PlotCardsTableAnnotationComposer,
    $$PlotCardsTableCreateCompanionBuilder,
    $$PlotCardsTableUpdateCompanionBuilder,
    (PlotCardRow, $$PlotCardsTableReferences),
    PlotCardRow,
    PrefetchHooks Function({bool projectId})> {
  $$PlotCardsTableTableManager(_$AppDatabase db, $PlotCardsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PlotCardsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PlotCardsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PlotCardsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String?> projectId = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<String?> summary = const Value.absent(),
            Value<double> xPosition = const Value.absent(),
            Value<double> yPosition = const Value.absent(),
            Value<int> colorHex = const Value.absent(),
            Value<bool> isDeleted = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              PlotCardsCompanion(
            id: id,
            projectId: projectId,
            title: title,
            summary: summary,
            xPosition: xPosition,
            yPosition: yPosition,
            colorHex: colorHex,
            isDeleted: isDeleted,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            Value<String?> projectId = const Value.absent(),
            required String title,
            Value<String?> summary = const Value.absent(),
            required double xPosition,
            required double yPosition,
            Value<int> colorHex = const Value.absent(),
            Value<bool> isDeleted = const Value.absent(),
            required DateTime createdAt,
            required DateTime updatedAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              PlotCardsCompanion.insert(
            id: id,
            projectId: projectId,
            title: title,
            summary: summary,
            xPosition: xPosition,
            yPosition: yPosition,
            colorHex: colorHex,
            isDeleted: isDeleted,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$PlotCardsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({projectId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
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
                      dynamic>>(state) {
                if (projectId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.projectId,
                    referencedTable:
                        $$PlotCardsTableReferences._projectIdTable(db),
                    referencedColumn:
                        $$PlotCardsTableReferences._projectIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$PlotCardsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $PlotCardsTable,
    PlotCardRow,
    $$PlotCardsTableFilterComposer,
    $$PlotCardsTableOrderingComposer,
    $$PlotCardsTableAnnotationComposer,
    $$PlotCardsTableCreateCompanionBuilder,
    $$PlotCardsTableUpdateCompanionBuilder,
    (PlotCardRow, $$PlotCardsTableReferences),
    PlotCardRow,
    PrefetchHooks Function({bool projectId})>;
typedef $$PlotConnectionsTableCreateCompanionBuilder = PlotConnectionsCompanion
    Function({
  required String id,
  Value<String?> projectId,
  required String sourceId,
  required String targetId,
  Value<String?> label,
  Value<bool> isDeleted,
  required DateTime createdAt,
  Value<int> rowid,
});
typedef $$PlotConnectionsTableUpdateCompanionBuilder = PlotConnectionsCompanion
    Function({
  Value<String> id,
  Value<String?> projectId,
  Value<String> sourceId,
  Value<String> targetId,
  Value<String?> label,
  Value<bool> isDeleted,
  Value<DateTime> createdAt,
  Value<int> rowid,
});

final class $$PlotConnectionsTableReferences extends BaseReferences<
    _$AppDatabase, $PlotConnectionsTable, PlotConnectionRow> {
  $$PlotConnectionsTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $ProjectsTable _projectIdTable(_$AppDatabase db) =>
      db.projects.createAlias(
          $_aliasNameGenerator(db.plotConnections.projectId, db.projects.id));

  $$ProjectsTableProcessedTableManager? get projectId {
    final $_column = $_itemColumn<String>('project_id');
    if ($_column == null) return null;
    final manager = $$ProjectsTableTableManager($_db, $_db.projects)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_projectIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$PlotConnectionsTableFilterComposer
    extends Composer<_$AppDatabase, $PlotConnectionsTable> {
  $$PlotConnectionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get sourceId => $composableBuilder(
      column: $table.sourceId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get targetId => $composableBuilder(
      column: $table.targetId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get label => $composableBuilder(
      column: $table.label, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isDeleted => $composableBuilder(
      column: $table.isDeleted, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  $$ProjectsTableFilterComposer get projectId {
    final $$ProjectsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.projectId,
        referencedTable: $db.projects,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ProjectsTableFilterComposer(
              $db: $db,
              $table: $db.projects,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$PlotConnectionsTableOrderingComposer
    extends Composer<_$AppDatabase, $PlotConnectionsTable> {
  $$PlotConnectionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get sourceId => $composableBuilder(
      column: $table.sourceId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get targetId => $composableBuilder(
      column: $table.targetId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get label => $composableBuilder(
      column: $table.label, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isDeleted => $composableBuilder(
      column: $table.isDeleted, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  $$ProjectsTableOrderingComposer get projectId {
    final $$ProjectsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.projectId,
        referencedTable: $db.projects,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ProjectsTableOrderingComposer(
              $db: $db,
              $table: $db.projects,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$PlotConnectionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PlotConnectionsTable> {
  $$PlotConnectionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get sourceId =>
      $composableBuilder(column: $table.sourceId, builder: (column) => column);

  GeneratedColumn<String> get targetId =>
      $composableBuilder(column: $table.targetId, builder: (column) => column);

  GeneratedColumn<String> get label =>
      $composableBuilder(column: $table.label, builder: (column) => column);

  GeneratedColumn<bool> get isDeleted =>
      $composableBuilder(column: $table.isDeleted, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$ProjectsTableAnnotationComposer get projectId {
    final $$ProjectsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.projectId,
        referencedTable: $db.projects,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ProjectsTableAnnotationComposer(
              $db: $db,
              $table: $db.projects,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$PlotConnectionsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $PlotConnectionsTable,
    PlotConnectionRow,
    $$PlotConnectionsTableFilterComposer,
    $$PlotConnectionsTableOrderingComposer,
    $$PlotConnectionsTableAnnotationComposer,
    $$PlotConnectionsTableCreateCompanionBuilder,
    $$PlotConnectionsTableUpdateCompanionBuilder,
    (PlotConnectionRow, $$PlotConnectionsTableReferences),
    PlotConnectionRow,
    PrefetchHooks Function({bool projectId})> {
  $$PlotConnectionsTableTableManager(
      _$AppDatabase db, $PlotConnectionsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PlotConnectionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PlotConnectionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PlotConnectionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String?> projectId = const Value.absent(),
            Value<String> sourceId = const Value.absent(),
            Value<String> targetId = const Value.absent(),
            Value<String?> label = const Value.absent(),
            Value<bool> isDeleted = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              PlotConnectionsCompanion(
            id: id,
            projectId: projectId,
            sourceId: sourceId,
            targetId: targetId,
            label: label,
            isDeleted: isDeleted,
            createdAt: createdAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            Value<String?> projectId = const Value.absent(),
            required String sourceId,
            required String targetId,
            Value<String?> label = const Value.absent(),
            Value<bool> isDeleted = const Value.absent(),
            required DateTime createdAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              PlotConnectionsCompanion.insert(
            id: id,
            projectId: projectId,
            sourceId: sourceId,
            targetId: targetId,
            label: label,
            isDeleted: isDeleted,
            createdAt: createdAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$PlotConnectionsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({projectId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
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
                      dynamic>>(state) {
                if (projectId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.projectId,
                    referencedTable:
                        $$PlotConnectionsTableReferences._projectIdTable(db),
                    referencedColumn:
                        $$PlotConnectionsTableReferences._projectIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$PlotConnectionsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $PlotConnectionsTable,
    PlotConnectionRow,
    $$PlotConnectionsTableFilterComposer,
    $$PlotConnectionsTableOrderingComposer,
    $$PlotConnectionsTableAnnotationComposer,
    $$PlotConnectionsTableCreateCompanionBuilder,
    $$PlotConnectionsTableUpdateCompanionBuilder,
    (PlotConnectionRow, $$PlotConnectionsTableReferences),
    PlotConnectionRow,
    PrefetchHooks Function({bool projectId})>;
typedef $$WorldMapsTableCreateCompanionBuilder = WorldMapsCompanion Function({
  required String id,
  Value<String?> projectId,
  required String name,
  required String imagePath,
  Value<int> rowid,
});
typedef $$WorldMapsTableUpdateCompanionBuilder = WorldMapsCompanion Function({
  Value<String> id,
  Value<String?> projectId,
  Value<String> name,
  Value<String> imagePath,
  Value<int> rowid,
});

final class $$WorldMapsTableReferences
    extends BaseReferences<_$AppDatabase, $WorldMapsTable, WorldMapRow> {
  $$WorldMapsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ProjectsTable _projectIdTable(_$AppDatabase db) =>
      db.projects.createAlias(
          $_aliasNameGenerator(db.worldMaps.projectId, db.projects.id));

  $$ProjectsTableProcessedTableManager? get projectId {
    final $_column = $_itemColumn<String>('project_id');
    if ($_column == null) return null;
    final manager = $$ProjectsTableTableManager($_db, $_db.projects)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_projectIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static MultiTypedResultKey<$MapPinsTable, List<MapPinRow>> _mapPinsRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.mapPins,
          aliasName: $_aliasNameGenerator(db.worldMaps.id, db.mapPins.mapId));

  $$MapPinsTableProcessedTableManager get mapPinsRefs {
    final manager = $$MapPinsTableTableManager($_db, $_db.mapPins)
        .filter((f) => f.mapId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_mapPinsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$WorldMapsTableFilterComposer
    extends Composer<_$AppDatabase, $WorldMapsTable> {
  $$WorldMapsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get imagePath => $composableBuilder(
      column: $table.imagePath, builder: (column) => ColumnFilters(column));

  $$ProjectsTableFilterComposer get projectId {
    final $$ProjectsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.projectId,
        referencedTable: $db.projects,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ProjectsTableFilterComposer(
              $db: $db,
              $table: $db.projects,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<bool> mapPinsRefs(
      Expression<bool> Function($$MapPinsTableFilterComposer f) f) {
    final $$MapPinsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.mapPins,
        getReferencedColumn: (t) => t.mapId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MapPinsTableFilterComposer(
              $db: $db,
              $table: $db.mapPins,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$WorldMapsTableOrderingComposer
    extends Composer<_$AppDatabase, $WorldMapsTable> {
  $$WorldMapsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get imagePath => $composableBuilder(
      column: $table.imagePath, builder: (column) => ColumnOrderings(column));

  $$ProjectsTableOrderingComposer get projectId {
    final $$ProjectsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.projectId,
        referencedTable: $db.projects,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ProjectsTableOrderingComposer(
              $db: $db,
              $table: $db.projects,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$WorldMapsTableAnnotationComposer
    extends Composer<_$AppDatabase, $WorldMapsTable> {
  $$WorldMapsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get imagePath =>
      $composableBuilder(column: $table.imagePath, builder: (column) => column);

  $$ProjectsTableAnnotationComposer get projectId {
    final $$ProjectsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.projectId,
        referencedTable: $db.projects,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ProjectsTableAnnotationComposer(
              $db: $db,
              $table: $db.projects,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<T> mapPinsRefs<T extends Object>(
      Expression<T> Function($$MapPinsTableAnnotationComposer a) f) {
    final $$MapPinsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.mapPins,
        getReferencedColumn: (t) => t.mapId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MapPinsTableAnnotationComposer(
              $db: $db,
              $table: $db.mapPins,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$WorldMapsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $WorldMapsTable,
    WorldMapRow,
    $$WorldMapsTableFilterComposer,
    $$WorldMapsTableOrderingComposer,
    $$WorldMapsTableAnnotationComposer,
    $$WorldMapsTableCreateCompanionBuilder,
    $$WorldMapsTableUpdateCompanionBuilder,
    (WorldMapRow, $$WorldMapsTableReferences),
    WorldMapRow,
    PrefetchHooks Function({bool projectId, bool mapPinsRefs})> {
  $$WorldMapsTableTableManager(_$AppDatabase db, $WorldMapsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WorldMapsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WorldMapsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WorldMapsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String?> projectId = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> imagePath = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              WorldMapsCompanion(
            id: id,
            projectId: projectId,
            name: name,
            imagePath: imagePath,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            Value<String?> projectId = const Value.absent(),
            required String name,
            required String imagePath,
            Value<int> rowid = const Value.absent(),
          }) =>
              WorldMapsCompanion.insert(
            id: id,
            projectId: projectId,
            name: name,
            imagePath: imagePath,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$WorldMapsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({projectId = false, mapPinsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (mapPinsRefs) db.mapPins],
              addJoins: <
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
                      dynamic>>(state) {
                if (projectId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.projectId,
                    referencedTable:
                        $$WorldMapsTableReferences._projectIdTable(db),
                    referencedColumn:
                        $$WorldMapsTableReferences._projectIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (mapPinsRefs)
                    await $_getPrefetchedData<WorldMapRow, $WorldMapsTable,
                            MapPinRow>(
                        currentTable: table,
                        referencedTable:
                            $$WorldMapsTableReferences._mapPinsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$WorldMapsTableReferences(db, table, p0)
                                .mapPinsRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.mapId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$WorldMapsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $WorldMapsTable,
    WorldMapRow,
    $$WorldMapsTableFilterComposer,
    $$WorldMapsTableOrderingComposer,
    $$WorldMapsTableAnnotationComposer,
    $$WorldMapsTableCreateCompanionBuilder,
    $$WorldMapsTableUpdateCompanionBuilder,
    (WorldMapRow, $$WorldMapsTableReferences),
    WorldMapRow,
    PrefetchHooks Function({bool projectId, bool mapPinsRefs})>;
typedef $$MapPinsTableCreateCompanionBuilder = MapPinsCompanion Function({
  required String id,
  required String mapId,
  required String entityId,
  required double xPercent,
  required double yPercent,
  Value<String?> label,
  Value<int> rowid,
});
typedef $$MapPinsTableUpdateCompanionBuilder = MapPinsCompanion Function({
  Value<String> id,
  Value<String> mapId,
  Value<String> entityId,
  Value<double> xPercent,
  Value<double> yPercent,
  Value<String?> label,
  Value<int> rowid,
});

final class $$MapPinsTableReferences
    extends BaseReferences<_$AppDatabase, $MapPinsTable, MapPinRow> {
  $$MapPinsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $WorldMapsTable _mapIdTable(_$AppDatabase db) => db.worldMaps
      .createAlias($_aliasNameGenerator(db.mapPins.mapId, db.worldMaps.id));

  $$WorldMapsTableProcessedTableManager get mapId {
    final $_column = $_itemColumn<String>('map_id')!;

    final manager = $$WorldMapsTableTableManager($_db, $_db.worldMaps)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_mapIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $EntitiesTable _entityIdTable(_$AppDatabase db) => db.entities
      .createAlias($_aliasNameGenerator(db.mapPins.entityId, db.entities.id));

  $$EntitiesTableProcessedTableManager get entityId {
    final $_column = $_itemColumn<String>('entity_id')!;

    final manager = $$EntitiesTableTableManager($_db, $_db.entities)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_entityIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$MapPinsTableFilterComposer
    extends Composer<_$AppDatabase, $MapPinsTable> {
  $$MapPinsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get xPercent => $composableBuilder(
      column: $table.xPercent, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get yPercent => $composableBuilder(
      column: $table.yPercent, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get label => $composableBuilder(
      column: $table.label, builder: (column) => ColumnFilters(column));

  $$WorldMapsTableFilterComposer get mapId {
    final $$WorldMapsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.mapId,
        referencedTable: $db.worldMaps,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$WorldMapsTableFilterComposer(
              $db: $db,
              $table: $db.worldMaps,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$EntitiesTableFilterComposer get entityId {
    final $$EntitiesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.entityId,
        referencedTable: $db.entities,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$EntitiesTableFilterComposer(
              $db: $db,
              $table: $db.entities,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$MapPinsTableOrderingComposer
    extends Composer<_$AppDatabase, $MapPinsTable> {
  $$MapPinsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get xPercent => $composableBuilder(
      column: $table.xPercent, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get yPercent => $composableBuilder(
      column: $table.yPercent, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get label => $composableBuilder(
      column: $table.label, builder: (column) => ColumnOrderings(column));

  $$WorldMapsTableOrderingComposer get mapId {
    final $$WorldMapsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.mapId,
        referencedTable: $db.worldMaps,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$WorldMapsTableOrderingComposer(
              $db: $db,
              $table: $db.worldMaps,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$EntitiesTableOrderingComposer get entityId {
    final $$EntitiesTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.entityId,
        referencedTable: $db.entities,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$EntitiesTableOrderingComposer(
              $db: $db,
              $table: $db.entities,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$MapPinsTableAnnotationComposer
    extends Composer<_$AppDatabase, $MapPinsTable> {
  $$MapPinsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<double> get xPercent =>
      $composableBuilder(column: $table.xPercent, builder: (column) => column);

  GeneratedColumn<double> get yPercent =>
      $composableBuilder(column: $table.yPercent, builder: (column) => column);

  GeneratedColumn<String> get label =>
      $composableBuilder(column: $table.label, builder: (column) => column);

  $$WorldMapsTableAnnotationComposer get mapId {
    final $$WorldMapsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.mapId,
        referencedTable: $db.worldMaps,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$WorldMapsTableAnnotationComposer(
              $db: $db,
              $table: $db.worldMaps,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$EntitiesTableAnnotationComposer get entityId {
    final $$EntitiesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.entityId,
        referencedTable: $db.entities,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$EntitiesTableAnnotationComposer(
              $db: $db,
              $table: $db.entities,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$MapPinsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $MapPinsTable,
    MapPinRow,
    $$MapPinsTableFilterComposer,
    $$MapPinsTableOrderingComposer,
    $$MapPinsTableAnnotationComposer,
    $$MapPinsTableCreateCompanionBuilder,
    $$MapPinsTableUpdateCompanionBuilder,
    (MapPinRow, $$MapPinsTableReferences),
    MapPinRow,
    PrefetchHooks Function({bool mapId, bool entityId})> {
  $$MapPinsTableTableManager(_$AppDatabase db, $MapPinsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MapPinsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MapPinsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MapPinsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> mapId = const Value.absent(),
            Value<String> entityId = const Value.absent(),
            Value<double> xPercent = const Value.absent(),
            Value<double> yPercent = const Value.absent(),
            Value<String?> label = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              MapPinsCompanion(
            id: id,
            mapId: mapId,
            entityId: entityId,
            xPercent: xPercent,
            yPercent: yPercent,
            label: label,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String mapId,
            required String entityId,
            required double xPercent,
            required double yPercent,
            Value<String?> label = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              MapPinsCompanion.insert(
            id: id,
            mapId: mapId,
            entityId: entityId,
            xPercent: xPercent,
            yPercent: yPercent,
            label: label,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$MapPinsTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: ({mapId = false, entityId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
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
                      dynamic>>(state) {
                if (mapId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.mapId,
                    referencedTable: $$MapPinsTableReferences._mapIdTable(db),
                    referencedColumn:
                        $$MapPinsTableReferences._mapIdTable(db).id,
                  ) as T;
                }
                if (entityId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.entityId,
                    referencedTable:
                        $$MapPinsTableReferences._entityIdTable(db),
                    referencedColumn:
                        $$MapPinsTableReferences._entityIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$MapPinsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $MapPinsTable,
    MapPinRow,
    $$MapPinsTableFilterComposer,
    $$MapPinsTableOrderingComposer,
    $$MapPinsTableAnnotationComposer,
    $$MapPinsTableCreateCompanionBuilder,
    $$MapPinsTableUpdateCompanionBuilder,
    (MapPinRow, $$MapPinsTableReferences),
    MapPinRow,
    PrefetchHooks Function({bool mapId, bool entityId})>;
typedef $$SetupPayoffsTableCreateCompanionBuilder = SetupPayoffsCompanion
    Function({
  required String id,
  Value<String?> projectId,
  required String setupChapterId,
  required String setupDescription,
  Value<String?> payoffChapterId,
  Value<String?> payoffDescription,
  Value<String?> entityId,
  Value<bool> isResolved,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<int> rowid,
});
typedef $$SetupPayoffsTableUpdateCompanionBuilder = SetupPayoffsCompanion
    Function({
  Value<String> id,
  Value<String?> projectId,
  Value<String> setupChapterId,
  Value<String> setupDescription,
  Value<String?> payoffChapterId,
  Value<String?> payoffDescription,
  Value<String?> entityId,
  Value<bool> isResolved,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

final class $$SetupPayoffsTableReferences
    extends BaseReferences<_$AppDatabase, $SetupPayoffsTable, SetupPayoffRow> {
  $$SetupPayoffsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ProjectsTable _projectIdTable(_$AppDatabase db) =>
      db.projects.createAlias(
          $_aliasNameGenerator(db.setupPayoffs.projectId, db.projects.id));

  $$ProjectsTableProcessedTableManager? get projectId {
    final $_column = $_itemColumn<String>('project_id');
    if ($_column == null) return null;
    final manager = $$ProjectsTableTableManager($_db, $_db.projects)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_projectIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$SetupPayoffsTableFilterComposer
    extends Composer<_$AppDatabase, $SetupPayoffsTable> {
  $$SetupPayoffsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get setupChapterId => $composableBuilder(
      column: $table.setupChapterId,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get setupDescription => $composableBuilder(
      column: $table.setupDescription,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get payoffChapterId => $composableBuilder(
      column: $table.payoffChapterId,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get payoffDescription => $composableBuilder(
      column: $table.payoffDescription,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get entityId => $composableBuilder(
      column: $table.entityId, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isResolved => $composableBuilder(
      column: $table.isResolved, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  $$ProjectsTableFilterComposer get projectId {
    final $$ProjectsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.projectId,
        referencedTable: $db.projects,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ProjectsTableFilterComposer(
              $db: $db,
              $table: $db.projects,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$SetupPayoffsTableOrderingComposer
    extends Composer<_$AppDatabase, $SetupPayoffsTable> {
  $$SetupPayoffsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get setupChapterId => $composableBuilder(
      column: $table.setupChapterId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get setupDescription => $composableBuilder(
      column: $table.setupDescription,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get payoffChapterId => $composableBuilder(
      column: $table.payoffChapterId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get payoffDescription => $composableBuilder(
      column: $table.payoffDescription,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get entityId => $composableBuilder(
      column: $table.entityId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isResolved => $composableBuilder(
      column: $table.isResolved, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  $$ProjectsTableOrderingComposer get projectId {
    final $$ProjectsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.projectId,
        referencedTable: $db.projects,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ProjectsTableOrderingComposer(
              $db: $db,
              $table: $db.projects,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$SetupPayoffsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SetupPayoffsTable> {
  $$SetupPayoffsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get setupChapterId => $composableBuilder(
      column: $table.setupChapterId, builder: (column) => column);

  GeneratedColumn<String> get setupDescription => $composableBuilder(
      column: $table.setupDescription, builder: (column) => column);

  GeneratedColumn<String> get payoffChapterId => $composableBuilder(
      column: $table.payoffChapterId, builder: (column) => column);

  GeneratedColumn<String> get payoffDescription => $composableBuilder(
      column: $table.payoffDescription, builder: (column) => column);

  GeneratedColumn<String> get entityId =>
      $composableBuilder(column: $table.entityId, builder: (column) => column);

  GeneratedColumn<bool> get isResolved => $composableBuilder(
      column: $table.isResolved, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$ProjectsTableAnnotationComposer get projectId {
    final $$ProjectsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.projectId,
        referencedTable: $db.projects,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ProjectsTableAnnotationComposer(
              $db: $db,
              $table: $db.projects,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$SetupPayoffsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SetupPayoffsTable,
    SetupPayoffRow,
    $$SetupPayoffsTableFilterComposer,
    $$SetupPayoffsTableOrderingComposer,
    $$SetupPayoffsTableAnnotationComposer,
    $$SetupPayoffsTableCreateCompanionBuilder,
    $$SetupPayoffsTableUpdateCompanionBuilder,
    (SetupPayoffRow, $$SetupPayoffsTableReferences),
    SetupPayoffRow,
    PrefetchHooks Function({bool projectId})> {
  $$SetupPayoffsTableTableManager(_$AppDatabase db, $SetupPayoffsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SetupPayoffsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SetupPayoffsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SetupPayoffsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String?> projectId = const Value.absent(),
            Value<String> setupChapterId = const Value.absent(),
            Value<String> setupDescription = const Value.absent(),
            Value<String?> payoffChapterId = const Value.absent(),
            Value<String?> payoffDescription = const Value.absent(),
            Value<String?> entityId = const Value.absent(),
            Value<bool> isResolved = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              SetupPayoffsCompanion(
            id: id,
            projectId: projectId,
            setupChapterId: setupChapterId,
            setupDescription: setupDescription,
            payoffChapterId: payoffChapterId,
            payoffDescription: payoffDescription,
            entityId: entityId,
            isResolved: isResolved,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            Value<String?> projectId = const Value.absent(),
            required String setupChapterId,
            required String setupDescription,
            Value<String?> payoffChapterId = const Value.absent(),
            Value<String?> payoffDescription = const Value.absent(),
            Value<String?> entityId = const Value.absent(),
            Value<bool> isResolved = const Value.absent(),
            required DateTime createdAt,
            required DateTime updatedAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              SetupPayoffsCompanion.insert(
            id: id,
            projectId: projectId,
            setupChapterId: setupChapterId,
            setupDescription: setupDescription,
            payoffChapterId: payoffChapterId,
            payoffDescription: payoffDescription,
            entityId: entityId,
            isResolved: isResolved,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$SetupPayoffsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({projectId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
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
                      dynamic>>(state) {
                if (projectId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.projectId,
                    referencedTable:
                        $$SetupPayoffsTableReferences._projectIdTable(db),
                    referencedColumn:
                        $$SetupPayoffsTableReferences._projectIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$SetupPayoffsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $SetupPayoffsTable,
    SetupPayoffRow,
    $$SetupPayoffsTableFilterComposer,
    $$SetupPayoffsTableOrderingComposer,
    $$SetupPayoffsTableAnnotationComposer,
    $$SetupPayoffsTableCreateCompanionBuilder,
    $$SetupPayoffsTableUpdateCompanionBuilder,
    (SetupPayoffRow, $$SetupPayoffsTableReferences),
    SetupPayoffRow,
    PrefetchHooks Function({bool projectId})>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$ProjectsTableTableManager get projects =>
      $$ProjectsTableTableManager(_db, _db.projects);
  $$EntitiesTableTableManager get entities =>
      $$EntitiesTableTableManager(_db, _db.entities);
  $$RelationshipsTableTableManager get relationships =>
      $$RelationshipsTableTableManager(_db, _db.relationships);
  $$TagsTableTableManager get tags => $$TagsTableTableManager(_db, _db.tags);
  $$EntityTagsTableTableManager get entityTags =>
      $$EntityTagsTableTableManager(_db, _db.entityTags);
  $$TimelineEntriesTableTableManager get timelineEntries =>
      $$TimelineEntriesTableTableManager(_db, _db.timelineEntries);
  $$EntityVersionsTableTableManager get entityVersions =>
      $$EntityVersionsTableTableManager(_db, _db.entityVersions);
  $$TemplatesTableTableManager get templates =>
      $$TemplatesTableTableManager(_db, _db.templates);
  $$ManuscriptChaptersTableTableManager get manuscriptChapters =>
      $$ManuscriptChaptersTableTableManager(_db, _db.manuscriptChapters);
  $$ChapterSnapshotsTableTableManager get chapterSnapshots =>
      $$ChapterSnapshotsTableTableManager(_db, _db.chapterSnapshots);
  $$PlotCardsTableTableManager get plotCards =>
      $$PlotCardsTableTableManager(_db, _db.plotCards);
  $$PlotConnectionsTableTableManager get plotConnections =>
      $$PlotConnectionsTableTableManager(_db, _db.plotConnections);
  $$WorldMapsTableTableManager get worldMaps =>
      $$WorldMapsTableTableManager(_db, _db.worldMaps);
  $$MapPinsTableTableManager get mapPins =>
      $$MapPinsTableTableManager(_db, _db.mapPins);
  $$SetupPayoffsTableTableManager get setupPayoffs =>
      $$SetupPayoffsTableTableManager(_db, _db.setupPayoffs);
}
