import 'dart:convert';

import 'package:drift/drift.dart';

/// Converts a Map<String, dynamic> to/from a JSON text column.
class JsonMapConverter extends TypeConverter<Map<String, dynamic>, String> {
  const JsonMapConverter();

  @override
  Map<String, dynamic> fromSql(String fromDb) {
    return (jsonDecode(fromDb) as Map<String, dynamic>?) ?? {};
  }

  @override
  String toSql(Map<String, dynamic> value) {
    return jsonEncode(value);
  }
}
