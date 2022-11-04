#ifndef __FB_IMGFILTER_GAUSSBLUR__
#define __FB_IMGFILTER_GAUSSBLUR__

'' Fast Gaussian blur
'' Port of:
''   https://blog.ivank.net/fastest-gaussian-blur.html
sub boxesForGauss( sigma as long, n as long, outA() as long )
  var wIdeal = sqr( ( 12 * sigma * sigma / n ) + 1 )
  var wl = floor( wIdeal )
  
  if( wl mod 2 = 0 ) then wl -= 1
  
  var wu = wl + 2
  var mIdeal = (12 * sigma * sigma - n * wl * wl - 4 * n * wl - 3 * n) / (-4 * wl - 4)
  var m = round( mIdeal )
  
  redim outA( 0 to n - 1 )
  
  for i as integer = 0 to n - 1
    outA( i ) = iif( i < m, wl, wu )
  next
end sub

sub boxBlurH_4( src() as long, dst() as long, w as long, h as long, r as long )
  var iarr = 1.0 / ( r + r + 1 )
  for i as integer = 0 to h - 1
    var ti = i * w, li = ti, ri = ti + r
    var fv = src( ti ), lv = src( ti + w - 1 ), val_ = ( r + 1 ) * fv
    
    for j as integer = 0 to r - 1 : val_ += src( ti + j ) : next
    
    for j as integer = 0 to r
      val_ += src( ri ) - fv : dst( ti ) = round( val_ * iarr ) : ri += 1 : ti += 1 : next
    
    for j as integer = r + 1 to ( w - r ) - 1
      val_ += src( ri ) - dst( li ) : dst( ti ) = round( val_ * iarr ) : ri += 1 : li += 1 : ti += 1 : next
    
    for j as integer = w - r to w - 1
      val_ += lv - src( li ) : dst( ti ) = round( val_ * iarr ) : li += 1 : ti += 1 : next
  next
end sub

sub boxBlurT_4( src() as long, dst() as long, w as long, h as long, r as long )
  var iarr = 1.0 / ( r + r + 1 )
  
  for i as integer = 0 to w - 1
    var ti = i, li = ti, ri = ti + r * w
    var fv = src( ti ), lv = src( ti + w * ( h - 1 ) ), val_ = ( r + 1 ) * fv
    
    for j as integer = 0 to j - 1 : val_ += src( ti + j * w ) : next
    for j as integer = 0 to r
      val_ += src( ri ) - fv : dst( ti ) = round( val_ * iarr ) : ri += w : ti += w : next
    for j as integer = r + 1 to ( h - r ) - 1
      val_ += src( ri ) - dst( li ) : dst( ti ) = round( val_ * iarr ) : li += w : ri += w : ti += w : next
    for j as integer = h - r to h - 1
      val_ += lv - src( li ) : dst( ti ) = round( val_ * iarr ) : li += w : ti += w : next
  next
end sub

sub boxBlur_4( src() as long, dst() as long, w as long, h as long, r as long )
  for i as integer = 0 to ubound( src ) : dst( i ) = src( i ) : next
  boxBlurH_4( dst(), src(), w, h, r )
  boxBlurT_4( src(), dst(), w, h, r )
end sub

sub gaussBlur_4( src() as long, dst() as long, w as long, h as long, r as long )
  dim as long bxs()
  
  boxesForGauss( r, 3, bxs() )
  
  boxBlur_4( src(), dst(), w, h, ( bxs( 0 ) - 1 ) / 2 )
  boxBlur_4( dst(), src(), w, h, ( bxs( 1 ) - 1 ) / 2 )
  boxBlur_4( src(), dst(), w, h, ( bxs( 2 ) - 1 ) / 2 )
end sub

function gaussianBlur( b as Fb.Bitmap, r as long ) as Fb.Bitmap
  var res = Fb.Bitmap( b.width, b.height )
  
  dim as long _
    c_r( 0 to ( b.width * b.height ) - 1 ), _
    c_g( 0 to ( b.width * b.height ) - 1 ), _
    c_b( 0 to ( b.width * b.height ) - 1 ), _
    c_a( 0 to ( b.width * b.height ) - 1 )
  
  dim as long ppitch = b.pitchInPixels
  
  for y as integer = 0 to b.height - 1
    for x as integer = 0 to b.width - 1
      dim as RGBAColor c = b.pixels[ y * ppitch + x ]
      
      c_r( y * b.width + x ) = c.r
      c_g( y * b.width + x ) = c.g
      c_b( y * b.width + x ) = c.b
      c_a( y * b.width + x ) = c.a
    next
  next
  
  dim as long _
    c_nr( 0 to ( b.width * b.height ) - 1 ), _
    c_ng( 0 to ( b.width * b.height ) - 1 ), _
    c_nb( 0 to ( b.width * b.height ) - 1 ), _
    c_na( 0 to ( b.width * b.height ) - 1 )
  
  gaussBlur_4( c_r(), c_nr(), b.width, b.height, r )
  gaussBlur_4( c_g(), c_ng(), b.width, b.height, r )
  gaussBlur_4( c_b(), c_nb(), b.width, b.height, r )
  gaussBlur_4( c_a(), c_na(), b.width, b.height, r )
  
  ppitch = res.pitchInPixels
  
  for y as integer = 0 to res.height - 1
    for x as integer = 0 to res.width - 1
      res.pixels[ y * ppitch + x ] = rgba( _
        Colors.clamp( c_nr( y * res.width + x ), 0, 255 ), _
        Colors.clamp( c_ng( y * res.width + x ), 0, 255 ), _
        Colors.clamp( c_nb( y * res.width + x ), 0, 255 ), _
        Colors.clamp( c_na( y * res.width + x ), 0, 255 ) )
    next
  next
  
  return( res )
end function

#endif