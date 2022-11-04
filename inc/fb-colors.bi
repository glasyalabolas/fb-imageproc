#ifndef __FB_COLORS__
#define __FB_COLORS__

#include once "fb-colors-math.bi"

/'
  A simple framework to work with different color models.
  
  You can express a color in three different color models:
  HSV, HSL and HCY (aka. Hue-Chroma-Luminance). Conversion
  functions to/from RGB are provided, such that:
  
  RGBtoHSV - Converts a color in the RGB model to the HSV model
  RGBtoHSL - Converts a color in the RGB model to the HSL model
  RGBtoHCY - Converts a color in the RGB model to the HCY model
  
  HSVtoRGB - Converts a color from the HSV model to the RGB model
  HSLtoRGB - Converts a color from the HSL model to the RGB model
  HCYtoRGB - Converts a color from the HCY model to the RGB model
  
  The mix() functions linearly interpolate between two colors in
  the RGB/RGBA model. To use them with other color models, simply
  convert them first, like this:
  
  '' Mix two HCY colors in equal amounts
  finalColor = Colors.mix( Colors.HCYtoRGB( color1 ), Colors.HCYtoRGB( color2 ), 0.5 )
  
  Port of:
    https://www.chilliant.com/rgb2hsv.html
'/
#ifndef uint32
  type as ulong uint32
#endif

#ifndef int32
  type as long int32
#endif

union RGBAcolor
  as uint32    value
  
  type
    as ubyte b
    as ubyte g
    as ubyte r
    as ubyte a
  end type
  
  declare constructor()
  declare constructor( as ubyte, as ubyte, as ubyte, as ubyte )
  declare constructor( as uint32 )
  declare operator cast() as uint32
  declare operator let( as uint32 )
end union

constructor RGBAcolor() : end constructor

constructor RGBAcolor( rhs as uint32 )
  value = rhs
end constructor

constructor RGBAcolor( rv as ubyte, gv as ubyte, bv as ubyte, av as ubyte )
  value = rgba( rv, gv, bv, av )
end constructor

operator RGBAcolor.cast() as uint32
  return( value )
end operator

operator RGBAcolor.let( rhs as uint32 )
  value = rhs
end operator

