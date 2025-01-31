/// Convenience alias for Vector3
typedef Position = Vector3; typedef Size = Vector3; typedef Direction = Vector3;

/// Convenience alias for Vector4
typedef Rotation = Vector4;



/// An object that represents the a vector in 3D world space
/// TODO(kerberjg): test whether it makes sense to even have a Vector3 - a cache line fits 2x Vector4 perfectly. Maybe there's pointers involved? Run benchmarks
class Vector3 {
  double x, y, z;

  Vector3(this.x, this.y, this.z);
  Vector3.only({this.x = 0, this.y = 0, this.z = 0});

  Vector3.x(final double x) : this.only(x: x);
  Vector3.y(final double y) : this.only(y: y);
  Vector3.z(final double z) : this.only(z: z);
  Vector3.all(final double value) : this.only(
    x: value, y: value, z: value
  );

  Map<String, dynamic> toJson() => {
        'x': x,
        'y': y,
        'z': z,
      };

  @override
  String toString() => 'Vector3(x: $x, y: $y, z: $z)';

  @override
  bool operator ==(final Object other) {
    if (identical(this, other)) return true;

    return other is Vector3 &&
        other.x == x &&
        other.y == y &&
        other.z == z;
  }

  @override
  int get hashCode => x.hashCode ^ y.hashCode ^ z.hashCode;
}

/// An object that represents the a vector in 4D world space
class Vector4 {
  /// Default value is 0
  double x, y, z;
  /// Default value is 1
  double w;

  Vector4({this.x = 0, this.y = 0, this.z = 0, this.w = 1});

  Vector4.x(final double x) : this(x: x);
  Vector4.y(final double y) : this(y: y);
  Vector4.z(final double z) : this(z: z);
  Vector4.w(final double w) : this(w: w);
  Vector4.all(final double value) : this(
    x: value, y: value, z: value, w: value,
  );

  Map<String, dynamic> toJson() => {
        'x': x,
        'y': y,
        'z': z,
        'w': w,
      };

  @override
  String toString() => 'Vector4(x: $x, y: $y, z: $z. w" $w)';

  @override
  bool operator ==(final Object other) {
    if (identical(this, other)) return true;

    return other is Vector4 &&
        other.x == x &&
        other.y == y &&
        other.z == z &&
        other.w == w;
  }

  @override
  int get hashCode => x.hashCode ^ y.hashCode ^ z.hashCode ^ w.hashCode;
}
