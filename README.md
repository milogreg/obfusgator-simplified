# obfusgator.zig

A zig program obfusgator

To self obfusgator:

```bash
zig run obfusgator.zig
```

To obfusgator another program:

```bash
zig run obfusgator.zig -- myprog.zig
```

```zig
// obfusgator.zig, Toby Jaffey 2025-01-07
// zig run obfusgator.zig
// zig run obfusgator.zig -- myprog.zig
                                                                                
                   const g = & [ _ ] u8 {                                       
           31 , 139 , 8 , 8 , 45 , 79 ,                                         
        125 , 103 , 0 , 3 , 102 ,                                               
        111 , 111 , 46 , 112 , 112 ,                                            
     109 , 0 , 237 , 211 ,                                                      
     203 , 13 ,                                                                 
   131 , 48 , 16 ,                                                              
   69 , 209 , 172                                                               
   , 93 , 69 ,                                                                  
   74 , 64 , 40                                                                 
   , 160 , 148                                                                  
 , 65 , 255 ,                                                                   
 205 , 144 , 29                                                                 
 , 66 , 254                                                                     
 , 105 , 226                                                            , 121 , 
 248 , 243 ,                               60 , 119                  , 69 , 64  
 , 25 , 124                                , 12 , 28                 , 187 ,    
 251 , 46 , 239 ,                       207 ,        226 , 214 , 109 ,      115 
 , 47 , 75 , 214 , 9 ,             170 , 181 ,       195 , 15 , 229 , 50 ,      
 102 , 87 , 77 , 226 , 229 , 19 , 229 , 99 ,         117 , 133 , 113 ,          
 63 , 199 , 48 , 243 , 82 , 50 , 175 , 204 , 203 , 234 , 21 , 74 , 205     ,    
 59 , 104 , 147 , 48 , 175 , 40 , 189 , 25 , 72 , 91 , 47 , 246 ,               
 190 , 18 , 136 , 121 , 43 , 236 , 128 , 112 , 172 , 102 ,                      
 109 , 247 , 131 , 251 , 165 , 178 , 153 , 209 , 91 ,                           
 104 , 118 , 62 , 58 , 7 , 178 , 54 , 111 , 44 , 106 ,                          
 38 , 36 , 148 , 215 , 155 , 208 , 173 , 23 , 21 ,                              
 189 , 215 , 179 , 232 , 191 , 172 , 174 , 10 , 23                              
 , 159 , 1 , 142 , 232 , 205 , 188 , 159 , 255 ,                                
   214 , 22 , 34 , 140 , 222 , 171 , 17 , 153 , 119 , 56 ,                      
   111 , 234 , 60 , 153 , 58 , 44 , 197 , 143 , 254 , 60 ,                      
   211 , 251 , 83 , 123 , 221 , 165 , 205 , 230 , 85 , 102 , 94 , 202 , 102 ,   
   123 , 159 , 139 , 191 , 226 , 212 , 31 , 171 , 13 , 196 , 134 , 218 , 183 ,  
   231 , 6 , 62 , 212 , 108 , 112 , 243 , 114 , 120 , 127 , 82 , 105 , 15 ,     
   254 , 141 , 37 , 0 , 0 } ; const z = @import ( "std" ) ; const Ti = z .      
     zig .                      Tokenizer                                       
     ; const T = z .            zig . Token ;                                   
        const a = z .              heap .                                       
        page_allocator             ; const io = z                               
        . io ; const w             = io .                                       
                                                                                
                                     getStdOut ( ) . writer                     
                                        ( ) ; const mem = z . mem ;             
                                           const fmt = z . fmt ; const          
                                           iobs = io .                          
                                                     fixedBufferStream ;        
                                                             const u =          
                                                             undefined ; pub    
                                                             const P =          
                                                                struct { d :    
                                                                [ 2 ] u32 ,     
                                                                p : [ ] u1 ,    
                                                                pub fn from (   
                                                                ls : [ ] const  
                                                                   u8 ) ! P {   
var f =                                                            iobs ( ls )  
; var ln :                 u32 = 0 ;                               var p : P =  
u ; var lb                 : [ 1024                                * 128 ] u8   
= u      ; var b = io .                                      bufferedReader (   
   f . reader ( ) ) ; var       r = b .                 reader ( ) ; while (    
        true ) { if ( try       r . readUntilDelimiterOrEof ( & lb , '\n' ) )   
   |    l | { switch ( ln ) { 1 => { var it = mem . splitAny ( u8 , l , " " )   
        ;    for ( 0 .. 2 ) | i | p . d [ i ] = try fmt . parseInt ( u32 , it   
             .     next ( ) . ? , 10 ) ; } , 3 => { p . p = try a . alloc ( u1  
                   ,    p . d [ 0 ] * p . d [ 1 ] ) ; for ( 0 .. p . d [ 0 ] *  
                   p    . d [ 1 ] ) | i | { if ( l [ i * 3 ] > 0 or l [ i * 3   
                             + 1 ] > 0 or l [ i * 3 + 2 ] > 0 ) { p . p [ i ]   
                             = 1 ; } } break ; } , else => { } , } ln += 1 ; }  
                     }       return p ; } } ; fn pt ( src : [ ] const u8 , ts   
     :     [    ]    const T , ti : * u32 , ncf : u32 , pws : * bool ) !        
                     void { var nc = ncf ; while ( true ) { if ( ti .* >= ts    
. len ) { return ; } const tok = ts [ ti .* ] ; if ( mem . containsAtLeast (    
u8 , @tagName ( tok . tag ) , 1 , "comment" ) ) { ti .* += 1 ; continue ; }     
   var tl : u32 = @intCast ( ( tok . loc . end - tok . loc . start ) + 1 ) ;    
   if ( ! pws .* ) tl += 1 ; if ( tl <= nc ) { if ( ! pws .* ) _ = try w .      
                                     write (                    " " ) ;         
                                try w . print (            "{s} " , . {         
                             src [ tok . loc            . start .. tok          
                             . loc . end ] }            ) ; pws .* =            
                             true ; nc -= tl            ; ti .* += 1 ;          
                                                                                
                   } else { for ( 0 .. nc                                       
           ) | _ | _ = try w . write (                                          
        " " ) ; return ; } } } pub                                              
        fn main ( ) ! void { _ = try                                            
     w . write ( "// zig"                                                       
     ++ " run" ++                                                               
   " obfusg" ++                                                                 
   "ator.zig" ++                                                                
   "\n// zig"                                                                   
   ++                                                                           
   " run obfus"                                                                 
 ++ "gator.zig"                                                                 
 ++ " -- m" ++                                                                  
 "yprog" ++                                                                     
 ".zig\n" )                                                             ; const 
 args = try                                z .                       process .  
 argsAlloc (                               a ) ; var                 src : [ :  
 0 ] const u8 =                                      @embedFile (               
 "obfusgator.zig" ) ;              if ( args .       len > 1 ) { const d =      
 try z . fs . cwd ( ) . readFileAlloc ( a ,          args [ 1 ] , 1024     *    
 64 ) ; src = try a . dupeZ ( u8 , d ) ; } var in = iobs ( g ) ; var r     :    
 [ 32768 ] u8 = u ; var ot = iobs ( & r ) ; try z . compress .                  
 gzip . decompress ( in . reader ( ) , ot . writer ( ) ) ;                      
 const p = try P . from ( & r ) ; var e : bool = false     ;                    
 var elen : u32 = 0 ; var ts = z . ArrayList ( T ) .                            
 init ( a ) ; var tokenizer = Ti . init ( src ) ;                               
 while ( true ) { const token = tokenizer . next (                              
 ) ; try ts . append ( token ) ; if ( token . tag       ==                      
   . eof ) break ; } var ti : u32 = 0 ; var pws = true ;                        
   var n : u32 = 0 ; while ( ti < ts . items . len ) { for   (     0    ..      
   p . d [ 1 ] ) | y | { for ( 0 .. p . d [ 0 ] ) | x | { var nx = x ; if ( n % 
   2 > 0 ) { nx = ( p . d [ 0 ] - 1 ) - x ; } if ( p . p [ y * p . d [ 0 ] + nx 
   ] > 0 ) { if ( ! e ) { e = true ; elen = 1 ; } else { elen += 1 ; } }        
   else { if ( e ) { e = false ; try pt ( src , ts . items , & ti , elen , &    
     pws ) ; }                  _ = try w                                       
     . write ( " " )            ; } } if ( e )                                  
        { e = false ;              try pt ( src ,                               
        ts . items , &             ti , elen , &                                
        pws ) ; } try w            . print ( "\n"                               
                                                                                
                                     , . { } ) ; if ( ti >=                     
                                        ts . items . len ) break ; }            
                                           n += 1 ; } }          
```
