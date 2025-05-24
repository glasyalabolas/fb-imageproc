#include once "inc/fb-imaging.bi"

screenRes( 1280, 600, 32 )

var src = Fb.Bitmap( loadBMP( "res/test2.bmp" ) )

put( 0, 0 ), src, pset

var gb = gaussianBlur( src, 3 )
put( src.width, 0 ), gb, pset

var sb = blur( src, 3, 3 )
put( src.width * 2, 0 ), sb, pset

sleep()
