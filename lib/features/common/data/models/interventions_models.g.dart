// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'interventions_models.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetInterventionRequestCollection on Isar {
  IsarCollection<InterventionRequest> get interventionRequests =>
      this.collection();
}

const InterventionRequestSchema = CollectionSchema(
  name: r'InterventionRequest',
  id: 7445906197666252949,
  properties: {
    r'clientName': PropertySchema(
      id: 0,
      name: r'clientName',
      type: IsarType.string,
    ),
    r'code': PropertySchema(
      id: 1,
      name: r'code',
      type: IsarType.string,
    ),
    r'date': PropertySchema(
      id: 2,
      name: r'date',
      type: IsarType.dateTime,
    ),
    r'issue': PropertySchema(
      id: 3,
      name: r'issue',
      type: IsarType.string,
    ),
    r'level': PropertySchema(
      id: 4,
      name: r'level',
      type: IsarType.string,
    ),
    r'location': PropertySchema(
      id: 5,
      name: r'location',
      type: IsarType.string,
    ),
    r'phone': PropertySchema(
      id: 6,
      name: r'phone',
      type: IsarType.string,
    )
  },
  estimateSize: _interventionRequestEstimateSize,
  serialize: _interventionRequestSerialize,
  deserialize: _interventionRequestDeserialize,
  deserializeProp: _interventionRequestDeserializeProp,
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
  getId: _interventionRequestGetId,
  getLinks: _interventionRequestGetLinks,
  attach: _interventionRequestAttach,
  version: '3.1.0+1',
);

int _interventionRequestEstimateSize(
  InterventionRequest object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.clientName.length * 3;
  bytesCount += 3 + object.code.length * 3;
  bytesCount += 3 + object.issue.length * 3;
  bytesCount += 3 + object.level.length * 3;
  bytesCount += 3 + object.location.length * 3;
  bytesCount += 3 + object.phone.length * 3;
  return bytesCount;
}

void _interventionRequestSerialize(
  InterventionRequest object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.clientName);
  writer.writeString(offsets[1], object.code);
  writer.writeDateTime(offsets[2], object.date);
  writer.writeString(offsets[3], object.issue);
  writer.writeString(offsets[4], object.level);
  writer.writeString(offsets[5], object.location);
  writer.writeString(offsets[6], object.phone);
}

InterventionRequest _interventionRequestDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = InterventionRequest();
  object.clientName = reader.readString(offsets[0]);
  object.code = reader.readString(offsets[1]);
  object.date = reader.readDateTime(offsets[2]);
  object.id = id;
  object.issue = reader.readString(offsets[3]);
  object.level = reader.readString(offsets[4]);
  object.location = reader.readString(offsets[5]);
  object.phone = reader.readString(offsets[6]);
  return object;
}

