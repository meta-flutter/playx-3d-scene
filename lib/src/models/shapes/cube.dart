import 'package:playx_3d_scene/src/models/scene/geometry/size.dart';
import 'package:playx_3d_scene/src/models/shapes/shape.dart';

/// An object that represents a cube shape to be rendered.
class Cube extends Shape {
  /// Length of the cube.
  PlayxSize size;

  late PlayxSize _size;

  Cube(
      {required super.id,
      required this.size,
      required super.centerPosition,
      super.scale,
      super.rotation,
      super.material,
      super.doubleSided,
      super.castShadows,
      super.receiveShadows,
      super.cullingEnabled})
      : super() {
    _size = size;
  }

  @override
  Map<String, dynamic> toJson() => {
        'id': id,
        'centerPosition': centerPosition?.toJson(),
        'size': _size.toJson(),
        'material': material?.toJson(),
        'scale': scale?.toJson(),
        'shapeType': 2,
        'rotation': rotation?.toJson(),
        'doubleSided': doubleSided,
        'cullingEnabled': cullingEnabled,
        'receiveShadows': receiveShadows,
        'castShadows': castShadows
      };

  @override
  String toString() {
    return 'Cube(id: $id, size: $size, centerPosition: $centerPosition)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Cube && other.size == size && super == other;
  }

  @override
  int get hashCode => size.hashCode ^ super.hashCode;
}
