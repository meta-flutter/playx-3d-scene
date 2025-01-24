///material types base on filamant general parameters.
///See also:
///* https://google.github.io/filament/Materials.html
enum MaterialType {
  /// Material value presented as color.
  color("COLOR"),

  /// Single boolean or Vector of 2 to 4 booleans
  ///used for material bool type, bool2,bool3,bool4 types
  /// Material value presented as bool.
  bool("BOOL"),

  /// Material value presented as Vector of 2 to 4 booleans.
  boolVector("BOOL_VECTOR"),

  /// Material value presented as float.
  float("FLOAT"),

  /// Material value presented as Vector of 2 to 4 booleans.
  floatVector("FLOAT_VECTOR"),

  /// Material value presented as int.
  int("INT"),

  /// Material value presented as Vector of 2 to 4 booleans.
  intVector("INT_VECTOR"),

  /// Material value presented as 3x3 matrix.
  mat3("MAT3"),

  /// Material value presented as 4x4 matrix.
  mat4("MAT4"),

  /// Material value presented as texture.
  texture("TEXTURE");



  final String value;
  const MaterialType(this.value);

  static MaterialType from(String value) => MaterialType.values.asNameMap()[value]!;
}
