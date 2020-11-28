	.file	"output.s"

.STR0:	.string "_________ Optimisation Problem _________\n"
.STR1:	.string "Enter the value of n: "
.STR2:	.string "Enter the elements\n"
.STR3:	.string "Max profit is "
.STR4:	.string "\n_______________________________________________\n"
	.text
	.globl	max
	.type	max, @function
max:
.LFB0:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$8, %rsp
	movl	%edi, -4(%rbp)
	movl	%esi, -8(%rbp)
# 0:arg1 = a arg2 = b 
	movl	-8(%rbp), %eax
	movl	-4(%rbp), %edx
	cmpl	%edx, %eax
	jg .L1
# 1:
	jmp .L2
# 2:
	jmp	.LRT0
# 3:res = a 
.L1:
	movl	-8(%rbp), %eax
	jmp	.LRT0
# 4:
	jmp	.LRT0
# 5:res = b 
.L2:
	movl	-4(%rbp), %eax
	jmp	.LRT0
# 6:
	jmp	.LRT0
.LRT0:
	addq	$-8, %rsp
	movq	%rbp, %rsp
	popq	%rbp
	ret
.LFE0:
	.size	max, .-max
	.globl	func
	.type	func, @function
func:
.LFB1:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$568, %rsp
	movl	%edi, -4(%rbp)
	movq	%rsi, -12(%rbp)
# 7:res = t000 
.L3:
	movl	$100, -416(%rbp)
# 8:res = t001 
	movl	$0, -420(%rbp)
# 9:res = t002 
	movl	$0, -424(%rbp)
# 10:res = t004 arg1 = t002 
	movl	-424(%rbp), %eax
	movl	$4, %ecx
	imull	%ecx, %eax
	movl	%eax, -432(%rbp)
# 11:res = t003 arg1 = t001 arg2 = t004 
	movl	-420(%rbp), %eax
	movl	-432(%rbp), %edx
	addl	%edx, %eax
	movl	%eax, -428(%rbp)
# 12:res = t005 
	movl	$0, -436(%rbp)
# 13:res = dp arg1 = t003 arg2 = t005 
	leaq	-412(%rbp), %rdx
	movslq	-428(%rbp), %rax
	addq	%rax, %rdx
	movl	-436(%rbp), %eax
	movl	%eax, (%rdx)
# 14:res = t006 arg1 = t005 
	movl	-436(%rbp), %eax
	movl	%eax, -440(%rbp)
# 15:res = t007 
	movl	$1, -452(%rbp)
# 16:res = i arg1 = t007 
	movl	-452(%rbp), %eax
	movl	%eax, -444(%rbp)
# 17:res = t008 arg1 = t007 
	movl	-452(%rbp), %eax
	movl	%eax, -456(%rbp)
# 18:arg1 = i arg2 = n 
.L6:
	movl	-444(%rbp), %eax
	movl	-4(%rbp), %edx
	cmpl	%edx, %eax
	jle .L4
# 19:
	jmp .L5
# 20:
	jmp .L5
# 21:res = t009 arg1 = i 
.L11:
	movl	-444(%rbp), %eax
	movl	%eax, -460(%rbp)
# 22:res = i arg1 = i 
	movl	-444(%rbp), %eax
	movl	$1, %edx
	addl	%edx, %eax
	movl	%eax, -444(%rbp)
# 23:
	jmp .L6
# 24:res = t010 
.L4:
	movl	$0, -468(%rbp)
# 25:res = cur arg1 = t010 
	movl	-468(%rbp), %eax
	movl	%eax, -464(%rbp)
# 26:res = t011 
	movl	$0, -472(%rbp)
# 27:res = j arg1 = t011 
	movl	-472(%rbp), %eax
	movl	%eax, -448(%rbp)
# 28:res = t012 arg1 = t011 
	movl	-472(%rbp), %eax
	movl	%eax, -476(%rbp)
# 29:arg1 = j arg2 = i 
.L9:
	movl	-448(%rbp), %eax
	movl	-444(%rbp), %edx
	cmpl	%edx, %eax
	jl .L7
# 30:
	jmp .L8
# 31:
	jmp .L8
# 32:res = t013 arg1 = j 
.L10:
	movl	-448(%rbp), %eax
	movl	%eax, -480(%rbp)
# 33:res = j arg1 = j 
	movl	-448(%rbp), %eax
	movl	$1, %edx
	addl	%edx, %eax
	movl	%eax, -448(%rbp)
# 34:
	jmp .L9
# 35:res = t014 
.L7:
	movl	$0, -484(%rbp)
# 36:res = t016 arg1 = j 
	movl	-448(%rbp), %eax
	movl	$4, %ecx
	imull	%ecx, %eax
	movl	%eax, -492(%rbp)
