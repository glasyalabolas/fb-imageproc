#ifndef __FB_IMAGING_LINEARGRADIENT__
#define __FB_IMAGING_LINEARGRADIENT__

#include once "fb-colors.bi"

type GradientStop
  declare constructor()
  declare constructor( as double, as Colors.float4 )
  
  as double t
  as Colors.float4 c
end type

constructor GradientStop() : end constructor

constructor GradientStop( t_ as double, c_ as Colors.float4 )
  t = t_ : c = c_
end constructor

type LinearGradient
  declare function at( as double ) as Colors.float4
  declare function addStop( as double, as Colors.float4 ) byref as LinearGradient
  
  private:
    as GradientStop _grad( any )
end type

function LinearGradient.at( t as double ) as Colors.float4
  dim as integer count = ( ubound( _grad ) - lbound( _grad ) ) + 1
  
  if( count = 0 ) then
    return( Colors.float4( 0.0, 0.0, 0.0, 0.0 ) )
  end if
  
  t = Colors.clamp( t, 0.0, 1.0 )
  
  dim as integer _
    low = 0, _
    high = count - 1, _
    first = 0
  
  if( t >= _grad( high ).t ) then
    first = high
  else
    do while( low <= high )
      dim as integer middle = low + ( high - low + 1 ) \ 2
      dim as double midVal = _grad( middle ).t
      
      if( midVal < t ) then
        first = middle
        low = middle + 1
      elseif( midVal > t ) then
        high = middle - 1
      elseif( midVal = t ) then
        high = middle - 1
      end if
    loop
    
    first = iif( _grad( low ).t = t, low, first )
  end if
  
  dim as integer last = Colors.clamp( first + 1, 0, count - 1 )
  
  dim as double dt = _grad( last ).t - _grad( first ).t
  
  return( iif( dt > 0, Colors.mix( _
    _grad( first ).c, _grad( last ).c, ( t - _grad( first ).t ) / dt ), _grad( last ).c ) )
end function

function LinearGradient.addStop( t as double, c as Colors.float4 ) byref as LinearGradient
  redim preserve _grad( 0 to ubound( _grad ) + 1 )
  _grad( ubound( _grad ) ) = GradientStop( t, c )
  
  for i as integer = 0 to ubound( _grad )
    dim as GradientStop key = _grad( i )
    dim as long j = i
    
    do while( j > 0 andAlso _grad( j - 1 ).t > key.t )
      _grad( j ) = _grad( j - 1 )
      j = j - 1
    loop
    
    _grad( j ) = key
  next
  
  return( this )
end function

#endif
