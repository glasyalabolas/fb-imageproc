#ifndef __IMAGE_FORMAT__
#define __IMAGE_FORMAT__

#include once "file.bi"
#include once "fbgfx.bi"

#ifndef loadBMP
  function loadBMP( path as const string ) as Fb.Image ptr
    #define __BM_WINDOWS__ &h4D42
    
    type __BITMAPFILEHEADER__ field = 1
      as ushort id
      as ulong size
      as ubyte reserved( 0 to 3 )
      as ulong offset
    end type
    
    type __BITMAPINFOHEADER__ field = 1
      as ulong size
      as long width
      as long height
      as ushort planes
      as ushort bpp
      as ulong compression_method
      as ulong image_size
      as ulong h_res
      as ulong v_res
      as ulong color_palette_num
      as ulong colors_used
    end type
    
    dim as any ptr img = 0
    
    if( fileExists( path ) ) then
      dim as __BITMAPFILEHEADER__ header 
      dim as __BITMAPINFOHEADER__ info
      
      dim as long f = freeFile()
      
      open path for binary as f
        get #f, , header
        get #f, sizeof( header ) + 1, info
      close( f )
      
      '' Check if the file is indeed a Windows bitmap
      if( header.id = __BM_WINDOWS__ ) then
        img = imageCreate( info.width, abs( info.height ) )
        bload( path, img )
      end if
    end if
    
    return( img )
  end function
#endif

#ifndef loadTGA
  '' Loads a TGA image info a Fb.Image buffer.
  '' Currently this only loads 32-bit *uncompressed* TGA files.		
  function loadTGA( aPath as const string ) as Fb.Image ptr
    '' TGA file format header
    type __TGAHeader__ field = 1
      as ubyte _
        idLength, _
        colorMapType, _
        dataTypeCode
      as short _
        colorMapOrigin, _
        colorMapLength
      as ubyte _
        colorMapDepth
      as short _
        x_origin, _
        y_origin, _
        width, _
        height
      as ubyte _
        bitsPerPixel, _
        imageDescriptor
    end type
    
    dim as long fileHandle = freeFile()
    
    dim as Fb.Image ptr image
    
    '' Open file
    dim as integer result = open( aPath for binary access read as fileHandle )
    
    if( result = 0 ) then
      '' Retrieve header
      dim as __TGAHeader__ h
      
      get #fileHandle, , h
      
      if( h.dataTypeCode = 2 andAlso h.bitsPerPixel = 32 ) then
        '' Create the image
        image = imageCreate( h.width, h.height, rgba( 0, 0, 0, 0 ) )
        
        '' Pointer to pixel data				
        dim as ulong ptr pix = cptr( ulong ptr, image ) + sizeof( Fb.Image ) \ sizeof( ulong )
        
        '' Get size of padding, as FB aligns the width of its images
        '' to the paragraph (16 bytes) boundary.
        dim as integer padd = image->pitch \ sizeof( ulong )
        
        '' Allocate temporary buffer to hold pixel data
        dim as ulong ptr buffer = allocate( ( h.width * h.height ) * sizeof( ulong ) )
        
        '' Read pixel data from file
        get #fileHandle, , *buffer, h.width * h.height
        
        close( fileHandle )
        
        '' Load pixel data onto image
        for y as integer = 0 to h.height - 1
          for x as integer = 0 to h.width - 1
            dim as integer yy = iif( h.y_origin = 0, ( h.height - 1 ) - y, y )
            
            pix[ yy * padd + x ] = buffer[ y * h.width + x ]
          next
        next
        
        deallocate( buffer )
      end if
    end if
    
    return( image )
  end function
#endif

#endif