P _interventionRequestDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readDateTime(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    case 5:
      return (reader.readString(offset)) as P;
    case 6:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _interventionRequestGetId(InterventionRequest object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _interventionRequestGetLinks(
    InterventionRequest object) {
  return [];
}

void _interventionRequestAttach(
    IsarCollection<dynamic> col, Id id, InterventionRequest object) {
  object.id = id;
}

extension InterventionRequestByIndex on IsarCollection<InterventionRequest> {
  Future<InterventionRequest?> getByCode(String code) {
    return getByIndex(r'code', [code]);
  }

  InterventionRequest? getByCodeSync(String code) {
    return getByIndexSync(r'code', [code]);
  }

  Future<bool> deleteByCode(String code) {
    return deleteByIndex(r'code', [code]);
  }

  bool deleteByCodeSync(String code) {
    return deleteByIndexSync(r'code', [code]);
  }

  Future<List<InterventionRequest?>> getAllByCode(List<String> codeValues) {
    final values = codeValues.map((e) => [e]).toList();
    return getAllByIndex(r'code', values);
  }

  List<InterventionRequest?> getAllByCodeSync(List<String> codeValues) {
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

  Future<Id> putByCode(InterventionRequest object) {
    return putByIndex(r'code', object);
  }

  Id putByCodeSync(InterventionRequest object, {bool saveLinks = true}) {
    return putByIndexSync(r'code', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByCode(List<InterventionRequest> objects) {
    return putAllByIndex(r'code', objects);
  }

  List<Id> putAllByCodeSync(List<InterventionRequest> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'code', objects, saveLinks: saveLinks);
  }
}

extension InterventionRequestQueryWhereSort
    on QueryBuilder<InterventionRequest, InterventionRequest, QWhere> {
  QueryBuilder<InterventionRequest, InterventionRequest, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension InterventionRequestQueryWhere
    on QueryBuilder<InterventionRequest, InterventionRequest, QWhereClause> {
  QueryBuilder<InterventionRequest, InterventionRequest, QAfterWhereClause>
      idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<InterventionRequest, InterventionRequest, QAfterWhereClause>
      idNotEqualTo(Id id) {
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

  QueryBuilder<InterventionRequest, InterventionRequest, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<InterventionRequest, InterventionRequest, QAfterWhereClause>
      idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<InterventionRequest, InterventionRequest, QAfterWhereClause>
      idBetween(
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

  QueryBuilder<InterventionRequest, InterventionRequest, QAfterWhereClause>
      codeEqualTo(String code) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'code',
        value: [code],
      ));
    });
  }

  QueryBuilder<InterventionRequest, InterventionRequest, QAfterWhereClause>
      codeNotEqualTo(String code) {
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

extension InterventionRequestQueryFilter on QueryBuilder<InterventionRequest,
    InterventionRequest, QFilterCondition> {
  QueryBuilder<InterventionRequest, InterventionRequest, QAfterFilterCondition>
      clientNameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'clientName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InterventionRequest, InterventionRequest, QAfterFilterCondition>
      clientNameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'clientName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InterventionRequest, InterventionRequest, QAfterFilterCondition>
      clientNameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'clientName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InterventionRequest, InterventionRequest, QAfterFilterCondition>
      clientNameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'clientName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InterventionRequest, InterventionRequest, QAfterFilterCondition>
      clientNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'clientName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InterventionRequest, InterventionRequest, QAfterFilterCondition>
      clientNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'clientName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InterventionRequest, InterventionRequest, QAfterFilterCondition>
      clientNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'clientName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InterventionRequest, InterventionRequest, QAfterFilterCondition>
      clientNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'clientName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InterventionRequest, InterventionRequest, QAfterFilterCondition>
      clientNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'clientName',
        value: '',
      ));
    });
  }

  QueryBuilder<InterventionRequest, InterventionRequest, QAfterFilterCondition>
      clientNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'clientName',
        value: '',
      ));
    });
  }

  QueryBuilder<InterventionRequest, InterventionRequest, QAfterFilterCondition>
      codeEqualTo(
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

  QueryBuilder<InterventionRequest, InterventionRequest, QAfterFilterCondition>
      codeGreaterThan(
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

  QueryBuilder<InterventionRequest, InterventionRequest, QAfterFilterCondition>
      codeLessThan(
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

  QueryBuilder<InterventionRequest, InterventionRequest, QAfterFilterCondition>
      codeBetween(
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

  QueryBuilder<InterventionRequest, InterventionRequest, QAfterFilterCondition>
      codeStartsWith(
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

  QueryBuilder<InterventionRequest, InterventionRequest, QAfterFilterCondition>
      codeEndsWith(
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

  QueryBuilder<InterventionRequest, InterventionRequest, QAfterFilterCondition>
      codeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'code',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InterventionRequest, InterventionRequest, QAfterFilterCondition>
      codeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'code',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InterventionRequest, InterventionRequest, QAfterFilterCondition>
      codeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'code',
        value: '',
      ));
    });
  }

  QueryBuilder<InterventionRequest, InterventionRequest, QAfterFilterCondition>
      codeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'code',
        value: '',
      ));
    });
  }

  QueryBuilder<InterventionRequest, InterventionRequest, QAfterFilterCondition>
      dateEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'date',
        value: value,
      ));
    });
  }

  QueryBuilder<InterventionRequest, InterventionRequest, QAfterFilterCondition>
      dateGreaterThan(
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

  QueryBuilder<InterventionRequest, InterventionRequest, QAfterFilterCondition>
      dateLessThan(
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

  QueryBuilder<InterventionRequest, InterventionRequest, QAfterFilterCondition>
      dateBetween(
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

  QueryBuilder<InterventionRequest, InterventionRequest, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<InterventionRequest, InterventionRequest, QAfterFilterCondition>
      idGreaterThan(
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

  QueryBuilder<InterventionRequest, InterventionRequest, QAfterFilterCondition>
      idLessThan(
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

  QueryBuilder<InterventionRequest, InterventionRequest, QAfterFilterCondition>
      idBetween(
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

  QueryBuilder<InterventionRequest, InterventionRequest, QAfterFilterCondition>
      issueEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'issue',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InterventionRequest, InterventionRequest, QAfterFilterCondition>
      issueGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'issue',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InterventionRequest, InterventionRequest, QAfterFilterCondition>
      issueLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'issue',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InterventionRequest, InterventionRequest, QAfterFilterCondition>
      issueBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'issue',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InterventionRequest, InterventionRequest, QAfterFilterCondition>
      issueStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'issue',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InterventionRequest, InterventionRequest, QAfterFilterCondition>
      issueEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'issue',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InterventionRequest, InterventionRequest, QAfterFilterCondition>
      issueContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'issue',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InterventionRequest, InterventionRequest, QAfterFilterCondition>
      issueMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'issue',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InterventionRequest, InterventionRequest, QAfterFilterCondition>
      issueIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'issue',
        value: '',
      ));
    });
  }

  QueryBuilder<InterventionRequest, InterventionRequest, QAfterFilterCondition>
      issueIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'issue',
        value: '',
      ));
    });
  }

  QueryBuilder<InterventionRequest, InterventionRequest, QAfterFilterCondition>
      levelEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'level',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InterventionRequest, InterventionRequest, QAfterFilterCondition>
      levelGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'level',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InterventionRequest, InterventionRequest, QAfterFilterCondition>
      levelLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'level',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InterventionRequest, InterventionRequest, QAfterFilterCondition>
      levelBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'level',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InterventionRequest, InterventionRequest, QAfterFilterCondition>
      levelStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'level',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InterventionRequest, InterventionRequest, QAfterFilterCondition>
      levelEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'level',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InterventionRequest, InterventionRequest, QAfterFilterCondition>
      levelContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'level',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InterventionRequest, InterventionRequest, QAfterFilterCondition>
      levelMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'level',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InterventionRequest, InterventionRequest, QAfterFilterCondition>
      levelIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'level',
        value: '',
      ));
    });
  }

  QueryBuilder<InterventionRequest, InterventionRequest, QAfterFilterCondition>
      levelIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'level',
        value: '',
      ));
    });
  }

  QueryBuilder<InterventionRequest, InterventionRequest, QAfterFilterCondition>
      locationEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'location',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InterventionRequest, InterventionRequest, QAfterFilterCondition>
      locationGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'location',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InterventionRequest, InterventionRequest, QAfterFilterCondition>
      locationLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'location',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InterventionRequest, InterventionRequest, QAfterFilterCondition>
      locationBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'location',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InterventionRequest, InterventionRequest, QAfterFilterCondition>
      locationStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'location',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InterventionRequest, InterventionRequest, QAfterFilterCondition>
      locationEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'location',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InterventionRequest, InterventionRequest, QAfterFilterCondition>
      locationContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'location',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InterventionRequest, InterventionRequest, QAfterFilterCondition>
      locationMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'location',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InterventionRequest, InterventionRequest, QAfterFilterCondition>
      locationIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'location',
        value: '',
      ));
    });
  }

  QueryBuilder<InterventionRequest, InterventionRequest, QAfterFilterCondition>
      locationIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'location',
        value: '',
      ));
    });
  }

  QueryBuilder<InterventionRequest, InterventionRequest, QAfterFilterCondition>
      phoneEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'phone',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InterventionRequest, InterventionRequest, QAfterFilterCondition>
      phoneGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'phone',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InterventionRequest, InterventionRequest, QAfterFilterCondition>
      phoneLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'phone',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InterventionRequest, InterventionRequest, QAfterFilterCondition>
      phoneBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'phone',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InterventionRequest, InterventionRequest, QAfterFilterCondition>
      phoneStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'phone',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InterventionRequest, InterventionRequest, QAfterFilterCondition>
      phoneEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'phone',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InterventionRequest, InterventionRequest, QAfterFilterCondition>
      phoneContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'phone',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InterventionRequest, InterventionRequest, QAfterFilterCondition>
      phoneMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'phone',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<InterventionRequest, InterventionRequest, QAfterFilterCondition>
      phoneIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'phone',
        value: '',
      ));
    });
  }

  QueryBuilder<InterventionRequest, InterventionRequest, QAfterFilterCondition>
      phoneIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'phone',
        value: '',
      ));
    });
  }
}

