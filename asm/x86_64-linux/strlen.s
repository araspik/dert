/**** Provides an optimized C string length calculator.
  * 
  * It utilizes SSE2 instructions, which we assume are available on x86_64.
  * 
  * Author: ARaspiK
  * License: MIT
  */

.include "asm/opts.s"
.file "x86_64-linux/strlen.s"

.section .text.strlen,"ax",@progbits
  .p2align 4,,15

.globl strlen
.type strlen, @function
.weak strlen
strlen: # const(char)* ptr -> (size_t | len+ptr arr)

  pxor %xmm0, %xmm0 # clear zero XMM reg
  mov %rdi, %rdx # move ptr to result register.
  xor %rax, %rax # zero count.

  // Test the first 16 bytes, then align up to 16 bytes
  movups (%rdi), %xmm1 # load unaligned
  pcmpeqb %xmm0, %xmm1 # compare to zeroes
  pmovmskb %xmm1, %rcx # store element-by-element comparisons as bits (1: equal, 0: !equal)
  bsf %rcx, %rcx # scan for matches
  jnz .Ldone # if mismatches occurred, then we finish
  // Otherwise we align the ptr.
  sub %rdi, %rax # subtract the ptr, negating it
  and $0xf, %rax # take the last 4 bits, which contain alignment.
  jmp .Lloop_postinc

.Lloop: # main loop, in 16 byte sets
  add $0x10, %rax # increment
.Lloop_postinc: # loop without increment
  movaps (%rdi, %rax), %xmm1 # load aligned
  pcmpeqb %xmm0, %xmm1 # compare to zero
  pmovmskb %xmm1, %rcx # store e-by-e comparisons as bits
  bsf %rcx, %rcx # scan for matches
  jz .Lloop # if nothing was found loop
.Lloop_done:
  // Otherwise skip to clean up

.Ldone: # clean-up
  add %rcx, %rax # add bit count to length
  ret # return

.size strlen, .-strlen
