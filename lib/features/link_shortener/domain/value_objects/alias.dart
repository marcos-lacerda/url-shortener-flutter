class Alias {
  Alias._(this.value);

  final String value;

  static Alias? tryParse(String raw) {
    final t = raw.trim();

    final ok = t.isNotEmpty && RegExp(r'^\d+$').hasMatch(t);

    return ok ? Alias._(t) : null;
  }

  @override
  String toString() => value;
}