extension InterventionRequestQueryObject on QueryBuilder<InterventionRequest,
    InterventionRequest, QFilterCondition> {}

extension InterventionRequestQueryLinks on QueryBuilder<InterventionRequest,
    InterventionRequest, QFilterCondition> {}

extension InterventionRequestQuerySortBy
    on QueryBuilder<InterventionRequest, InterventionRequest, QSortBy> {
  QueryBuilder<InterventionRequest, InterventionRequest, QAfterSortBy>
      sortByClientName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'clientName', Sort.asc);
    });
  }

  QueryBuilder<InterventionRequest, InterventionRequest, QAfterSortBy>
      sortByClientNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'clientName', Sort.desc);
    });
  }

  QueryBuilder<InterventionRequest, InterventionRequest, QAfterSortBy>
      sortByCode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'code', Sort.asc);
    });
  }

  QueryBuilder<InterventionRequest, InterventionRequest, QAfterSortBy>
      sortByCodeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'code', Sort.desc);
    });
  }

  QueryBuilder<InterventionRequest, InterventionRequest, QAfterSortBy>
      sortByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.asc);
    });
  }

  QueryBuilder<InterventionRequest, InterventionRequest, QAfterSortBy>
      sortByDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.desc);
    });
  }

  QueryBuilder<InterventionRequest, InterventionRequest, QAfterSortBy>
      sortByIssue() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'issue', Sort.asc);
    });
  }

  QueryBuilder<InterventionRequest, InterventionRequest, QAfterSortBy>
      sortByIssueDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'issue', Sort.desc);
    });
  }

  QueryBuilder<InterventionRequest, InterventionRequest, QAfterSortBy>
      sortByLevel() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'level', Sort.asc);
    });
  }

  QueryBuilder<InterventionRequest, InterventionRequest, QAfterSortBy>
      sortByLevelDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'level', Sort.desc);
    });
  }

  QueryBuilder<InterventionRequest, InterventionRequest, QAfterSortBy>
      sortByLocation() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'location', Sort.asc);
    });
  }

  QueryBuilder<InterventionRequest, InterventionRequest, QAfterSortBy>
      sortByLocationDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'location', Sort.desc);
    });
  }

  QueryBuilder<InterventionRequest, InterventionRequest, QAfterSortBy>
      sortByPhone() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'phone', Sort.asc);
    });
  }

  QueryBuilder<InterventionRequest, InterventionRequest, QAfterSortBy>
      sortByPhoneDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'phone', Sort.desc);
    });
  }
}

