	.file	"output.s"

.STR0:	.string "_____________  Factorial Calculation _____________\n"
.STR1:	.string "Enter the value of n: "
.STR2:	.string "Factorial of n is: "
.STR3:	.string "\n_________________________\n"
	.text
	.globl	fact
	.type	fact, @function
fact:
.LFB0:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$428, %rsp
	movl	%edi, -4(%rbp)
# 0:res = t000 
	movl	$80, -332(%rbp)
# 1:res = t001 
	movl	$0, -336(%rbp)
# 2:res = t002 
	movl	$0, -340(%rbp)
# 3:res = t004 arg1 = t002 
	movl	-340(%rbp), %eax
	movl	$4, %ecx
	imull	%ecx, %eax
	movl	%eax, -348(%rbp)
# 4:res = t003 arg1 = t001 arg2 = t004 
	movl	-336(%rbp), %eax
	movl	-348(%rbp), %edx
	addl	%edx, %eax
	movl	%eax, -344(%rbp)
# 5:res = t005 
	movl	$1, -352(%rbp)
# 6:res = dp arg1 = t003 arg2 = t005 
	leaq	-328(%rbp), %rdx
	movslq	-344(%rbp), %rax
	addq	%rax, %rdx
	movl	-352(%rbp), %eax
	movl	%eax, (%rdx)
# 7:res = t006 arg1 = t005 
	movl	-352(%rbp), %eax
	movl	%eax, -356(%rbp)
# 8:res = t007 
	movl	$1, -360(%rbp)
# 9:res = i arg1 = t007 
	movl	-360(%rbp), %eax
	movl	%eax, -8(%rbp)
# 10:res = t008 arg1 = t007 
	movl	-360(%rbp), %eax
	movl	%eax, -364(%rbp)
# 11:arg1 = i arg2 = n 
.L3:
	movl	-8(%rbp), %eax
	movl	-4(%rbp), %edx
	cmpl	%edx, %eax
	jle .L1
# 12:
	jmp .L2
# 13:
	jmp .L2
# 14:res = t009 arg1 = i 
.L4:
	movl	-8(%rbp), %eax
	movl	%eax, -368(%rbp)
# 15:res = i arg1 = i 
	movl	-8(%rbp), %eax
	movl	$1, %edx
	addl	%edx, %eax
	movl	%eax, -8(%rbp)
# 16:
	jmp .L3
# 17:res = t010 
.L1:
	movl	$0, -372(%rbp)
# 18:res = t012 arg1 = i 
	movl	-8(%rbp), %eax
	movl	$4, %ecx
	imull	%ecx, %eax
	movl	%eax, -380(%rbp)
# 19:res = t011 arg1 = t010 arg2 = t012 
	movl	-372(%rbp), %eax
	movl	-380(%rbp), %edx
	addl	%edx, %eax
	movl	%eax, -376(%rbp)
# 20:res = t013 
	movl	$0, -384(%rbp)
# 21:res = t014 
	movl	$1, -388(%rbp)
# 22:res = t015 arg1 = i arg2 = t014 
	movl	-8(%rbp), %eax
	movl	-388(%rbp), %edx
	subl	%edx, %eax
	movl	%eax, -392(%rbp)
# 23:res = t017 arg1 = t015 
	movl	-392(%rbp), %eax
	movl	$4, %ecx
	imull	%ecx, %eax
	movl	%eax, -400(%rbp)
# 24:res = t016 arg1 = t013 arg2 = t017 
	movl	-384(%rbp), %eax
	movl	-400(%rbp), %edx
	addl	%edx, %eax
	movl	%eax, -396(%rbp)
# 25:res = t018 arg1 = dp arg2 = t016 
	leaq	-328(%rbp), %rdx
	movslq	-396(%rbp), %rax
	addq	%rax, %rdx
	movl	(%rdx), %eax
	movl	%eax, -404(%rbp)
# 26:res = t019 arg1 = t018 arg2 = i 
	movl	-404(%rbp), %eax
	imull	-8(%rbp), %eax
	movl	%eax, -408(%rbp)
