// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'custom_bank_rule.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetCustomBankRuleCollection on Isar {
  IsarCollection<CustomBankRule> get customBankRules => this.collection();
}

const CustomBankRuleSchema = CollectionSchema(
  name: r'CustomBankRule',
  id: -2598737789131276010,
  properties: {
    r'amountRegex': PropertySchema(
      id: 0,
      name: r'amountRegex',
      type: IsarType.string,
    ),
    r'balanceRegex': PropertySchema(
      id: 1,
      name: r'balanceRegex',
      type: IsarType.string,
    ),
    r'bankName': PropertySchema(
      id: 2,
      name: r'bankName',
      type: IsarType.string,
    ),
    r'createdAt': PropertySchema(
      id: 3,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'expenseKeyword': PropertySchema(
      id: 4,
      name: r'expenseKeyword',
      type: IsarType.string,
    ),
    r'incomeKeyword': PropertySchema(
      id: 5,
      name: r'incomeKeyword',
      type: IsarType.string,
    ),
    r'packageName': PropertySchema(
      id: 6,
      name: r'packageName',
      type: IsarType.string,
    )
  },
  estimateSize: _customBankRuleEstimateSize,
  serialize: _customBankRuleSerialize,
  deserialize: _customBankRuleDeserialize,
  deserializeProp: _customBankRuleDeserializeProp,
  idName: r'id',
  indexes: {
    r'packageName': IndexSchema(
      id: -3211024755902609907,
      name: r'packageName',
      unique: true,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'packageName',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _customBankRuleGetId,
  getLinks: _customBankRuleGetLinks,
  attach: _customBankRuleAttach,
  version: '3.1.0+1',
);

int _customBankRuleEstimateSize(
  CustomBankRule object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.amountRegex.length * 3;
  bytesCount += 3 + object.balanceRegex.length * 3;
  bytesCount += 3 + object.bankName.length * 3;
  bytesCount += 3 + object.expenseKeyword.length * 3;
  bytesCount += 3 + object.incomeKeyword.length * 3;
  bytesCount += 3 + object.packageName.length * 3;
  return bytesCount;
}

void _customBankRuleSerialize(
  CustomBankRule object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.amountRegex);
  writer.writeString(offsets[1], object.balanceRegex);
  writer.writeString(offsets[2], object.bankName);
  writer.writeDateTime(offsets[3], object.createdAt);
  writer.writeString(offsets[4], object.expenseKeyword);
  writer.writeString(offsets[5], object.incomeKeyword);
  writer.writeString(offsets[6], object.packageName);
}

CustomBankRule _customBankRuleDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = CustomBankRule();
  object.amountRegex = reader.readString(offsets[0]);
  object.balanceRegex = reader.readString(offsets[1]);
  object.bankName = reader.readString(offsets[2]);
  object.createdAt = reader.readDateTime(offsets[3]);
  object.expenseKeyword = reader.readString(offsets[4]);
  object.id = id;
  object.incomeKeyword = reader.readString(offsets[5]);
  object.packageName = reader.readString(offsets[6]);
  return object;
}

P _customBankRuleDeserializeProp<P>(
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
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readDateTime(offset)) as P;
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

Id _customBankRuleGetId(CustomBankRule object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _customBankRuleGetLinks(CustomBankRule object) {
  return [];
}

void _customBankRuleAttach(
    IsarCollection<dynamic> col, Id id, CustomBankRule object) {
  object.id = id;
}

extension CustomBankRuleByIndex on IsarCollection<CustomBankRule> {
  Future<CustomBankRule?> getByPackageName(String packageName) {
    return getByIndex(r'packageName', [packageName]);
  }

  CustomBankRule? getByPackageNameSync(String packageName) {
    return getByIndexSync(r'packageName', [packageName]);
  }

  Future<bool> deleteByPackageName(String packageName) {
    return deleteByIndex(r'packageName', [packageName]);
  }

  bool deleteByPackageNameSync(String packageName) {
    return deleteByIndexSync(r'packageName', [packageName]);
  }

  Future<List<CustomBankRule?>> getAllByPackageName(
      List<String> packageNameValues) {
    final values = packageNameValues.map((e) => [e]).toList();
    return getAllByIndex(r'packageName', values);
  }

  List<CustomBankRule?> getAllByPackageNameSync(
      List<String> packageNameValues) {
    final values = packageNameValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'packageName', values);
  }

  Future<int> deleteAllByPackageName(List<String> packageNameValues) {
    final values = packageNameValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'packageName', values);
  }

  int deleteAllByPackageNameSync(List<String> packageNameValues) {
    final values = packageNameValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'packageName', values);
  }

  Future<Id> putByPackageName(CustomBankRule object) {
    return putByIndex(r'packageName', object);
  }

  Id putByPackageNameSync(CustomBankRule object, {bool saveLinks = true}) {
    return putByIndexSync(r'packageName', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByPackageName(List<CustomBankRule> objects) {
    return putAllByIndex(r'packageName', objects);
  }

  List<Id> putAllByPackageNameSync(List<CustomBankRule> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'packageName', objects, saveLinks: saveLinks);
  }
}

