/**** Provides initialisation on x86-64 Linux platforms.
  * 
  * Author: ARaspiK
  * License: MIT
  */

.include "asm/opts.s"
.file "x86_64-linux/init.s"

.section .text.init,"ax",@progbits
  .p2align 4,,15

.globl _start
.type _start, @function
_start:

  // Get argument information
  mov 0(%rsp), %r12 # argc
  lea 8(%rsp), %r13 # argv

  // Allocate space for string[argc] and save the length in bytes.
  mov %r12, %r14 # copy to another save
  shl $0x4, %r14 # multiply by 16
  sub %r14, %rsp # allocate

  // do-while: guaranteed to be 1 arg (prog path)
  xor %rbx, %rbx
.Lloop_args:
  mov 0(%r13, %rbx), %rdi # get arg ptr
  mov %rdi, 8(%rsp, %rbx) # save to args[rbx].ptr
  call strlen # get length
  mov %rax, 0(%rsp, %rbx) # save to args[rbx].length

  add $0x10, %rbx # increment
  test %rbx, %r14 # test
  jne .Lloop_args # continue if not equal
.Ldone_args:

  // Save args.ptr, args.length is same as argc
  mov %rsp, %r13

  // TODO: Constructors, Destructors (.init and .fini sections)

  // Call D main
  mov %r12, %rdi # args.length
  mov %r13, %rsi # args.ptr
  call _Dmain
  mov %rax, %r14 # save result

  // Exit with return value
  mov %r14, %rdi # move result to arg[0] spot
  mov $0x3c, %rax # mov syscall num (60, exit)
  syscall # Exit
.size _start, .-_start
