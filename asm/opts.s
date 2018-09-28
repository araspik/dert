.file "asm/opts.s"

.ifndef ASM_OPTS
.set ASM_OPTS, 1

.ifdef PIC
.set PIC, 1
.else
.set PIC, 0
.endif

.endif
