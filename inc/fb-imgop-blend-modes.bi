#ifndef __FB_IMGOP_BLEND_MODES__
#define __FB_IMGOP_BLEND_MODES__

/'
  Alpha blend using bit masks to merge red and blue into "one" operation.
  Green and Alpha are combined in their own sequence.
 
  red and blue combined:
  dst = ((dst and &HFF00FF) * a + (src and &HFF00FF) * (255 - a)) shr 8
 
  This blend uses the definition:  back * a + fore * (1 - a),
  which I've found to outperform  'back + a * (fore - back)'
  
  - dafhi
'/

'function bmAlpha( byref src as RGBAColor, byref dst as RGBAColor, byval opacity as ubyte = 255, byval param as any ptr = 0 ) as uint32
'  opacity = (opacity * src.a) shr 8
'  return ( ( _
'    (        src  And &Hff00ff) * opacity + _
'    (        dst  And &Hff00ff) * (255-opacity) ) And &Hff00ff00)Shr 8 Or ( _
'    ( (src Shr 8) And &Hff00ff) * opacity + _
'    ( (dst Shr 8) And &Hff00ff) * (255-opacity) ) And &HFF00FF00
'end function

type as function( as RGBAColor, as RGBAColor, as ubyte = 255, as any ptr = 0 ) as uint32 _
  blendFunc

union tintParams
  declare constructor()
  declare constructor( as uint32, as int32 )
  
  as longint p
  
  type
    as ulong tintColor
    as int32 amount
  end type
end union

constructor tintParams() : end constructor

constructor tintParams( c as uint32, a as int32 )
  tintColor = c : amount = a
end constructor

'' d = base, s = blend
'' a is usually the source/blend alpha
#define OA_BLEND( d, s, a, op ) _
  ( d + ( op * ( ( d + ( a * ( ( s ) - d ) ) shr 8 ) - d ) shr 8 ) )
#define CMULT( a, b ) ( ( ( a ) * ( b ) ) shr 8 )
#define CDIV( a, b ) ( ( ( a ) shl 8 ) \ ( b ) )
#define CCLMP( a ) Colors.clamp( a, 0, 255 )
#define CMIN( a, b ) Colors.min( a, b )
#define CMAX( a, b ) Colors.max( a, b )

/'
  Base blending function.
  
  It blends two bitmaps, respecting both the alpha of each one _and_ the opacity specified
  in the blending process.
  
  Other blends replace the term in angle brackets if the alpha channel doesn't need to be
  respected:
    dst.r + ( opacity * ( >>( dst.r + ( src.a * ( src.r - dst.r ) )<< shr 8 ) - dst.r ) shr 8 )
  
  if the alpha channel for each pixel needs to be respected, the term to be replaced is:
    dst.r + ( opacity * ( ( dst.r + ( src.a * ( >>src.r<< - dst.r ) ) shr 8 ) - dst.r ) shr 8 ), _
'/
function bm_alpha( src as RGBAColor, dst as RGBAColor, op as ubyte = 255, param as any ptr = 0 ) as uint32
  return( rgba( _
    OA_BLEND( dst.r, src.r, src.a, op ), _
    OA_BLEND( dst.g, src.g, src.a, op ), _
    OA_BLEND( dst.b, src.b, src.a, op ), _
    OA_BLEND( dst.a, src.a, src.a, op ) ) )	
end function

function bm_dissolve( src as RGBAColor, dst as RGBAColor, op as ubyte = 255, param as any ptr = 0 ) as uint32
  return( iif( ( rnd() * 255 ) >= *cast( ubyte ptr, param ), cast( uint32, dst ), rgba( _
      OA_BLEND( dst.r, src.r, src.a, op ), _
      OA_BLEND( dst.g, src.g, src.a, op ), _
      OA_BLEND( dst.b, src.b, src.a, op ), _
      OA_BLEND( dst.a, src.a, src.a, op ) ) ) )	
end function

