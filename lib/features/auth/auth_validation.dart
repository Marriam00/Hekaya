String? validateAuthEmail(String? value) {
  final email = value?.trim() ?? '';
  if (email.isEmpty) return 'Email is required.';
  if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email)) {
    return 'Enter a valid email address.';
  }
  return null;
}

String? validateDisplayName(String? value) {
  if ((value ?? '').trim().isEmpty) return 'Display name is required.';
  return null;
}

String? validateAuthPassword(String? value, {required bool requireLength}) {
  if ((value ?? '').isEmpty) return 'Password is required.';
  if (requireLength && value!.length < 6) {
    return 'Password must be at least 6 characters.';
  }
  return null;
}