extension CustomBankRuleQueryWhereSort
    on QueryBuilder<CustomBankRule, CustomBankRule, QWhere> {
  QueryBuilder<CustomBankRule, CustomBankRule, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension CustomBankRuleQueryWhere
    on QueryBuilder<CustomBankRule, CustomBankRule, QWhereClause> {
  QueryBuilder<CustomBankRule, CustomBankRule, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<CustomBankRule, CustomBankRule, QAfterWhereClause> idNotEqualTo(
      Id id) {
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

  QueryBuilder<CustomBankRule, CustomBankRule, QAfterWhereClause> idGreaterThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<CustomBankRule, CustomBankRule, QAfterWhereClause> idLessThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<CustomBankRule, CustomBankRule, QAfterWhereClause> idBetween(
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

  QueryBuilder<CustomBankRule, CustomBankRule, QAfterWhereClause>
      packageNameEqualTo(String packageName) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'packageName',
        value: [packageName],
      ));
    });
  }

  QueryBuilder<CustomBankRule, CustomBankRule, QAfterWhereClause>
      packageNameNotEqualTo(String packageName) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'packageName',
              lower: [],
              upper: [packageName],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'packageName',
              lower: [packageName],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'packageName',
              lower: [packageName],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'packageName',
              lower: [],
              upper: [packageName],
              includeUpper: false,
            ));
      }
    });
  }
}

