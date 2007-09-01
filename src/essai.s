	.file	"essai.c"
	.section	.rodata.str1.1,"aMS",@progbits,1
.LC0:
	.string	"A"
.LC1:
	.string	"B"
.LC2:
	.string	"C"
.LC3:
	.string	"D"
.LC4:
	.string	"E"
.LC5:
	.string	"F"
.LC6:
	.string	"G"
.LC7:
	.string	"H"
.LC8:
	.string	"I"
.LC9:
	.string	"J"
.LC10:
	.string	"K"
.LC11:
	.string	"L"
.LC12:
	.string	"M"
.LC13:
	.string	"N"
.LC14:
	.string	"O"
.LC15:
	.string	"P"
.LC16:
	.string	"Q"
.LC17:
	.string	"R"
.LC18:
	.string	"S"
.LC19:
	.string	"T"
.LC20:
	.string	"U"
.LC21:
	.string	"V"
.LC22:
	.string	"W"
	.text
	.p2align 4,,15
.globl main
	.type	main, @function
main:
	leal	4(%esp), %ecx
	andl	$-16, %esp
	pushl	-4(%ecx)
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%ecx
	subl	$4, %esp
	call	rand
	cmpl	$210, %eax
	ja	.L2
	jmp	*.L26(,%eax,4)
	.section	.rodata
	.align 4
	.align 4
.L26:
	.long	.L3
	.long	.L4
	.long	.L5
	.long	.L2
	.long	.L2
	.long	.L6
	.long	.L7
	.long	.L8
	.long	.L2
	.long	.L9
	.long	.L10
	.long	.L11
	.long	.L2
	.long	.L12
	.long	.L13
	.long	.L2
	.long	.L2
	.long	.L2
	.long	.L14
	.long	.L2
	.long	.L15
	.long	.L2
	.long	.L16
	.long	.L2
	.long	.L17
	.long	.L18
	.long	.L19
	.long	.L2
	.long	.L2
	.long	.L2
	.long	.L2
	.long	.L2
	.long	.L2
	.long	.L2
	.long	.L2
	.long	.L2
	.long	.L2
	.long	.L2
	.long	.L2
	.long	.L2
	.long	.L2
	.long	.L2
	.long	.L2
	.long	.L2
	.long	.L2
	.long	.L2
	.long	.L2
	.long	.L2
	.long	.L2
	.long	.L2
	.long	.L2
	.long	.L2
	.long	.L2
	.long	.L2
	.long	.L2
	.long	.L2
	.long	.L2
	.long	.L2
	.long	.L2
	.long	.L2
	.long	.L2
	.long	.L2
	.long	.L2
	.long	.L2
	.long	.L2
	.long	.L2
	.long	.L2
	.long	.L2
	.long	.L2
	.long	.L2
	.long	.L20
	.long	.L2
	.long	.L2
	.long	.L2
	.long	.L2
	.long	.L2
	.long	.L2
	.long	.L2
	.long	.L2
	.long	.L2
	.long	.L2
	.long	.L2
	.long	.L2
	.long	.L2
	.long	.L2
	.long	.L2
	.long	.L2
	.long	.L2
	.long	.L2
	.long	.L2
	.long	.L21
	.long	.L2
	.long	.L2
	.long	.L2
	.long	.L2
	.long	.L2
	.long	.L2
	.long	.L2
	.long	.L2
	.long	.L2
	.long	.L2
	.long	.L2
	.long	.L2
	.long	.L2
	.long	.L2
	.long	.L2
	.long	.L2
	.long	.L2
	.long	.L2
	.long	.L2
	.long	.L2
	.long	.L2
	.long	.L2
	.long	.L2
	.long	.L2
	.long	.L2
	.long	.L2
	.long	.L2
	.long	.L2
	.long	.L2
	.long	.L2
	.long	.L2
	.long	.L2
	.long	.L2
	.long	.L2
	.long	.L2
	.long	.L2
	.long	.L2
	.long	.L2
	.long	.L2
	.long	.L2
	.long	.L2
	.long	.L2
	.long	.L2
	.long	.L2
	.long	.L2
	.long	.L2
	.long	.L2
	.long	.L2
	.long	.L2
	.long	.L2
	.long	.L2
	.long	.L2
	.long	.L2
	.long	.L2
	.long	.L2
	.long	.L2
	.long	.L2
	.long	.L2
	.long	.L2
	.long	.L2
	.long	.L2
	.long	.L2
	.long	.L2
	.long	.L2
	.long	.L2
	.long	.L2
	.long	.L2
	.long	.L2
	.long	.L2
	.long	.L2
	.long	.L2
	.long	.L2
	.long	.L2
	.long	.L2
	.long	.L2
	.long	.L2
	.long	.L2
	.long	.L2
	.long	.L2
	.long	.L22
	.long	.L2
	.long	.L2
	.long	.L2
	.long	.L2
	.long	.L2
	.long	.L2
	.long	.L2
	.long	.L2
	.long	.L2
	.long	.L2
	.long	.L2
	.long	.L2
	.long	.L2
	.long	.L2
	.long	.L2
	.long	.L2
	.long	.L2
	.long	.L2
	.long	.L2
	.long	.L23
	.long	.L2
	.long	.L2
	.long	.L2
	.long	.L2
	.long	.L2
	.long	.L2
	.long	.L2
	.long	.L2
	.long	.L2
	.long	.L24
	.long	.L2
	.long	.L2
	.long	.L2
	.long	.L2
	.long	.L2
	.long	.L2
	.long	.L2
	.long	.L2
	.long	.L2
	.long	.L25
	.text
