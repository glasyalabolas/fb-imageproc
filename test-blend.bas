#include once "inc/fb-imaging.bi"

sub showBlend( _
  x as long, y as long, dst as Fb.Bitmap, src as Fb.Bitmap, f as blendFunc, _
  n as string, op as ubyte = 255, p as longInt = 0 )
  
  var res = blend( dst, src, op, f, , , @p )
  
  draw string res, ( res.width - ( len( n ) * 8 ) - 8 + 1, res.height - 8 - 8 + 1 ), n, rgb( 0, 0, 0 )
  draw string res, ( res.width - ( len( n ) * 8 ) - 8, res.height - 8 - 8 ), n, rgb( 255, 255, 255 )
  
  put( x, y ), res, pset
end sub

screenRes( 1280, 720, 32 )

var dst = Fb.Bitmap( loadBMP( "res/test6.bmp" ) )
var src = Fb.Bitmap( loadBMP( "res/test7.bmp" ) )

dim as ubyte p

cls()
put( 0, 0 ), dst, pset
put( dst.width, 0 ), src, pset

showBlend( 0, dst.height, dst, src, @bm_alpha, "Alpha", 128 )
showBlend( dst.width, dst.height, dst, src, @bm_dissolve, "Dissolve", 128, 128 )
showBlend( dst.width * 2, dst.height, dst, src, @bm_multiply, "Multiply" )
showBlend( dst.width * 3, dst.height, dst, src, @bm_divide, "Divide" )
showBlend( 0, dst.height * 2, dst, src, @bm_screen, "Screen" )
showBlend( dst.width, dst.height * 2, dst, src, @bm_overlay, "Overlay" )
showBlend( dst.width * 2, dst.height * 2, dst, src, @bm_dodge, "Dodge" )
showBlend( dst.width * 3, dst.height * 2, dst, src, @bm_dodge, "Burn" )

sleep()

cls()
put( 0, 0 ), dst, pset
put( dst.width, 0 ), src, pset

showBlend( 0, dst.height, dst, src, @bm_hardLight, "Hard Light" )
showBlend( dst.width, dst.height, dst, src, @bm_softLight, "Soft Light" )
showBlend( dst.width * 2, dst.height, dst, src, @bm_grainExtract, "Grain Extract" )
showBlend( dst.width * 3, dst.height, dst, src, @bm_grainMerge, "Grain Merge" )
showBlend( 0, dst.height * 2, dst, src, @bm_difference, "Difference" )
showBlend( dst.width, dst.height * 2, dst, src, @bm_add, "Add" )
showBlend( dst.width * 2, dst.height * 2, dst, src, @bm_substract, "Substract" )
showBlend( dst.width * 3, dst.height * 2, dst, src, @bm_substract_GIMP, "Substract (GIMP)" )

sleep()

cls()
put( 0, 0 ), dst, pset
put( dst.width, 0 ), src, pset

showBlend( 0, dst.height, dst, src, @bm_darkenOnly, "Darken Only" )
showBlend( dst.width, dst.height, dst, src, @bm_lightenOnly, "Lighten Only" )
showBlend( dst.width * 2, dst.height, dst, src, @bm_average, "Average" )
showBlend( dst.width * 3, dst.height, dst, src, @bm_stamp, "Stamp" )
showBlend( 0, dst.height * 2, dst, src, @bm_grayscale, "Grayscale" )
showBlend( dst.width, dst.height * 2, dst, src, @bm_desaturate, "Desaturate", 128 )
showBlend( dst.width * 2, dst.height * 2, dst, src, @bm_negative, "Negative" )
showBlend( dst.width * 3, dst.height * 2, dst, src, @bm_brighten, "Brighten", 128 )

sleep()

cls()
put( 0, 0 ), dst, pset
put( dst.width, 0 ), src, pset

showBlend( 0, dst.height, dst, src, @bm_darken, "Darken", 128 )
showBlend( dst.width, dst.height, dst, src, @bm_brightness, "Brightness", 128 )
showBlend( dst.width * 2, dst.height, dst, src, @bm_reflect, "Reflect" )
showBlend( dst.width * 3, dst.height, dst, src, @bm_glow, "Glow" )
showBlend( 0, dst.height * 2, dst, src, @bm_freeze, "Freeze" )
showBlend( dst.width, dst.height * 2, dst, src, @bm_heat, "Heat" )
showBlend( dst.width * 2, dst.height * 2, dst, src, @bm_exclusion, "Exclusion" )
showBlend( dst.width * 3, dst.height * 2, dst, src, @bm_tint, "Tint", , tintParams( rgb( 255, 128, 64 ), 128 ).p )

sleep()

cls()
put( 0, 0 ), dst, pset
put( dst.width, 0 ), src, pset

showBlend( 0, dst.height, dst, src, @bm_min, "Min" )
showBlend( dst.width, dst.height, dst, src, @bm_max, "Max" )
showBlend( dst.width * 2, dst.height, dst, src, @bm_and, "And" )
showBlend( dst.width * 3, dst.height, dst, src, @bm_or, "Or" )
showBlend( 0, dst.height * 2, dst, src, @bm_xor, "Xor" )
showBlend( dst.width, dst.height * 2, dst, src, @bm_hardMix, "Hard Mix" )
showBlend( dst.width * 2, dst.height * 2, dst, src, @bm_linearBurn, "Linear Burn" )
showBlend( dst.width * 3, dst.height * 2, dst, src, @bm_linearLight, "Linear Light" )

sleep()

cls()
put( 0, 0 ), dst, pset
put( dst.width, 0 ), src, pset

showBlend( 0, dst.height, dst, src, @bm_pinLight, "Pin Light" )
showBlend( dst.width, dst.height, dst, src, @bm_vividLight, "Vivid Light" )
showBlend( dst.width * 2, dst.height, dst, src, @bm_phoenix, "Phoenix" )
showBlend( dst.width * 3, dst.height, dst, src, @bm_negation, "Negation" )
'showBlend( 0, dst.height * 2, dst, src, @bm_difference, "Difference" )
'showBlend( dst.width, dst.height * 2, dst, src, @bm_add, "Add" )
'showBlend( dst.width * 2, dst.height * 2, dst, src, @bm_substract, "Substract" )
'showBlend( dst.width * 3, dst.height * 2, dst, src, @bm_substract_GIMP, "Substract (GIMP)" )

sleep()
