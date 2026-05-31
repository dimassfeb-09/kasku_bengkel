// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'service_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ServiceItem _$ServiceItemFromJson(Map<String, dynamic> json) {
  switch (json['runtimeType']) {
    case 'labor':
      return LaborItem.fromJson(json);
    case 'part':
      return PartItem.fromJson(json);

    default:
      throw CheckedFromJsonException(
        json,
        'runtimeType',
        'ServiceItem',
        'Invalid union type "${json['runtimeType']}"!',
      );
  }
}

/// @nodoc
mixin _$ServiceItem {
  String get name => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String name, double price) labor,
    required TResult Function(String name, int quantity, double unitPrice) part,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String name, double price)? labor,
    TResult? Function(String name, int quantity, double unitPrice)? part,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String name, double price)? labor,
    TResult Function(String name, int quantity, double unitPrice)? part,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LaborItem value) labor,
    required TResult Function(PartItem value) part,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LaborItem value)? labor,
    TResult? Function(PartItem value)? part,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LaborItem value)? labor,
    TResult Function(PartItem value)? part,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;

  /// Serializes this ServiceItem to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ServiceItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ServiceItemCopyWith<ServiceItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ServiceItemCopyWith<$Res> {
  factory $ServiceItemCopyWith(
    ServiceItem value,
    $Res Function(ServiceItem) then,
  ) = _$ServiceItemCopyWithImpl<$Res, ServiceItem>;
  @useResult
  $Res call({String name});
}

/// @nodoc
class _$ServiceItemCopyWithImpl<$Res, $Val extends ServiceItem>
    implements $ServiceItemCopyWith<$Res> {
  _$ServiceItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ServiceItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? name = null}) {
    return _then(
      _value.copyWith(
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$LaborItemImplCopyWith<$Res>
    implements $ServiceItemCopyWith<$Res> {
  factory _$$LaborItemImplCopyWith(
    _$LaborItemImpl value,
    $Res Function(_$LaborItemImpl) then,
  ) = __$$LaborItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String name, double price});
}

/// @nodoc
class __$$LaborItemImplCopyWithImpl<$Res>
    extends _$ServiceItemCopyWithImpl<$Res, _$LaborItemImpl>
    implements _$$LaborItemImplCopyWith<$Res> {
  __$$LaborItemImplCopyWithImpl(
    _$LaborItemImpl _value,
    $Res Function(_$LaborItemImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ServiceItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? name = null, Object? price = null}) {
    return _then(
      _$LaborItemImpl(
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        price: null == price
            ? _value.price
            : price // ignore: cast_nullable_to_non_nullable
                  as double,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$LaborItemImpl extends LaborItem {
  const _$LaborItemImpl({
    required this.name,
    required this.price,
    final String? $type,
  }) : $type = $type ?? 'labor',
       super._();

  factory _$LaborItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$LaborItemImplFromJson(json);

  @override
  final String name;
  @override
  final double price;

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'ServiceItem.labor(name: $name, price: $price)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LaborItemImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.price, price) || other.price == price));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, name, price);

  /// Create a copy of ServiceItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LaborItemImplCopyWith<_$LaborItemImpl> get copyWith =>
      __$$LaborItemImplCopyWithImpl<_$LaborItemImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String name, double price) labor,
    required TResult Function(String name, int quantity, double unitPrice) part,
  }) {
    return labor(name, price);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String name, double price)? labor,
    TResult? Function(String name, int quantity, double unitPrice)? part,
  }) {
    return labor?.call(name, price);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String name, double price)? labor,
    TResult Function(String name, int quantity, double unitPrice)? part,
    required TResult orElse(),
  }) {
    if (labor != null) {
      return labor(name, price);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LaborItem value) labor,
    required TResult Function(PartItem value) part,
  }) {
    return labor(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LaborItem value)? labor,
    TResult? Function(PartItem value)? part,
  }) {
    return labor?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LaborItem value)? labor,
    TResult Function(PartItem value)? part,
    required TResult orElse(),
  }) {
    if (labor != null) {
      return labor(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$LaborItemImplToJson(this);
  }
}

abstract class LaborItem extends ServiceItem {
  const factory LaborItem({
    required final String name,
    required final double price,
  }) = _$LaborItemImpl;
  const LaborItem._() : super._();

  factory LaborItem.fromJson(Map<String, dynamic> json) =
      _$LaborItemImpl.fromJson;

  @override
  String get name;
  double get price;

  /// Create a copy of ServiceItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LaborItemImplCopyWith<_$LaborItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$PartItemImplCopyWith<$Res>
    implements $ServiceItemCopyWith<$Res> {
  factory _$$PartItemImplCopyWith(
    _$PartItemImpl value,
    $Res Function(_$PartItemImpl) then,
  ) = __$$PartItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String name, int quantity, double unitPrice});
}