.L19:
	movl	$.LC22, (%esp)
	call	puts
	.p2align 4,,15
.L2:
	popl	%edx
	xorl	%eax, %eax
	popl	%ecx
	popl	%ebp
	leal	-4(%ecx), %esp
	ret
.L3:
	movl	$.LC12, (%esp)
	call	puts
	jmp	.L2
.L4:
	movl	$.LC1, (%esp)
	call	puts
	.p2align 4,,3
	jmp	.L2
.L5:
	movl	$.LC6, (%esp)
	call	puts
	.p2align 4,,3
	jmp	.L2
.L6:
	movl	$.LC10, (%esp)
	call	puts
	.p2align 4,,3
	jmp	.L2
.L7:
	movl	$.LC14, (%esp)
	call	puts
	.p2align 4,,3
	jmp	.L2
.L8:
	movl	$.LC16, (%esp)
	call	puts
	.p2align 4,,3
	jmp	.L2
.L9:
	movl	$.LC18, (%esp)
	call	puts
	.p2align 4,,3
	jmp	.L2
.L10:
	movl	$.LC20, (%esp)
	call	puts
	.p2align 4,,3
	jmp	.L2
.L11:
	movl	$.LC11, (%esp)
	call	puts
	.p2align 4,,3
	jmp	.L2
.L12:
	movl	$.LC9, (%esp)
	call	puts
	.p2align 4,,3
	jmp	.L2
.L13:
	movl	$.LC8, (%esp)
	call	puts
	.p2align 4,,3
	jmp	.L2
.L14:
	movl	$.LC4, (%esp)
	call	puts
	.p2align 4,,3
	jmp	.L2
.L15:
	movl	$.LC2, (%esp)
	call	puts
	.p2align 4,,3
	jmp	.L2
.L16:
	movl	$.LC0, (%esp)
	call	puts
	.p2align 4,,3
	jmp	.L2
.L17:
	movl	$.LC17, (%esp)
	call	puts
	.p2align 4,,3
	jmp	.L2
.L18:
	movl	$.LC7, (%esp)
	call	puts
	.p2align 4,,3
	jmp	.L2
.L20:
	movl	$.LC15, (%esp)
	call	puts
	.p2align 4,,3
	jmp	.L2
.L21:
	movl	$.LC13, (%esp)
	call	puts
	.p2align 4,,3
	jmp	.L2
.L22:
	movl	$.LC5, (%esp)
	call	puts
	.p2align 4,,3
	jmp	.L2
.L23:
	movl	$.LC3, (%esp)
	call	puts
	.p2align 4,,3
	jmp	.L2
.L24:
	movl	$.LC19, (%esp)
	call	puts
	.p2align 4,,3
	jmp	.L2
.L25:
	movl	$.LC21, (%esp)
	call	puts
	.p2align 4,,3
	jmp	.L2
	.size	main, .-main
	.ident	"GCC: (GNU) 4.1.2 20061115 (prerelease) (Debian 4.1.1-21)"
	.section	.note.GNU-stack,"",@progbits
