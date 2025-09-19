// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sav_models.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetSavRecordCollection on Isar {
  IsarCollection<SavRecord> get savRecords => this.collection();
}

const SavRecordSchema = CollectionSchema(
  name: r'SavRecord',
  id: -3320461516270661883,
  properties: {
    r'arrival': PropertySchema(
      id: 0,
      name: r'arrival',
      type: IsarType.dateTime,
    ),
    r'client': PropertySchema(
      id: 1,
      name: r'client',
      type: IsarType.string,
    ),
    r'code': PropertySchema(
      id: 2,
      name: r'code',
      type: IsarType.string,
    ),
    r'date': PropertySchema(
      id: 3,
      name: r'date',
      type: IsarType.dateTime,
    ),
    r'diagnostic': PropertySchema(
      id: 4,
      name: r'diagnostic',
      type: IsarType.string,
    ),
    r'partChanged': PropertySchema(
      id: 5,
      name: r'partChanged',
      type: IsarType.string,
    ),
    r'repairPerformed': PropertySchema(
      id: 6,
      name: r'repairPerformed',
      type: IsarType.string,
    ),
    r'ret': PropertySchema(
      id: 7,
      name: r'ret',
      type: IsarType.dateTime,
    )
  },
  estimateSize: _savRecordEstimateSize,
  serialize: _savRecordSerialize,
  deserialize: _savRecordDeserialize,
  deserializeProp: _savRecordDeserializeProp,
  idName: r'id',
  indexes: {
    r'code': IndexSchema(
      id: 329780482934683790,
      name: r'code',
      unique: true,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'code',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _savRecordGetId,
  getLinks: _savRecordGetLinks,
  attach: _savRecordAttach,
  version: '3.1.0+1',
);

int _savRecordEstimateSize(
  SavRecord object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.client.length * 3;
  bytesCount += 3 + object.code.length * 3;
  bytesCount += 3 + object.diagnostic.length * 3;
  bytesCount += 3 + object.partChanged.length * 3;
  bytesCount += 3 + object.repairPerformed.length * 3;
  return bytesCount;
}

void _savRecordSerialize(
  SavRecord object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.arrival);
  writer.writeString(offsets[1], object.client);
  writer.writeString(offsets[2], object.code);
  writer.writeDateTime(offsets[3], object.date);
  writer.writeString(offsets[4], object.diagnostic);
  writer.writeString(offsets[5], object.partChanged);
  writer.writeString(offsets[6], object.repairPerformed);
  writer.writeDateTime(offsets[7], object.ret);
}

SavRecord _savRecordDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = SavRecord();
  object.arrival = reader.readDateTime(offsets[0]);
  object.client = reader.readString(offsets[1]);
  object.code = reader.readString(offsets[2]);
  object.date = reader.readDateTime(offsets[3]);
  object.diagnostic = reader.readString(offsets[4]);
  object.id = id;
  object.partChanged = reader.readString(offsets[5]);
  object.repairPerformed = reader.readString(offsets[6]);
  object.ret = reader.readDateTime(offsets[7]);
  return object;
}