extension CustomBankRuleQueryFilter
    on QueryBuilder<CustomBankRule, CustomBankRule, QFilterCondition> {
  QueryBuilder<CustomBankRule, CustomBankRule, QAfterFilterCondition>
      amountRegexEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'amountRegex',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CustomBankRule, CustomBankRule, QAfterFilterCondition>
      amountRegexGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'amountRegex',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CustomBankRule, CustomBankRule, QAfterFilterCondition>
      amountRegexLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'amountRegex',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CustomBankRule, CustomBankRule, QAfterFilterCondition>
      amountRegexBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'amountRegex',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CustomBankRule, CustomBankRule, QAfterFilterCondition>
      amountRegexStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'amountRegex',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CustomBankRule, CustomBankRule, QAfterFilterCondition>
      amountRegexEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'amountRegex',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CustomBankRule, CustomBankRule, QAfterFilterCondition>
      amountRegexContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'amountRegex',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CustomBankRule, CustomBankRule, QAfterFilterCondition>
      amountRegexMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'amountRegex',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CustomBankRule, CustomBankRule, QAfterFilterCondition>
      amountRegexIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'amountRegex',
        value: '',
      ));
    });
  }

  QueryBuilder<CustomBankRule, CustomBankRule, QAfterFilterCondition>
      amountRegexIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'amountRegex',
        value: '',
      ));
    });
  }

  QueryBuilder<CustomBankRule, CustomBankRule, QAfterFilterCondition>
      balanceRegexEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'balanceRegex',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CustomBankRule, CustomBankRule, QAfterFilterCondition>
      balanceRegexGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'balanceRegex',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CustomBankRule, CustomBankRule, QAfterFilterCondition>
      balanceRegexLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'balanceRegex',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CustomBankRule, CustomBankRule, QAfterFilterCondition>
      balanceRegexBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'balanceRegex',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CustomBankRule, CustomBankRule, QAfterFilterCondition>
      balanceRegexStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'balanceRegex',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CustomBankRule, CustomBankRule, QAfterFilterCondition>
      balanceRegexEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'balanceRegex',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CustomBankRule, CustomBankRule, QAfterFilterCondition>
      balanceRegexContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'balanceRegex',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CustomBankRule, CustomBankRule, QAfterFilterCondition>
      balanceRegexMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'balanceRegex',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CustomBankRule, CustomBankRule, QAfterFilterCondition>
      balanceRegexIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'balanceRegex',
        value: '',
      ));
    });
  }

  QueryBuilder<CustomBankRule, CustomBankRule, QAfterFilterCondition>
      balanceRegexIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'balanceRegex',
        value: '',
      ));
    });
  }

  QueryBuilder<CustomBankRule, CustomBankRule, QAfterFilterCondition>
      bankNameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'bankName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CustomBankRule, CustomBankRule, QAfterFilterCondition>
      bankNameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'bankName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CustomBankRule, CustomBankRule, QAfterFilterCondition>
      bankNameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'bankName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CustomBankRule, CustomBankRule, QAfterFilterCondition>
      bankNameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'bankName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CustomBankRule, CustomBankRule, QAfterFilterCondition>
      bankNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'bankName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CustomBankRule, CustomBankRule, QAfterFilterCondition>
      bankNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'bankName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CustomBankRule, CustomBankRule, QAfterFilterCondition>
      bankNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'bankName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CustomBankRule, CustomBankRule, QAfterFilterCondition>
      bankNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'bankName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CustomBankRule, CustomBankRule, QAfterFilterCondition>
      bankNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'bankName',
        value: '',
      ));
    });
  }

  QueryBuilder<CustomBankRule, CustomBankRule, QAfterFilterCondition>
      bankNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'bankName',
        value: '',
      ));
    });
  }

  QueryBuilder<CustomBankRule, CustomBankRule, QAfterFilterCondition>
      createdAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<CustomBankRule, CustomBankRule, QAfterFilterCondition>
      createdAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<CustomBankRule, CustomBankRule, QAfterFilterCondition>
      createdAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<CustomBankRule, CustomBankRule, QAfterFilterCondition>
      createdAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'createdAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<CustomBankRule, CustomBankRule, QAfterFilterCondition>
      expenseKeywordEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'expenseKeyword',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CustomBankRule, CustomBankRule, QAfterFilterCondition>
      expenseKeywordGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'expenseKeyword',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CustomBankRule, CustomBankRule, QAfterFilterCondition>
      expenseKeywordLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'expenseKeyword',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CustomBankRule, CustomBankRule, QAfterFilterCondition>
      expenseKeywordBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'expenseKeyword',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CustomBankRule, CustomBankRule, QAfterFilterCondition>
      expenseKeywordStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'expenseKeyword',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CustomBankRule, CustomBankRule, QAfterFilterCondition>
      expenseKeywordEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'expenseKeyword',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CustomBankRule, CustomBankRule, QAfterFilterCondition>
      expenseKeywordContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'expenseKeyword',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CustomBankRule, CustomBankRule, QAfterFilterCondition>
      expenseKeywordMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'expenseKeyword',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CustomBankRule, CustomBankRule, QAfterFilterCondition>
      expenseKeywordIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'expenseKeyword',
        value: '',
      ));
    });
  }

  QueryBuilder<CustomBankRule, CustomBankRule, QAfterFilterCondition>
      expenseKeywordIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'expenseKeyword',
        value: '',
      ));
    });
  }

  QueryBuilder<CustomBankRule, CustomBankRule, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<CustomBankRule, CustomBankRule, QAfterFilterCondition>
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

  QueryBuilder<CustomBankRule, CustomBankRule, QAfterFilterCondition>
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

  QueryBuilder<CustomBankRule, CustomBankRule, QAfterFilterCondition> idBetween(
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

  QueryBuilder<CustomBankRule, CustomBankRule, QAfterFilterCondition>
      incomeKeywordEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'incomeKeyword',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CustomBankRule, CustomBankRule, QAfterFilterCondition>
      incomeKeywordGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'incomeKeyword',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CustomBankRule, CustomBankRule, QAfterFilterCondition>
      incomeKeywordLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'incomeKeyword',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CustomBankRule, CustomBankRule, QAfterFilterCondition>
      incomeKeywordBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'incomeKeyword',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CustomBankRule, CustomBankRule, QAfterFilterCondition>
      incomeKeywordStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'incomeKeyword',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CustomBankRule, CustomBankRule, QAfterFilterCondition>
      incomeKeywordEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'incomeKeyword',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CustomBankRule, CustomBankRule, QAfterFilterCondition>
      incomeKeywordContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'incomeKeyword',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CustomBankRule, CustomBankRule, QAfterFilterCondition>
      incomeKeywordMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'incomeKeyword',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CustomBankRule, CustomBankRule, QAfterFilterCondition>
      incomeKeywordIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'incomeKeyword',
        value: '',
      ));
    });
  }

  QueryBuilder<CustomBankRule, CustomBankRule, QAfterFilterCondition>
      incomeKeywordIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'incomeKeyword',
        value: '',
      ));
    });
  }

  QueryBuilder<CustomBankRule, CustomBankRule, QAfterFilterCondition>
      packageNameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'packageName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CustomBankRule, CustomBankRule, QAfterFilterCondition>
      packageNameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'packageName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CustomBankRule, CustomBankRule, QAfterFilterCondition>
      packageNameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'packageName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CustomBankRule, CustomBankRule, QAfterFilterCondition>
      packageNameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'packageName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CustomBankRule, CustomBankRule, QAfterFilterCondition>
      packageNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'packageName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CustomBankRule, CustomBankRule, QAfterFilterCondition>
      packageNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'packageName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CustomBankRule, CustomBankRule, QAfterFilterCondition>
      packageNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'packageName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CustomBankRule, CustomBankRule, QAfterFilterCondition>
      packageNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'packageName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CustomBankRule, CustomBankRule, QAfterFilterCondition>
      packageNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'packageName',
        value: '',
      ));
    });
  }

  QueryBuilder<CustomBankRule, CustomBankRule, QAfterFilterCondition>
      packageNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'packageName',
        value: '',
      ));
    });
  }
}

