///Camera Modes that operates on.
///Three modes are supported: ORBIT, MAP, and FREE_FLIGHT.
enum Mode {
  orbit,
  map,
  freeFlight,
  autoOrbit,
  inertiaAndGestures;

  String toName() {
    switch (this) {
      case Mode.orbit:
        return "ORBIT";
      case Mode.map:
        return "MAP";
      case Mode.freeFlight:
        return "FREE_FLIGHT";
      case Mode.autoOrbit:
        return "AUTO_ORBIT";
      case Mode.inertiaAndGestures:
        return "INERTIA_AND_GESTURES";
      default:
        return "ORBIT";
    }
  }
}