P _savRecordDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDateTime(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readDateTime(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    case 5:
      return (reader.readString(offset)) as P;
    case 6:
      return (reader.readString(offset)) as P;
    case 7:
      return (reader.readDateTime(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _savRecordGetId(SavRecord object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _savRecordGetLinks(SavRecord object) {
  return [];
}

void _savRecordAttach(IsarCollection<dynamic> col, Id id, SavRecord object) {
  object.id = id;
}

extension SavRecordByIndex on IsarCollection<SavRecord> {
  Future<SavRecord?> getByCode(String code) {
    return getByIndex(r'code', [code]);
  }

  SavRecord? getByCodeSync(String code) {
    return getByIndexSync(r'code', [code]);
  }

  Future<bool> deleteByCode(String code) {
    return deleteByIndex(r'code', [code]);
  }

  bool deleteByCodeSync(String code) {
    return deleteByIndexSync(r'code', [code]);
  }

  Future<List<SavRecord?>> getAllByCode(List<String> codeValues) {
    final values = codeValues.map((e) => [e]).toList();
    return getAllByIndex(r'code', values);
  }

  List<SavRecord?> getAllByCodeSync(List<String> codeValues) {
    final values = codeValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'code', values);
  }

  Future<int> deleteAllByCode(List<String> codeValues) {
    final values = codeValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'code', values);
  }

  int deleteAllByCodeSync(List<String> codeValues) {
    final values = codeValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'code', values);
  }

  Future<Id> putByCode(SavRecord object) {
    return putByIndex(r'code', object);
  }

  Id putByCodeSync(SavRecord object, {bool saveLinks = true}) {
    return putByIndexSync(r'code', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByCode(List<SavRecord> objects) {
    return putAllByIndex(r'code', objects);
  }

  List<Id> putAllByCodeSync(List<SavRecord> objects, {bool saveLinks = true}) {
    return putAllByIndexSync(r'code', objects, saveLinks: saveLinks);
  }
}

extension SavRecordQueryWhereSort
    on QueryBuilder<SavRecord, SavRecord, QWhere> {
  QueryBuilder<SavRecord, SavRecord, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension SavRecordQueryWhere
    on QueryBuilder<SavRecord, SavRecord, QWhereClause> {
  QueryBuilder<SavRecord, SavRecord, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<SavRecord, SavRecord, QAfterWhereClause> idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<SavRecord, SavRecord, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<SavRecord, SavRecord, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<SavRecord, SavRecord, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SavRecord, SavRecord, QAfterWhereClause> codeEqualTo(
      String code) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'code',
        value: [code],
      ));
    });
  }

  QueryBuilder<SavRecord, SavRecord, QAfterWhereClause> codeNotEqualTo(
      String code) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'code',
              lower: [],
              upper: [code],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'code',
              lower: [code],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'code',
              lower: [code],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'code',
              lower: [],
              upper: [code],
              includeUpper: false,
            ));
      }
    });
  }
}

