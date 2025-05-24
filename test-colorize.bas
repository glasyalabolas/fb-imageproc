#include once "inc/fb-imaging.bi"

screenRes( 1280, 600, 32 )

var img = Fb.Bitmap( loadBMP( "res/test2.bmp" ) )
put( 0, 0 ), img, pset

var res = colorize( img, rgb( 0, 255, 255 ) )
put( img.width, 0 ), res, pset

sleep()