# 27:res = dp arg1 = t011 arg2 = t019 
	leaq	-328(%rbp), %rdx
	movslq	-376(%rbp), %rax
	addq	%rax, %rdx
	movl	-408(%rbp), %eax
	movl	%eax, (%rdx)
# 28:res = t020 arg1 = t019 
	movl	-408(%rbp), %eax
	movl	%eax, -412(%rbp)
# 29:
	jmp .L4
# 30:res = t021 
.L2:
	movl	$0, -416(%rbp)
# 31:res = t023 arg1 = n 
	movl	-4(%rbp), %eax
	movl	$4, %ecx
	imull	%ecx, %eax
	movl	%eax, -424(%rbp)
# 32:res = t022 arg1 = t021 arg2 = t023 
	movl	-416(%rbp), %eax
	movl	-424(%rbp), %edx
	addl	%edx, %eax
	movl	%eax, -420(%rbp)
# 33:res = t024 arg1 = dp arg2 = t022 
	leaq	-328(%rbp), %rdx
	movslq	-420(%rbp), %rax
	addq	%rax, %rdx
	movl	(%rdx), %eax
	movl	%eax, -428(%rbp)
# 34:res = t024 
	movl	-428(%rbp), %eax
	jmp	.LRT0
.LRT0:
	addq	$-428, %rsp
	movq	%rbp, %rsp
	popq	%rbp
	ret
.LFE0:
	.size	fact, .-fact
	.globl	main
	.type	main, @function
main:
.LFB1:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$64, %rsp
# 35:
	movq	$.STR0,	%rdi
# 36:res = t025 
	pushq %rbp
	call	printStr
	movl	%eax, -12(%rbp)
	addq $8 , %rsp
# 37:res = t026 
	movl	$1, -20(%rbp)
# 38:res = err arg1 = t026 
	movl	-20(%rbp), %eax
	movl	%eax, -16(%rbp)
# 39:
	movq	$.STR1,	%rdi
# 40:res = t027 
	pushq %rbp
	call	printStr
	movl	%eax, -24(%rbp)
	addq $8 , %rsp
# 41:res = t028 arg1 = err 
	leaq	-16(%rbp), %rax
	movq	%rax, -32(%rbp)
# 42:res = t028 
# 43:res = t029 
	pushq %rbp
	movq	-32(%rbp), %rdi
	call	readInt
	movl	%eax, -36(%rbp)
	addq $0 , %rsp
# 44:res = n arg1 = t029 
	movl	-36(%rbp), %eax
	movl	%eax, -4(%rbp)
# 45:res = t030 arg1 = t029 
	movl	-36(%rbp), %eax
	movl	%eax, -40(%rbp)
# 46:res = n 
# 47:res = t031 
	pushq %rbp
	movl	-4(%rbp) , %edi
	call	fact
	movl	%eax, -44(%rbp)
	addq $0 , %rsp
# 48:res = ans arg1 = t031 
	movl	-44(%rbp), %eax
	movl	%eax, -8(%rbp)
# 49:res = t032 arg1 = t031 
	movl	-44(%rbp), %eax
	movl	%eax, -48(%rbp)
# 50:
	movq	$.STR2,	%rdi
# 51:res = t033 
	pushq %rbp
	call	printStr
	movl	%eax, -52(%rbp)
	addq $8 , %rsp
# 52:res = ans 
# 53:res = t034 
	pushq %rbp
	movl	-8(%rbp) , %edi
	call	printInt
	movl	%eax, -56(%rbp)
	addq $0 , %rsp
# 54:
	movq	$.STR3,	%rdi
# 55:res = t035 
	pushq %rbp
	call	printStr
	movl	%eax, -60(%rbp)
	addq $8 , %rsp
# 56:res = t036 
	movl	$0, -64(%rbp)
# 57:res = t036 
	movl	-64(%rbp), %eax
	jmp	.LRT1
.LRT1:
	addq	$-64, %rsp
	movq	%rbp, %rsp
	popq	%rbp
	ret
.LFE1:
	.size	main, .-main