function bm_multiply( src as RGBAColor, dst as RGBAColor, op as ubyte = 255, param as any ptr = 0 ) as uint32
  return( rgba( _
    OA_BLEND( dst.r, CMULT( dst.r, src.r ), src.a, op ), _
    OA_BLEND( dst.g, CMULT( dst.g, src.g ), src.a, op ), _
    OA_BLEND( dst.b, CMULT( dst.b, src.b ), src.a, op ), _
    OA_BLEND( dst.a, src.a, src.a, op ) ) )	
end function

function bm_divide( src as RGBAColor, dst as RGBAColor, op as ubyte = 255, param as any ptr = 0 ) as uint32
  return( rgba( _
    OA_BLEND( dst.r, CCLMP( CDIV( dst.r, src.r + 1 ) ), src.a, op ), _
    OA_BLEND( dst.g, CCLMP( CDIV( dst.g, src.g + 1 ) ), src.a, op ), _
    OA_BLEND( dst.b, CCLMP( CDIV( dst.b, src.b + 1 ) ), src.a, op ), _
    OA_BLEND( dst.a, src.a, src.a, op ) ) )
end function

function bm_screen( src as RGBAColor, dst as RGBAColor, op as ubyte = 255, param as any ptr = 0 ) as uint32
  return( rgba( _
    OA_BLEND( dst.r, ( 255 - CMULT( ( 255 - src.r ), ( 255 - dst.r ) ) ), src.a, op ), _
    OA_BLEND( dst.g, ( 255 - CMULT( ( 255 - src.g ), ( 255 - dst.g ) ) ), src.a, op ), _
    OA_BLEND( dst.b, ( 255 - CMULT( ( 255 - src.b ), ( 255 - dst.b ) ) ), src.a, op ), _
    OA_BLEND( dst.a, src.a, src.a, op ) ) )
end function

/'
  Interestingly, according to the GIMP documentation, the Overlay blend mode has a bug, and its implementation
  is equivalent to the Soft Light blend mode.
  See https://docs.gimp.org/2.8/en/gimp-concepts-layer-modes.html#ftn.gimp-layer-mode-bug162395 for details on
  this one.
  
  This is the Wikipedia Overlay method. See https://en.wikipedia.org/wiki/Blend_modes#Overlay
  
  Basically:
  	if dst < 128: dst = ( 2 * src * dst )
  	otherwise: dst = 255 - 2 * ( 255 - dst ) * ( 255 - src )
  
  And you also have to alpha composite it, of course.
'/
function bm_overlay( src as RGBAColor, dst as RGBAColor, op as ubyte = 255, param as any ptr = 0 ) as uint32
  return( rgba( _
    OA_BLEND( dst.r, iif( dst.r < 128, _
      CMULT( 2, dst.r * src.r ), 255 - CMULT( 2, ( 255 - dst.r ) * ( 255 - src.r ) ) ), src.a, op ), _
    OA_BLEND( dst.g, iif( dst.g < 128, _
      CMULT( 2, dst.g * src.g ), 255 - CMULT( 2, ( 255 - dst.g ) * ( 255 - src.g ) ) ), src.a, op ), _
    OA_BLEND( dst.b, iif( dst.b < 128, _
      CMULT( 2, dst.b * src.b ), 255 - CMULT( 2, ( 255 - dst.b ) * ( 255 - src.b ) ) ), src.a, op ), _
    OA_BLEND( dst.a, src.a, src.a, op ) ) )
end function

function bm_dodge( src as RGBAColor, dst as RGBAColor, op as ubyte = 255, param as any ptr = 0 ) as uint32
  return( rgba( _
    OA_BLEND( dst.r, ( CMIN( 255, CDIV( dst.r, ( 255 - src.r ) + 1 ) ) ), src.a, op ), _
    OA_BLEND( dst.g, ( CMIN( 255, CDIV( dst.g, ( 255 - src.g ) + 1 ) ) ), src.a, op ), _
    OA_BLEND( dst.b, ( CMIN( 255, CDIV( dst.b, ( 255 - src.b ) + 1 ) ) ), src.a, op ), _
    OA_BLEND( dst.a, src.a, src.a, op ) ) )
end function