extension CustomBankRuleQueryObject
    on QueryBuilder<CustomBankRule, CustomBankRule, QFilterCondition> {}

extension CustomBankRuleQueryLinks
    on QueryBuilder<CustomBankRule, CustomBankRule, QFilterCondition> {}

extension CustomBankRuleQuerySortBy
    on QueryBuilder<CustomBankRule, CustomBankRule, QSortBy> {
  QueryBuilder<CustomBankRule, CustomBankRule, QAfterSortBy>
      sortByAmountRegex() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amountRegex', Sort.asc);
    });
  }

  QueryBuilder<CustomBankRule, CustomBankRule, QAfterSortBy>
      sortByAmountRegexDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amountRegex', Sort.desc);
    });
  }

  QueryBuilder<CustomBankRule, CustomBankRule, QAfterSortBy>
      sortByBalanceRegex() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'balanceRegex', Sort.asc);
    });
  }

  QueryBuilder<CustomBankRule, CustomBankRule, QAfterSortBy>
      sortByBalanceRegexDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'balanceRegex', Sort.desc);
    });
  }

  QueryBuilder<CustomBankRule, CustomBankRule, QAfterSortBy> sortByBankName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bankName', Sort.asc);
    });
  }

  QueryBuilder<CustomBankRule, CustomBankRule, QAfterSortBy>
      sortByBankNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bankName', Sort.desc);
    });
  }

  QueryBuilder<CustomBankRule, CustomBankRule, QAfterSortBy> sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<CustomBankRule, CustomBankRule, QAfterSortBy>
      sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<CustomBankRule, CustomBankRule, QAfterSortBy>
      sortByExpenseKeyword() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'expenseKeyword', Sort.asc);
    });
  }

  QueryBuilder<CustomBankRule, CustomBankRule, QAfterSortBy>
      sortByExpenseKeywordDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'expenseKeyword', Sort.desc);
    });
  }

  QueryBuilder<CustomBankRule, CustomBankRule, QAfterSortBy>
      sortByIncomeKeyword() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'incomeKeyword', Sort.asc);
    });
  }

  QueryBuilder<CustomBankRule, CustomBankRule, QAfterSortBy>
      sortByIncomeKeywordDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'incomeKeyword', Sort.desc);
    });
  }

  QueryBuilder<CustomBankRule, CustomBankRule, QAfterSortBy>
      sortByPackageName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'packageName', Sort.asc);
    });
  }

  QueryBuilder<CustomBankRule, CustomBankRule, QAfterSortBy>
      sortByPackageNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'packageName', Sort.desc);
    });
  }
}