extension SavRecordQueryFilter
    on QueryBuilder<SavRecord, SavRecord, QFilterCondition> {
  QueryBuilder<SavRecord, SavRecord, QAfterFilterCondition> arrivalEqualTo(
      DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'arrival',
        value: value,
      ));
    });
  }

  QueryBuilder<SavRecord, SavRecord, QAfterFilterCondition> arrivalGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'arrival',
        value: value,
      ));
    });
  }

  QueryBuilder<SavRecord, SavRecord, QAfterFilterCondition> arrivalLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'arrival',
        value: value,
      ));
    });
  }

  QueryBuilder<SavRecord, SavRecord, QAfterFilterCondition> arrivalBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'arrival',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SavRecord, SavRecord, QAfterFilterCondition> clientEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'client',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SavRecord, SavRecord, QAfterFilterCondition> clientGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'client',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SavRecord, SavRecord, QAfterFilterCondition> clientLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'client',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SavRecord, SavRecord, QAfterFilterCondition> clientBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'client',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SavRecord, SavRecord, QAfterFilterCondition> clientStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'client',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SavRecord, SavRecord, QAfterFilterCondition> clientEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'client',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SavRecord, SavRecord, QAfterFilterCondition> clientContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'client',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SavRecord, SavRecord, QAfterFilterCondition> clientMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'client',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SavRecord, SavRecord, QAfterFilterCondition> clientIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'client',
        value: '',
      ));
    });
  }

  QueryBuilder<SavRecord, SavRecord, QAfterFilterCondition> clientIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'client',
        value: '',
      ));
    });
  }

  QueryBuilder<SavRecord, SavRecord, QAfterFilterCondition> codeEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'code',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SavRecord, SavRecord, QAfterFilterCondition> codeGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'code',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SavRecord, SavRecord, QAfterFilterCondition> codeLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'code',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SavRecord, SavRecord, QAfterFilterCondition> codeBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'code',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SavRecord, SavRecord, QAfterFilterCondition> codeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'code',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SavRecord, SavRecord, QAfterFilterCondition> codeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'code',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SavRecord, SavRecord, QAfterFilterCondition> codeContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'code',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SavRecord, SavRecord, QAfterFilterCondition> codeMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'code',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SavRecord, SavRecord, QAfterFilterCondition> codeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'code',
        value: '',
      ));
    });
  }

  QueryBuilder<SavRecord, SavRecord, QAfterFilterCondition> codeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'code',
        value: '',
      ));
    });
  }

  QueryBuilder<SavRecord, SavRecord, QAfterFilterCondition> dateEqualTo(
      DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'date',
        value: value,
      ));
    });
  }

  QueryBuilder<SavRecord, SavRecord, QAfterFilterCondition> dateGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'date',
        value: value,
      ));
    });
  }

  QueryBuilder<SavRecord, SavRecord, QAfterFilterCondition> dateLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'date',
        value: value,
      ));
    });
  }

  QueryBuilder<SavRecord, SavRecord, QAfterFilterCondition> dateBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'date',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SavRecord, SavRecord, QAfterFilterCondition> diagnosticEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'diagnostic',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SavRecord, SavRecord, QAfterFilterCondition>
      diagnosticGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'diagnostic',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SavRecord, SavRecord, QAfterFilterCondition> diagnosticLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'diagnostic',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SavRecord, SavRecord, QAfterFilterCondition> diagnosticBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'diagnostic',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SavRecord, SavRecord, QAfterFilterCondition>
      diagnosticStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'diagnostic',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SavRecord, SavRecord, QAfterFilterCondition> diagnosticEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'diagnostic',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SavRecord, SavRecord, QAfterFilterCondition> diagnosticContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'diagnostic',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SavRecord, SavRecord, QAfterFilterCondition> diagnosticMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'diagnostic',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SavRecord, SavRecord, QAfterFilterCondition>
      diagnosticIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'diagnostic',
        value: '',
      ));
    });
  }

  QueryBuilder<SavRecord, SavRecord, QAfterFilterCondition>
      diagnosticIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'diagnostic',
        value: '',
      ));
    });
  }

  QueryBuilder<SavRecord, SavRecord, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<SavRecord, SavRecord, QAfterFilterCondition> idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<SavRecord, SavRecord, QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<SavRecord, SavRecord, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SavRecord, SavRecord, QAfterFilterCondition> partChangedEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'partChanged',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SavRecord, SavRecord, QAfterFilterCondition>
      partChangedGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'partChanged',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SavRecord, SavRecord, QAfterFilterCondition> partChangedLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'partChanged',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SavRecord, SavRecord, QAfterFilterCondition> partChangedBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'partChanged',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SavRecord, SavRecord, QAfterFilterCondition>
      partChangedStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'partChanged',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SavRecord, SavRecord, QAfterFilterCondition> partChangedEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'partChanged',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SavRecord, SavRecord, QAfterFilterCondition> partChangedContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'partChanged',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SavRecord, SavRecord, QAfterFilterCondition> partChangedMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'partChanged',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SavRecord, SavRecord, QAfterFilterCondition>
      partChangedIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'partChanged',
        value: '',
      ));
    });
  }

  QueryBuilder<SavRecord, SavRecord, QAfterFilterCondition>
      partChangedIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'partChanged',
        value: '',
      ));
    });
  }

  QueryBuilder<SavRecord, SavRecord, QAfterFilterCondition>
      repairPerformedEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'repairPerformed',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SavRecord, SavRecord, QAfterFilterCondition>
      repairPerformedGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'repairPerformed',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SavRecord, SavRecord, QAfterFilterCondition>
      repairPerformedLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'repairPerformed',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SavRecord, SavRecord, QAfterFilterCondition>
      repairPerformedBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'repairPerformed',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SavRecord, SavRecord, QAfterFilterCondition>
      repairPerformedStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'repairPerformed',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SavRecord, SavRecord, QAfterFilterCondition>
      repairPerformedEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'repairPerformed',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SavRecord, SavRecord, QAfterFilterCondition>
      repairPerformedContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'repairPerformed',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SavRecord, SavRecord, QAfterFilterCondition>
      repairPerformedMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'repairPerformed',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SavRecord, SavRecord, QAfterFilterCondition>
      repairPerformedIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'repairPerformed',
        value: '',
      ));
    });
  }

  QueryBuilder<SavRecord, SavRecord, QAfterFilterCondition>
      repairPerformedIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'repairPerformed',
        value: '',
      ));
    });
  }

  QueryBuilder<SavRecord, SavRecord, QAfterFilterCondition> retEqualTo(
      DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'ret',
        value: value,
      ));
    });
  }

  QueryBuilder<SavRecord, SavRecord, QAfterFilterCondition> retGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'ret',
        value: value,
      ));
    });
  }

  QueryBuilder<SavRecord, SavRecord, QAfterFilterCondition> retLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'ret',
        value: value,
      ));
    });
  }

  QueryBuilder<SavRecord, SavRecord, QAfterFilterCondition> retBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'ret',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension SavRecordQueryObject
    on QueryBuilder<SavRecord, SavRecord, QFilterCondition> {}

