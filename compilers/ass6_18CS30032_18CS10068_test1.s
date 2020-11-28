	.file	"output.s"

.STR0:	.string "_____________ Product of 3 integers _____________\n"
.STR1:	.string "Enter the 1st integer: "
.STR2:	.string "Enter the 2nd integer: "
.STR3:	.string "Enter the 3rd integer: "
.STR4:	.string "Product is "
.STR5:	.string "\n"
.STR6:	.string "\n__________________________\n"
	.text
	.globl	main
	.type	main, @function
main:
.LFB0:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$120, %rsp
# 0:
	movq	$.STR0,	%rdi
# 1:res = t000 
	pushq %rbp
	call	printStr
	movl	%eax, -20(%rbp)
	addq $8 , %rsp
# 2:res = t001 
	movl	$1, -28(%rbp)
# 3:res = err arg1 = t001 
	movl	-28(%rbp), %eax
	movl	%eax, -24(%rbp)
# 4:
	movq	$.STR1,	%rdi
# 5:res = t002 
	pushq %rbp
	call	printStr
	movl	%eax, -32(%rbp)
	addq $8 , %rsp
# 6:res = t003 arg1 = err 
	leaq	-24(%rbp), %rax
	movq	%rax, -40(%rbp)
# 7:res = t003 
# 8:res = t004 
	pushq %rbp
	movq	-40(%rbp), %rdi
	call	readInt
	movl	%eax, -44(%rbp)
	addq $0 , %rsp
# 9:res = a arg1 = t004 
	movl	-44(%rbp), %eax
	movl	%eax, -4(%rbp)
# 10:res = t005 arg1 = t004 
	movl	-44(%rbp), %eax
	movl	%eax, -48(%rbp)
# 11:
	movq	$.STR2,	%rdi
# 12:res = t006 
	pushq %rbp
	call	printStr
	movl	%eax, -52(%rbp)
	addq $8 , %rsp
# 13:res = t007 arg1 = err 
	leaq	-24(%rbp), %rax
	movq	%rax, -60(%rbp)
# 14:res = t007 
# 15:res = t008 
	pushq %rbp
	movq	-60(%rbp), %rdi
	call	readInt
	movl	%eax, -64(%rbp)
	addq $0 , %rsp
# 16:res = b arg1 = t008 
	movl	-64(%rbp), %eax
	movl	%eax, -8(%rbp)
# 17:res = t009 arg1 = t008 
	movl	-64(%rbp), %eax
	movl	%eax, -68(%rbp)
# 18:
	movq	$.STR3,	%rdi
# 19:res = t010 
	pushq %rbp
	call	printStr
	movl	%eax, -72(%rbp)
	addq $8 , %rsp
# 20:res = t011 arg1 = err 
	leaq	-24(%rbp), %rax
	movq	%rax, -80(%rbp)
# 21:res = t011 
# 22:res = t012 
	pushq %rbp
	movq	-80(%rbp), %rdi
	call	readInt
	movl	%eax, -84(%rbp)
	addq $0 , %rsp
# 23:res = c arg1 = t012 
	movl	-84(%rbp), %eax
	movl	%eax, -12(%rbp)
# 24:res = t013 arg1 = t012 
	movl	-84(%rbp), %eax
	movl	%eax, -88(%rbp)
# 25:res = t014 arg1 = a arg2 = b 
	movl	-4(%rbp), %eax
	imull	-8(%rbp), %eax
	movl	%eax, -92(%rbp)
# 26:res = t015 arg1 = t014 arg2 = c 
	movl	-92(%rbp), %eax
	imull	-12(%rbp), %eax
	movl	%eax, -96(%rbp)
# 27:res = prod arg1 = t015 
	movl	-96(%rbp), %eax
	movl	%eax, -16(%rbp)
# 28:res = t016 arg1 = t015 
	movl	-96(%rbp), %eax
	movl	%eax, -100(%rbp)
# 29:
	movq	$.STR4,	%rdi
# 30:res = t017 
	pushq %rbp
	call	printStr
	movl	%eax, -104(%rbp)
	addq $8 , %rsp
# 31:res = prod 
# 32:res = t018 
	pushq %rbp
	movl	-16(%rbp) , %edi
	call	printInt
	movl	%eax, -108(%rbp)
	addq $0 , %rsp
# 33:
	movq	$.STR5,	%rdi
# 34:res = t019 
	pushq %rbp
	call	printStr
	movl	%eax, -112(%rbp)
	addq $8 , %rsp
# 35:
	movq	$.STR6,	%rdi
# 36:res = t020 
	pushq %rbp
	call	printStr
	movl	%eax, -116(%rbp)
	addq $8 , %rsp
# 37:res = t021 
	movl	$0, -120(%rbp)
# 38:res = t021 
	movl	-120(%rbp), %eax
	jmp	.LRT0
.LRT0:
	addq	$-120, %rsp
	movq	%rbp, %rsp
	popq	%rbp
	ret
.LFE0:
	.size	main, .-main