namespace Colors
  '' Convert pure Hue to RGB
  function hueToRGB( h as float ) as float3
    dim as float _
      r = abs( h * 6.0 - 3.0 ) - 1.0, _
      g = 2.0 - abs( h * 6.0 - 2.0 ), _
      b = 2.0 - abs( h * 6.0 - 4.0 )
    
    return( ( float3( _
      clamp( r, 0.0, 1.0 ), _
      clamp( g, 0.0, 1.0 ), _
      clamp( b, 0.0, 1.0 ) ) ) )
  end function
  
  const as double _
    _CD23 = 2.0 / 3.0, _
    _CDM13 = -1.0 / 3.0
  
  '' Convert RGB to Hue/Chroma/Value
  function RGBtoHCV( aRGB as float3 ) as float3
    var _
      P = iif( aRGB.g < aRGB.b, _
        float4( aRGB.b, aRGB.g, -1.0, _CD23 ), _
        float4( aRGB.g, aRGB.b, 0.0, _CDM13 ) ), _
      Q = iif( aRGB.r < P.x, _
        float4( P.x, P.y, P.w, aRGB.r ), _
        float4( aRGB.r, P.y, P.z, P.x ) )
      
    dim as float _
      C = Q.x - min( Q.w, Q.y ), _
      H = abs( ( Q.w - Q.y ) / ( 6.0 * C + Epsilon ) + Q.z )
    
    return( float3( H, C, Q.x ) )
  end function
  
  '' Convert Hue-Saturation-Value to RGB
  function HSVtoRGB( byval HSV as float3 ) as float3
    dim as float3 aRGB = hueToRGB( HSV.x )
    
    return( float3( _
      ( ( aRGB.x - 1.0 ) * HSV.y + 1.0 ) * HSV.z, _
      ( ( aRGB.y - 1.0 ) * HSV.y + 1.0 ) * HSV.z, _
      ( ( aRGB.z - 1.0 ) * HSV.y + 1.0 ) * HSV.z ) )
  end function
  
  '' Convert Hue-Saturation-Lightness to RGB
  function HSLtoRGB( byval HSL as float3 ) as float3
    dim as float3 aRGB = hueToRGB( HSL.x )
    dim as float C = ( 1.0 - abs( 2.0 * HSL.z - 1.0 ) ) * HSL.y
    
    return( float3( _
      ( aRGB.x - 0.5 ) * C + HSL.z, _
      ( aRGB.y - 0.5 ) * C + HSL.z, _
      ( aRGB.z - 0.5 ) * C + HSL.z ) )
  end function

  /'
    The weights of RGB contributions to luminance.
    Should sum to unity.  
  '/
  dim as const float3 _HCYweights = float3( 0.299, 0.587, 0.114 )
  
  '' Convert Hue-Chroma-Luminance to RGB
  function HCYtoRGB( byval HCY as float3 ) as float3
    var aRGB = hueToRGB( HCY.x )
    
    dim as float Z = dot( aRGB, _HCYweights )
    
    if( HCY.z < Z ) then
      HCY.y *= HCY.z / Z
    elseif( z < 1.0 ) then
      HCY.y *= ( 1.0 - HCY.z ) / ( 1.0 - Z )
    end if
    
    return( float3( _
      ( aRGB.x - Z ) * HCY.Y + HCY.z, _
      ( aRGB.y - Z ) * HCY.Y + HCY.z, _
      ( aRGB.z - Z ) * HCY.Y + HCY.z ) )
  end function
  
  '' Converting RGB to Hue-Chroma-Luminance
  function RGBtoHCY( aRGB as float3 ) as float3
    var HCV = RGBtoHCV( aRGB )
    
    dim as float _
      Y = dot( aRGB, _HCYweights ), _
      Z = dot( hueToRGB( HCV.x ), _HCYweights )
    
    if( Y < Z ) then
      HCV.y *= Z / ( Epsilon + Y )
    else
      HCV.y *= ( 1.0 - Z ) / ( Epsilon + 1.0 - Y )
    end if
    
    return( float3( HCV.x, HCV.y, Y ) )
  end function
  
  '' Converting RGB to Hue-Saturation-Value
  function RGBtoHSV( aRGB as float3 ) as float3
    dim as float3 HCV = RGBtoHCV( aRGB )
    dim as float S = HCV.y / ( HCV.z + Epsilon )
    
    return( float3( HCV.x, S, HCV.z ) )
  end function
  
  '' Converting RGB to Hue-Saturation-Lightness
  function RGBtoHSL( aRGB as float3 ) as float3
    dim as float3 HCV = RGBtoHCV( aRGB )
    dim as float _
      L = HCV.z - HCV.y * 0.5, _
      S = HCV.y / ( 1.0 - abs( L * 2.0 - 1.0 ) + Epsilon )
    
    return( float3( HCV.x, S, L ) )
  end function  
  
  function mix overload( c1 as float3, c2 as float3, t as float ) as float3
    return( float3( _
      c1.x + ( ( c2.x - c1.x ) * t ), _
      c1.y + ( ( c2.y - c1.y ) * t ), _
      c1.z + ( ( c2.z - c1.z ) * t ) ) )
  end function
  
  function mix( c1 as float4, c2 as float4, t as float ) as float4
    return( float4( _
      c1.x + ( ( c2.x - c1.x ) * t ), _
      c1.y + ( ( c2.y - c1.y ) * t ), _
      c1.z + ( ( c2.z - c1.z ) * t ), _
      c1.w + ( ( c2.w - c1.w ) * t ) ) )
  end function
  
  type as Colors.float3 HSVColor, HSLColor, HCYColor
  type as Colors.float4 HSVAColor, HSLAColor, HCYAColor
end namespace

#endif