extension SavRecordQueryLinks
    on QueryBuilder<SavRecord, SavRecord, QFilterCondition> {}

extension SavRecordQuerySortBy on QueryBuilder<SavRecord, SavRecord, QSortBy> {
  QueryBuilder<SavRecord, SavRecord, QAfterSortBy> sortByArrival() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'arrival', Sort.asc);
    });
  }

  QueryBuilder<SavRecord, SavRecord, QAfterSortBy> sortByArrivalDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'arrival', Sort.desc);
    });
  }

  QueryBuilder<SavRecord, SavRecord, QAfterSortBy> sortByClient() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'client', Sort.asc);
    });
  }

  QueryBuilder<SavRecord, SavRecord, QAfterSortBy> sortByClientDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'client', Sort.desc);
    });
  }

  QueryBuilder<SavRecord, SavRecord, QAfterSortBy> sortByCode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'code', Sort.asc);
    });
  }

  QueryBuilder<SavRecord, SavRecord, QAfterSortBy> sortByCodeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'code', Sort.desc);
    });
  }

  QueryBuilder<SavRecord, SavRecord, QAfterSortBy> sortByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.asc);
    });
  }

  QueryBuilder<SavRecord, SavRecord, QAfterSortBy> sortByDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.desc);
    });
  }

  QueryBuilder<SavRecord, SavRecord, QAfterSortBy> sortByDiagnostic() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'diagnostic', Sort.asc);
    });
  }

  QueryBuilder<SavRecord, SavRecord, QAfterSortBy> sortByDiagnosticDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'diagnostic', Sort.desc);
    });
  }

  QueryBuilder<SavRecord, SavRecord, QAfterSortBy> sortByPartChanged() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'partChanged', Sort.asc);
    });
  }

  QueryBuilder<SavRecord, SavRecord, QAfterSortBy> sortByPartChangedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'partChanged', Sort.desc);
    });
  }

  QueryBuilder<SavRecord, SavRecord, QAfterSortBy> sortByRepairPerformed() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'repairPerformed', Sort.asc);
    });
  }

  QueryBuilder<SavRecord, SavRecord, QAfterSortBy> sortByRepairPerformedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'repairPerformed', Sort.desc);
    });
  }

  QueryBuilder<SavRecord, SavRecord, QAfterSortBy> sortByRet() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ret', Sort.asc);
    });
  }

  QueryBuilder<SavRecord, SavRecord, QAfterSortBy> sortByRetDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ret', Sort.desc);
    });
  }
}

