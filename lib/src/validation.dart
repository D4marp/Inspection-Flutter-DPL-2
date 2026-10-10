String? validateRequired(String? raw, String fieldName) =>
    (raw ?? '').trim().isEmpty ? '$fieldName wajib diisi' : null;

String? validateNote(bool needsAction, String? raw) {
  final note = (raw ?? '').trim();
  if (note.length > 500) return 'Maksimal 500 karakter';
  if (needsAction && note.length < 10) {
    return 'Temuan membutuhkan catatan minimal 10 karakter';
  }
  return null;
}
