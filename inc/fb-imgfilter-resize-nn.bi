#ifndef __FB_IMGFILTER_NEAREST__
#define __FB_IMGFILTER_NEAREST__

function resize_nearest( b as Fb.Bitmap, nw as long, nh as long ) as Fb.Bitmap
  var res = Fb.Bitmap( nw, nh )
  
  dim as long _
    spitch = b.pitchInPixels, _
    dpitch = res.pitchInPixels
  
  dim as long _
    x_ratio = ( ( b.width shl 16 ) / res.width ) + 1, _
    y_ratio = ( ( b.height shl 16 ) / res.height ) + 1
  dim as long x2, y2
  
  for y as integer = 0 to res.height - 1
    for x as integer = 0 to res.width - 1
      x2 = ( ( x * x_ratio ) shr 16 )
      y2 = ( ( y * y_ratio ) shr 16 )
      
      res.pixels[ y * dpitch + x ] = b.pixels[ y2 * spitch + x2 ]
    next
  next
  
  return( res )
end function

#endif
