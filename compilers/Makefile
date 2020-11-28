tinyC_compiler: y.tab.o lex.yy.o ass6_18CS30032_18CS10068_translator.o ass6_18CS30032_18CS10068_target_translator.o 
	@g++ -g ass6_18CS30032_18CS10068_translator.o ass6_18CS30032_18CS10068_target_translator.o lex.yy.o y.tab.o -lfl -o tinyC_compiler
	@./tinyC_compiler < ass6_18CS30032_18CS10068_test1.c
	@./tinyC_compiler < ass6_18CS30032_18CS10068_test2.c 
	@./tinyC_compiler < ass6_18CS30032_18CS10068_test3.c
	@./tinyC_compiler < ass6_18CS30032_18CS10068_test4.c
	@./tinyC_compiler < ass6_18CS30032_18CS10068_test5.c
	@echo " WRITE \"make run\" ON THE TERMINAL TO RUN THE TEST FILES"
lex.yy.c: ass6_18CS30032_18CS10068.l
	@flex ass6_18CS30032_18CS10068.l
y.tab.c: ass6_18CS30032_18CS10068.y
	@yacc -dtv ass6_18CS30032_18CS10068.y
ass6_18CS30032_18CS10068_target_translator.o: ass6_18CS30032_18CS10068_target_translator.cxx
	@g++ -g -c ass6_18CS30032_18CS10068_target_translator.cxx
ass6_18CS30032_18CS10068_translator.o: ass6_18CS30032_18CS10068_translator.cxx
	@g++ -g -c ass6_18CS30032_18CS10068_translator.cxx
lex.yy.o: lex.yy.c
	@g++ -g -c lex.yy.c
y.tab.o:    y.tab.c
	@g++ -g -DYYDEBUG -c y.tab.c
libass2_18CS30032_18CS10068.a: ass2_18CS30032_18CS10068.o
	@ar -rcs libass2_18CS30032_18CS10068.a ass2_18CS30032_18CS10068.o

ass2_18CS30032_18CS10068.o: ass2_18CS30032_18CS10068.c myl.h
	@gcc -Wall  -c ass2_18CS30032_18CS10068.c
clean:
	@rm ass6_18CS30032_18CS10068_test1.s ass6_18CS30032_18CS10068_test2.s ass6_18CS30032_18CS10068_test3.s ass6_18CS30032_18CS10068_test4.s ass6_18CS30032_18CS10068_test5.s runtest1 runtest2 runtest3 runtest4 runtest5 lex.yy.c y.tab.h y.output y.tab.c lex.yy.o y.tab.o ass6_18CS30032_18CS10068_translator.o ass6_18CS30032_18CS10068_target_translator.o ass6_18CS30032_18CS10068_test1.o ass6_18CS30032_18CS10068_test2.o ass6_18CS30032_18CS10068_test3.o ass6_18CS30032_18CS10068_test4.o ass6_18CS30032_18CS10068_test5.o libass2_18CS30032_18CS10068.a ass2_18CS30032_18CS10068.o ass6_18CS30032_18CS10068_quad1.out ass6_18CS30032_18CS10068_quad2.out ass6_18CS30032_18CS10068_quad3.out ass6_18CS30032_18CS10068_quad4.out ass6_18CS30032_18CS10068_quad5.out tinyC_compiler


runtest1: ass6_18CS30032_18CS10068_test1.o libass2_18CS30032_18CS10068.a
	@gcc -no-pie -g ass6_18CS30032_18CS10068_test1.o -o runtest1 -L. -lass2_18CS30032_18CS10068
ass6_18CS30032_18CS10068_test1.o: ass6_18CS30032_18CS10068_test1.s myl.h
	@gcc -no-pie -g -Wall  -c ass6_18CS30032_18CS10068_test1.s -o ass6_18CS30032_18CS10068_test1.o

runtest2: ass6_18CS30032_18CS10068_test2.o libass2_18CS30032_18CS10068.a
	@gcc -no-pie -g  ass6_18CS30032_18CS10068_test2.o -o runtest2 -L. -lass2_18CS30032_18CS10068
ass6_18CS30032_18CS10068_test2.o: ass6_18CS30032_18CS10068_test2.s myl.h
	@gcc -no-pie -g -Wall -c ass6_18CS30032_18CS10068_test2.s

runtest3: ass6_18CS30032_18CS10068_test3.o libass2_18CS30032_18CS10068.a
	@gcc -no-pie -g  ass6_18CS30032_18CS10068_test3.o -o runtest3 -L. -lass2_18CS30032_18CS10068
ass6_18CS30032_18CS10068_test3.o: ass6_18CS30032_18CS10068_test3.s myl.h
	@gcc -no-pie -g -Wall  -c ass6_18CS30032_18CS10068_test3.s

runtest4: ass6_18CS30032_18CS10068_test4.o libass2_18CS30032_18CS10068.a
	@gcc -no-pie -g  ass6_18CS30032_18CS10068_test4.o -o runtest4 -L. -lass2_18CS30032_18CS10068
ass6_18CS30032_18CS10068_test4.o: ass6_18CS30032_18CS10068_test4.s myl.h
	@gcc -no-pie -g -Wall  -c ass6_18CS30032_18CS10068_test4.s

runtest5: ass6_18CS30032_18CS10068_test5.o libass2_18CS30032_18CS10068.a
	@gcc -no-pie -g  ass6_18CS30032_18CS10068_test5.o -o runtest5 -L. -lass2_18CS30032_18CS10068
ass6_18CS30032_18CS10068_test5.o: ass6_18CS30032_18CS10068_test5.s myl.h
	@gcc -no-pie -g -Wall -c ass6_18CS30032_18CS10068_test5.s

output: output.o libass2_18CS30032_18CS10068.a
	@gcc -no-pie -g  output.o -o output -L. -lass2_18CS30032_18CS10068
output.o: output.s myl.h
	@gcc -no-pie -g -Wall -c output.s

run: 
		
	@./tinyC_compiler < ass6_18CS30032_18CS10068_test1.c > ass6_18CS30032_18CS10068_quad1.out
	
	@mv output.s ass6_18CS30032_18CS10068_test1.s
	
	@make runtest1
	
	@./tinyC_compiler < ass6_18CS30032_18CS10068_test2.c > ass6_18CS30032_18CS10068_quad2.out

	@mv output.s ass6_18CS30032_18CS10068_test2.s
	
	@make runtest2

	@./tinyC_compiler < ass6_18CS30032_18CS10068_test3.c > ass6_18CS30032_18CS10068_quad3.out

	@mv output.s ass6_18CS30032_18CS10068_test3.s

	@make runtest3

	@./tinyC_compiler < ass6_18CS30032_18CS10068_test4.c > ass6_18CS30032_18CS10068_quad4.out
	
	@mv output.s ass6_18CS30032_18CS10068_test4.s

	@make runtest4

	@./tinyC_compiler < ass6_18CS30032_18CS10068_test5.c > ass6_18CS30032_18CS10068_quad5.out
	
	@mv output.s ass6_18CS30032_18CS10068_test5.s

	@make runtest5

	@echo ""
	@echo "USE THE COMMAND MENTIONED AGAINST THE CORRESPONDING TEST FILE TO RUN IT"
	@echo "1 : Product of 3 integers                : ./runtest1"
	@echo "2 : Reversing digits of an integer       : ./runtest2"
	@echo "3 : HCF Calculation                      : ./runtest3"
	@echo "4 : Factorial Calculation                : ./runtest4"
	@echo "5 : Optimisation Problem                 : ./runtest5"
