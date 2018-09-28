/**** Provides a C string length function.
  * 
  * Author: ARaspiK
  * License: MIT
  */
module core.c.strlen;

/**** A C string length function.
  * 
  * The implementation is in assembly for optimization; see the `asm/` dir.
  */
extern(C) @system @nogc inout(char)[] strlen(inout(char)*) nothrow pure;
