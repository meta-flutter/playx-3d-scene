import 'model.dart';

/// represents object of model that will be loaded from glb file.
///
/// GLB is a binary container format of glTF.
/// It bundles all the textures and mesh data into a single file.
class GlbModel extends Model {
  /// creates glb model based on glb file asset path.
  GlbModel.asset(String path,
      {super.fallback, super.scale
      , super.collidable, super.centerPosition
      , super.animation, super.rotation
      , required super.castShadows, required  super.receiveShadows
      , super.name, super.global_guid})
      : super(assetPath: path) {
    assert(path.isNotEmpty);
    assert(path.contains('.glb'), "path should be a glb file path");
  }

  /// creates glb model based on glb file url.
  GlbModel.url(String url,
      {super.fallback, super.scale, super.centerPosition
      , super.animation, required bool receiveShadows, required bool castShadows})
      : super(url: url, receiveShadows: receiveShadows
                        , castShadows: castShadows);

  @override
  Map<String, dynamic> toJson() => {
        'assetPath': assetPath,
        'url': url,
        'fallback': fallback?.toJson(),
        'scale': scale?.toJson(),
        'collidable': collidable?.toJson(),
        'rotation': rotation?.toJson(),
        'centerPosition': centerPosition?.toJson(),
        'animation': animation?.toJson(),
        'castShadows': castShadows,
        'receiveShadows': receiveShadows,
        'isGlb': true,
        'name': name,
        'global_guid' : global_guid,
      };

  @override
  String toString() {
    return 'GlbModel(assetPath: $assetPath, url: $url, fallback: $fallback, scale: $scale, centerPosition: $centerPosition, animation: $animation)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is GlbModel &&
        other.assetPath == assetPath &&
        other.url == url &&
        other.fallback == fallback &&
        other.scale == scale &&
        other.centerPosition == centerPosition &&
        other.animation == animation;
  }

  @override
  int get hashCode {
    return assetPath.hashCode ^
        url.hashCode ^
        fallback.hashCode ^
        scale.hashCode ^
        centerPosition.hashCode ^
        animation.hashCode;
  }
}