extension CustomBankRuleQuerySortThenBy
    on QueryBuilder<CustomBankRule, CustomBankRule, QSortThenBy> {
  QueryBuilder<CustomBankRule, CustomBankRule, QAfterSortBy>
      thenByAmountRegex() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amountRegex', Sort.asc);
    });
  }

  QueryBuilder<CustomBankRule, CustomBankRule, QAfterSortBy>
      thenByAmountRegexDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amountRegex', Sort.desc);
    });
  }

  QueryBuilder<CustomBankRule, CustomBankRule, QAfterSortBy>
      thenByBalanceRegex() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'balanceRegex', Sort.asc);
    });
  }

  QueryBuilder<CustomBankRule, CustomBankRule, QAfterSortBy>
      thenByBalanceRegexDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'balanceRegex', Sort.desc);
    });
  }

  QueryBuilder<CustomBankRule, CustomBankRule, QAfterSortBy> thenByBankName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bankName', Sort.asc);
    });
  }

  QueryBuilder<CustomBankRule, CustomBankRule, QAfterSortBy>
      thenByBankNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bankName', Sort.desc);
    });
  }

  QueryBuilder<CustomBankRule, CustomBankRule, QAfterSortBy> thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<CustomBankRule, CustomBankRule, QAfterSortBy>
      thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<CustomBankRule, CustomBankRule, QAfterSortBy>
      thenByExpenseKeyword() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'expenseKeyword', Sort.asc);
    });
  }

  QueryBuilder<CustomBankRule, CustomBankRule, QAfterSortBy>
      thenByExpenseKeywordDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'expenseKeyword', Sort.desc);
    });
  }

  QueryBuilder<CustomBankRule, CustomBankRule, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<CustomBankRule, CustomBankRule, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<CustomBankRule, CustomBankRule, QAfterSortBy>
      thenByIncomeKeyword() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'incomeKeyword', Sort.asc);
    });
  }

  QueryBuilder<CustomBankRule, CustomBankRule, QAfterSortBy>
      thenByIncomeKeywordDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'incomeKeyword', Sort.desc);
    });
  }

  QueryBuilder<CustomBankRule, CustomBankRule, QAfterSortBy>
      thenByPackageName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'packageName', Sort.asc);
    });
  }

  QueryBuilder<CustomBankRule, CustomBankRule, QAfterSortBy>
      thenByPackageNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'packageName', Sort.desc);
    });
  }
}

extension CustomBankRuleQueryWhereDistinct
    on QueryBuilder<CustomBankRule, CustomBankRule, QDistinct> {
  QueryBuilder<CustomBankRule, CustomBankRule, QDistinct> distinctByAmountRegex(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'amountRegex', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<CustomBankRule, CustomBankRule, QDistinct>
      distinctByBalanceRegex({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'balanceRegex', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<CustomBankRule, CustomBankRule, QDistinct> distinctByBankName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'bankName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<CustomBankRule, CustomBankRule, QDistinct>
      distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<CustomBankRule, CustomBankRule, QDistinct>
      distinctByExpenseKeyword({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'expenseKeyword',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<CustomBankRule, CustomBankRule, QDistinct>
      distinctByIncomeKeyword({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'incomeKeyword',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<CustomBankRule, CustomBankRule, QDistinct> distinctByPackageName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'packageName', caseSensitive: caseSensitive);
    });
  }
}

extension CustomBankRuleQueryProperty
    on QueryBuilder<CustomBankRule, CustomBankRule, QQueryProperty> {
  QueryBuilder<CustomBankRule, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<CustomBankRule, String, QQueryOperations> amountRegexProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'amountRegex');
    });
  }

  QueryBuilder<CustomBankRule, String, QQueryOperations>
      balanceRegexProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'balanceRegex');
    });
  }

  QueryBuilder<CustomBankRule, String, QQueryOperations> bankNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'bankName');
    });
  }

  QueryBuilder<CustomBankRule, DateTime, QQueryOperations> createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<CustomBankRule, String, QQueryOperations>
      expenseKeywordProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'expenseKeyword');
    });
  }

  QueryBuilder<CustomBankRule, String, QQueryOperations>
      incomeKeywordProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'incomeKeyword');
    });
  }

  QueryBuilder<CustomBankRule, String, QQueryOperations> packageNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'packageName');
    });
  }
}
