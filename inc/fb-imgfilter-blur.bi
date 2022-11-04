#ifndef __FB_FILTER_BLUR__
#define __FB_FILTER_BLUR__

function blur( img as Fb.Bitmap, passes as long = 1, size as long = 1 ) as Fb.Bitmap
  var dst = img, src = img
  
  dim as Fb.Bitmap ptr pDst = @dst, pSrc = @src
  
  dim as long ppitch = img.pitchInPixels
  
  for i as integer = 0 to passes
    for y as integer = 0 to pSrc->height - 1
      for x as integer = 0 to pSrc->width - 1
        dim as long sumr, sumg, sumb, suma, count
        dim as RGBAColor c
        
        for yy as integer = Colors.max( 0, y - size ) to Colors.min( pSrc->height - 1, y + size )
          for xx as integer = Colors.max( 0, x - size ) to Colors.min( pSrc->width - 1, x + size )
            c = pSrc->pixels[ ppitch * yy + xx ]
            
            sumr += c.r
            sumg += c.g
            sumb += c.b
            suma += c.a
            
            count += 1
          next
        next
        
        dim as long iCount = 255 / count
        
        c.r = Colors.min( 255, ( sumr * iCount ) shr 8 )
        c.g = Colors.min( 255, ( sumg * iCount ) shr 8 )
        c.b = Colors.min( 255, ( sumb * iCount ) shr 8 )
        c.a = Colors.min( 255, ( suma * iCount ) shr 8 )
        
        pDst->pixels[ ppitch * y + x ] = c
      next
    next
    
    swap pDst, pSrc
  next
  
  return( *pDst )
end function

#endif
