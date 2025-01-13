// based on 'obfusgator.zig, Toby Jaffey 2025-01-07'
// zig run obfusgator.zig
// zig run obfusgator.zig -- myprog.zig
                                                                                
                   const std = @import (                                        
           "std" ) ; const runs = [ _ ]                                         
        u8 { 99 , 24 , 48 , 29 , 48                                             
        , 29 , 51 , 29 , 48 , 22 ,                                              
     58 , 14 , 64 , 16 ,                                                        
     64 , 16 , 64                                                               
   , 13 , 67 , 13                                                               
   , 67 , 13 , 65                                                               
   , 15 , 65 ,                                                                  
   15 , 65 , 12                                                                 
   , 68 , 12 ,                                                                  
 59 , 8 , 1 ,                                                                   
 12 , 30 , 10 ,                                                                 
 16 , 11 , 1                                                                    
 , 12 , 30 ,                                                            10 , 16 
 , 11 , 1 ,                                18 , 21 ,                 8 , 5 , 18 
 , 2 , 1 , 2                               , 4 , 1 ,                 23 , 11 ,  
 13 , 5 , 24 , 4 ,                      47 , 5       , 19 , 3 , 2 , 4       ,   
 71 , 3 , 2 , 4 , 66 ,             2 , 3 , 9 ,       60 , 3 , 3 , 14 , 55 ,     
 3 , 2 , 20 , 55 , 3 , 2 , 20 , 50 , 30 , 50 ,       30 , 50 , 5 , 3 ,          
 24 , 56 , 2 , 3 , 3 , 2 , 3 , 3 , 8 , 56 , 2 , 3 , 3 , 2 , 3 , 3 , 8 ,         
 77 , 3 , 77 , 3 , 74 , 6 , 74 , 8 , 11 , 16 , 11 , 42 , 16 , 11 ,   16         
 , 40 , 16 , 11 , 16 , 37 , 16 , 11 , 16 , 37 , 16 , 11 , 16    ,               
 29 } ; pub fn main ( ) ! void { var gpa = std . heap .                         
 GeneralPurposeAllocator ( . { } ) . init ; defer _ =                           
 gpa . deinit ( ) ; const allocator = gpa .                                     
 allocator ( ) ; const writer = std . io .                                      
 getStdOut ( ) . writer ( ) ; const file_name =                                 
   "obfusgator.zig" ; const help_base = "// zig run " ++                        
   file_name ; _ = try writer . write ( help_base ++ "\n"    ++                 
   help_base ++ " -- myprog.zig" ++ "\n" ) ; const args = try std . process .   
   argsAlloc ( allocator ) ; defer std . process . argsFree ( allocator , args  
   ) ; const src = if ( args . len > 1 ) try std . fs . cwd ( ) .               
   readFileAllocOptions ( allocator , args [ 1 ] , 1 << 20 , null , 1 , 0 )     
     else                       @embedFile                                      
     ( file_name ) ;            defer if ( args                                 
        . len > 1 )                allocator .                                  
        free ( src ) ;             var gator : [                                
        40 * 80 ] u1 =             undefined ; var                              
                                                                                
                                     gator_len : usize = 0 ;                    
                                        for ( runs , 0 .. ) | run ,             
                                           i | { @memset ( gator [              
                                           gator_len .. gator_len + run         
                                                     ] , @truncate ( i ) )      
                                                             ; gator_len        
                                                             += run ; } var     
                                                             tokenizer = std    
                                                                . zig .         
                                                                Tokenizer .     
                                                                init ( src )    
                                                                ; var pos :     
                                                                usize = 0 ;     
                                                                   var res =    
std .                                                              ArrayList (  
u8 ) .                     init (                                  allocator )  
; defer                    res .                                   deinit ( )   
;        while ( true ) {       const                        token = tokenizer  
   . next ( ) ; switch (        token . tag             ) { . eof => break , .  
        doc_comment , .         container_doc_comment => continue , .           
        multiline_string_literal_line => return error . TokenUnsupported ,      
             else => { } , } const token_len = token . loc . end - token . loc  
             .     start ; if ( token_len > 76 ) { return error . TokenTooLong  
                   ;    } for ( 2 ) | _ | { if ( std . mem . indexOf ( u1 ,     
                        gator [ pos .. ] , @as ( [ 80 ] u1 , @splat ( 1 ) ) [   
                             0 .. token_len + 1 ] ) ) | idx | { try res .       
                             appendNTimes ( ' ' , idx ) ; try res .             
                             appendSlice ( src [ token . loc . start .. token   
     .               loc . end ] ) ; try res . append ( ' ' ) ; pos += idx +    
                     token_len + 1 ; break ; } try res . appendNTimes ( ' '     
, gator_len - pos ) ; pos = 0 ; for ( 0 .. 40 ) | i | { std . mem . reverse     
( u1 , gator [ i * 80 .. ] [ 0 .. 80 ] ) ; } } else unreachable ; } for (       
   res . items , 1 .. ) | item , i | { try writer . writeByte ( item ) ; if     
   ( i % 80 == 0 ) { try writer . writeByte ( '\n' ) ; } } } 
