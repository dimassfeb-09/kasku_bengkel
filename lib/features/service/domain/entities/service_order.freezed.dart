// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'service_order.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

VehicleInfo _$VehicleInfoFromJson(Map<String, dynamic> json) {
  return _VehicleInfo.fromJson(json);
}

/// @nodoc
mixin _$VehicleInfo {
  String get plateNumber => throw _privateConstructorUsedError;
  String get ownerName => throw _privateConstructorUsedError;
  String get ownerPhone => throw _privateConstructorUsedError;
  String get vehicleType => throw _privateConstructorUsedError;
  String? get vehicleBrand => throw _privateConstructorUsedError;
  String? get vehicleModel => throw _privateConstructorUsedError;

  /// Serializes this VehicleInfo to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of VehicleInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $VehicleInfoCopyWith<VehicleInfo> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $VehicleInfoCopyWith<$Res> {
  factory $VehicleInfoCopyWith(
    VehicleInfo value,
    $Res Function(VehicleInfo) then,
  ) = _$VehicleInfoCopyWithImpl<$Res, VehicleInfo>;
  @useResult
  $Res call({
    String plateNumber,
    String ownerName,
    String ownerPhone,
    String vehicleType,
    String? vehicleBrand,
    String? vehicleModel,
  });
}

/// @nodoc
class _$VehicleInfoCopyWithImpl<$Res, $Val extends VehicleInfo>
    implements $VehicleInfoCopyWith<$Res> {
  _$VehicleInfoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of VehicleInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? plateNumber = null,
    Object? ownerName = null,
    Object? ownerPhone = null,
    Object? vehicleType = null,
    Object? vehicleBrand = freezed,
    Object? vehicleModel = freezed,
  }) {
    return _then(
      _value.copyWith(
            plateNumber: null == plateNumber
                ? _value.plateNumber
                : plateNumber // ignore: cast_nullable_to_non_nullable
                      as String,
            ownerName: null == ownerName
                ? _value.ownerName
                : ownerName // ignore: cast_nullable_to_non_nullable
                      as String,
            ownerPhone: null == ownerPhone
                ? _value.ownerPhone
                : ownerPhone // ignore: cast_nullable_to_non_nullable
                      as String,
            vehicleType: null == vehicleType
                ? _value.vehicleType
                : vehicleType // ignore: cast_nullable_to_non_nullable
                      as String,
            vehicleBrand: freezed == vehicleBrand
                ? _value.vehicleBrand
                : vehicleBrand // ignore: cast_nullable_to_non_nullable
                      as String?,
            vehicleModel: freezed == vehicleModel
                ? _value.vehicleModel
                : vehicleModel // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$VehicleInfoImplCopyWith<$Res>
    implements $VehicleInfoCopyWith<$Res> {
  factory _$$VehicleInfoImplCopyWith(
    _$VehicleInfoImpl value,
    $Res Function(_$VehicleInfoImpl) then,
  ) = __$$VehicleInfoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String plateNumber,
    String ownerName,
    String ownerPhone,
    String vehicleType,
    String? vehicleBrand,
    String? vehicleModel,
  });
}

/// @nodoc
class __$$VehicleInfoImplCopyWithImpl<$Res>
    extends _$VehicleInfoCopyWithImpl<$Res, _$VehicleInfoImpl>
    implements _$$VehicleInfoImplCopyWith<$Res> {
  __$$VehicleInfoImplCopyWithImpl(
    _$VehicleInfoImpl _value,
    $Res Function(_$VehicleInfoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of VehicleInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? plateNumber = null,
    Object? ownerName = null,
    Object? ownerPhone = null,
    Object? vehicleType = null,
    Object? vehicleBrand = freezed,
    Object? vehicleModel = freezed,
  }) {
    return _then(
      _$VehicleInfoImpl(
        plateNumber: null == plateNumber
            ? _value.plateNumber
            : plateNumber // ignore: cast_nullable_to_non_nullable
                  as String,
        ownerName: null == ownerName
            ? _value.ownerName
            : ownerName // ignore: cast_nullable_to_non_nullable
                  as String,
        ownerPhone: null == ownerPhone
            ? _value.ownerPhone
            : ownerPhone // ignore: cast_nullable_to_non_nullable
                  as String,
        vehicleType: null == vehicleType
            ? _value.vehicleType
            : vehicleType // ignore: cast_nullable_to_non_nullable
                  as String,
        vehicleBrand: freezed == vehicleBrand
            ? _value.vehicleBrand
            : vehicleBrand // ignore: cast_nullable_to_non_nullable
                  as String?,
        vehicleModel: freezed == vehicleModel
            ? _value.vehicleModel
            : vehicleModel // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$VehicleInfoImpl implements _VehicleInfo {
  const _$VehicleInfoImpl({
    required this.plateNumber,
    required this.ownerName,
    required this.ownerPhone,
    required this.vehicleType,
    this.vehicleBrand,
    this.vehicleModel,
  });

  factory _$VehicleInfoImpl.fromJson(Map<String, dynamic> json) =>
      _$$VehicleInfoImplFromJson(json);

  @override
  final String plateNumber;
  @override
  final String ownerName;
  @override
  final String ownerPhone;
  @override
  final String vehicleType;
  @override
  final String? vehicleBrand;
  @override
  final String? vehicleModel;

  @override
  String toString() {
    return 'VehicleInfo(plateNumber: $plateNumber, ownerName: $ownerName, ownerPhone: $ownerPhone, vehicleType: $vehicleType, vehicleBrand: $vehicleBrand, vehicleModel: $vehicleModel)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$VehicleInfoImpl &&
            (identical(other.plateNumber, plateNumber) ||
                other.plateNumber == plateNumber) &&
            (identical(other.ownerName, ownerName) ||
                other.ownerName == ownerName) &&
            (identical(other.ownerPhone, ownerPhone) ||
                other.ownerPhone == ownerPhone) &&
            (identical(other.vehicleType, vehicleType) ||
                other.vehicleType == vehicleType) &&
            (identical(other.vehicleBrand, vehicleBrand) ||
                other.vehicleBrand == vehicleBrand) &&
            (identical(other.vehicleModel, vehicleModel) ||
                other.vehicleModel == vehicleModel));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    plateNumber,
    ownerName,
    ownerPhone,
    vehicleType,
    vehicleBrand,
    vehicleModel,
  );

  /// Create a copy of VehicleInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$VehicleInfoImplCopyWith<_$VehicleInfoImpl> get copyWith =>
      __$$VehicleInfoImplCopyWithImpl<_$VehicleInfoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$VehicleInfoImplToJson(this);
  }
}

abstract class _VehicleInfo implements VehicleInfo {
  const factory _VehicleInfo({
    required final String plateNumber,
    required final String ownerName,
    required final String ownerPhone,
    required final String vehicleType,
    final String? vehicleBrand,
    final String? vehicleModel,
  }) = _$VehicleInfoImpl;

  factory _VehicleInfo.fromJson(Map<String, dynamic> json) =
      _$VehicleInfoImpl.fromJson;

  @override
  String get plateNumber;
  @override
  String get ownerName;
  @override
  String get ownerPhone;
  @override
  String get vehicleType;
  @override
  String? get vehicleBrand;
  @override
  String? get vehicleModel;

  /// Create a copy of VehicleInfo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$VehicleInfoImplCopyWith<_$VehicleInfoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ServiceOrder _$ServiceOrderFromJson(Map<String, dynamic> json) {
  return _ServiceOrder.fromJson(json);
}

/// @nodoc
mixin _$ServiceOrder {
  String get id => throw _privateConstructorUsedError;
  String? get vehicleId =>
      throw _privateConstructorUsedError; // Added for master data reference
  VehicleInfo get vehicleInfo => throw _privateConstructorUsedError;
  String get complaint => throw _privateConstructorUsedError;
  String? get mechanicName => throw _privateConstructorUsedError;
  ServiceStatus get status => throw _privateConstructorUsedError;
  List<ServiceItem> get items => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;
  DateTime? get completedAt => throw _privateConstructorUsedError;
  DateTime? get readyAt => throw _privateConstructorUsedError;

  /// Serializes this ServiceOrder to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ServiceOrder
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ServiceOrderCopyWith<ServiceOrder> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ServiceOrderCopyWith<$Res> {
  factory $ServiceOrderCopyWith(
    ServiceOrder value,
    $Res Function(ServiceOrder) then,
  ) = _$ServiceOrderCopyWithImpl<$Res, ServiceOrder>;
  @useResult
  $Res call({
    String id,
    String? vehicleId,
    VehicleInfo vehicleInfo,
    String complaint,
    String? mechanicName,
    ServiceStatus status,
    List<ServiceItem> items,
    DateTime createdAt,
    DateTime updatedAt,
    DateTime? completedAt,
    DateTime? readyAt,
  });

  $VehicleInfoCopyWith<$Res> get vehicleInfo;
}

/// @nodoc
class _$ServiceOrderCopyWithImpl<$Res, $Val extends ServiceOrder>
    implements $ServiceOrderCopyWith<$Res> {
  _$ServiceOrderCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ServiceOrder
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? vehicleId = freezed,
    Object? vehicleInfo = null,
    Object? complaint = null,
    Object? mechanicName = freezed,
    Object? status = null,
    Object? items = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? completedAt = freezed,
    Object? readyAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            vehicleId: freezed == vehicleId
                ? _value.vehicleId
                : vehicleId // ignore: cast_nullable_to_non_nullable
                      as String?,
            vehicleInfo: null == vehicleInfo
                ? _value.vehicleInfo
                : vehicleInfo // ignore: cast_nullable_to_non_nullable
                      as VehicleInfo,
            complaint: null == complaint
                ? _value.complaint
                : complaint // ignore: cast_nullable_to_non_nullable
                      as String,
            mechanicName: freezed == mechanicName
                ? _value.mechanicName
                : mechanicName // ignore: cast_nullable_to_non_nullable
                      as String?,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as ServiceStatus,
            items: null == items
                ? _value.items
                : items // ignore: cast_nullable_to_non_nullable
                      as List<ServiceItem>,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            updatedAt: null == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            completedAt: freezed == completedAt
                ? _value.completedAt
                : completedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            readyAt: freezed == readyAt
                ? _value.readyAt
                : readyAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }

  /// Create a copy of ServiceOrder
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $VehicleInfoCopyWith<$Res> get vehicleInfo {
    return $VehicleInfoCopyWith<$Res>(_value.vehicleInfo, (value) {
      return _then(_value.copyWith(vehicleInfo: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ServiceOrderImplCopyWith<$Res>
    implements $ServiceOrderCopyWith<$Res> {
  factory _$$ServiceOrderImplCopyWith(
    _$ServiceOrderImpl value,
    $Res Function(_$ServiceOrderImpl) then,
  ) = __$$ServiceOrderImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String? vehicleId,
    VehicleInfo vehicleInfo,
    String complaint,
    String? mechanicName,
    ServiceStatus status,
    List<ServiceItem> items,
    DateTime createdAt,
    DateTime updatedAt,
    DateTime? completedAt,
    DateTime? readyAt,
  });

  @override
  $VehicleInfoCopyWith<$Res> get vehicleInfo;
}

/// @nodoc
class __$$ServiceOrderImplCopyWithImpl<$Res>
    extends _$ServiceOrderCopyWithImpl<$Res, _$ServiceOrderImpl>
    implements _$$ServiceOrderImplCopyWith<$Res> {
  __$$ServiceOrderImplCopyWithImpl(
    _$ServiceOrderImpl _value,
    $Res Function(_$ServiceOrderImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ServiceOrder
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? vehicleId = freezed,
    Object? vehicleInfo = null,
    Object? complaint = null,
    Object? mechanicName = freezed,
    Object? status = null,
    Object? items = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? completedAt = freezed,
    Object? readyAt = freezed,
  }) {
    return _then(
      _$ServiceOrderImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        vehicleId: freezed == vehicleId
            ? _value.vehicleId
            : vehicleId // ignore: cast_nullable_to_non_nullable
                  as String?,
        vehicleInfo: null == vehicleInfo
            ? _value.vehicleInfo
            : vehicleInfo // ignore: cast_nullable_to_non_nullable
                  as VehicleInfo,
        complaint: null == complaint
            ? _value.complaint
            : complaint // ignore: cast_nullable_to_non_nullable
                  as String,
        mechanicName: freezed == mechanicName
            ? _value.mechanicName
            : mechanicName // ignore: cast_nullable_to_non_nullable
                  as String?,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as ServiceStatus,
        items: null == items
            ? _value._items
            : items // ignore: cast_nullable_to_non_nullable
                  as List<ServiceItem>,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        updatedAt: null == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        completedAt: freezed == completedAt
            ? _value.completedAt
            : completedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        readyAt: freezed == readyAt
            ? _value.readyAt
            : readyAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ServiceOrderImpl extends _ServiceOrder {
  const _$ServiceOrderImpl({
    required this.id,
    this.vehicleId,
    required this.vehicleInfo,
    required this.complaint,
    this.mechanicName,
    this.status = ServiceStatus.antri,
    final List<ServiceItem> items = const [],
    required this.createdAt,
    required this.updatedAt,
    this.completedAt,
    this.readyAt,
  }) : _items = items,
       super._();

  factory _$ServiceOrderImpl.fromJson(Map<String, dynamic> json) =>
      _$$ServiceOrderImplFromJson(json);

  @override
  final String id;
  @override
  final String? vehicleId;
  // Added for master data reference
  @override
  final VehicleInfo vehicleInfo;
  @override
  final String complaint;
  @override
  final String? mechanicName;
  @override
  @JsonKey()
  final ServiceStatus status;
  final List<ServiceItem> _items;
  @override
  @JsonKey()
  List<ServiceItem> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;
  @override
  final DateTime? completedAt;
  @override
  final DateTime? readyAt;

  @override
  String toString() {
    return 'ServiceOrder(id: $id, vehicleId: $vehicleId, vehicleInfo: $vehicleInfo, complaint: $complaint, mechanicName: $mechanicName, status: $status, items: $items, createdAt: $createdAt, updatedAt: $updatedAt, completedAt: $completedAt, readyAt: $readyAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ServiceOrderImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.vehicleId, vehicleId) ||
                other.vehicleId == vehicleId) &&
            (identical(other.vehicleInfo, vehicleInfo) ||
                other.vehicleInfo == vehicleInfo) &&
            (identical(other.complaint, complaint) ||
                other.complaint == complaint) &&
            (identical(other.mechanicName, mechanicName) ||
                other.mechanicName == mechanicName) &&
            (identical(other.status, status) || other.status == status) &&
            const DeepCollectionEquality().equals(other._items, _items) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.completedAt, completedAt) ||
                other.completedAt == completedAt) &&
            (identical(other.readyAt, readyAt) || other.readyAt == readyAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    vehicleId,
    vehicleInfo,
    complaint,
    mechanicName,
    status,
    const DeepCollectionEquality().hash(_items),
    createdAt,
    updatedAt,
    completedAt,
    readyAt,
  );

  /// Create a copy of ServiceOrder
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ServiceOrderImplCopyWith<_$ServiceOrderImpl> get copyWith =>
      __$$ServiceOrderImplCopyWithImpl<_$ServiceOrderImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ServiceOrderImplToJson(this);
  }
}

abstract class _ServiceOrder extends ServiceOrder {
  const factory _ServiceOrder({
    required final String id,
    final String? vehicleId,
    required final VehicleInfo vehicleInfo,
    required final String complaint,
    final String? mechanicName,
    final ServiceStatus status,
    final List<ServiceItem> items,
    required final DateTime createdAt,
    required final DateTime updatedAt,
    final DateTime? completedAt,
    final DateTime? readyAt,
  }) = _$ServiceOrderImpl;
  const _ServiceOrder._() : super._();

  factory _ServiceOrder.fromJson(Map<String, dynamic> json) =
      _$ServiceOrderImpl.fromJson;

  @override
  String get id;
  @override
  String? get vehicleId; // Added for master data reference
  @override
  VehicleInfo get vehicleInfo;
  @override
  String get complaint;
  @override
  String? get mechanicName;
  @override
  ServiceStatus get status;
  @override
  List<ServiceItem> get items;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;
  @override
  DateTime? get completedAt;
  @override
  DateTime? get readyAt;

  /// Create a copy of ServiceOrder
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ServiceOrderImplCopyWith<_$ServiceOrderImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