function bm_burn( src as RGBAColor, dst as RGBAColor, op as ubyte = 255, param as any ptr = 0 ) as uint32
  return( rgba( _
    OA_BLEND( dst.r, CMAX( 0, 255 - CDIV( 255 - dst.r, src.r + 1 ) ), src.a, op ), _
    OA_BLEND( dst.g, CMAX( 0, 255 - CDIV( 255 - dst.g, src.g + 1 ) ), src.a, op ), _
    OA_BLEND( dst.b, CMAX( 0, 255 - CDIV( 255 - dst.b, src.b + 1 ) ), src.a, op ), _
    OA_BLEND( dst.a, src.a, src.a, op ) ) )
end function

function bm_hardLight( src as RGBAColor, dst as RGBAColor, op as ubyte = 255, param as any ptr = 0 ) as uint32
  return( rgba( _
    OA_BLEND( dst.r, iif( src.r > 128, _
      CMAX( 0, ( 255 - ( CMULT( 255 - 2 * ( src.r - 128 ), 255 - dst.r ) ) ) ), _
      CMIN( 255, CMULT( 2, dst.r * src.r ) ) ), src.a, op ), _
    OA_BLEND( dst.g, iif( src.g > 128, _
      CMAX( 0, ( 255 - ( CMULT( 255 - 2 * ( src.g - 128 ), 255 - dst.g ) ) ) ), _
      CMIN( 255, CMULT( 2, dst.g * src.g ) ) ), src.a, op ), _
    OA_BLEND( dst.b, iif( src.b > 128, _
      CMAX( 0, ( 255 - ( CMULT( 255 - 2 * ( src.b - 128 ), 255 - dst.b ) ) ) ), _
      CMIN( 255, CMULT( 2, dst.b * src.b ) ) ), src.a, op ), _
    OA_BLEND( dst.a, src.a, src.a, op ) ) )
end function

function bm_softLight( src as RGBAColor, dst as RGBAColor, op as ubyte = 255, param as any ptr = 0 ) as uint32	
  return( rgba( _
    OA_BLEND( dst.r, CMULT( src.r, dst.r ) +  _
      CMULT( dst.r, 255 - CMULT( 255 - dst.r, 255 - src.r ) - _
      CMULT( src.r, dst.r ) ), src.a, op ), _
    OA_BLEND( dst.g, CMULT( src.g, dst.g ) + _
      CMULT( dst.g, 255 - CMULT( 255 - dst.g, 255 - src.g ) - _
      CMULT( src.g, dst.g) ), src.a, op ), _
    OA_BLEND( dst.b, CMULT( src.b, dst.b ) + _
      CMULT( dst.b, 255 - CMULT( 255 - dst.b, 255 - src.b ) - _
      CMULT( src.b, dst.b ) ), src.a, op ), _
    OA_BLEND( dst.a, src.a, src.a, op ) ) )
end function

function bm_grainExtract( src as RGBAColor, dst as RGBAColor, op as ubyte = 255, param as any ptr = 0 ) as uint32
  return( rgba( _
    OA_BLEND( dst.r, CCLMP( dst.r - src.r + 128 ), src.a, op ), _
    OA_BLEND( dst.g, CCLMP( dst.g - src.g + 128 ), src.a, op ), _
    OA_BLEND( dst.b, CCLMP( dst.b - src.b + 128 ), src.a, op ), _
    OA_BLEND( dst.a, src.a, src.a, op ) ) )
end function

function bm_grainMerge( src as RGBAColor, dst as RGBAColor, op as ubyte = 255, param as any ptr = 0 ) as uint32
  return( rgba( _
    OA_BLEND( dst.r, CCLMP( dst.r + src.r - 128 ), src.a, op ), _
    OA_BLEND( dst.g, CCLMP( dst.g + src.g - 128 ), src.a, op ), _
    OA_BLEND( dst.b, CCLMP( dst.b + src.b - 128 ), src.a, op ), _
    OA_BLEND( dst.a, src.a, src.a, op ) ) )
end function

function bm_difference( src as RGBAColor, dst as RGBAColor, op as ubyte = 255, param as any ptr = 0 ) as uint32
  return( rgba( _
    OA_BLEND( dst.r, abs( src.r - dst.r ), src.a, op ), _
    OA_BLEND( dst.g, abs( src.g - dst.g ), src.a, op ), _
    OA_BLEND( dst.b, abs( src.b - dst.b ), src.a, op ), _
    OA_BLEND( dst.a, src.a, src.a, op ) ) )
