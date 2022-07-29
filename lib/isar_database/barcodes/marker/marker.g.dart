// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: no_leading_underscores_for_local_identifiers

part of 'marker.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, unused_local_variable

extension GetMarkerCollection on Isar {
  IsarCollection<Marker> get markers => getCollection();
}

const MarkerSchema = CollectionSchema(
  name: 'Marker',
  schema:
      '{"name":"Marker","idName":"id","properties":[{"name":"barcodeUID","type":"String"},{"name":"hashCode","type":"Long"},{"name":"parentContainerUID","type":"String"}],"indexes":[],"links":[]}',
  idName: 'id',
  propertyIds: {'barcodeUID': 0, 'hashCode': 1, 'parentContainerUID': 2},
  listProperties: {},
  indexIds: {},
  indexValueTypes: {},
  linkIds: {},
  backlinkLinkNames: {},
  getId: _markerGetId,
  setId: _markerSetId,
  getLinks: _markerGetLinks,
  attachLinks: _markerAttachLinks,
  serializeNative: _markerSerializeNative,
  deserializeNative: _markerDeserializeNative,
  deserializePropNative: _markerDeserializePropNative,
  serializeWeb: _markerSerializeWeb,
  deserializeWeb: _markerDeserializeWeb,
  deserializePropWeb: _markerDeserializePropWeb,
  version: 3,
);

int? _markerGetId(Marker object) {
  if (object.id == Isar.autoIncrement) {
    return null;
  } else {
    return object.id;
  }
}

void _markerSetId(Marker object, int id) {
  object.id = id;
}

List<IsarLinkBase> _markerGetLinks(Marker object) {
  return [];
}

void _markerSerializeNative(
    IsarCollection<Marker> collection,
    IsarRawObject rawObj,
    Marker object,
    int staticSize,
    List<int> offsets,
    AdapterAlloc alloc) {
  var dynamicSize = 0;
  final value0 = object.barcodeUID;
  final _barcodeUID = IsarBinaryWriter.utf8Encoder.convert(value0);
  dynamicSize += (_barcodeUID.length) as int;
  final value1 = object.hashCode;
  final _hashCode = value1;
  final value2 = object.parentContainerUID;
  IsarUint8List? _parentContainerUID;
  if (value2 != null) {
    _parentContainerUID = IsarBinaryWriter.utf8Encoder.convert(value2);
  }
  dynamicSize += (_parentContainerUID?.length ?? 0) as int;
  final size = staticSize + dynamicSize;

  rawObj.buffer = alloc(size);
  rawObj.buffer_length = size;
  final buffer = IsarNative.bufAsBytes(rawObj.buffer, size);
  final writer = IsarBinaryWriter(buffer, staticSize);
  writer.writeBytes(offsets[0], _barcodeUID);
  writer.writeLong(offsets[1], _hashCode);
  writer.writeBytes(offsets[2], _parentContainerUID);
}

Marker _markerDeserializeNative(IsarCollection<Marker> collection, int id,
    IsarBinaryReader reader, List<int> offsets) {
  final object = Marker();
  object.barcodeUID = reader.readString(offsets[0]);
  object.id = id;
  object.parentContainerUID = reader.readStringOrNull(offsets[2]);
  return object;
}

P _markerDeserializePropNative<P>(
    int id, IsarBinaryReader reader, int propertyIndex, int offset) {
  switch (propertyIndex) {
    case -1:
      return id as P;
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readLong(offset)) as P;
    case 2:
      return (reader.readStringOrNull(offset)) as P;
    default:
      throw 'Illegal propertyIndex';
  }
}

dynamic _markerSerializeWeb(IsarCollection<Marker> collection, Marker object) {
  final jsObj = IsarNative.newJsObject();
  IsarNative.jsObjectSet(jsObj, 'barcodeUID', object.barcodeUID);
  IsarNative.jsObjectSet(jsObj, 'hashCode', object.hashCode);
  IsarNative.jsObjectSet(jsObj, 'id', object.id);
  IsarNative.jsObjectSet(
      jsObj, 'parentContainerUID', object.parentContainerUID);
  return jsObj;
}

