#ifndef __FB_IMGOP_COLORIZE__
#define __FB_IMGOP_COLORIZE__

function colorize( img as Fb.Bitmap, c as RGBAColor, lFunc as gsFunc = @gs_luma ) as Fb.Bitmap
  var res = Fb.Bitmap( img.width, img.height )
  
  dim as long ppitch = res.pitchInPixels
  
  var hsl_c = Colors.RGBtoHSL( Colors.float3( c.r * C_I255, c.g * C_I255, c.b * C_I255 ) )
  
  for y as integer = 0 to img.height - 1
    for x as integer = 0 to img.width - 1
      dim as ulong ppos = y * ppitch + x
      dim as RGBAColor sp = img.pixels[ ppos ]
      
      dim as Colors.float lum = lFunc( sp ) * C_I255
      
      var out_c = Colors.HSLtoRGB( Colors.float3( hsl_c.x, hsl_c.y, lum ) )
      
		  res.pixels[ ppos ] = rgba( out_c.r * 255, out_c.g * 255, out_c.b * 255, sp.a )
    next
  next
  
  return( res )
end function

#endif
