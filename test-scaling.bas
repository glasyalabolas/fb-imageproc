#include once "inc/fb-imaging.bi"

screenRes( 1280, 720, 32 )

var src = Fb.Bitmap( loadBMP( "res/test.bmp" ) )

put( 0, 0 ), src, pset

var nn = resize_nearest( src, src.width * 0.37, src.height * 0.37 )
put( 0, 0 ), nn, pset

var bl = resize_bilinear( src, src.width * 0.37, src.height * 0.37 )
put( nn.width, 0 ), bl, pset

var nn_upscale = resize_nearest( nn, src.width, src.height )
var bl_upscale = resize_bilinear( bl, src.width, src.height )

put( src.width, 0 ), nn_upscale, pset

sleep()

put( src.width, 0 ), bl_upscale, pset

sleep()
