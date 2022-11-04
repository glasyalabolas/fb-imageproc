#ifndef __FB_IMGOP_FLIP__
#define __FB_IMGOP_FLIP__

function flipH( b as Fb.Bitmap ) as Fb.Bitmap
  var res = Fb.Bitmap( b.width, b.height )
  
  dim as long ppitch = res.pitchInPixels
  
  for y as integer = 0 to res.height - 1
    for x as integer = 0 to res.width - 1
      res.pixels[ y * ppitch + ( res.width - x ) ] = b.pixels[ y * ppitch + x ]
    next
  next
  
  return( res )
end function

function flipV( b as Fb.Bitmap ) as Fb.Bitmap
  var res = Fb.Bitmap( b.width, b.height )
  
  dim as long ppitch = res.pitchInPixels
  
  for y as integer = 0 to res.height - 1
    for x as integer = 0 to res.width - 1
      res.pixels[ ( res.height - y ) * ppitch + x ] = b.pixels[ y * ppitch + x ]
    next
  next
  
  return( res )
end function

#endif
