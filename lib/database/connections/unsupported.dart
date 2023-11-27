import 'package:drift/drift.dart';

// Depending on the platform the app is compiled to, the following stubs will
// be replaced with the methods in native.dart or web.dart

DatabaseConnection connect() {
  _unsupported();
}

Future<void> validateDatabaseSchema(GeneratedDatabase database) async {
  _unsupported();
}

Never _unsupported() {
  throw UnsupportedError(
      'No suitable database implementation was found on this platform.');
}
