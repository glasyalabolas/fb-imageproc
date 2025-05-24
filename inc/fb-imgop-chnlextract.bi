#ifndef __FB_IMGOP_CHNLEXTRACT__
#define __FB_IMGOP_CHNLEXTRACT__

type as function( as RGBAColor ) as long chFunc

function chRed( c as RGBAColor ) as long
  return( c.r )
end function

function chGreen( c as RGBAColor ) as long
  return( c.g )
end function

function chBlue( c as RGBAColor ) as long
  return( c.b )
end function

function chAlpha( c as RGBAColor ) as long
  return( c.a )
end function

function chHue( c as RGBAColor ) as long
  var hsl_c = Colors.RGBtoHSL( Colors.float3( _
    c.r * C_I255, c.g * C_I255, c.b * C_I255 ) )
  
  return( Colors.min( hsl_c.x * 255, 255 ) )
end function

function chHSV_Saturation( c as RGBAColor ) as long
  var hsv_c = Colors.RGBtoHSV( Colors.float3( _
    c.r * C_I255, c.g * C_I255, c.b * C_I255 ) )
  
  return( Colors.min( hsv_c.y * 255, 255 ) )
end function

function chHSV_Value( c as RGBAColor ) as long
  var hsv_c = Colors.RGBtoHSV( Colors.float3( _
    c.r * C_I255, c.g * C_I255, c.b * C_I255 ) )
  
  return( Colors.min( hsv_c.z * 255, 255 ) )
end function

function chHSL_Saturation( c as RGBAColor ) as long
  var hsl_c = Colors.RGBtoHSL( Colors.float3( _
    c.r * C_I255, c.g * C_I255, c.b * C_I255 ) )
  
  return( Colors.min( hsl_c.y * 255, 255 ) )
end function

function chHSL_Lightness( c as RGBAColor ) as long
  var hsl_c = Colors.RGBtoHSL( Colors.float3( _
    c.r * C_I255, c.g * C_I255, c.b * C_I255 ) )
  
  return( Colors.min( hsl_c.z * 255, 255 ) )
end function

function chHCY_Chroma( c as RGBAColor ) as long
  var hcy_c = Colors.RGBtoHCY( Colors.float3( _
    c.r * C_I255, c.g * C_I255, c.b * C_I255 ) )
  
  return( Colors.min( hcy_c.y * 255, 255 ) )
end function

function chHCY_Luminance( c as RGBAColor ) as long
  var hcy_c = Colors.RGBtoHCY( Colors.float3( _
    c.r * C_I255, c.g * C_I255, c.b * C_I255 ) )
  
  return( Colors.min( hcy_c.z * 255, 255 ) )
end function

function extract( img as Fb.Bitmap, channel as chFunc ) as Fb.Bitmap
  var res = Fb.Bitmap( img.width, img.height )
  
  dim as long ppitch = img.pitchInPixels
  
  for y as integer = 0 to img.height - 1
    for x as integer = 0 to img.width - 1
      dim as ulong ppos = y * ppitch + x
      dim as long value = channel( img.pixels[ ppos ] )
      
      res.pixels[ ppos ] = rgba( value, value, value, 255 )
    next
  next
  
  return( res )
end function

#endif