extension SavRecordQuerySortThenBy
    on QueryBuilder<SavRecord, SavRecord, QSortThenBy> {
  QueryBuilder<SavRecord, SavRecord, QAfterSortBy> thenByArrival() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'arrival', Sort.asc);
    });
  }

  QueryBuilder<SavRecord, SavRecord, QAfterSortBy> thenByArrivalDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'arrival', Sort.desc);
    });
  }

  QueryBuilder<SavRecord, SavRecord, QAfterSortBy> thenByClient() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'client', Sort.asc);
    });
  }

  QueryBuilder<SavRecord, SavRecord, QAfterSortBy> thenByClientDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'client', Sort.desc);
    });
  }

  QueryBuilder<SavRecord, SavRecord, QAfterSortBy> thenByCode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'code', Sort.asc);
    });
  }

  QueryBuilder<SavRecord, SavRecord, QAfterSortBy> thenByCodeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'code', Sort.desc);
    });
  }

  QueryBuilder<SavRecord, SavRecord, QAfterSortBy> thenByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.asc);
    });
  }

  QueryBuilder<SavRecord, SavRecord, QAfterSortBy> thenByDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.desc);
    });
  }

  QueryBuilder<SavRecord, SavRecord, QAfterSortBy> thenByDiagnostic() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'diagnostic', Sort.asc);
    });
  }

  QueryBuilder<SavRecord, SavRecord, QAfterSortBy> thenByDiagnosticDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'diagnostic', Sort.desc);
    });
  }

  QueryBuilder<SavRecord, SavRecord, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<SavRecord, SavRecord, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<SavRecord, SavRecord, QAfterSortBy> thenByPartChanged() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'partChanged', Sort.asc);
    });
  }

  QueryBuilder<SavRecord, SavRecord, QAfterSortBy> thenByPartChangedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'partChanged', Sort.desc);
    });
  }

  QueryBuilder<SavRecord, SavRecord, QAfterSortBy> thenByRepairPerformed() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'repairPerformed', Sort.asc);
    });
  }

  QueryBuilder<SavRecord, SavRecord, QAfterSortBy> thenByRepairPerformedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'repairPerformed', Sort.desc);
    });
  }

  QueryBuilder<SavRecord, SavRecord, QAfterSortBy> thenByRet() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ret', Sort.asc);
    });
  }

  QueryBuilder<SavRecord, SavRecord, QAfterSortBy> thenByRetDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ret', Sort.desc);
    });
  }
}

extension SavRecordQueryWhereDistinct
    on QueryBuilder<SavRecord, SavRecord, QDistinct> {
  QueryBuilder<SavRecord, SavRecord, QDistinct> distinctByArrival() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'arrival');
    });
  }

  QueryBuilder<SavRecord, SavRecord, QDistinct> distinctByClient(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'client', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SavRecord, SavRecord, QDistinct> distinctByCode(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'code', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SavRecord, SavRecord, QDistinct> distinctByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'date');
    });
  }

  QueryBuilder<SavRecord, SavRecord, QDistinct> distinctByDiagnostic(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'diagnostic', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SavRecord, SavRecord, QDistinct> distinctByPartChanged(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'partChanged', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SavRecord, SavRecord, QDistinct> distinctByRepairPerformed(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'repairPerformed',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SavRecord, SavRecord, QDistinct> distinctByRet() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'ret');
    });
  }
}

extension SavRecordQueryProperty
    on QueryBuilder<SavRecord, SavRecord, QQueryProperty> {
  QueryBuilder<SavRecord, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<SavRecord, DateTime, QQueryOperations> arrivalProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'arrival');
    });
  }

  QueryBuilder<SavRecord, String, QQueryOperations> clientProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'client');
    });
  }

  QueryBuilder<SavRecord, String, QQueryOperations> codeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'code');
    });
  }

  QueryBuilder<SavRecord, DateTime, QQueryOperations> dateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'date');
    });
  }

  QueryBuilder<SavRecord, String, QQueryOperations> diagnosticProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'diagnostic');
    });
  }

  QueryBuilder<SavRecord, String, QQueryOperations> partChangedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'partChanged');
    });
  }

  QueryBuilder<SavRecord, String, QQueryOperations> repairPerformedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'repairPerformed');
    });
  }

  QueryBuilder<SavRecord, DateTime, QQueryOperations> retProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'ret');
    });
  }
}