# 37:res = t015 arg1 = t014 arg2 = t016 
	movl	-484(%rbp), %eax
	movl	-492(%rbp), %edx
	addl	%edx, %eax
	movl	%eax, -488(%rbp)
# 38:res = t017 arg1 = p arg2 = t015 
	movq	-12(%rbp), %rdx
	movslq	-488(%rbp), %rax
	addq	%rax, %rdx
	movl	(%rdx), %eax
	movl	%eax, -496(%rbp)
# 39:res = t018 
	movl	$0, -500(%rbp)
# 40:res = t019 arg1 = i arg2 = j 
	movl	-444(%rbp), %eax
	movl	-448(%rbp), %edx
	subl	%edx, %eax
	movl	%eax, -504(%rbp)
# 41:res = t020 
	movl	$1, -508(%rbp)
# 42:res = t021 arg1 = t019 arg2 = t020 
	movl	-504(%rbp), %eax
	movl	-508(%rbp), %edx
	subl	%edx, %eax
	movl	%eax, -512(%rbp)
# 43:res = t023 arg1 = t021 
	movl	-512(%rbp), %eax
	movl	$4, %ecx
	imull	%ecx, %eax
	movl	%eax, -520(%rbp)
# 44:res = t022 arg1 = t018 arg2 = t023 
	movl	-500(%rbp), %eax
	movl	-520(%rbp), %edx
	addl	%edx, %eax
	movl	%eax, -516(%rbp)
# 45:res = t024 arg1 = dp arg2 = t022 
	leaq	-412(%rbp), %rdx
	movslq	-516(%rbp), %rax
	addq	%rax, %rdx
	movl	(%rdx), %eax
	movl	%eax, -524(%rbp)
# 46:res = t025 arg1 = t017 arg2 = t024 
	movl	-496(%rbp), %eax
	movl	-524(%rbp), %edx
	addl	%edx, %eax
	movl	%eax, -528(%rbp)
# 47:res = cur 
# 48:res = t025 
# 49:res = t026 
	pushq %rbp
	movl	-528(%rbp) , %edi
	movl	-464(%rbp) , %esi
	call	max
	movl	%eax, -532(%rbp)
	addq $0 , %rsp
# 50:res = cur arg1 = t026 
	movl	-532(%rbp), %eax
	movl	%eax, -464(%rbp)
# 51:res = t027 arg1 = t026 
	movl	-532(%rbp), %eax
	movl	%eax, -536(%rbp)
# 52:
	jmp .L10
# 53:res = t028 
.L8:
	movl	$0, -540(%rbp)
# 54:res = t030 arg1 = i 
	movl	-444(%rbp), %eax
	movl	$4, %ecx
	imull	%ecx, %eax
	movl	%eax, -548(%rbp)
# 55:res = t029 arg1 = t028 arg2 = t030 
	movl	-540(%rbp), %eax
	movl	-548(%rbp), %edx
	addl	%edx, %eax
	movl	%eax, -544(%rbp)
# 56:res = dp arg1 = t029 arg2 = cur 
	leaq	-412(%rbp), %rdx
	movslq	-544(%rbp), %rax
	addq	%rax, %rdx
	movl	-464(%rbp), %eax
	movl	%eax, (%rdx)
# 57:res = t031 arg1 = cur 
	movl	-464(%rbp), %eax
	movl	%eax, -552(%rbp)
# 58:
	jmp .L11
# 59:res = t032 
.L5:
	movl	$0, -556(%rbp)
# 60:res = t034 arg1 = n 
	movl	-4(%rbp), %eax
	movl	$4, %ecx
	imull	%ecx, %eax
	movl	%eax, -564(%rbp)
# 61:res = t033 arg1 = t032 arg2 = t034 
	movl	-556(%rbp), %eax
	movl	-564(%rbp), %edx
	addl	%edx, %eax
	movl	%eax, -560(%rbp)
# 62:res = t035 arg1 = dp arg2 = t033 
	leaq	-412(%rbp), %rdx
	movslq	-560(%rbp), %rax
	addq	%rax, %rdx
	movl	(%rdx), %eax
	movl	%eax, -568(%rbp)
# 63:res = t035 
	movl	-568(%rbp), %eax
	jmp	.LRT1
.LRT1:
	addq	$-568, %rsp
	movq	%rbp, %rsp
	popq	%rbp
	ret
.LFE1:
	.size	func, .-func
	.globl	main
	.type	main, @function
main:
.LFB2:
	pushq	%rbp
	movq	%rsp, %rbp
	subq	$520, %rsp
# 64:res = t036 
	movl	$1, -8(%rbp)
# 65:res = err arg1 = t036 
	movl	-8(%rbp), %eax
	movl	%eax, -4(%rbp)
# 66:res = t037 
	movl	$100, -412(%rbp)
# 67:
	movq	$.STR0,	%rdi