Marker _markerDeserializeWeb(IsarCollection<Marker> collection, dynamic jsObj) {
  final object = Marker();
  object.barcodeUID = IsarNative.jsObjectGet(jsObj, 'barcodeUID') ?? '';
  object.id = IsarNative.jsObjectGet(jsObj, 'id') ?? double.negativeInfinity;
  object.parentContainerUID =
      IsarNative.jsObjectGet(jsObj, 'parentContainerUID');
  return object;
}

P _markerDeserializePropWeb<P>(Object jsObj, String propertyName) {
  switch (propertyName) {
    case 'barcodeUID':
      return (IsarNative.jsObjectGet(jsObj, 'barcodeUID') ?? '') as P;
    case 'hashCode':
      return (IsarNative.jsObjectGet(jsObj, 'hashCode') ??
          double.negativeInfinity) as P;
    case 'id':
      return (IsarNative.jsObjectGet(jsObj, 'id') ?? double.negativeInfinity)
          as P;
    case 'parentContainerUID':
      return (IsarNative.jsObjectGet(jsObj, 'parentContainerUID')) as P;
    default:
      throw 'Illegal propertyName';
  }
}

void _markerAttachLinks(IsarCollection col, int id, Marker object) {}

extension MarkerQueryWhereSort on QueryBuilder<Marker, Marker, QWhere> {
  QueryBuilder<Marker, Marker, QAfterWhere> anyId() {
    return addWhereClauseInternal(const IdWhereClause.any());
  }
}

extension MarkerQueryWhere on QueryBuilder<Marker, Marker, QWhereClause> {
  QueryBuilder<Marker, Marker, QAfterWhereClause> idEqualTo(int id) {
    return addWhereClauseInternal(IdWhereClause.between(
      lower: id,
      includeLower: true,
      upper: id,
      includeUpper: true,
    ));
  }

  QueryBuilder<Marker, Marker, QAfterWhereClause> idNotEqualTo(int id) {
    if (whereSortInternal == Sort.asc) {
      return addWhereClauseInternal(
        IdWhereClause.lessThan(upper: id, includeUpper: false),
      ).addWhereClauseInternal(
        IdWhereClause.greaterThan(lower: id, includeLower: false),
      );
    } else {
      return addWhereClauseInternal(
        IdWhereClause.greaterThan(lower: id, includeLower: false),
      ).addWhereClauseInternal(
        IdWhereClause.lessThan(upper: id, includeUpper: false),
      );
    }
  }

  QueryBuilder<Marker, Marker, QAfterWhereClause> idGreaterThan(int id,
      {bool include = false}) {
    return addWhereClauseInternal(
      IdWhereClause.greaterThan(lower: id, includeLower: include),
    );
  }

  QueryBuilder<Marker, Marker, QAfterWhereClause> idLessThan(int id,
      {bool include = false}) {
    return addWhereClauseInternal(
      IdWhereClause.lessThan(upper: id, includeUpper: include),
    );
  }

  QueryBuilder<Marker, Marker, QAfterWhereClause> idBetween(
    int lowerId,
    int upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addWhereClauseInternal(IdWhereClause.between(
      lower: lowerId,
      includeLower: includeLower,
      upper: upperId,
      includeUpper: includeUpper,
    ));
  }
}

