#ifndef __FB_OP_GRAYSCALE__
#define __FB_OP_GRAYSCALE__

type as function( as RGBAColor ) as long gsFunc

function gs_luma( c as RGBAColor ) as long
  return( Colors.clamp( ( c.r * 0.21 + c.g * 0.71 + c.b * 0.07 ), 0, 255 ) )
end function

function gs_lightness( c as RGBAColor ) as long
  return( Colors.clamp( 0.5 * ( Colors.max( Colors.max( c.r, c.g ), c.b ) + _
    Colors.min( Colors.min( c.r, c.g ), c.b ) ), 0, 255 ) )
end function

function gs_average( c as RGBAColor ) as long
  return( Colors.clamp( ( c.r + c.g + c.b ) / 3, 0, 255 ) )
end function

function gs_value( c as RGBAColor ) as long
  return( Colors.max( Colors.max( c.r, c.g ), c.b ) )
end function

function grayscale( img as Fb.Bitmap, method as gsFunc = @gs_average ) as Fb.Bitmap
  var res = Fb.Bitmap( img.width, img.height )
  
  dim as long ppitch = img.pitchInPixels
  
  for y as integer = 0 to img.height - 1
    for x as integer = 0 to img.width - 1
      dim as ulong ppos = y * ppitch + x
      dim as RGBAColor c = img.pixels[ ppos ]
      
      dim as long value = method( c )
      
      res.pixels[ ppos ] = rgba( value, value, value, c.a )
    next
  next
  
  return( res )
end function

#endif