extension InterventionRequestQuerySortThenBy
    on QueryBuilder<InterventionRequest, InterventionRequest, QSortThenBy> {
  QueryBuilder<InterventionRequest, InterventionRequest, QAfterSortBy>
      thenByClientName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'clientName', Sort.asc);
    });
  }

  QueryBuilder<InterventionRequest, InterventionRequest, QAfterSortBy>
      thenByClientNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'clientName', Sort.desc);
    });
  }

  QueryBuilder<InterventionRequest, InterventionRequest, QAfterSortBy>
      thenByCode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'code', Sort.asc);
    });
  }

  QueryBuilder<InterventionRequest, InterventionRequest, QAfterSortBy>
      thenByCodeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'code', Sort.desc);
    });
  }

  QueryBuilder<InterventionRequest, InterventionRequest, QAfterSortBy>
      thenByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.asc);
    });
  }

  QueryBuilder<InterventionRequest, InterventionRequest, QAfterSortBy>
      thenByDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.desc);
    });
  }

  QueryBuilder<InterventionRequest, InterventionRequest, QAfterSortBy>
      thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<InterventionRequest, InterventionRequest, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<InterventionRequest, InterventionRequest, QAfterSortBy>
      thenByIssue() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'issue', Sort.asc);
    });
  }

  QueryBuilder<InterventionRequest, InterventionRequest, QAfterSortBy>
      thenByIssueDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'issue', Sort.desc);
    });
  }

  QueryBuilder<InterventionRequest, InterventionRequest, QAfterSortBy>
      thenByLevel() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'level', Sort.asc);
    });
  }

  QueryBuilder<InterventionRequest, InterventionRequest, QAfterSortBy>
      thenByLevelDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'level', Sort.desc);
    });
  }

  QueryBuilder<InterventionRequest, InterventionRequest, QAfterSortBy>
      thenByLocation() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'location', Sort.asc);
    });
  }

  QueryBuilder<InterventionRequest, InterventionRequest, QAfterSortBy>
      thenByLocationDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'location', Sort.desc);
    });
  }

  QueryBuilder<InterventionRequest, InterventionRequest, QAfterSortBy>
      thenByPhone() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'phone', Sort.asc);
    });
  }

  QueryBuilder<InterventionRequest, InterventionRequest, QAfterSortBy>
      thenByPhoneDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'phone', Sort.desc);
    });
  }
}

extension InterventionRequestQueryWhereDistinct
    on QueryBuilder<InterventionRequest, InterventionRequest, QDistinct> {
  QueryBuilder<InterventionRequest, InterventionRequest, QDistinct>
      distinctByClientName({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'clientName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<InterventionRequest, InterventionRequest, QDistinct>
      distinctByCode({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'code', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<InterventionRequest, InterventionRequest, QDistinct>
      distinctByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'date');
    });
  }

  QueryBuilder<InterventionRequest, InterventionRequest, QDistinct>
      distinctByIssue({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'issue', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<InterventionRequest, InterventionRequest, QDistinct>
      distinctByLevel({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'level', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<InterventionRequest, InterventionRequest, QDistinct>
      distinctByLocation({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'location', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<InterventionRequest, InterventionRequest, QDistinct>
      distinctByPhone({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'phone', caseSensitive: caseSensitive);
    });
  }
}

extension InterventionRequestQueryProperty
    on QueryBuilder<InterventionRequest, InterventionRequest, QQueryProperty> {
  QueryBuilder<InterventionRequest, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<InterventionRequest, String, QQueryOperations>
      clientNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'clientName');
    });
  }

  QueryBuilder<InterventionRequest, String, QQueryOperations> codeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'code');
    });
  }

  QueryBuilder<InterventionRequest, DateTime, QQueryOperations> dateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'date');
    });
  }

  QueryBuilder<InterventionRequest, String, QQueryOperations> issueProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'issue');
    });
  }

  QueryBuilder<InterventionRequest, String, QQueryOperations> levelProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'level');
    });
  }

  QueryBuilder<InterventionRequest, String, QQueryOperations>
      locationProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'location');
    });
  }

  QueryBuilder<InterventionRequest, String, QQueryOperations> phoneProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'phone');
    });
  }
}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetTechnicianReportCollection on Isar {
  IsarCollection<TechnicianReport> get technicianReports => this.collection();
}

