import 'package:playx_3d_scene/src/models/model/animation.dart';
import 'package:playx_3d_scene/src/models/model/glb_model.dart';
import 'package:playx_3d_scene/src/models/model/gltf_model.dart';
import 'package:playx_3d_scene/src/models/scene/geometry/position.dart';
import 'package:playx_3d_scene/src/models/scene/geometry/size.dart';
import 'package:playx_3d_scene/src/models/scene/geometry/rotation.dart';
import 'package:playx_3d_scene/src/models/scene/geometry/collidable.dart';

import '../scene/geometry/collidable.dart';
  
/// represents base object of the 3d model to be rendered.
///
/// see also :
///
/// [GlbModel] :
/// [GltfModel] :
abstract class Model {
  /// Model asset path to load the model from assets.
  String? assetPath;

  /// Model url to load the model from url.
  String? url;

  /// used for communication back and forth from dart/native
  String? name;

  /// used for communication back and forth from dart/native
  String? global_guid;

  /// Model to be shown when error happened.
  ///
  /// can be whether [GlbModel] or [GltfModel]
  Model? fallback;

  /// Scale Factor of the model.
  /// Should be greater than 0.
  /// Defaults to 1.
  PlayxSize? scale;

  /// Do we have a collidable for this object (expecting to collide)
  /// For now this will create a box using the extents value
  Collidable? collidable;

  ///Coordinate of center point position of the rendered model.
  ///
  /// Defaults to ( x:0,y: 0,z: -4)
  PlayxPosition? centerPosition;

  ///Controls what animation should be played by the rendered model.
  PlayxAnimation? animation;

    /// Quaternion rotation for the shape
  PlayxRotation? rotation;

  Model(
      {this.assetPath,
      this.url,
      this.fallback,
      this.scale,
      this.rotation,
      this.collidable,
      this.centerPosition,
      this.animation,
      this.global_guid,
      this.name,});

  Map<String, dynamic> toJson() {
    if (this is GlbModel) {
      return (this as GlbModel).toJson();
    } else if (this is GltfModel) {
      return (this as GltfModel).toJson();
    } else {
      return {};
    }
  }

  @override
  String toString() {
    return 'Model(assetPath: $assetPath, url: $url, fallback: $fallback, scale: $scale, centerPosition: $centerPosition, animation: $animation)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Model &&
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
