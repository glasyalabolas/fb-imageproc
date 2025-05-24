#ifndef __FB_IMAGING__
#define __FB_IMAGING__

#include once "fb-image-format.bi"
#include once "fb-bitmap.bi"
#include once "fb-colors.bi"
#include once "fb-linear-gradient.bi"

#ifndef RGBA_R
  #define RGBA_R( c ) ( culng( c ) shr 16 and 255 )
#endif

#ifndef RGBA_G
  #define RGBA_G( c ) ( culng( c ) shr 8 and 255 )
#endif

#ifndef RGBA_B
  #define RGBA_B( c ) ( culng( c ) and 255 )
#endif

#ifndef RGBA_A
  #define RGBA_A( c ) ( culng( c ) shr 24 )
#endif

const as double C_I255 = 1.0 / 255

#include once "fb-imgop-grayscale.bi"
#include once "fb-imgop-chnlextract.bi"
#include once "fb-imgop-chnlcompose.bi"
#include once "fb-imgop-colorize.bi"
#include once "fb-imgop-gradient-map.bi"
#include once "fb-imgop-blend.bi"
#include once "fb-imgop-flip.bi"

#include once "fb-imgfilter-blur.bi"
#include once "fb-imgfilter-gaussblur.bi"
#include once "fb-imgfilter-convolution.bi"
#include once "fb-imgfilter-convolution-predef.bi"
#include once "fb-imgfilter-resize-nn.bi"
#include once "fb-imgfilter-resize-bilinear.bi"

#endif
