#include once "inc/fb-imaging.bi"

screenRes( 1280, 600, 32 )

with LinearGradient() _
  .addStop( 0.00, Colors.float4( 0.0, 0.0, 128 / 255, 1.0 ) ) _
  .addStop( 0.25, Colors.float4( 0.0, 0.0, 128 / 255, 1.0 ) ) _
  .addStop( 0.43, Colors.float4( 128 / 255, 128 / 255, 128 / 255, 1.0 ) ) _
  .addStop( 0.45, Colors.float4( 149 / 255, 0.0, 192 / 255, 1.0 ) ) _
  .addStop( 0.50, Colors.float4( 255 / 255, 125 / 255, 67 / 255, 1.0 ) ) _
  .addStop( 0.58, Colors.float4( 255 / 255, 255 / 255, 64 / 255, 1.0 ) ) _
  .addStop( 0.72, Colors.float4( 192 / 255, 255 / 255, 255 / 255, 1.0 ) ) _
  .addStop( 1.00, Colors.float4( 128 / 255, 128 / 255, 255 / 255, 1.0 ) )
  
  for i as integer = 0 to 599
    line( 0, i ) - ( 1279, i ), .at( i / 600 )
  next
end with

sleep()
