#include once "inc/fb-imaging.bi"

screenRes( 800, 600, 32 )

var img = Fb.Bitmap( loadBMP( "res/test2.bmp" ) )
put( 0, 0 ), img, pset

var blr = blur( img, 2, 2 )
put( img.width, 0 ), blr, pset

sleep()
