#include once "inc/fb-imaging.bi"

screenRes( 1280, 600, 32 )

var img = Fb.Bitmap( loadBMP( "res/test2.bmp" ) )
put( 0, 0 ), img, pset

put( img.width, 0 ), flipH( img ), pset
put( img.width * 2, 0 ), flipV( img ), pset

sleep()
