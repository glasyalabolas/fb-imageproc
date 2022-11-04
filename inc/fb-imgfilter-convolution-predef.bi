#ifndef __FB_FILTER_CONVOLUTION_PREDEF__
#define __FB_FILTER_CONVOLUTION_PREDEF__

'' Some predefined convolution filters
function cf_emboss( b as double = 128.0 ) as ConvolutionFilter
  var c = ConvolutionFilter( 3, 3 )
  
  c[ 0 ] = -1 : c[ 1 ] = -1 : c[ 2 ] = 0
  c[ 3 ] = -1 : c[ 4 ] =  0 : c[ 5 ] = 1
  c[ 6 ] =  0 : c[ 7 ] =  1 : c[ 8 ] = 1
  
  c.bias = b
  
  return( c )
end function

function cf_embossMore( b as double = 128.0 ) as ConvolutionFilter
  var c = ConvolutionFilter( 5, 5 )
  
  c[  0 ] = -1 : c[  1 ] = -1 : c[  2 ] = -1 : c[  3 ] = -1 : c[  4 ] = 0
  c[  5 ] = -1 : c[  6 ] = -1 : c[  7 ] = -1 : c[  8 ] =  0 : c[  9 ] = 1
  c[ 10 ] = -1 : c[ 11 ] = -1 : c[ 12 ] =  0 : c[ 13 ] =  1 : c[ 14 ] = 1
  c[ 15 ] = -1 : c[ 16 ] =  0 : c[ 17 ] =  1 : c[ 18 ] =  1 : c[ 19 ] = 1
  c[ 20 ] =  0 : c[ 21 ] =  1 : c[ 22 ] =  1 : c[ 23 ] =  1 : c[ 24 ] = 1
  
  c.bias = b
  
  return( c )
end function

function cf_sharpen( b as double = 0.0 ) as ConvolutionFilter
  var c = ConvolutionFilter( 5, 5 )
  
  c[  0 ] = -1 : c[  1 ] = -1 : c[  2 ] = -1 : c[  3 ] = -1 : c[  4 ] = -1
  c[  5 ] = -1 : c[  6 ] =  2 : c[  7 ] =  2 : c[  8 ] =  2 : c[  9 ] = -1
  c[ 10 ] = -1 : c[ 11 ] =  2 : c[ 12 ] =  8 : c[ 13 ] =  2 : c[ 14 ] = -1
  c[ 15 ] = -1 : c[ 16 ] =  2 : c[ 17 ] =  2 : c[ 18 ] =  2 : c[ 19 ] = -1
  c[ 20 ] = -1 : c[ 21 ] = -1 : c[ 22 ] = -1 : c[ 23 ] = -1 : c[ 24 ] = -1
  
  c.bias = b
  
  return( c )
end function

function cf_sharpenMore( b as double = 0.0 ) as ConvolutionFilter
  var c = ConvolutionFilter( 3, 3 )
  
  c[ 0 ] = -1 : c[ 1 ] = -1 : c[ 2 ] = -1
  c[ 3 ] = -1 : c[ 4 ] =  9 : c[ 5 ] = -1
  c[ 6 ] = -1 : c[ 7 ] = -1 : c[ 8 ] = -1
  
  c.bias = b
  
  return( c )
end function

function cf_edgeEnhance( b as double = 0.0 ) as ConvolutionFilter
  var c = ConvolutionFilter( 3, 3 )
  
  c[ 0 ] = 1 : c[ 1 ] =  1 : c[ 2 ] = 1
  c[ 3 ] = 1 : c[ 4 ] = -6 : c[ 5 ] = 1
  c[ 6 ] = 1 : c[ 7 ] =  1 : c[ 8 ] = 1
  
  c.bias = b
  
  return( c )
end function

function cf_edgeDetect( b as double = 0.0 ) as ConvolutionFilter
  var c = ConvolutionFilter( 3, 3 )
  
  c[ 0 ] = -1 : c[ 1 ] = -1 : c[ 2 ] = -1
  c[ 3 ] = -1 : c[ 4 ] =  8 : c[ 5 ] = -1
  c[ 6 ] = -1 : c[ 7 ] = -1 : c[ 8 ] = -1
  
  c.bias = b
  
  return( c )
end function
  
function cf_findEdgesV( b as double = 0.0 ) as ConvolutionFilter
  var c = ConvolutionFilter( 5, 5 )
  
  c[  0 ] = 0 : c[  1 ] = 0 : c[  2 ] = -1 : c[  3 ] = 0 : c[  4 ] = 0
  c[  5 ] = 0 : c[  6 ] = 0 : c[  7 ] = -1 : c[  8 ] = 0 : c[  9 ] = 0
  c[ 10 ] = 0 : c[ 11 ] = 0 : c[ 12 ] =  4 : c[ 13 ] = 0 : c[ 14 ] = 0
  c[ 15 ] = 0 : c[ 16 ] = 0 : c[ 17 ] = -1 : c[ 18 ] = 0 : c[ 19 ] = 0
  c[ 20 ] = 0 : c[ 21 ] = 0 : c[ 22 ] = -1 : c[ 23 ] = 0 : c[ 24 ] = 0
  
  c.bias = b
  
  return( c )
end function

function cf_findEdgesH( b as double = 0.0 ) as ConvolutionFilter
  var c = ConvolutionFilter( 5, 5 )
  
  c[  0 ] =  0 : c[  1 ] =  0 : c[  2 ] = 0 : c[  3 ] =  0 : c[  4 ] =  0
  c[  5 ] =  0 : c[  6 ] =  0 : c[  7 ] = 0 : c[  8 ] =  0 : c[  9 ] =  0
  c[ 10 ] = -1 : c[ 11 ] = -1 : c[ 12 ] = 4 : c[ 13 ] = -1 : c[ 14 ] = -1
  c[ 15 ] =  0 : c[ 16 ] =  0 : c[ 17 ] = 0 : c[ 18 ] =  0 : c[ 19 ] =  0
  c[ 20 ] =  0 : c[ 21 ] =  0 : c[ 22 ] = 0 : c[ 23 ] =  0 : c[ 24 ] =  0
  
  c.bias = b
  
  return( c )
end function

function cf_smooth( b as double = 0.0 ) as ConvolutionFilter
  var c = ConvolutionFilter( 3, 3 )
  
  c[ 0 ] = 1 : c[ 1 ] = 1 : c[ 2 ] = 1
  c[ 3 ] = 1 : c[ 4 ] = 9 : c[ 5 ] = 1
  c[ 6 ] = 1 : c[ 7 ] = 1 : c[ 8 ] = 1
  
  c.bias = b
  
  return( c )
end function

#endif
