
import 'dart:ui';

import 'package:playx_3d_scene/utils/colors_ext.dart';



const FogOptions kFogDisabled = FogOptions(enabled: false);

class FogOptions {
  /// Enable or disable large-scale fog
  final bool enabled;

  /// Distance in world units [m] from the camera to where the fog starts ( >= 0.0 )
  final double distance;
  
  /// Distance in world units [m] after which the fog calculation is disabled.
  /// This can be used to exclude the skybox, which is desirable if it already contains clouds or
  /// fog. The default value is +infinity which applies the fog to everything.
  ///
  /// Note: The SkyBox is typically at a distance of 1e19 in world space (depending on the near
  /// plane distance and projection used though).
  final double cutOffDistance;
  
  /// fog's maximum opacity between 0 and 1
  final double maximumOpacity;
  
  /// Fog's floor in world units [m]. This sets the "sea level".
  final double height;
  
  /// How fast the fog dissipates with altitude. heightFalloff has a unit of [1/m].
  /// It can be expressed as 1/H, where H is the altitude change in world units [m] that causes a
  /// factor 2.78 (e) change in fog density.
  ///
  /// A falloff of 0 means the fog density is constant everywhere and may result is slightly
  /// faster computations.
  final double heightFalloff;
  
  ///  Fog's color is used for ambient light in-scattering, a good value is
  ///  to use the average of the ambient light, possibly tinted towards blue
  ///  for outdoors environments. Color component's values should be between 0 and 1, values
  ///  above one are allowed but could create a non energy-conservative fog (this is dependant
  ///  on the IBL's intensity as well).
  ///
  ///  We assume that our fog has no absorption and therefore all the light it scatters out
  ///  becomes ambient light in-scattering and has lost all directionality, i.e.: scattering is
  ///  isotropic. This somewhat simulates Rayleigh scattering.
  ///
  ///  This value is used as a tint instead, when fogColorFromIbl is enabled.
  ///
  ///  @see fogColorFromIbl
  // @NonNull @Size(min = 3)
  final Color color;
  
  /// Extinction factor in [1/m] at altitude 'height'. The extinction factor controls how much
  /// light is absorbed and out-scattered per unit of distance. Each unit of extinction reduces
  /// the incoming light to 37% of its original value.
  ///
  /// Note: The extinction factor is related to the fog density, it's usually some constant K times
  /// the density at sea level (more specifically at fog height). The constant K depends on
  /// the composition of the fog/atmosphere.
  ///
  /// For historical reason this parameter is called `density`.
  final double density;
  
  /// Distance in world units [m] from the camera where the Sun in-scattering starts.
  final double inScatteringStart;
  
  /// Very inaccurately simulates the Sun's in-scattering. That is, the light from the sun that
  /// is scattered (by the fog) towards the camera.
  /// Size of the Sun in-scattering (>0 to activate). Good values are >> 1 (e.g. ~10 - 100).
  /// Smaller values result is a larger scattering size.
  final double inScatteringSize;
  
  /// The fog color will be sampled from the IBL in the view direction and tinted by `color`.
  /// Depending on the scene this can produce very convincing results.
  ///
  /// This simulates a more anisotropic phase-function.
  ///
  /// `fogColorFromIbl` is ignored when skyTexture is specified.
  ///
  /// @see skyColor
  // final bool fogColorFromIbl;
  
  /// skyTexture must be a mipmapped cubemap. When provided, the fog color will be sampled from
  /// this texture, higher resolution mip levels will be used for objects at the far clip plane,
  /// and lower resolution mip levels for objects closer to the camera. The skyTexture should
  /// typically be heavily blurred; a typical way to produce this texture is to blur the base
  /// level with a strong gaussian filter or even an irradiance filter and then generate mip
  /// levels as usual. How blurred the base level is somewhat of an artistic decision.
  ///
  /// This simulates a more anisotropic phase-function.
  ///
  /// `fogColorFromIbl` is ignored when skyTexture is specified.
  ///
  /// @see Texture
  /// @see fogColorFromIbl
  // final Texture? skyColor = null;
  

  const FogOptions({
    this.distance = 0,
    this.cutOffDistance = double.infinity,
    this.maximumOpacity = 1,
    this.height = 0,
    this.heightFalloff = 1,
    this.color = const Color(0xffFFFFFF),
    this.density = 0.1,
    this.inScatteringStart = 0,
    this.inScatteringSize = -1,
    // this.fogColorFromIbl = false,
    // this.skyColor = null,
    this.enabled = false,
  });

  Map<String, Object?> toJson() {
    return {
      'distance': distance,
      'cutOffDistance': cutOffDistance,
      'maximumOpacity': maximumOpacity,
      'height': height,
      'heightFalloff': heightFalloff,
      // color as 
      'color': color.toHex(),
      'density': density,
      'inScatteringStart': inScatteringStart,
      'inScatteringSize': inScatteringSize,
      // 'fogColorFromIbl': fogColorFromIbl,
      // 'skyColor': skyColor,
      'enabled': enabled,
    };
  }
}
