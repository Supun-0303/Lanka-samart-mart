import 'dart:math';

final Random _idRandom = Random();

String generateId() {
  final timestamp = DateTime.now().microsecondsSinceEpoch;
  final suffix = _idRandom.nextInt(1 << 32).toRadixString(16);
  return '${timestamp}_$suffix';
}