const TechnicianReportSchema = CollectionSchema(
  name: r'TechnicianReport',
  id: 9036622175712508667,
  properties: {
    r'arrive': PropertySchema(
      id: 0,
      name: r'arrive',
      type: IsarType.dateTime,
    ),
    r'code': PropertySchema(
      id: 1,
      name: r'code',
      type: IsarType.string,
    ),
    r'depart': PropertySchema(
      id: 2,
      name: r'depart',
      type: IsarType.dateTime,
    ),
    r'diagnosis': PropertySchema(
      id: 3,
      name: r'diagnosis',
      type: IsarType.string,
    ),
    r'manager': PropertySchema(
      id: 4,
      name: r'manager',
      type: IsarType.string,
    ),
    r'modelType': PropertySchema(
      id: 5,
      name: r'modelType',
      type: IsarType.string,
    ),
    r'reparation': PropertySchema(
      id: 6,
      name: r'reparation',
      type: IsarType.string,
    ),
    r'signaturePng': PropertySchema(
      id: 7,
      name: r'signaturePng',
      type: IsarType.longList,
    ),
    r'technician': PropertySchema(
      id: 8,
      name: r'technician',
      type: IsarType.string,
    )
  },
  estimateSize: _technicianReportEstimateSize,
  serialize: _technicianReportSerialize,
  deserialize: _technicianReportDeserialize,
  deserializeProp: _technicianReportDeserializeProp,
  idName: r'id',
  indexes: {
    r'code': IndexSchema(
      id: 329780482934683790,
      name: r'code',
      unique: false,
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
  getId: _technicianReportGetId,
  getLinks: _technicianReportGetLinks,
  attach: _technicianReportAttach,
  version: '3.1.0+1',
);

int _technicianReportEstimateSize(
  TechnicianReport object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.code.length * 3;
  bytesCount += 3 + object.diagnosis.length * 3;
  bytesCount += 3 + object.manager.length * 3;
  bytesCount += 3 + object.modelType.length * 3;
  bytesCount += 3 + object.reparation.length * 3;
  {
    final value = object.signaturePng;
    if (value != null) {
      bytesCount += 3 + value.length * 8;
    }
  }
  bytesCount += 3 + object.technician.length * 3;
  return bytesCount;
}

void _technicianReportSerialize(
  TechnicianReport object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.arrive);
  writer.writeString(offsets[1], object.code);
  writer.writeDateTime(offsets[2], object.depart);
  writer.writeString(offsets[3], object.diagnosis);
  writer.writeString(offsets[4], object.manager);
  writer.writeString(offsets[5], object.modelType);
  writer.writeString(offsets[6], object.reparation);
  writer.writeLongList(offsets[7], object.signaturePng);
  writer.writeString(offsets[8], object.technician);
}

TechnicianReport _technicianReportDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = TechnicianReport();
  object.arrive = reader.readDateTime(offsets[0]);
  object.code = reader.readString(offsets[1]);
  object.depart = reader.readDateTime(offsets[2]);
  object.diagnosis = reader.readString(offsets[3]);
  object.id = id;
  object.manager = reader.readString(offsets[4]);
  object.modelType = reader.readString(offsets[5]);
  object.reparation = reader.readString(offsets[6]);
  object.signaturePng = reader.readLongList(offsets[7]);
  object.technician = reader.readString(offsets[8]);
  return object;
}

