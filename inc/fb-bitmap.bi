#ifndef __FB_BITMAP__
#define __FB_BITMAP__

#include once "fbgfx.bi"
#include once "crt.bi"

#ifndef uint32
  type as ulong uint32
#endif

namespace Fb
  type Bitmap
    public:
      declare constructor()
      declare constructor( as long, as long, as uint32 = rgba( 0, 0, 0, 0 ) )
      declare constructor( as Fb.Image ptr )
      declare constructor( as Bitmap )
      declare destructor()
      
      declare operator let( as Bitmap )
      declare operator let( as Fb.Image ptr )
      
      declare operator cast() as any ptr
      
      declare property width() as long
      declare property height() as long
      declare property pitch() as long
      declare property pitchInPixels() as long
      
      declare property pixels() as uint32 ptr
      
      declare sub clear( as uint32 = rgba( 0, 0, 0, 0 ) )
      
    private:
      as Fb.Image ptr _image
  end type
  
  constructor Bitmap()
  end constructor
  
  constructor Bitmap( w as long, h as long, bc as uint32 = rgba( 0, 0, 0, 0 ) )
    _image = imageCreate( w, h, bc )
  end constructor
  
  constructor Bitmap( i as Fb.Image ptr )
    _image = i
  end constructor
  
  constructor Bitmap( b as Bitmap )
    _image = imageCreate( b.width, b.height )
    
    memcpy( _
      cast( ubyte ptr, _image ) + sizeof( Fb.Image ), _
      cast( ubyte ptr, b ) + sizeof( Fb.Image ), _
      b._image->pitch * b._image->height )
  end constructor
  
  destructor Bitmap()
    if( _image ) then
      imageDestroy( _image )
      _image = 0
    end if
  end destructor
  
  operator Bitmap.let( rhs as Bitmap )
    if( _image ) then
      imageDestroy( _image )
    end if
    
    _image = imageCreate( rhs.width, rhs.height, rgba( 0, 0, 0, 0 ) )
    
    memcpy( _
      cast( ubyte ptr, _image ) + sizeof( Fb.Image ), _
      cast( ubyte ptr, rhs._image ) + sizeof( Fb.Image ), _
      rhs._image->pitch * rhs._image->height )
  end operator
  
  operator Bitmap.let( rhs as Fb.Image ptr )
    if( _image ) then
      imageDestroy( _image )
    end if
    
    _image = imageCreate( rhs->width, rhs->height, rgba( 0, 0, 0, 0 ) )
    
    memcpy( _
      cast( ubyte ptr, _image ) + sizeof( Fb.Image ), _
      cast( ubyte ptr, rhs ) + sizeof( Fb.Image ), _
      rhs->pitch * rhs->height )
  end operator
  
  operator Bitmap.cast() as any ptr
    return( _image )
  end operator
  
  property Bitmap.width() as long
    return( iif( _image, _image->width, 0 ) )
  end property
  
  property Bitmap.height() as long
    return( iif( _image, _image->height, 0 ) )
  end property
  
  property Bitmap.pitch() as long
    return( iif( _image, _image->pitch, 0 ) )
  end property
  
  property Bitmap.pitchInPixels() as long
    return( iif( _image, _image->pitch \ sizeof( ulong ), 0 ) )
  end property
  
  property Bitmap.pixels() as uint32 ptr
    return( cast( uint32 ptr, cast( ubyte ptr, _image ) + sizeof( Fb.Image ) ) )
  end property
  
  sub Bitmap.clear( c as uint32 = rgba( 0, 0, 0, 0 ) )
    dim as long ppitch = pitchInPixels
    
    for i as integer = 0 to ( _image->height * ppitch ) - 1
      pixels[ i ] = c
    next
  end sub
end namespace

#endif