end function

function bm_add( src as RGBAColor, dst as RGBAColor, op as ubyte = 255, param as any ptr = 0 ) as uint32
  return( rgba( _
    OA_BLEND( dst.r, CMIN( src.r + dst.r, 255 ), src.a, op ), _
    OA_BLEND( dst.g, CMIN( src.g + dst.g, 255 ), src.a, op ), _
    OA_BLEND( dst.b, CMIN( src.b + dst.b, 255 ), src.a, op ), _
    OA_BLEND( dst.a, src.a, src.a, op ) ) )
end function

function bm_substract( src as RGBAColor, dst as RGBAColor, op as ubyte = 255, param as any ptr = 0 ) as uint32
  return( rgba( _
    OA_BLEND( dst.r, CMAX( ( src.r + dst.r ) - 256, 0 ), src.a, op ), _
    OA_BLEND( dst.g, CMAX( ( src.g + dst.g ) - 256, 0 ), src.a, op ), _
    OA_BLEND( dst.b, CMAX( ( src.b + dst.b ) - 256, 0 ), src.a, op ), _
    OA_BLEND( dst.a, src.a, src.a, op ) ) )
end function

function bm_substract_GIMP( src as RGBAColor, dst as RGBAColor, op as ubyte = 255, param as any ptr = 0 ) as uint32
  return( rgba( _
    OA_BLEND( dst.r, CMAX( dst.r - src.r, 0 ), src.a, op ), _
    OA_BLEND( dst.g, CMAX( dst.g - src.g, 0 ), src.a, op ), _
    OA_BLEND( dst.b, CMAX( dst.b - src.b, 0 ), src.a, op ), _
    OA_BLEND( dst.a, src.a, src.a, op ) ) )
end function

function bm_darkenOnly( src as RGBAColor, dst as RGBAColor, op as ubyte = 255, param as any ptr = 0 ) as uint32
  return( rgba( _
    OA_BLEND( dst.r, CMIN( dst.r, src.r ), src.a, op ), _
    OA_BLEND( dst.g, CMIN( dst.g, src.g ), src.a, op ), _
    OA_BLEND( dst.b, CMIN( dst.b, src.b ), src.a, op ), _
    OA_BLEND( dst.a, src.a, src.a, op ) ) )
end function

function bm_lightenOnly( src as RGBAColor, dst as RGBAColor, op as ubyte = 255, param as any ptr = 0 ) as uint32
  return( rgba( _
    OA_BLEND( dst.r, CMAX( dst.r, src.r ), src.a, op ), _
    OA_BLEND( dst.g, CMAX( dst.g, src.g ), src.a, op ), _
    OA_BLEND( dst.b, CMAX( dst.b, src.b ), src.a, op ), _
    OA_BLEND( dst.a, src.a, src.a, op ) ) )
end function

function bm_average( src as RGBAColor, dst as RGBAColor, op as ubyte = 255, param as any ptr = 0 ) as uint32
  return( rgba( _
    OA_BLEND( dst.r, ( dst.r + src.r ) shr 1, src.a, op ), _
    OA_BLEND( dst.g, ( dst.g + src.g ) shr 1, src.a, op ), _
    OA_BLEND( dst.b, ( dst.b + src.b ) shr 1, src.a, op ), _
    OA_BLEND( dst.a, src.a, src.a, op ) ) )
end function

function bm_stamp( src as RGBAColor, dst as RGBAColor, op as ubyte = 255, param as any ptr = 0 ) as uint32
  return( rgba( _
    OA_BLEND( dst.r, CCLMP( dst.r + 2 * src.r - 256 ), src.a, op ), _
    OA_BLEND( dst.g, CCLMP( dst.g + 2 * src.g - 256 ), src.a, op ), _
    OA_BLEND( dst.b, CCLMP( dst.b + 2 * src.b - 256 ), src.a, op ), _
    OA_BLEND( dst.a, src.a, src.a, op ) ) )
end function

const as single C_I3 = 1 / 3