P _technicianReportDeserializeProp<P>(
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
      return (reader.readDateTime(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    case 5:
      return (reader.readString(offset)) as P;
    case 6:
      return (reader.readString(offset)) as P;
    case 7:
      return (reader.readLongList(offset)) as P;
    case 8:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _technicianReportGetId(TechnicianReport object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _technicianReportGetLinks(TechnicianReport object) {
  return [];
}

void _technicianReportAttach(
    IsarCollection<dynamic> col, Id id, TechnicianReport object) {
  object.id = id;
}

extension TechnicianReportQueryWhereSort
    on QueryBuilder<TechnicianReport, TechnicianReport, QWhere> {
  QueryBuilder<TechnicianReport, TechnicianReport, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension TechnicianReportQueryWhere
    on QueryBuilder<TechnicianReport, TechnicianReport, QWhereClause> {
  QueryBuilder<TechnicianReport, TechnicianReport, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<TechnicianReport, TechnicianReport, QAfterWhereClause>
      idNotEqualTo(Id id) {
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

  QueryBuilder<TechnicianReport, TechnicianReport, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<TechnicianReport, TechnicianReport, QAfterWhereClause>
      idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<TechnicianReport, TechnicianReport, QAfterWhereClause> idBetween(
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

  QueryBuilder<TechnicianReport, TechnicianReport, QAfterWhereClause>
      codeEqualTo(String code) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'code',
        value: [code],
      ));
    });
  }

  QueryBuilder<TechnicianReport, TechnicianReport, QAfterWhereClause>
      codeNotEqualTo(String code) {
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

extension TechnicianReportQueryFilter
    on QueryBuilder<TechnicianReport, TechnicianReport, QFilterCondition> {
  QueryBuilder<TechnicianReport, TechnicianReport, QAfterFilterCondition>
      arriveEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'arrive',
        value: value,
      ));
    });
  }

  QueryBuilder<TechnicianReport, TechnicianReport, QAfterFilterCondition>
      arriveGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'arrive',
        value: value,
      ));
    });
  }

  QueryBuilder<TechnicianReport, TechnicianReport, QAfterFilterCondition>
      arriveLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'arrive',
        value: value,
      ));
    });
  }

  QueryBuilder<TechnicianReport, TechnicianReport, QAfterFilterCondition>
      arriveBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'arrive',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<TechnicianReport, TechnicianReport, QAfterFilterCondition>
      codeEqualTo(
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

  QueryBuilder<TechnicianReport, TechnicianReport, QAfterFilterCondition>
      codeGreaterThan(
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

  QueryBuilder<TechnicianReport, TechnicianReport, QAfterFilterCondition>
      codeLessThan(
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

  QueryBuilder<TechnicianReport, TechnicianReport, QAfterFilterCondition>
      codeBetween(
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

  QueryBuilder<TechnicianReport, TechnicianReport, QAfterFilterCondition>
      codeStartsWith(
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

  QueryBuilder<TechnicianReport, TechnicianReport, QAfterFilterCondition>
      codeEndsWith(
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

  QueryBuilder<TechnicianReport, TechnicianReport, QAfterFilterCondition>
      codeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'code',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TechnicianReport, TechnicianReport, QAfterFilterCondition>
      codeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'code',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TechnicianReport, TechnicianReport, QAfterFilterCondition>
      codeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'code',
        value: '',
      ));
    });
  }

  QueryBuilder<TechnicianReport, TechnicianReport, QAfterFilterCondition>
      codeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'code',
        value: '',
      ));
    });
  }

  QueryBuilder<TechnicianReport, TechnicianReport, QAfterFilterCondition>
      departEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'depart',
        value: value,
      ));
    });
  }

  QueryBuilder<TechnicianReport, TechnicianReport, QAfterFilterCondition>
      departGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'depart',
        value: value,
      ));
    });
  }

  QueryBuilder<TechnicianReport, TechnicianReport, QAfterFilterCondition>
      departLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'depart',
        value: value,
      ));
    });
  }

  QueryBuilder<TechnicianReport, TechnicianReport, QAfterFilterCondition>
      departBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'depart',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<TechnicianReport, TechnicianReport, QAfterFilterCondition>
      diagnosisEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'diagnosis',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TechnicianReport, TechnicianReport, QAfterFilterCondition>
      diagnosisGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'diagnosis',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TechnicianReport, TechnicianReport, QAfterFilterCondition>
      diagnosisLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'diagnosis',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TechnicianReport, TechnicianReport, QAfterFilterCondition>
      diagnosisBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'diagnosis',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TechnicianReport, TechnicianReport, QAfterFilterCondition>
      diagnosisStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'diagnosis',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TechnicianReport, TechnicianReport, QAfterFilterCondition>
      diagnosisEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'diagnosis',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TechnicianReport, TechnicianReport, QAfterFilterCondition>
      diagnosisContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'diagnosis',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TechnicianReport, TechnicianReport, QAfterFilterCondition>
      diagnosisMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'diagnosis',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TechnicianReport, TechnicianReport, QAfterFilterCondition>
      diagnosisIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'diagnosis',
        value: '',
      ));
    });
  }

  QueryBuilder<TechnicianReport, TechnicianReport, QAfterFilterCondition>
      diagnosisIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'diagnosis',
        value: '',
      ));
    });
  }

  QueryBuilder<TechnicianReport, TechnicianReport, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<TechnicianReport, TechnicianReport, QAfterFilterCondition>
      idGreaterThan(
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

  QueryBuilder<TechnicianReport, TechnicianReport, QAfterFilterCondition>
      idLessThan(
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

  QueryBuilder<TechnicianReport, TechnicianReport, QAfterFilterCondition>
      idBetween(
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

  QueryBuilder<TechnicianReport, TechnicianReport, QAfterFilterCondition>
      managerEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'manager',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TechnicianReport, TechnicianReport, QAfterFilterCondition>
      managerGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'manager',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TechnicianReport, TechnicianReport, QAfterFilterCondition>
      managerLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'manager',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TechnicianReport, TechnicianReport, QAfterFilterCondition>
      managerBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'manager',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TechnicianReport, TechnicianReport, QAfterFilterCondition>
      managerStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'manager',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TechnicianReport, TechnicianReport, QAfterFilterCondition>
      managerEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'manager',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TechnicianReport, TechnicianReport, QAfterFilterCondition>
      managerContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'manager',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TechnicianReport, TechnicianReport, QAfterFilterCondition>
      managerMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'manager',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TechnicianReport, TechnicianReport, QAfterFilterCondition>
      managerIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'manager',
        value: '',
      ));
    });
  }

  QueryBuilder<TechnicianReport, TechnicianReport, QAfterFilterCondition>
      managerIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'manager',
        value: '',
      ));
    });
  }

  QueryBuilder<TechnicianReport, TechnicianReport, QAfterFilterCondition>
      modelTypeEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'modelType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TechnicianReport, TechnicianReport, QAfterFilterCondition>
      modelTypeGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'modelType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TechnicianReport, TechnicianReport, QAfterFilterCondition>
      modelTypeLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'modelType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TechnicianReport, TechnicianReport, QAfterFilterCondition>
      modelTypeBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'modelType',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TechnicianReport, TechnicianReport, QAfterFilterCondition>
      modelTypeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'modelType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TechnicianReport, TechnicianReport, QAfterFilterCondition>
      modelTypeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'modelType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TechnicianReport, TechnicianReport, QAfterFilterCondition>
      modelTypeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'modelType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TechnicianReport, TechnicianReport, QAfterFilterCondition>
      modelTypeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'modelType',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TechnicianReport, TechnicianReport, QAfterFilterCondition>
      modelTypeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'modelType',
        value: '',
      ));
    });
  }

  QueryBuilder<TechnicianReport, TechnicianReport, QAfterFilterCondition>
      modelTypeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'modelType',
        value: '',
      ));
    });
  }

  QueryBuilder<TechnicianReport, TechnicianReport, QAfterFilterCondition>
      reparationEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'reparation',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TechnicianReport, TechnicianReport, QAfterFilterCondition>
      reparationGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'reparation',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TechnicianReport, TechnicianReport, QAfterFilterCondition>
      reparationLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'reparation',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TechnicianReport, TechnicianReport, QAfterFilterCondition>
      reparationBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'reparation',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TechnicianReport, TechnicianReport, QAfterFilterCondition>
      reparationStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'reparation',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TechnicianReport, TechnicianReport, QAfterFilterCondition>
      reparationEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'reparation',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TechnicianReport, TechnicianReport, QAfterFilterCondition>
      reparationContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'reparation',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TechnicianReport, TechnicianReport, QAfterFilterCondition>
      reparationMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'reparation',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TechnicianReport, TechnicianReport, QAfterFilterCondition>
      reparationIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'reparation',
        value: '',
      ));
    });
  }

  QueryBuilder<TechnicianReport, TechnicianReport, QAfterFilterCondition>
      reparationIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'reparation',
        value: '',
      ));
    });
  }

  QueryBuilder<TechnicianReport, TechnicianReport, QAfterFilterCondition>
      signaturePngIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'signaturePng',
      ));
    });
  }

  QueryBuilder<TechnicianReport, TechnicianReport, QAfterFilterCondition>
      signaturePngIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'signaturePng',
      ));
    });
  }

  QueryBuilder<TechnicianReport, TechnicianReport, QAfterFilterCondition>
      signaturePngElementEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'signaturePng',
        value: value,
      ));
    });
  }

  QueryBuilder<TechnicianReport, TechnicianReport, QAfterFilterCondition>
      signaturePngElementGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'signaturePng',
        value: value,
      ));
    });
  }

  QueryBuilder<TechnicianReport, TechnicianReport, QAfterFilterCondition>
      signaturePngElementLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'signaturePng',
        value: value,
      ));
    });
  }

  QueryBuilder<TechnicianReport, TechnicianReport, QAfterFilterCondition>
      signaturePngElementBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'signaturePng',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<TechnicianReport, TechnicianReport, QAfterFilterCondition>
      signaturePngLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'signaturePng',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<TechnicianReport, TechnicianReport, QAfterFilterCondition>
      signaturePngIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'signaturePng',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<TechnicianReport, TechnicianReport, QAfterFilterCondition>
      signaturePngIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'signaturePng',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<TechnicianReport, TechnicianReport, QAfterFilterCondition>
      signaturePngLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'signaturePng',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<TechnicianReport, TechnicianReport, QAfterFilterCondition>
      signaturePngLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'signaturePng',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<TechnicianReport, TechnicianReport, QAfterFilterCondition>
      signaturePngLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'signaturePng',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<TechnicianReport, TechnicianReport, QAfterFilterCondition>
      technicianEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'technician',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TechnicianReport, TechnicianReport, QAfterFilterCondition>
      technicianGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'technician',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TechnicianReport, TechnicianReport, QAfterFilterCondition>
      technicianLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'technician',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TechnicianReport, TechnicianReport, QAfterFilterCondition>
      technicianBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'technician',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TechnicianReport, TechnicianReport, QAfterFilterCondition>
      technicianStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'technician',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TechnicianReport, TechnicianReport, QAfterFilterCondition>
      technicianEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'technician',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TechnicianReport, TechnicianReport, QAfterFilterCondition>
      technicianContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'technician',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TechnicianReport, TechnicianReport, QAfterFilterCondition>
      technicianMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'technician',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TechnicianReport, TechnicianReport, QAfterFilterCondition>
      technicianIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'technician',
        value: '',
      ));
    });
  }

  QueryBuilder<TechnicianReport, TechnicianReport, QAfterFilterCondition>
      technicianIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'technician',
        value: '',
      ));
    });
  }
}