# 68:res = t038 
	pushq %rbp
	call	printStr
	movl	%eax, -428(%rbp)
	addq $8 , %rsp
# 69:
	movq	$.STR1,	%rdi
# 70:res = t039 
	pushq %rbp
	call	printStr
	movl	%eax, -432(%rbp)
	addq $8 , %rsp
# 71:res = t040 arg1 = err 
	leaq	-4(%rbp), %rax
	movq	%rax, -440(%rbp)
# 72:res = t040 
# 73:res = t041 
	pushq %rbp
	movq	-440(%rbp), %rdi
	call	readInt
	movl	%eax, -444(%rbp)
	addq $0 , %rsp
# 74:res = n arg1 = t041 
	movl	-444(%rbp), %eax
	movl	%eax, -420(%rbp)
# 75:res = t042 arg1 = t041 
	movl	-444(%rbp), %eax
	movl	%eax, -448(%rbp)
# 76:
	movq	$.STR2,	%rdi
# 77:res = t043 
	pushq %rbp
	call	printStr
	movl	%eax, -452(%rbp)
	addq $8 , %rsp
# 78:res = t044 
	movl	$0, -456(%rbp)
# 79:res = i arg1 = t044 
	movl	-456(%rbp), %eax
	movl	%eax, -416(%rbp)
# 80:res = t045 arg1 = t044 
	movl	-456(%rbp), %eax
	movl	%eax, -460(%rbp)
# 81:arg1 = i arg2 = n 
.L14:
	movl	-416(%rbp), %eax
	movl	-420(%rbp), %edx
	cmpl	%edx, %eax
	jl .L12
# 82:
	jmp .L13
# 83:
	jmp .L13
# 84:res = t046 arg1 = i 
.L15:
	movl	-416(%rbp), %eax
	movl	%eax, -464(%rbp)
# 85:res = i arg1 = i 
	movl	-416(%rbp), %eax
	movl	$1, %edx
	addl	%edx, %eax
	movl	%eax, -416(%rbp)
# 86:
	jmp .L14
# 87:res = t047 
.L12:
	movl	$0, -468(%rbp)
# 88:res = t049 arg1 = i 
	movl	-416(%rbp), %eax
	movl	$4, %ecx
	imull	%ecx, %eax
	movl	%eax, -476(%rbp)
# 89:res = t048 arg1 = t047 arg2 = t049 
	movl	-468(%rbp), %eax
	movl	-476(%rbp), %edx
	addl	%edx, %eax
	movl	%eax, -472(%rbp)
# 90:res = t050 arg1 = err 
	leaq	-4(%rbp), %rax
	movq	%rax, -484(%rbp)
# 91:res = t050 
# 92:res = t051 
	pushq %rbp
	movq	-484(%rbp), %rdi
	call	readInt
	movl	%eax, -488(%rbp)
	addq $0 , %rsp
# 93:res = p arg1 = t048 arg2 = t051 
	leaq	-408(%rbp), %rdx
	movslq	-472(%rbp), %rax
	addq	%rax, %rdx
	movl	-488(%rbp), %eax
	movl	%eax, (%rdx)
# 94:res = t052 arg1 = t051 
	movl	-488(%rbp), %eax
	movl	%eax, -492(%rbp)
# 95:
	jmp .L15
# 96:res = t053 
.L13:
	movl	$0, -496(%rbp)
# 97:res = p 
# 98:res = n 
# 99:res = t054 
	pushq %rbp
	movl	-420(%rbp) , %edi
	leaq	-408(%rbp), %rsi
	call	func
	movl	%eax, -500(%rbp)
	addq $0 , %rsp
# 100:res = ans arg1 = t054 
	movl	-500(%rbp), %eax
	movl	%eax, -424(%rbp)
# 101:res = t055 arg1 = t054 
	movl	-500(%rbp), %eax
	movl	%eax, -504(%rbp)
# 102:
	movq	$.STR3,	%rdi
# 103:res = t056 
	pushq %rbp
	call	printStr
	movl	%eax, -508(%rbp)
	addq $8 , %rsp
# 104:res = ans 
# 105:res = t057 
	pushq %rbp
	movl	-424(%rbp) , %edi
	call	printInt
	movl	%eax, -512(%rbp)
	addq $0 , %rsp
# 106:
	movq	$.STR4,	%rdi
# 107:res = t058 
	pushq %rbp
	call	printStr
	movl	%eax, -516(%rbp)
	addq $8 , %rsp
# 108:res = t059 
	movl	$0, -520(%rbp)
# 109:res = t059 
	movl	-520(%rbp), %eax
	jmp	.LRT2
.LRT2:
	addq	$-520, %rsp
	movq	%rbp, %rsp
	popq	%rbp
	ret
.LFE2:
	.size	main, .-main