function bm_grayscale( src as RGBAColor, dst as RGBAColor, op as ubyte = 255, param as any ptr = 0 ) as uint32
  dim as ubyte avg = ( src.r + src.g + src.b ) * C_I3
  
  return( rgba( _
    OA_BLEND( dst.r, avg, src.a, op ), _
    OA_BLEND( dst.g, avg, src.a, op ), _
    OA_BLEND( dst.b, avg, src.a, op ), _
    OA_BLEND( dst.a, src.a, src.a, op ) ) )
end function

function bm_desaturate( src as RGBAColor, dst as RGBAColor, op as ubyte = 255, param as any ptr = 0 ) as uint32
  dim as ubyte _
    l = ( 77 * src.r + 153 * src.g + 26 * src.b ) shr 8, _
    amount = *cast( ubyte ptr, param )
  
  return( rgba( _
    OA_BLEND( dst.r, src.r + CMULT( amount, l - src.r ), src.a, op ), _
    OA_BLEND( dst.g, src.g + CMULT( amount, l - src.g ), src.a, op ), _
    OA_BLEND( dst.b, src.b + CMULT( amount, l - src.b ), src.a, op ), _
    OA_BLEND( dst.a, src.a, src.a, op ) ) )
end function

function bm_negative( src as RGBAColor, dst as RGBAColor, op as ubyte = 255, param as any ptr = 0 ) as uint32
  return( rgba( _
    OA_BLEND( dst.r, CMAX( 0, 255 - src.r ), src.a, op ), _
    OA_BLEND( dst.g, CMAX( 0, 255 - src.g ), src.a, op ), _
    OA_BLEND( dst.b, CMAX( 0, 255 - src.b ), src.a, op ), _
    OA_BLEND( dst.a, src.a, src.a, op ) ) )
end function

function bm_brighten( src as RGBAColor, dst as RGBAColor, op as ubyte = 255, param as any ptr = 0 ) as uint32
  dim as ubyte amount = *cast( ubyte ptr, param )
  
  return( rgba( _
    OA_BLEND( dst.r, CMIN( 255, amount + src.r ), src.a, op ), _
    OA_BLEND( dst.g, CMIN( 255, amount + src.g ), src.a, op ), _
    OA_BLEND( dst.b, CMIN( 255, amount + src.b ), src.a, op ), _
    OA_BLEND( dst.a, src.a, src.a, op ) ) )
end function

function bm_darken( src as RGBAColor, dst as RGBAColor, op as ubyte = 255, param as any ptr = 0 ) as uint32
  dim as ubyte amount = *cast( ubyte ptr, param )
  
  return( rgba( _
    OA_BLEND( dst.r, CMAX( 0, src.r - amount ), src.a, op ), _
    OA_BLEND( dst.g, CMAX( 0, src.g - amount ), src.a, op ), _
    OA_BLEND( dst.b, CMAX( 0, src.b - amount ), src.a, op ), _
    OA_BLEND( dst.a, src.a, src.a, op ) ) )
end function

function bm_brightness( src as RGBAColor, dst as RGBAColor, op as ubyte = 255, param as any ptr = 0 ) as uint32
  dim as int32 amount = *cast( int32 ptr, param )
  
  return( rgba( _
    OA_BLEND( dst.r, CCLMP( amount + src.r ), src.a, op ), _
    OA_BLEND( dst.g, CCLMP( amount + src.g ), src.a, op ), _
    OA_BLEND( dst.b, CCLMP( amount + src.b ), src.a, op ), _
    OA_BLEND( dst.a, src.a, src.a, op ) ) )
end function

function bm_reflect( src as RGBAColor, dst as RGBAColor, op as ubyte = 255, param as any ptr = 0 ) as uint32
  return( rgba( _
    OA_BLEND( dst.r, iif( dst.r = 255, _
      255, CMIN( 255, ( src.r * src.r ) \ ( 255 - dst.r ) ) ), src.a, op ), _
    OA_BLEND( dst.g, iif( dst.g = 255, _
      255, CMIN( 255, ( src.g * src.g ) \ ( 255 - dst.g ) ) ), src.a, op ), _
    OA_BLEND( dst.b, iif( dst.b = 255, _
      255, CMIN( 255, ( src.b * src.b ) \ ( 255 - dst.b ) ) ), src.a, op ), _
    OA_BLEND( dst.a, src.a, src.a, op ) ) )
