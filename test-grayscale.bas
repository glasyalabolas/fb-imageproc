#include once "inc/fb-imaging.bi"

screenRes( 1280, 600, 32 )

var img = Fb.Bitmap( loadBMP( "res/test3.bmp" ) )
put( 0, 0 ), img, pset

var gs1 = grayscale( img, @gs_luma )
put( img.width, 0 ), gs1, pset

var gs2 = grayscale( img, @gs_lightness )
put( img.width * 2, 0 ), gs2, pset

var gs3 = grayscale( img, @gs_average )
put( img.width * 3, 0 ), gs3, pset

var gs4 = grayscale( img, @gs_value )
put( 0, img.height ), gs4, pset

sleep()
