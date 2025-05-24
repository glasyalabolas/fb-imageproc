#include once "inc/fb-imaging.bi"

screenRes( 1280, 600, 32 )

var src = Fb.Bitmap( loadBMP( "res/test8.bmp" ) )

put( 0, 0 ), src, pset

var dst = apply( src, cf_emboss )
put( src.width, 0 ), dst, pset

dst = apply( src, cf_sharpen )
put( src.width * 2, 0 ), dst, pset

dst = apply( src, cf_edgeEnhance )
put( 0, src.height ), dst, pset

dst = apply( src, cf_edgeDetect )
put( src.width, src.height ), dst, pset

dst = apply( src, cf_smooth )
put( src.width * 2, src.height ), dst, pset

sleep()
