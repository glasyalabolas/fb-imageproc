#ifndef __FB_COLORS_MATH__
#define __FB_COLORS_MATH__

namespace Colors
  type as double float
  
  const as float _
    epsilon = 1e-10, _
    phi = ( 1.0 + sqr( 5.0 ) ) / 2.0, _
    invPhi = 1.0 / phi
  
  function fmod overload( n as float, d as float ) as float
    return( n - int( n / d ) * d )
  end function
  
  function min overload( a as float, b as float ) as float
    return( iif( a < b, a, b ) )
  end function
  
  function max overload( a as float, b as float ) as float
    return( iif( a > b, a, b ) )
  end function
  
  function clamp overload( v as float, a as float, b as float ) as float
    return( max( a, min( v, b ) ) )
  end function
  
  function wrap overload( v as float, a as float, b as float ) as float
    return( fmod( ( fmod( ( v - a ), ( b - a ) ) + ( b - a  ) ), ( b - a ) + a ) )
  end function
  
  type float3
    declare constructor()
    declare constructor( as float, as float, as float )
    declare constructor( as float3 )
    
    declare operator let( as float3 )
    
    declare property r() as float
    declare property r( as float )
    declare property g() as float
    declare property g( as float )
    declare property b() as float
    declare property b( as float )
    
    declare operator cast() as ulong
    
    as float _
      x, y, z
  end type
  
  constructor float3()
    constructor( 0.0, 0.0, 0.0 )
  end constructor
  
  constructor float3( nX as float, nY as float, nZ as float )
    x = nX : y = nY : z = nZ
  end constructor
  
  constructor float3( rhs as float3 )
    x = rhs.x : y = rhs.y : z = rhs.z
  end constructor
  
  operator float3.let( rhs as float3 )
    x = rhs.x : y = rhs.y : z = rhs.z
  end operator
  
  property float3.r() as float
    return( x )
  end property
  
  property float3.r( value as float )
    x = value
  end property
  
  property float3.g() as float
    return( y )
  end property
  
  property float3.g( value as float )
    y = value
  end property
  
  property float3.b() as float
    return( z )
  end property
  
  property float3.b( value as float )
    z = value
  end property
  
  operator float3.cast() as ulong
    return( _
      ( cubyte( x * 255 ) shl 16 ) or _
      ( cubyte( y * 255 ) shl 8 ) or _
      ( cubyte( z * 255 ) ) )
  end operator
  
  '' Dot product
  function dot overload( v as const float3, w as const float3 ) as float
  	return( v.x * w.x + v.y * w.y + v.z * w.z )
  end function  
  
  type float4
    declare constructor()
    declare constructor( as float, as float, as float, as float = 1.0 )
    declare constructor( as float3, as float )
    declare constructor( as float4 )
    
    declare operator let( as float4 )
    
    declare property r() as float
    declare property r( as float )
    declare property g() as float
    declare property g( as float )
    declare property b() as float
    declare property b( as float )
    declare property a() as float
    declare property a( as float )
    
    declare operator cast() as ulong
    
    as float _
      x, y, z, w
  end type
  
  constructor float4()
    constructor( 0.0, 0.0, 0.0, 1.0 )
  end constructor
  
  constructor float4( nX as float, nY as float, nZ as float, nW as float = 1.0 )
    x = nX : y = nY : z = nZ : w = nW
  end constructor
  
  constructor float4( nf as float3, nA as float )
    x = nf.x : y = nf.y : z = nf.z : a = nA
  end constructor
  
  constructor float4( rhs as float4 )
    x = rhs.x : y = rhs.y : z = rhs.z : a = rhs.w
  end constructor
  
  operator float4.let( rhs as float4 )
    x = rhs.x : y = rhs.y : z = rhs.z : w = rhs.w
  end operator
  
  property float4.r() as float
    return( x )
  end property
  
  property float4.r( value as float )
    x = value
  end property
  
  property float4.g() as float
    return( y )
  end property
  
  property float4.g( value as float )
    y = value
  end property
  
  property float4.b() as float
    return( z )
  end property
  
  property float4.b( value as float )
    z = value
  end property
  
  property float4.a() as float
    return( w )
  end property
  
  property float4.a( value as float )
    w = value
  end property
  
  operator float4.cast() as ulong
    return( _
      ( cubyte( r * 255 ) shl 16 ) or _
      ( cubyte( g * 255 ) shl 8 ) or _
      ( cubyte( b * 255 ) ) or _
      ( cubyte( a * 255 ) shl 24 ) )
  end operator
end namespace

#endif