end function

function bm_glow( src as RGBAColor, dst as RGBAColor, op as ubyte = 255, param as any ptr = 0 ) as uint32
  return( rgba( _
    OA_BLEND( dst.r, CMIN( 255, iif( src.r = 255, _
      255, ( dst.r * dst.r ) \ ( 255 - src.r ) ) ), src.a, op ), _
    OA_BLEND( dst.g, CMIN( 255, iif( src.g = 255, _
      255, ( dst.g * dst.g ) \ ( 255 - src.g ) ) ), src.a, op ), _
    OA_BLEND( dst.b, CMIN( 255, iif( src.b = 255, _
      255, ( dst.b * dst.b ) \ ( 255 - src.b ) ) ), src.a, op ), _
    OA_BLEND( dst.a, src.a, src.a, op ) ) )
end function

function bm_freeze( src as RGBAColor, dst as RGBAColor, op as ubyte = 255, param as any ptr = 0 ) as uint32
  return( rgba( _
    OA_BLEND( dst.r, iif( src.r = 0, 0, _
      CMAX( 0, 255 - ( ( 255 - dst.r ) ^ 2 ) \ src.r ) ), src.a, op ), _
    OA_BLEND( dst.g, iif( src.g = 0, 0, _
      CMAX( 0, 255 - ( ( 255 - dst.g ) ^ 2 ) \ src.g ) ), src.a, op ), _
    OA_BLEND( dst.b, iif( src.b = 0, 0, _
      CMAX( 0, 255 - ( ( 255 - dst.b ) ^ 2 ) \ src.b ) ), src.a, op ), _
    OA_BLEND( dst.a, src.a, src.a, op ) ) )
end function

function bm_heat( src as RGBAColor, dst as RGBAColor, op as ubyte = 255, param as any ptr = 0 ) as uint32
  return( rgba( _
    OA_BLEND( dst.r, iif( dst.r = 0, 0, _
      CMAX( 0, 255 - ( ( 255 - src.r ) ^ 2 ) \ dst.r ) ), src.a, op ), _
    OA_BLEND( dst.g, iif( dst.g = 0, 0, _
      CMAX( 0, 255 - ( ( 255 - src.g ) ^ 2 ) \ dst.g ) ), src.a, op ), _
    OA_BLEND( dst.b, iif( dst.b = 0, 0, _
      CMAX( 0, 255 - ( ( 255 - src.b ) ^ 2 ) \ dst.b ) ), src.a, op ), _
    OA_BLEND( dst.a, src.a, src.a, op ) ) )
end function

function bm_exclusion( src as RGBAColor, dst as RGBAColor, op as ubyte = 255, param as any ptr = 0 ) as uint32
  return( rgba( _
    OA_BLEND( dst.r, CMAX( 0, 128 - CMULT( 2, ( dst.r - 128 ) * ( src.r - 128 ) ) ), src.a, op ), _
    OA_BLEND( dst.g, CMAX( 0, 128 - CMULT( 2, ( dst.g - 128 ) * ( src.g - 128 ) ) ), src.a, op ), _
    OA_BLEND( dst.b, CMAX( 0, 128 - CMULT( 2, ( dst.b - 128 ) * ( src.b - 128 ) ) ), src.a, op ), _
    OA_BLEND( dst.a, src.a, src.a, op ) ) )
end function

function bm_tint( src as RGBAColor, dst as RGBAColor, op as ubyte = 255, param as any ptr = 0 ) as uint32
  var tint = *cast( tintParams ptr, param )
  
  return( rgba( _
    OA_BLEND( dst.r, CCLMP( src.r + CMULT( RGBA_R( tint.tintColor ), tint.amount ) ), src.a, op ), _
    OA_BLEND( dst.g, CCLMP( src.g + CMULT( RGBA_G( tint.tintColor ), tint.amount ) ), src.a, op ), _
    OA_BLEND( dst.b, CCLMP( src.b + CMULT( RGBA_B( tint.tintColor ), tint.amount ) ), src.a, op ), _
    OA_BLEND( dst.a, src.a, src.a, op ) ) )
