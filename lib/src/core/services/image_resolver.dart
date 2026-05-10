import 'package:supabase_flutter/supabase_flutter.dart';

/// Resolves a stored product image reference into a fully-qualified
/// network URL pointing at the Supabase Storage bucket.
///
/// The DB historically stored values in a few different shapes:
///   - `assets/images/products/s21.jpg`   (legacy asset path)
///   - `/images/products/s21.jpg`         (legacy DB path)
///   - `products/s21.jpg`                  (new bucket-relative path)
///   - `s21.jpg`                            (just a filename)
///   - `https://…/storage/v1/object/...`  (already a URL)
///
/// All of those are normalised onto the public URL of the
/// `Product_Images` bucket so the rest of the UI just calls
/// [Image.network].
class ProductImageResolver {
  ProductImageResolver._();

  static const String bucket = 'Product_Images';
  static const String _folder = 'products';

  /// Returns a fully-qualified network URL for [raw], or `null` when [raw]
  /// is empty / null.
  static String? resolve(String? raw) {
    if (raw == null) return null;
    final value = raw.trim();
    if (value.isEmpty) return null;

    // Already a fully-qualified URL → use as-is.
    if (value.startsWith('http://') || value.startsWith('https://')) {
      return value;
    }

    final path = _normaliseStoragePath(value);
    return Supabase.instance.client.storage.from(bucket).getPublicUrl(path);
  }

  /// Convert legacy / partial paths into the bucket-relative path
  /// (`products/<filename>`).
  static String _normaliseStoragePath(String value) {
    var v = value;

    // Strip a leading slash so split logic works uniformly.
    if (v.startsWith('/')) v = v.substring(1);

    // Drop the `assets/` prefix if it's a legacy asset path.
    if (v.startsWith('assets/')) v = v.substring('assets/'.length);

    // Drop a leading `images/` segment — historic DB rows stored
    // `/images/products/...`.
    if (v.startsWith('images/')) v = v.substring('images/'.length);

    // If the path already starts with the bucket name, drop it.
    final bucketPrefix = '$bucket/';
    if (v.startsWith(bucketPrefix)) v = v.substring(bucketPrefix.length);

    // Whatever is left should be either `products/<file>` or just `<file>`.
    if (v.startsWith('$_folder/')) return v;
    return '$_folder/$v';
  }
}
