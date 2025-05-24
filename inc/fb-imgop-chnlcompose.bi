#ifndef __FB_IMGOP_COMPOSE__
#define __FB_IMGOP_COMPOSE__

function composeHSVA( _
    Hch as Fb.Bitmap, Sch as Fb.Bitmap, Vch as Fb.Bitmap, Ach as Fb.Bitmap ) _
  as Fb.Bitmap
  
  var res = Fb.Bitmap( Hch.width, Hch.height )
  
  dim as long ppitch = res.pitchInPixels
  
  for y as integer = 0 to res.height - 1
    for x as integer = 0 to res.width - 1
      dim as ulong ppos = y * ppitch + x
      
      dim as ubyte _
        HC = RGBA_R( Hch.pixels[ ppos ] ), _
        SC = RGBA_G( Sch.pixels[ ppos ] ), _
        VC = RGBA_B( Vch.pixels[ ppos ] )
      
      var rgb_c = Colors.HSVtoRGB( Colors.float3( _
        fmin( HC * C_I255, 1.0 ), fmin( SC * C_I255, 1.0 ), fmin( VC * C_I255, 1.0 ) ) )
      
      res.pixels[ ppos ] = RGBA( _
        Colors.min( rgb_c.x * 255, 255 ), _
        Colors.min( rgb_c.y * 255, 255 ), _
        Colors.min( rgb_c.z * 255, 255 ), _
        RGBA_A( Ach.pixels[ ppos ] ) )
    next
  next
  
  return( res )
end function

function composeHSLA( _
    Hch as Fb.Bitmap, Sch as Fb.Bitmap, Lch as Fb.Bitmap, Ach as Fb.Bitmap ) _
  as Fb.Bitmap
  
  var res = Fb.Bitmap( Hch.width, Hch.height )
  
  dim as long ppitch = res.pitchInPixels
  
  for y as integer = 0 to res.height - 1
    for x as integer = 0 to res.width - 1
      dim as ulong ppos = y * ppitch + x
      
      dim as ubyte _
        HC = RGBA_R( Hch.pixels[ ppos ] ), _
        SC = RGBA_G( Sch.pixels[ ppos ] ), _
        LC = RGBA_B( Lch.pixels[ ppos ] )
      
      var rgb_c = Colors.HSLtoRGB( Colors.float3( _
        HC * C_I255, SC * C_I255, LC * C_I255 ) )
      
      res.pixels[ ppos ] = RGBA( _
        Colors.min( rgb_c.x * 255, 255 ), _
        Colors.min( rgb_c.y * 255, 255 ), _
        Colors.min( rgb_c.z * 255, 255 ), _
        RGBA_A( Ach.pixels[ ppos ] ) )
    next
  next
  
  return( res )
end function

function composeHCYA( _
    Hch as Fb.Bitmap, Cch as Fb.Bitmap, Ych as Fb.Bitmap, Ach as Fb.Bitmap ) _
  as Fb.Bitmap
  
  var res = Fb.Bitmap( Hch.width, Hch.height )
  
  dim as long ppitch = res.pitchInPixels
  
  for y as integer = 0 to res.height - 1
    for x as integer = 0 to res.width - 1
      dim as ulong ppos = y * ppitch + x
      
      dim as ubyte _
        HC = RGBA_R( Hch.pixels[ ppos ] ), _
        CC = RGBA_G( Cch.pixels[ ppos ] ), _
        YC = RGBA_B( Ych.pixels[ ppos ] )
      
      var rgb_c = Colors.HCYtoRGB( Colors.float3( _
        HC * C_I255, CC * C_I255, YC * C_I255 ) )
      
      res.pixels[ ppos ] = RGBA( _
        Colors.min( rgb_c.x * 255, 255 ), _
        Colors.min( rgb_c.y * 255, 255 ), _
        Colors.min( rgb_c.z * 255, 255 ), _
        RGBA_A( Ach.pixels[ ppos ] ) )
    next
  next
  
  return( res )
end function

function composeRGBA( _
    Rch as Fb.Bitmap, Gch as Fb.Bitmap, Bch as Fb.Bitmap, Ach as Fb.Bitmap ) _
  as Fb.Bitmap
  
  var res = Fb.Bitmap( Rch.width, Rch.height )
  
  dim as long ppitch = res.pitchInPixels
  
  for y as integer = 0 to res.height - 1
    for x as integer = 0 to res.width - 1
      dim as ulong ppos = y * ppitch + x
      
      res.pixels[ ppos ] = RGBA( _
        RGBA_R( Rch.pixels[ ppos ] ), _
        RGBA_G( Gch.pixels[ ppos ] ), _
        RGBA_B( Bch.pixels[ ppos ] ), _
        RGBA_A( Ach.pixels[ ppos ] ) )
    next
  next
  
  return( res )
end function

#endif