end function

function bm_min( src as RGBAColor, dst as RGBAColor, op as ubyte = 255, param as any ptr = 0 ) as uint32
  return( rgba( _
    OA_BLEND( dst.r, CMIN( src.r, dst.r ), src.a, op ), _
    OA_BLEND( dst.g, CMIN( src.g, dst.g ), src.a, op ), _
    OA_BLEND( dst.b, CMIN( src.b, dst.b ), src.a, op ), _
    OA_BLEND( dst.a, src.a, src.a, op ) ) )
end function

function bm_max( src as RGBAColor, dst as RGBAColor, op as ubyte = 255, param as any ptr = 0 ) as uint32
  return( rgba( _
    OA_BLEND( dst.r, CMAX( src.r, dst.r ), src.a, op ), _
    OA_BLEND( dst.g, CMAX( src.g, dst.g ), src.a, op ), _
    OA_BLEND( dst.b, CMAX( src.b, dst.b ), src.a, op ), _
    OA_BLEND( dst.a, src.a, src.a, op ) ) )
end function

function bm_and( src as RGBAColor, dst as RGBAColor, op as ubyte = 255, param as any ptr = 0 ) as uint32
  return( rgba( _
    OA_BLEND( dst.r, src.r and dst.r, src.a, op ), _
    OA_BLEND( dst.g, src.g and dst.g, src.a, op ), _
    OA_BLEND( dst.b, src.b and dst.b, src.a, op ), _
    OA_BLEND( dst.a, src.a, src.a, op ) ) )
end function

function bm_or( src as RGBAColor, dst as RGBAColor, op as ubyte = 255, param as any ptr = 0 ) as uint32
  return( rgba( _
    OA_BLEND( dst.r, src.r or dst.r, src.a, op ), _
    OA_BLEND( dst.g, src.g or dst.g, src.a, op ), _
    OA_BLEND( dst.b, src.b or dst.b, src.a, op ), _
    OA_BLEND( dst.a, src.a, src.a, op ) ) )
end function

function bm_xor( src as RGBAColor, dst as RGBAColor, op as ubyte = 255, param as any ptr = 0 ) as uint32
  return( rgba( _
    OA_BLEND( dst.r, src.r xor dst.r, src.a, op ), _
    OA_BLEND( dst.g, src.g xor dst.g, src.a, op ), _
    OA_BLEND( dst.b, src.b xor dst.b, src.a, op ), _
    OA_BLEND( dst.a, src.a, src.a, op ) ) )
end function

function bm_hardMix( src as RGBAColor, dst as RGBAColor, op as ubyte = 255, param as any ptr = 0 ) as uint32
  return( rgba( _
    OA_BLEND( dst.r, iif( src.r + dst.r < 255, 0, 255 ), src.a, op ), _
    OA_BLEND( dst.g, iif( src.g + dst.g < 255, 0, 255 ), src.a, op ), _
    OA_BLEND( dst.b, iif( src.b + dst.b < 255, 0, 255 ), src.a, op ), _
    OA_BLEND( dst.a, src.a, src.a, op ) ) )
end function

function bm_linearBurn( src as RGBAColor, dst as RGBAColor, op as ubyte = 255, param as any ptr = 0 ) as uint32
  return( rgba( _
    OA_BLEND( dst.r, CMAX( 0, ( dst.r + src.r ) - 255 ), src.a, op ), _
    OA_BLEND( dst.g, CMAX( 0, ( dst.g + src.g ) - 255 ), src.a, op ), _
    OA_BLEND( dst.b, CMAX( 0, ( dst.b + src.b ) - 255 ), src.a, op ), _
    OA_BLEND( dst.a, src.a, src.a, op ) ) )
end function

