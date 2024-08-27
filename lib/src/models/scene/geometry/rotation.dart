class PlayxRotation {
  double x;
  double y;
  double z;
  double w;

  // Default constructor with optional named parameters
  PlayxRotation({this.x = 0.0, this.y = 0.0, this.z = 0.0, this.w = 1.0});

  // Constructor that initializes all components to the same value
  PlayxRotation.all(double v)
      : x = v,
        y = v,
        z = v,
        w = v;

  // Converts the quaternion to a JSON-compatible map
  Map<String, dynamic> toJson() => {
        'x': x,
        'y': y,
        'z': z,
        'w': w,
      };

  @override
  String toString() => 'PlayxRotation(x: $x, y: $y, z: $z, w: $w)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PlayxRotation &&
        other.x == x &&
        other.y == y &&
        other.z == z &&
        other.w == w;
  }

  @override
  int get hashCode => x.hashCode ^ y.hashCode ^ z.hashCode ^ w.hashCode;
}
