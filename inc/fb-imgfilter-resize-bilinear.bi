#ifndef __FB_IMGFILTER_BILINEAR__
#define __FB_IMGFILTER_BILINEAR__

function resize_bilinear( src as Fb.Bitmap, w2 as long, h2 as long ) as Fb.Bitmap
  var res = Fb.Bitmap( w2, h2 )
  
  dim as long _
    spitch = src.pitchInPixels, dpitch = res.pitchInPixels
  
  dim as uint32 a, b, c, d
  dim as long xp, yp, index, w = src.width, h = src.height
  dim as single x_ratio = ( w - 1 ) / w2
  dim as single y_ratio = ( h - 1 ) / h2
  dim as single x_diff, y_diff
  dim as long red, green, blue
  
  dim as long offset
  
  for i as integer = 0 to h2 - 1
    for j as integer = 0 to w2 - 1
      xp = int( x_ratio * j )
      yp = int( y_ratio * i )
      x_diff = ( x_ratio * j ) - xp
      y_diff = ( y_ratio * i ) - yp
      
      index = yp * spitch + xp
      
      a = src.pixels[ index ]
      b = src.pixels[ index + 1 ]
      c = src.pixels[ index + spitch ]
      d = src.pixels[ index + spitch + 1 ]
      
      red   = RGBA_R( A ) * ( 1 - x_diff ) * ( 1 - y_diff ) + RGBA_R( B ) * ( x_diff ) * ( 1 - y_diff ) + _
              RGBA_R( C ) * ( y_diff ) * ( 1 - x_diff ) + RGBA_R( D ) * ( x_diff * y_diff )
      green = RGBA_G( A ) * ( 1 - x_diff ) * ( 1 - y_diff ) + RGBA_G( B ) * ( x_diff ) * ( 1 - y_diff ) + _
              RGBA_G( C ) * ( y_diff ) * ( 1 - x_diff ) + RGBA_G( D ) * ( x_diff * y_diff )
      blue  = RGBA_B( A ) * ( 1 - x_diff ) * ( 1 - y_diff ) + RGBA_B( B ) * ( x_diff ) * ( 1 - y_diff ) + _
              RGBA_B( C ) * ( y_diff ) * ( 1 - x_diff ) + RGBA_B( D ) * ( x_diff * y_diff )
      
      res.pixels[ i * dpitch + j ] = rgb( red, green, blue )
      
      next
    next
  return( res )
end function

#endif
