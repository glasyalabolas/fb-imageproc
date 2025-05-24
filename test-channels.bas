#include once "inc/fb-imaging.bi"

sub showChannels( _
  img as Fb.Bitmap, ch1 as Fb.Bitmap, ch2 as Fb.Bitmap, ch3 as Fb.Bitmap, ch4 as Fb.Bitmap )
  
  cls()
  
  put( 0, 0 ), img, pset
  put( 0, img.height ), ch1, pset
  put( img.width, img.height ), ch2, pset
  put( img.width * 2, img.height ), ch3, pset
  put( img.width * 3, img.height ), ch4, pset
end sub

screenRes( 1280, 600, 32 )

var img = Fb.Bitmap( loadBMP( "res/test3.bmp" ) )

windowTitle( "RGB: Red, Green, Blue, Alpha" )

showChannels( img, _
  extract( img, @chRed ), _
  extract( img, @chGreen ), _
  extract( img, @chBlue ), _
  extract( img, @chAlpha ) )

sleep()

windowTitle( "HSV: Hue, Saturation, Value, Alpha" )

showChannels( img, _
  extract( img, @chHue ), _
  extract( img, @chHSV_Saturation ), _
  extract( img, @chHSV_Value ), _
  extract( img, @chAlpha ) )

sleep()

windowTitle( "HSL: Hue, Saturation, Lightness, Alpha" )

showChannels( img, _
  extract( img, @chHue ), _
  extract( img, @chHSL_Saturation ), _
  extract( img, @chHSL_Lightness ), _
  extract( img, @chAlpha ) )

sleep()

windowTitle( "HCY: Hue, Chroma, Luminance, Alpha" )

showChannels( img, _
  extract( img, @chHue ), _
  extract( img, @chHCY_Chroma ), _
  extract( img, @chHCY_Luminance ), _
  extract( img, @chAlpha ) )

sleep()