extension TechnicianReportQueryObject
    on QueryBuilder<TechnicianReport, TechnicianReport, QFilterCondition> {}

extension TechnicianReportQueryLinks
    on QueryBuilder<TechnicianReport, TechnicianReport, QFilterCondition> {}

extension TechnicianReportQuerySortBy
    on QueryBuilder<TechnicianReport, TechnicianReport, QSortBy> {
  QueryBuilder<TechnicianReport, TechnicianReport, QAfterSortBy>
      sortByArrive() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'arrive', Sort.asc);
    });
  }

  QueryBuilder<TechnicianReport, TechnicianReport, QAfterSortBy>
      sortByArriveDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'arrive', Sort.desc);
    });
  }

  QueryBuilder<TechnicianReport, TechnicianReport, QAfterSortBy> sortByCode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'code', Sort.asc);
    });
  }

  QueryBuilder<TechnicianReport, TechnicianReport, QAfterSortBy>
      sortByCodeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'code', Sort.desc);
    });
  }

  QueryBuilder<TechnicianReport, TechnicianReport, QAfterSortBy>
      sortByDepart() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'depart', Sort.asc);
    });
  }

  QueryBuilder<TechnicianReport, TechnicianReport, QAfterSortBy>
      sortByDepartDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'depart', Sort.desc);
    });
  }

  QueryBuilder<TechnicianReport, TechnicianReport, QAfterSortBy>
      sortByDiagnosis() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'diagnosis', Sort.asc);
    });
  }

  QueryBuilder<TechnicianReport, TechnicianReport, QAfterSortBy>
      sortByDiagnosisDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'diagnosis', Sort.desc);
    });
  }

  QueryBuilder<TechnicianReport, TechnicianReport, QAfterSortBy>
      sortByManager() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'manager', Sort.asc);
    });
  }

  QueryBuilder<TechnicianReport, TechnicianReport, QAfterSortBy>
      sortByManagerDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'manager', Sort.desc);
    });
  }

  QueryBuilder<TechnicianReport, TechnicianReport, QAfterSortBy>
      sortByModelType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'modelType', Sort.asc);
    });
  }

  QueryBuilder<TechnicianReport, TechnicianReport, QAfterSortBy>
      sortByModelTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'modelType', Sort.desc);
    });
  }

  QueryBuilder<TechnicianReport, TechnicianReport, QAfterSortBy>
      sortByReparation() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reparation', Sort.asc);
    });
  }

  QueryBuilder<TechnicianReport, TechnicianReport, QAfterSortBy>
      sortByReparationDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reparation', Sort.desc);
    });
  }

  QueryBuilder<TechnicianReport, TechnicianReport, QAfterSortBy>
      sortByTechnician() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'technician', Sort.asc);
    });
  }

  QueryBuilder<TechnicianReport, TechnicianReport, QAfterSortBy>
      sortByTechnicianDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'technician', Sort.desc);
    });
  }
}

