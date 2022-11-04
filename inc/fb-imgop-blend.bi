#ifndef __FB_IMGOP_BLEND__
#define __FB_IMGOP_BLEND__

#include once "fb-imgop-blend-modes.bi"

function blend( _
    dst as Fb.Bitmap, src as Fb.Bitmap, _
    o as ubyte = 255, bf as blendFunc = @bm_alpha, x as long = 0, y as long = 0, p as any ptr = 0 ) _
  as Fb.Bitmap
  
  var res = dst
  
  dim as long _
    dstStartX = Colors.max( 0,  x ), dstStartY = Colors.max( 0,  y ), _
    srcStartX = Colors.max( 0, -x ), srcStartY = Colors.max( 0, -y )
  
  var srcp = src.pixels, dstp = dst.pixels, resp = res.pixels
  
  dim as long _
    srcPadding = src.pitchInPixels - src.width, _
    dstPadding = dst.pitchInPixels - dst.width
  
  '' Compute clipping values		
  dim as long _
    srcEndX = Colors.min( src.width - 1, ( ( dst.width - 1 ) - ( x + src.width - 1 ) ) + src.width - 1 ), _
    srcEndY = Colors.min( src.height - 1, ( ( dst.height - 1 ) - ( y + src.height - 1 ) ) + src.height - 1 )
  
  '' Calculate the strides
  dim as long _
    dstStride = dst.pitchInPixels - ( srcEndX - srcStartX ) - 1, _
    srcStride = srcPadding + srcStartX + ( src.width - 1 - srcEndX )
  
  '' Offset the buffers to its starting positions
  dstp += ( ( dstStartY * ( dst.pitchInPixels + dstPadding ) ) + dstStartX )						
  resp += ( ( dstStartY * ( dst.pitchInPixels + dstPadding ) ) + dstStartX )						
  srcp += ( ( srcStartY * src.pitchInPixels ) + srcStartX )
  
  for y as integer = srcStartY to srcEndY
    for x as integer = srcStartX to srcEndX			
      *resp = bf( *srcp, *dstp, o, p )
      
      dstp += 1
      srcp += 1
      resp += 1
    next
    
    dstp += dstStride
    srcp += srcStride
    resp += dstStride
  next
  
  return( res )
end function

#endif
