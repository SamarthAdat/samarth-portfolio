import '../error/exceptions.dart';

/// Typed, fail-loud accessors for decoded JSON maps.
///
/// Every miss throws [ContentParsingException] naming the offending key, so a
/// malformed payload surfaces as one clear error instead of a late
/// `Null is not a subtype of String` somewhere in the widget tree.
extension JsonMapReader on Map<String, dynamic> {
  String requireString(String key) {
    final Object? value = this[key];
    if (value is String) return value;
    throw ContentParsingException(
      'Expected a String at "$key" but found ${value.runtimeType}.',
    );
  }

  String? optionalString(String key) {
    final Object? value = this[key];
    if (value == null) return null;
    if (value is String) return value;
    throw ContentParsingException(
      'Expected a String or null at "$key" but found ${value.runtimeType}.',
    );
  }

  int requireInt(String key) {
    final Object? value = this[key];
    if (value is int) return value;
    throw ContentParsingException(
      'Expected an int at "$key" but found ${value.runtimeType}.',
    );
  }

  bool optionalBool(String key, {bool defaultValue = false}) {
    final Object? value = this[key];
    if (value == null) return defaultValue;
    if (value is bool) return value;
    throw ContentParsingException(
      'Expected a bool at "$key" but found ${value.runtimeType}.',
    );
  }

  Map<String, dynamic> requireObject(String key) {
    final Object? value = this[key];
    if (value is Map<String, dynamic>) return value;
    if (value is Map) return Map<String, dynamic>.from(value);
    throw ContentParsingException(
      'Expected an object at "$key" but found ${value.runtimeType}.',
    );
  }

  List<String> requireStringList(String key) {
    final Object? value = this[key];
    if (value is! List) {
      throw ContentParsingException(
        'Expected a list at "$key" but found ${value.runtimeType}.',
      );
    }
    return value.map((Object? item) {
      if (item is String) return item;
      throw ContentParsingException(
        'Expected only Strings in "$key" but found ${item.runtimeType}.',
      );
    }).toList(growable: false);
  }

  List<Map<String, dynamic>> requireObjectList(String key) {
    final Object? value = this[key];
    if (value is! List) {
      throw ContentParsingException(
        'Expected a list at "$key" but found ${value.runtimeType}.',
      );
    }
    return value.map((Object? item) {
      if (item is Map<String, dynamic>) return item;
      if (item is Map) return Map<String, dynamic>.from(item);
      throw ContentParsingException(
        'Expected only objects in "$key" but found ${item.runtimeType}.',
      );
    }).toList(growable: false);
  }

  /// Reads an enum by its declared name, e.g. `"agriTech"` for
  /// `ProjectCategory.agriTech`.
  T requireEnum<T extends Enum>(String key, List<T> values) {
    final String name = requireString(key);
    for (final T value in values) {
      if (value.name == name) return value;
    }
    throw ContentParsingException(
      'Unknown value "$name" at "$key". '
      'Expected one of: ${values.map((T v) => v.name).join(', ')}.',
    );
  }
}