extension TechnicianReportQuerySortThenBy
    on QueryBuilder<TechnicianReport, TechnicianReport, QSortThenBy> {
  QueryBuilder<TechnicianReport, TechnicianReport, QAfterSortBy>
      thenByArrive() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'arrive', Sort.asc);
    });
  }

  QueryBuilder<TechnicianReport, TechnicianReport, QAfterSortBy>
      thenByArriveDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'arrive', Sort.desc);
    });
  }

  QueryBuilder<TechnicianReport, TechnicianReport, QAfterSortBy> thenByCode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'code', Sort.asc);
    });
  }

  QueryBuilder<TechnicianReport, TechnicianReport, QAfterSortBy>
      thenByCodeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'code', Sort.desc);
    });
  }

  QueryBuilder<TechnicianReport, TechnicianReport, QAfterSortBy>
      thenByDepart() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'depart', Sort.asc);
    });
  }

  QueryBuilder<TechnicianReport, TechnicianReport, QAfterSortBy>
      thenByDepartDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'depart', Sort.desc);
    });
  }

  QueryBuilder<TechnicianReport, TechnicianReport, QAfterSortBy>
      thenByDiagnosis() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'diagnosis', Sort.asc);
    });
  }

  QueryBuilder<TechnicianReport, TechnicianReport, QAfterSortBy>
      thenByDiagnosisDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'diagnosis', Sort.desc);
    });
  }

  QueryBuilder<TechnicianReport, TechnicianReport, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<TechnicianReport, TechnicianReport, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<TechnicianReport, TechnicianReport, QAfterSortBy>
      thenByManager() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'manager', Sort.asc);
    });
  }

  QueryBuilder<TechnicianReport, TechnicianReport, QAfterSortBy>
      thenByManagerDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'manager', Sort.desc);
    });
  }

  QueryBuilder<TechnicianReport, TechnicianReport, QAfterSortBy>
      thenByModelType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'modelType', Sort.asc);
    });
  }

  QueryBuilder<TechnicianReport, TechnicianReport, QAfterSortBy>
      thenByModelTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'modelType', Sort.desc);
    });
  }

  QueryBuilder<TechnicianReport, TechnicianReport, QAfterSortBy>
      thenByReparation() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reparation', Sort.asc);
    });
  }

  QueryBuilder<TechnicianReport, TechnicianReport, QAfterSortBy>
      thenByReparationDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reparation', Sort.desc);
    });
  }

  QueryBuilder<TechnicianReport, TechnicianReport, QAfterSortBy>
      thenByTechnician() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'technician', Sort.asc);
    });
  }

  QueryBuilder<TechnicianReport, TechnicianReport, QAfterSortBy>
      thenByTechnicianDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'technician', Sort.desc);
    });
  }
}

extension TechnicianReportQueryWhereDistinct
    on QueryBuilder<TechnicianReport, TechnicianReport, QDistinct> {
  QueryBuilder<TechnicianReport, TechnicianReport, QDistinct>
      distinctByArrive() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'arrive');
    });
  }

  QueryBuilder<TechnicianReport, TechnicianReport, QDistinct> distinctByCode(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'code', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TechnicianReport, TechnicianReport, QDistinct>
      distinctByDepart() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'depart');
    });
  }

  QueryBuilder<TechnicianReport, TechnicianReport, QDistinct>
      distinctByDiagnosis({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'diagnosis', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TechnicianReport, TechnicianReport, QDistinct> distinctByManager(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'manager', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TechnicianReport, TechnicianReport, QDistinct>
      distinctByModelType({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'modelType', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TechnicianReport, TechnicianReport, QDistinct>
      distinctByReparation({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'reparation', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TechnicianReport, TechnicianReport, QDistinct>
      distinctBySignaturePng() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'signaturePng');
    });
  }

  QueryBuilder<TechnicianReport, TechnicianReport, QDistinct>
      distinctByTechnician({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'technician', caseSensitive: caseSensitive);
    });
  }
}

extension TechnicianReportQueryProperty
    on QueryBuilder<TechnicianReport, TechnicianReport, QQueryProperty> {
  QueryBuilder<TechnicianReport, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<TechnicianReport, DateTime, QQueryOperations> arriveProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'arrive');
    });
  }

  QueryBuilder<TechnicianReport, String, QQueryOperations> codeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'code');
    });
  }

  QueryBuilder<TechnicianReport, DateTime, QQueryOperations> departProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'depart');
    });
  }

  QueryBuilder<TechnicianReport, String, QQueryOperations> diagnosisProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'diagnosis');
    });
  }

  QueryBuilder<TechnicianReport, String, QQueryOperations> managerProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'manager');
    });
  }

  QueryBuilder<TechnicianReport, String, QQueryOperations> modelTypeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'modelType');
    });
  }

  QueryBuilder<TechnicianReport, String, QQueryOperations>
      reparationProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'reparation');
    });
  }

  QueryBuilder<TechnicianReport, List<int>?, QQueryOperations>
      signaturePngProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'signaturePng');
    });
  }

  QueryBuilder<TechnicianReport, String, QQueryOperations>
      technicianProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'technician');
    });
  }
}
