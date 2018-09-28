/**** Provides types and functions necessary to all D programs.
  * 
  * Author: ARaspiK
  * License: MIT
  */
module object;

/// String type: immutable UTF-8 character array
alias string = immutable(char)[];
/// String type: immutable UTF-16 character array
alias wstring = immutable(wchar)[];
/// String type: immutable UTF-32 character array
alias dstring = immutable(dchar)[];

/// Unsigned type: Architecture word-size (32-bit, 64-bit, etc.) unsigned
alias size_t = typeof(void.sizeof);
/// Signed type: Architecture word-size (32-bit, 64-bit, etc.) signed
alias diff_t = typeof(cast(void*)0 - cast(void*)0);
/// ditto
alias ptrdiff_t = diff_t;