/// @nodoc
class __$$PartItemImplCopyWithImpl<$Res>
    extends _$ServiceItemCopyWithImpl<$Res, _$PartItemImpl>
    implements _$$PartItemImplCopyWith<$Res> {
  __$$PartItemImplCopyWithImpl(
    _$PartItemImpl _value,
    $Res Function(_$PartItemImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ServiceItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? quantity = null,
    Object? unitPrice = null,
  }) {
    return _then(
      _$PartItemImpl(
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        quantity: null == quantity
            ? _value.quantity
            : quantity // ignore: cast_nullable_to_non_nullable
                  as int,
        unitPrice: null == unitPrice
            ? _value.unitPrice
            : unitPrice // ignore: cast_nullable_to_non_nullable
                  as double,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PartItemImpl extends PartItem {
  const _$PartItemImpl({
    required this.name,
    required this.quantity,
    required this.unitPrice,
    final String? $type,
  }) : $type = $type ?? 'part',
       super._();

  factory _$PartItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$PartItemImplFromJson(json);

  @override
  final String name;
  @override
  final int quantity;
  @override
  final double unitPrice;

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'ServiceItem.part(name: $name, quantity: $quantity, unitPrice: $unitPrice)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PartItemImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity) &&
            (identical(other.unitPrice, unitPrice) ||
                other.unitPrice == unitPrice));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, name, quantity, unitPrice);

  /// Create a copy of ServiceItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PartItemImplCopyWith<_$PartItemImpl> get copyWith =>
      __$$PartItemImplCopyWithImpl<_$PartItemImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String name, double price) labor,
    required TResult Function(String name, int quantity, double unitPrice) part,
  }) {
    return part(name, quantity, unitPrice);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String name, double price)? labor,
    TResult? Function(String name, int quantity, double unitPrice)? part,
  }) {
    return part?.call(name, quantity, unitPrice);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String name, double price)? labor,
    TResult Function(String name, int quantity, double unitPrice)? part,
    required TResult orElse(),
  }) {
    if (part != null) {
      return part(name, quantity, unitPrice);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(LaborItem value) labor,
    required TResult Function(PartItem value) part,
  }) {
    return part(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(LaborItem value)? labor,
    TResult? Function(PartItem value)? part,
  }) {
    return part?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(LaborItem value)? labor,
    TResult Function(PartItem value)? part,
    required TResult orElse(),
  }) {
    if (part != null) {
      return part(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$PartItemImplToJson(this);
  }
}

abstract class PartItem extends ServiceItem {
  const factory PartItem({
    required final String name,
    required final int quantity,
    required final double unitPrice,
  }) = _$PartItemImpl;
  const PartItem._() : super._();

  factory PartItem.fromJson(Map<String, dynamic> json) =
      _$PartItemImpl.fromJson;

  @override
  String get name;
  int get quantity;
  double get unitPrice;

  /// Create a copy of ServiceItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PartItemImplCopyWith<_$PartItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
