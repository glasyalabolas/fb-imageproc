#include once "inc/fb-imaging.bi"

screenRes( 1280, 720, 32 )

var src = Fb.Bitmap( loadBMP( "res/test.bmp" ) )

put( 0, 0 ), src, pset

var nn = resize_nearest( src, src.width * 0.57, src.height * 0.57 )
put( 0, 0 ), nn, pset

var bl = resize_bilinear( src, src.width * 0.57, src.height * 0.57 )
put( nn.width, 0 ), bl, pset

sleep()