function bm_linearLight( src as RGBAColor, dst as RGBAColor, op as ubyte = 255, param as any ptr = 0 ) as uint32
  return( rgba( _
    OA_BLEND( dst.r, CCLMP( iif( src.r <= 128, _
      dst.r + 2 * src.r - 255, dst.r + 2 * ( src.r - 128 ) ) ), src.a, op ), _
    OA_BLEND( dst.g, CCLMP( iif( src.g <= 128, _
      dst.g + 2 * src.g - 255, dst.g + 2 * ( src.g - 128 ) ) ), src.a, op ), _
    OA_BLEND( dst.b, CCLMP( iif( src.b <= 128, _
      dst.b + 2 * src.b - 255, dst.b + 2 * ( src.b - 128 ) ) ), src.a, op ), _
    OA_BLEND( dst.a, src.a, src.a, op ) ) )
end function

function bm_pinLight( src as RGBAColor, dst as RGBAColor, op as ubyte = 255, param as any ptr = 0 ) as uint32
  return( rgba( _
    OA_BLEND( dst.r, iif( src.r > 128, _
      CMAX( dst.r, 2 * ( src.r - 127 ) ), CMIN( dst.r, 2 * src.r ) ), src.a, op ), _
    OA_BLEND( dst.g, iif( src.g > 128, _
      CMAX( dst.g, 2 * ( src.g - 127 ) ), CMIN( dst.g, 2 * src.g ) ), src.a, op ), _
    OA_BLEND( dst.b, iif( src.b > 128, _
      CMAX( dst.b, 2 * ( src.b - 127 ) ), CMIN( dst.b, 2 * src.b ) ), src.a, op ), _
    OA_BLEND( dst.a, src.a, src.a, op ) ) )
end function

function bm_vividLight( src as RGBAColor, dst as RGBAColor, op as ubyte = 255, param as any ptr = 0 ) as uint32
  dim as long _
    sr = 2 * src.r, sg = 2 * src.g, sb = 2 * src.b, _
    isr = 2 * ( 255 - src.r ), isg = 2 * ( 255 - src.g ), isb = 2 * ( 255 - src.b )
  
  return( rgba( _
    OA_BLEND( dst.r, iif( src.r <= 127, _
      CMAX( 0, iif( sr > 0, 255 - CDIV( 255 - dst.r, sr ), 0 ) ), _
      CMIN( 255, iif( isr > 0, CDIV( dst.r, isr ), 255 ) ) ), src.a, op ), _
    OA_BLEND( dst.g, iif( src.g <= 127, _
      CMAX( 0, iif( sg > 0, 255 - CDIV( 255 - dst.g, sg ), 0 ) ), _
      CMIN( 255, iif( isg > 0, CDIV( dst.g, isg ), 255 ) ) ), src.a, op ), _
    OA_BLEND( dst.b, iif( src.b <= 127, _
      CMAX( 0, iif( sb > 0, 255 - CDIV( 255 - dst.b, sb ), 0 ) ), _
      CMIN( 255, iif( isb > 0, CDIV( dst.b, isb ), 255 ) ) ), src.a, op ), _
    OA_BLEND( dst.a, src.a, src.a, op ) ) )
end function

function bm_phoenix( src as RGBAColor, dst as RGBAColor, op as ubyte = 255, param as any ptr = 0 ) as uint32
  return( rgba( _
    OA_BLEND( dst.r, CMIN( src.r, dst.r ) - CMAX( src.r, dst.r ) + 255, src.a, op ), _
    OA_BLEND( dst.g, CMIN( src.g, dst.g ) - CMAX( src.g, dst.g ) + 255, src.a, op ), _
    OA_BLEND( dst.b, CMIN( src.b, dst.b ) - CMAX( src.b, dst.b ) + 255, src.a, op ), _
    OA_BLEND( dst.a, src.a, src.a, op ) ) )	
end function

function bm_negation( src as RGBAColor, dst as RGBAColor, op as ubyte = 255, param as any ptr = 0 ) as uint32
  return( rgba( _
    OA_BLEND( dst.r, 255 - abs( 255 - src.r - dst.r ), src.a, op ), _
    OA_BLEND( dst.g, 255 - abs( 255 - src.g - dst.g ), src.a, op ), _
    OA_BLEND( dst.b, 255 - abs( 255 - src.b - dst.b ), src.a, op ), _
    OA_BLEND( dst.a, src.a, src.a, op ) ) )
end function

#endif