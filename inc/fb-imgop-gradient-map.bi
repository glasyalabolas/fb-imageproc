#ifndef __FB_IMGOP_MAP__
#define __FB_IMGOP_MAP__

function map overload( b as Fb.Bitmap, l as LinearGradient ) as Fb.Bitmap
  var res = grayscale( b )
  
  dim as long ppitch = res.pitchInPixels
  
  for y as integer = 0 to res.height - 1
    for x as integer = 0 to res.width - 1
      dim as ulong ppos = y * ppitch + x
      dim as RGBAColor c = res.pixels[ ppos ]
      
      var mc = l.at( c.r / 255 )
      
      res.pixels[ ppos ] = rgba( _
        mc.x * 255, mc.y * 255, mc.z * 255, mc.w * 255 )
    next
  next
  
  return( res )
end function

#endif