extension MarkerQueryFilter on QueryBuilder<Marker, Marker, QFilterCondition> {
  QueryBuilder<Marker, Marker, QAfterFilterCondition> barcodeUIDEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'barcodeUID',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Marker, Marker, QAfterFilterCondition> barcodeUIDGreaterThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'barcodeUID',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Marker, Marker, QAfterFilterCondition> barcodeUIDLessThan(
    String value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'barcodeUID',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Marker, Marker, QAfterFilterCondition> barcodeUIDBetween(
    String lower,
    String upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'barcodeUID',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Marker, Marker, QAfterFilterCondition> barcodeUIDStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.startsWith,
      property: 'barcodeUID',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Marker, Marker, QAfterFilterCondition> barcodeUIDEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.endsWith,
      property: 'barcodeUID',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Marker, Marker, QAfterFilterCondition> barcodeUIDContains(
      String value,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'barcodeUID',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Marker, Marker, QAfterFilterCondition> barcodeUIDMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'barcodeUID',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Marker, Marker, QAfterFilterCondition> hashCodeEqualTo(
      int value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'hashCode',
      value: value,
    ));
  }

  QueryBuilder<Marker, Marker, QAfterFilterCondition> hashCodeGreaterThan(
    int value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'hashCode',
      value: value,
    ));
  }

  QueryBuilder<Marker, Marker, QAfterFilterCondition> hashCodeLessThan(
    int value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'hashCode',
      value: value,
    ));
  }

  QueryBuilder<Marker, Marker, QAfterFilterCondition> hashCodeBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'hashCode',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
    ));
  }

  QueryBuilder<Marker, Marker, QAfterFilterCondition> idEqualTo(int value) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'id',
      value: value,
    ));
  }

  QueryBuilder<Marker, Marker, QAfterFilterCondition> idGreaterThan(
    int value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'id',
      value: value,
    ));
  }

  QueryBuilder<Marker, Marker, QAfterFilterCondition> idLessThan(
    int value, {
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'id',
      value: value,
    ));
  }

  QueryBuilder<Marker, Marker, QAfterFilterCondition> idBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'id',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
    ));
  }

  QueryBuilder<Marker, Marker, QAfterFilterCondition>
      parentContainerUIDIsNull() {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.isNull,
      property: 'parentContainerUID',
      value: null,
    ));
  }

  QueryBuilder<Marker, Marker, QAfterFilterCondition> parentContainerUIDEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.eq,
      property: 'parentContainerUID',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Marker, Marker, QAfterFilterCondition>
      parentContainerUIDGreaterThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.gt,
      include: include,
      property: 'parentContainerUID',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Marker, Marker, QAfterFilterCondition>
      parentContainerUIDLessThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.lt,
      include: include,
      property: 'parentContainerUID',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Marker, Marker, QAfterFilterCondition> parentContainerUIDBetween(
    String? lower,
    String? upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return addFilterConditionInternal(FilterCondition.between(
      property: 'parentContainerUID',
      lower: lower,
      includeLower: includeLower,
      upper: upper,
      includeUpper: includeUpper,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Marker, Marker, QAfterFilterCondition>
      parentContainerUIDStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.startsWith,
      property: 'parentContainerUID',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Marker, Marker, QAfterFilterCondition>
      parentContainerUIDEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.endsWith,
      property: 'parentContainerUID',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Marker, Marker, QAfterFilterCondition>
      parentContainerUIDContains(String value, {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.contains,
      property: 'parentContainerUID',
      value: value,
      caseSensitive: caseSensitive,
    ));
  }

  QueryBuilder<Marker, Marker, QAfterFilterCondition> parentContainerUIDMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return addFilterConditionInternal(FilterCondition(
      type: ConditionType.matches,
      property: 'parentContainerUID',
      value: pattern,
      caseSensitive: caseSensitive,
    ));
  }
}

extension MarkerQueryLinks on QueryBuilder<Marker, Marker, QFilterCondition> {}

extension MarkerQueryWhereSortBy on QueryBuilder<Marker, Marker, QSortBy> {
  QueryBuilder<Marker, Marker, QAfterSortBy> sortByBarcodeUID() {
    return addSortByInternal('barcodeUID', Sort.asc);
  }

  QueryBuilder<Marker, Marker, QAfterSortBy> sortByBarcodeUIDDesc() {
    return addSortByInternal('barcodeUID', Sort.desc);
  }

