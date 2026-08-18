import 'package:retro/otr/types/texture.dart';

enum TextureEntryKind {
  replacement,
  additive,
  additiveFontGlyph,
}

class TextureManifestEntry {

  TextureManifestEntry(this.hash, this.textureType, this.textureWidth, this.textureHeight, {this.tileWidth, this.tileHeight});

  factory TextureManifestEntry.fromJson(Map<String, dynamic> json) {
    return TextureManifestEntry(
      json['hash'] as String,
      TextureType.values[json['textureType'] as int],
      json['textureWidth'] as int,
      json['textureHeight'] as int,
      tileWidth: json['tileWidth'] as int?,
      tileHeight: json['tileHeight'] as int?,
    );
  }

  String hash;
  TextureType textureType;
  int textureWidth;
  int textureHeight;
  int? tileWidth;
  int? tileHeight;
  TextureEntryKind kind = TextureEntryKind.replacement;
  String? targetName;

  /// Content hash of the source file as of the most recent scan. Not
  /// persisted to the manifest; used at runtime to avoid re-staging a file
  /// whose content hasn't changed since it was last staged.
  String? sourceHash;

  Map<String, dynamic> toJson() => {
    'hash': hash,
    'textureType': textureType.value,
    'textureWidth': textureWidth,
    'textureHeight': textureHeight,
    if (tileWidth != null) 'tileWidth': tileWidth,
    if (tileHeight != null) 'tileHeight': tileHeight,
  };
}
