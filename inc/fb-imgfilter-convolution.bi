#ifndef __FB_FILTER_CONVOLUTION__
#define __FB_FILTER_CONVOLUTION__

type ConvolutionFilter
  declare constructor()
  declare constructor( as long, as long )
  
  declare property width() as long
  declare property height() as long
  
  declare operator []( as integer ) byref as single
  declare operator cast() as single ptr
  
  as long bias
  
  private:
    as long _w, _h
    as single _v( any )
end type

constructor ConvolutionFilter() : end constructor

constructor ConvolutionFilter( w as long, h as long )
  _w = iif( w < 3, 3, w ) : _h = iif( h < 3, 3, h )
  redim _v( 0 to ( _w * _h ) - 1 )
end constructor

operator ConvolutionFilter.[]( index as integer ) byref as single
  return( _v( index ) )
end operator

operator ConvolutionFilter.cast() as single ptr
  return( @_v( 0 ) )
end operator

property ConvolutionFilter.width() as long
  return( _w )
end property

property ConvolutionFilter.height() as long
  return( _h )
end property

'' Applies the specified convolution filter to a bitmap
function apply overload( src as Fb.Bitmap, f as ConvolutionFilter ) as Fb.Bitmap
  var dst = Fb.Bitmap( src.width, src.height )
  
  dim as long ppitch = dst.pitchInPixels
  
  dim as single factor
  
  for i as integer = 0 to f.width * f.height - 1
    factor += f[ i ]
  next
  
  if( factor = 0 ) then factor = 1
  
  dim as long ifactor = ( 1 / factor ) * 255 
  
  for y as integer = 0 to dst.height - 1
    for x as integer = 0 to dst.width - 1
      dim as long red, green, blue
      
      for filterY as integer = 0 to f.height - 1
        for filterX as integer = 0 to f.width - 1
          dim as long _
            imageX = ( x - f.width shr 1 + filterX ), _
            imageY = ( y - f.height shr 1 + filterY )
          
          if( imageX >= 0 andAlso imageX <= dst.width - 1 andAlso _
            imageY >= 0 andAlso imageY <= dst.height - 1 ) then
            
            dim as RGBAColor c = src.pixels[ imageY * ppitch + imageX ]
            
            dim as single fv = f[ filterX * f.width + filterY ]
            
            red += c.r * fv
            green += c.g * fv
            blue += c.b * fv
          end if
        next
      next
      
      dst.pixels[ y * ppitch + x ] = rgba( _
        Colors.clamp( ( ifactor * red ) shr 8 + f.bias, 0, 255 ), _
        Colors.clamp( ( ifactor * green ) shr 8 + f.bias, 0, 255 ), _
        Colors.clamp( ( ifactor * blue ) shr 8 + f.bias, 0, 255 ), _
        255 )
    next
  next
  
  return( dst )
end function

#endif
