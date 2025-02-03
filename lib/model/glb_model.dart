part of 'model.dart';

/// represents object of model that will be loaded from glb file.
///
/// GLB is a binary container format of glTF.
/// It bundles all the textures and mesh data into a single file.
class GlbModel extends Model {
  /// creates glb model based on glb file asset path.
  GlbModel.asset(String path,
      {super.scale
        , super.should_keep_asset_in_memory
      , super.is_primary_to_instance_from
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
      {super.scale, super.centerPosition
        , super.should_keep_asset_in_memory
        , super.is_primary_to_instance_from
      , super.animation, required bool receiveShadows, required bool castShadows})
      : super(url: url, receiveShadows: receiveShadows
                        , castShadows: castShadows);

  @override
  Map<String, dynamic> toJson() => {
        'assetPath': assetPath,
        'url': url,
    'should_keep_asset_in_memory': should_keep_asset_in_memory,
    'is_primary_to_instance_from': is_primary_to_instance_from,
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
    return 'GlbModel(assetPath: $assetPath, url: $url, scale: $scale, centerPosition: $centerPosition, animation: $animation)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is GlbModel &&
        other.assetPath == assetPath &&
        other.url == url &&
        other.scale == scale &&
        other.centerPosition == centerPosition &&
        other.animation == animation;
  }

  @override
  int get hashCode {
    return assetPath.hashCode ^
        url.hashCode ^
        scale.hashCode ^
        centerPosition.hashCode ^
        animation.hashCode;
  }
}