  QueryBuilder<Marker, Marker, QAfterSortBy> sortByHashCode() {
    return addSortByInternal('hashCode', Sort.asc);
  }

  QueryBuilder<Marker, Marker, QAfterSortBy> sortByHashCodeDesc() {
    return addSortByInternal('hashCode', Sort.desc);
  }

  QueryBuilder<Marker, Marker, QAfterSortBy> sortById() {
    return addSortByInternal('id', Sort.asc);
  }

  QueryBuilder<Marker, Marker, QAfterSortBy> sortByIdDesc() {
    return addSortByInternal('id', Sort.desc);
  }

  QueryBuilder<Marker, Marker, QAfterSortBy> sortByParentContainerUID() {
    return addSortByInternal('parentContainerUID', Sort.asc);
  }

  QueryBuilder<Marker, Marker, QAfterSortBy> sortByParentContainerUIDDesc() {
    return addSortByInternal('parentContainerUID', Sort.desc);
  }
}

extension MarkerQueryWhereSortThenBy
    on QueryBuilder<Marker, Marker, QSortThenBy> {
  QueryBuilder<Marker, Marker, QAfterSortBy> thenByBarcodeUID() {
    return addSortByInternal('barcodeUID', Sort.asc);
  }

  QueryBuilder<Marker, Marker, QAfterSortBy> thenByBarcodeUIDDesc() {
    return addSortByInternal('barcodeUID', Sort.desc);
  }

  QueryBuilder<Marker, Marker, QAfterSortBy> thenByHashCode() {
    return addSortByInternal('hashCode', Sort.asc);
  }

  QueryBuilder<Marker, Marker, QAfterSortBy> thenByHashCodeDesc() {
    return addSortByInternal('hashCode', Sort.desc);
  }

  QueryBuilder<Marker, Marker, QAfterSortBy> thenById() {
    return addSortByInternal('id', Sort.asc);
  }

  QueryBuilder<Marker, Marker, QAfterSortBy> thenByIdDesc() {
    return addSortByInternal('id', Sort.desc);
  }

  QueryBuilder<Marker, Marker, QAfterSortBy> thenByParentContainerUID() {
    return addSortByInternal('parentContainerUID', Sort.asc);
  }

  QueryBuilder<Marker, Marker, QAfterSortBy> thenByParentContainerUIDDesc() {
    return addSortByInternal('parentContainerUID', Sort.desc);
  }
}

extension MarkerQueryWhereDistinct on QueryBuilder<Marker, Marker, QDistinct> {
  QueryBuilder<Marker, Marker, QDistinct> distinctByBarcodeUID(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('barcodeUID', caseSensitive: caseSensitive);
  }

  QueryBuilder<Marker, Marker, QDistinct> distinctByHashCode() {
    return addDistinctByInternal('hashCode');
  }

  QueryBuilder<Marker, Marker, QDistinct> distinctById() {
    return addDistinctByInternal('id');
  }

  QueryBuilder<Marker, Marker, QDistinct> distinctByParentContainerUID(
      {bool caseSensitive = true}) {
    return addDistinctByInternal('parentContainerUID',
        caseSensitive: caseSensitive);
  }
}

extension MarkerQueryProperty on QueryBuilder<Marker, Marker, QQueryProperty> {
  QueryBuilder<Marker, String, QQueryOperations> barcodeUIDProperty() {
    return addPropertyNameInternal('barcodeUID');
  }

  QueryBuilder<Marker, int, QQueryOperations> hashCodeProperty() {
    return addPropertyNameInternal('hashCode');
  }

  QueryBuilder<Marker, int, QQueryOperations> idProperty() {
    return addPropertyNameInternal('id');
  }

  QueryBuilder<Marker, String?, QQueryOperations> parentContainerUIDProperty() {
    return addPropertyNameInternal('parentContainerUID');
  }
}