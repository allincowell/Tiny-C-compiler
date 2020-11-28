	.file	"output.s"

.STR0:	.string "_____________ Reversing digits of a non -ve integer ______________\n"
.STR1:	.string "Enter a non -ve integer: "
.STR2:	.string "Reversed integer is: "
.STR3:	.string "\n"
.STR4:	.string "\n_______________________________________________\n"
	.text
	.globl	main
	.type	main, @function
main:
.LFB0:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$104, %rsp
# 0:
	movq	$.STR0,	%rdi
# 1:res = t000 
	pushq %rbp
	call	printStr
	movl	%eax, -8(%rbp)
	addq $8 , %rsp
# 2:
	movq	$.STR1,	%rdi
# 3:res = t001 
	pushq %rbp
	call	printStr
	movl	%eax, -12(%rbp)
	addq $8 , %rsp
# 4:res = t002 
	movl	$1, -20(%rbp)
# 5:res = err arg1 = t002 
	movl	-20(%rbp), %eax
	movl	%eax, -16(%rbp)
# 6:res = t003 arg1 = err 
	leaq	-16(%rbp), %rax
	movq	%rax, -28(%rbp)
# 7:res = t003 
# 8:res = t004 
	pushq %rbp
	movq	-28(%rbp), %rdi
	call	readInt
	movl	%eax, -32(%rbp)
	addq $0 , %rsp
# 9:res = n arg1 = t004 
	movl	-32(%rbp), %eax
	movl	%eax, -4(%rbp)
# 10:res = t005 arg1 = t004 
	movl	-32(%rbp), %eax
	movl	%eax, -36(%rbp)
# 11:res = t006 
	movl	$0, -44(%rbp)
# 12:res = ans arg1 = t006 
	movl	-44(%rbp), %eax
	movl	%eax, -40(%rbp)
# 13:res = t007 
.L3:
	movl	$0, -48(%rbp)
# 14:arg1 = n arg2 = t007 
	movl	-4(%rbp), %eax
	movl	-48(%rbp), %edx
	cmpl	%edx, %eax
	jg .L1
# 15:
	jmp .L2
# 16:
	jmp .L2
# 17:res = t008 
.L1:
	movl	$10, -52(%rbp)
# 18:res = t009 arg1 = ans arg2 = t008 
	movl	-40(%rbp), %eax
	imull	-52(%rbp), %eax
	movl	%eax, -56(%rbp)
# 19:res = t010 
	movl	$10, -60(%rbp)
# 20:res = t011 arg1 = n arg2 = t010 
	movl	-4(%rbp), %eax
	cltd
	idivl	-60(%rbp), %eax
	movl	%edx, -64(%rbp)
# 21:res = t012 arg1 = t009 arg2 = t011 
	movl	-56(%rbp), %eax
	movl	-64(%rbp), %edx
	addl	%edx, %eax
	movl	%eax, -68(%rbp)
# 22:res = ans arg1 = t012 
	movl	-68(%rbp), %eax
	movl	%eax, -40(%rbp)
# 23:res = t013 arg1 = t012 
	movl	-68(%rbp), %eax
	movl	%eax, -72(%rbp)
# 24:res = t014 
	movl	$10, -76(%rbp)
# 25:res = t015 arg1 = n arg2 = t014 
	movl	-4(%rbp), %eax
	cltd
	idivl	-76(%rbp), %eax
	movl	%eax, -80(%rbp)
# 26:res = n arg1 = t015 
	movl	-80(%rbp), %eax
	movl	%eax, -4(%rbp)
# 27:res = t016 arg1 = t015 
	movl	-80(%rbp), %eax
	movl	%eax, -84(%rbp)
# 28:
	jmp .L3
# 29:
.L2:
	movq	$.STR2,	%rdi
# 30:res = t017 
	pushq %rbp
	call	printStr
	movl	%eax, -88(%rbp)
	addq $8 , %rsp
# 31:res = ans 
# 32:res = t018 
	pushq %rbp
	movl	-40(%rbp) , %edi
	call	printInt
	movl	%eax, -92(%rbp)
	addq $0 , %rsp
# 33:
	movq	$.STR3,	%rdi
# 34:res = t019 
	pushq %rbp
	call	printStr
	movl	%eax, -96(%rbp)
	addq $8 , %rsp
# 35:
	movq	$.STR4,	%rdi
# 36:res = t020 
	pushq %rbp
	call	printStr
	movl	%eax, -100(%rbp)
	addq $8 , %rsp
# 37:res = t021 
	movl	$0, -104(%rbp)
# 38:res = t021 
	movl	-104(%rbp), %eax
	jmp	.LRT0
.LRT0:
	addq	$-104, %rsp
	movq	%rbp, %rsp
	popq	%rbp
	ret
.LFE0:
	.size	main, .-main
