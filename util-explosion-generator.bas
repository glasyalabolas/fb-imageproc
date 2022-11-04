#include once "inc/fb-imaging.bi"

screenRes( 800, 600, 32 )

var src = Fb.Bitmap( loadBMP( "res/exp.bmp" ) )
put( 0, 0 ), src, pset

var explo = map( gaussianBlur( src, 2 ), LinearGradient() _
  .addStop( 0.00, Colors.float4( 0.0, 0.0, 0.0, 1.0 ) ) _
  .addStop( 0.55, Colors.float4( 16 / 255, 16 / 255, 16 / 255, 1.0 ) ) _
  .addStop( 0.72, Colors.float4( 1.0, 0.0, 0.0, 1.0 ) ) _
  .addStop( 0.91, Colors.float4( 1.0, 1.0, 0.0, 1.0 ) ) _
  .addStop( 1.00, Colors.float4( 1.0, 1.0, 1.0, 1.0 ) ) )

put( src.width, 0 ), explo, pset

sleep()
