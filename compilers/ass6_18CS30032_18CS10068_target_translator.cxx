#include "ass6_18CS30032_18CS10068_translator.h"
#include "y.tab.h"

extern vector<string> vs;
extern vector<string> cs;
extern quadArray glob_quad;
extern int next_instr;

stack<string> PARAMETER;
stack<int> TYPES;
stack<int> OFFSET;
stack<int> POINTER_ARRAY;

map<int, int> S;
int adding_offset;

void DEBUG() {
	return;
}

void symtab::global_variables(FILE *fp)
{
	DEBUG();
	for(int i = 0; i < symbol_table.size(); i++)
	{
		DEBUG();
		if(symbol_table[i]->name[0] != 't' && symbol_table[i]->tp_n != NULL && symbol_table[i]->var_type != "func")
		{
			DEBUG();
			if(symbol_table[i]->tp_n->basetp == tp_int)
			{
				DEBUG();
				vs.push_back(symbol_table[i]->name);
				DEBUG();
				if(symbol_table[i]->isInitialized == false)
				{
					DEBUG();
					fprintf(fp, "\n\t.comm\t%s, 4, 4", symbol_table[i]->name.c_str());
					DEBUG();
				}
				else
				{
					DEBUG();
					fprintf(fp, "\n\t.globl\t%s", symbol_table[i]->name.c_str());
					DEBUG();
					fprintf(fp, "\n\t.data");
					DEBUG();
					fprintf(fp, "\n\t.align 4");
					DEBUG();
					fprintf(fp, "\n\t.type\t%s, @object", symbol_table[i]->name.c_str());
					DEBUG();
					fprintf(fp, "\n\t.size\t%s, 4", symbol_table[i]->name.c_str());
					DEBUG();
					fprintf(fp, "\n%s:", symbol_table[i]->name.c_str());
					DEBUG();
					fprintf(fp, "\n\t.long %d", symbol_table[i]->i_val.int_val);
					DEBUG();
				}
		    }
		    if(symbol_table[i]->tp_n->basetp == tp_char)
			{
				DEBUG();
				cs.push_back(symbol_table[i]->name);
				DEBUG();
				if(symbol_table[i]->isInitialized == false)
				{
					DEBUG();
					fprintf(fp, "\n\t.comm\t%s, 1, 1", symbol_table[i]->name.c_str());
					DEBUG();
				}
				else
				{
					DEBUG();
					fprintf(fp, "\n\t.globl\t%s", symbol_table[i]->name.c_str());
					DEBUG();
					fprintf(fp, "\n\t.data");
					DEBUG();
					fprintf(fp, "\n\t.type\t%s, @object", symbol_table[i]->name.c_str());
					DEBUG();
					fprintf(fp, "\n\t.size\t%s, 1", symbol_table[i]->name.c_str());
					DEBUG();
					fprintf(fp, "\n%s:", symbol_table[i]->name.c_str());
					DEBUG();
					fprintf(fp, "\n\t.byte %c", symbol_table[i]->i_val.char_val);
					DEBUG();
				}
				DEBUG();
		    }
			DEBUG();
		}
		DEBUG();
	}

	DEBUG();
	fprintf(fp, "\n\t.text");
	DEBUG();
}

string symtab::assign_reg(int type_of,int no)
{
	string s = "NULL";
	DEBUG();
	if(type_of == tp_char){
		DEBUG();
        switch(no){
            case 0: 
					DEBUG();
            		s = "dil";
					DEBUG();
                    break;
            case 1: 
					DEBUG();
            		s = "sil";
					DEBUG();
                    break;
            case 2: 
					DEBUG();
            		s = "dl";
					DEBUG();
                    break;
            case 3: 
					DEBUG();
            		s = "cl";
					DEBUG();
                    break;
            case 4: 
					DEBUG();
            		s = "r8b";
					DEBUG();
                    break;
            case 5: 
					DEBUG();
            		s = "r9b";
					DEBUG();
                    break;
        }
		DEBUG();
    }
    else if(type_of == tp_int){
        switch(no){
            case 0: 
					DEBUG();
            		s = "edi";
					DEBUG();
                    break;
            case 1: 
            		DEBUG();
            		s = "esi";
					DEBUG();
                    break;
            case 2: 
            		DEBUG();
            		s = "edx";
					DEBUG();
                    break;
            case 3: 
            		DEBUG();
            		s = "ecx";
					DEBUG();
                    break;
            case 4: 
            		DEBUG();
            		s = "r8d";
					DEBUG();
                    break;
            case 5: 
            		DEBUG();
            		s = "r9d";
					DEBUG();
                    break;
        }
		DEBUG();
    }
    else
    {
        switch(no){
            case 0: 
            		DEBUG();
            		s = "rdi";
					DEBUG();
                    break;
            case 1: 
            		DEBUG();
            		s = "rsi";
					DEBUG();
                    break;
            case 2: 
            		DEBUG();
            		s = "rdx";
					DEBUG();
                    break;
            case 3: 
            		DEBUG();
            		s = "rcx";
					DEBUG();
                    break;
            case 4: 
            		DEBUG();
            		s = "r8";
					DEBUG();
                    break;
            case 5: 
            		DEBUG();
            		s = "r9";
					DEBUG();
                    break;
        }
		DEBUG();
    }
	DEBUG();
    return s;
}

void symtab::mark_labels()
{
	int C = 1;
	DEBUG();
	for(int i = 0; i < next_instr; i++)
	{
		DEBUG();
		switch(glob_quad.arr[i].op)
		{
			case Q_GOTO: DEBUG();
			case Q_IF_EQUAL: DEBUG();
			case Q_IF_NOT_EQUAL: DEBUG();
			case Q_IF_EXPRESSION: DEBUG();
			case Q_IF_NOT_EXPRESSION: DEBUG();
			case Q_IF_LESS: DEBUG();
			case Q_IF_GREATER: DEBUG();
			case Q_IF_LESS_OR_EQUAL: DEBUG();
			case Q_IF_GREATER_OR_EQUAL: DEBUG();
			if(glob_quad.arr[i].result != "-1")
			{	
				DEBUG();
				if(S.find(atoi(glob_quad.arr[i].result.c_str())) == S.end())
				{
					DEBUG();
					S[atoi(glob_quad.arr[i].result.c_str())] = C;
					DEBUG();
					C++;
					DEBUG();				
				}
			}
		}
	}
}

void symtab::assign_offset()
{
	int curr_offset = 0;
	int param_offset = 16;
	no_params = 0;
	DEBUG();
	for(int i = (symbol_table).size() - 1; i >= 0; i--)
    {
		DEBUG();
        if(symbol_table[i]->ispresent == false)
        	continue;
		DEBUG();
        if(symbol_table[i]->var_type == "param" && symbol_table[i]->isdone == false)
        {
			DEBUG();
        	no_params++;
			DEBUG();
        	if(symbol_table[i]->tp_n && symbol_table[i]->tp_n->basetp == tp_arr)
        	{
				DEBUG();
        		if(symbol_table[i]->tp_n->size == -1)
        		{
					DEBUG();
        			symbol_table[i]->isptrarr = true;
					DEBUG();
        		}
				DEBUG();
        		symbol_table[i]->size = 8;
				DEBUG();
        	}
			DEBUG();
        	symbol_table[i]->offset = curr_offset-symbol_table[i]->size;
			DEBUG();
        	curr_offset = curr_offset-symbol_table[i]->size;
			DEBUG();
        	symbol_table[i]->isdone = true;
			DEBUG();
        }
        if(no_params == 6)
        	break;
		DEBUG();
    }
    for(int i = 0; i < (symbol_table).size(); i++)
    {
        if(symbol_table[i]->ispresent == false)
        	continue;
		DEBUG();
        if(symbol_table[i]->var_type != "return" && symbol_table[i]->var_type != "param" && symbol_table[i]->isdone == false)
        {
			DEBUG();
        	symbol_table[i]->offset = curr_offset-symbol_table[i]->size;
			DEBUG();
        	curr_offset = curr_offset-symbol_table[i]->size;
			DEBUG();
        	symbol_table[i]->isdone = true;
			DEBUG();
        }
        else if(symbol_table[i]->var_type == "param" && symbol_table[i]->isdone == false)
        {
			DEBUG();
        	if(symbol_table[i]->tp_n && symbol_table[i]->tp_n->basetp == tp_arr)
        	{
				DEBUG();
        		if(symbol_table[i]->tp_n->size == -1)
        		{
					DEBUG();
        			symbol_table[i]->isptrarr = true;
					DEBUG();
        		}
				DEBUG();
        		symbol_table[i]->size = 8;
				DEBUG();
        	}
			DEBUG();
        	symbol_table[i]->isdone = true;
			DEBUG();
        	no_params++;
			DEBUG();
        	symbol_table[i]->offset = param_offset;
			DEBUG();
        	param_offset = param_offset+symbol_table[i]->size;
			DEBUG();
        }
		DEBUG();
    }
	DEBUG();
    offset = curr_offset;
	DEBUG();
}

void symtab::function_restore(FILE *fp)
{
	DEBUG();
	int C = 0;
	DEBUG();
	string register_name;
	DEBUG();
	for(int i = symbol_table.size() - 1; i >= 0; i--)
	{
		DEBUG();
	    if(symbol_table[i]->ispresent == false)
	    	continue;
		DEBUG();
	    if(symbol_table[i]->var_type == "param" && symbol_table[i]->offset < 0)
	    {
			DEBUG();
		    if(symbol_table[i]->tp_n->basetp == tp_char){
				DEBUG();
	            register_name = assign_reg(tp_char,C);
				DEBUG();
	            fprintf(fp, "\n\tmovb\t%%%s, %d(%%rbp)", register_name.c_str(), symbol_table[i]->offset);
				DEBUG();
	        }
	        else if(symbol_table[i]->tp_n->basetp == tp_int){
				DEBUG();
	            register_name = assign_reg(tp_int,C);
				DEBUG();
	            fprintf(fp, "\n\tmovl\t%%%s, %d(%%rbp)", register_name.c_str(), symbol_table[i]->offset);
				DEBUG();
	        }
	        else {
				DEBUG();
	            register_name = assign_reg(10,C);
				DEBUG();
	            fprintf(fp, "\n\tmovq\t%%%s, %d(%%rbp)", register_name.c_str(), symbol_table[i]->offset);
				DEBUG();
	        }
			DEBUG();
	    	C++;
			DEBUG();
	    }
		DEBUG();
	    if(C == 6)
	    	break;
		DEBUG();
    }
}

int symtab::function_call(FILE *fp)
{
	
	int c = 0;
	DEBUG();
	fprintf(fp, "\n\tpushq %%rbp");
	DEBUG();
	int C = 0;
	DEBUG();
	while(C < 6 && PARAMETER.size())
	{
		DEBUG();
		string p = PARAMETER.top();
		DEBUG();
		int btp = TYPES.top();
		DEBUG();
		int off = OFFSET.top();
		DEBUG();
		int parr = POINTER_ARRAY.top();
		DEBUG();
		PARAMETER.pop();
		DEBUG();
		TYPES.pop();
		DEBUG();
		OFFSET.pop();
		DEBUG();
		POINTER_ARRAY.pop();
		DEBUG();
		string temp_str = assign_reg(btp,C);
		DEBUG();
		if(temp_str != "NULL")
		{
			DEBUG();
			if(btp == tp_int)
			{
				DEBUG();
				fprintf(fp, "\n\tmovl\t%d(%%rbp) , %%%s", off, temp_str.c_str());
				DEBUG();
			}
			else if(btp == tp_char)
			{
				DEBUG();
				fprintf(fp, "\n\tmovb\t%d(%%rbp), %%%s", off, temp_str.c_str());
				DEBUG();
			}
			else if(btp == tp_arr && parr == 1)
			{
				DEBUG();
				fprintf(fp, "\n\tmovq\t%d(%%rbp), %%%s", off, temp_str.c_str());
				DEBUG();
			}
			else if(btp == tp_arr)
			{
				DEBUG();
				fprintf(fp, "\n\tleaq\t%d(%%rbp), %%%s", off, temp_str.c_str());
				DEBUG();
			}
			else
			{
				DEBUG();
				fprintf(fp, "\n\tmovq\t%d(%%rbp), %%%s", off, temp_str.c_str());
				DEBUG();
			}
			DEBUG();
			C++;
			DEBUG();
		}
		DEBUG();
	}
	while(PARAMETER.size())
	{
		DEBUG();
		string p = PARAMETER.top();
		DEBUG();
		int btp = TYPES.top();
		DEBUG();
		int off = OFFSET.top();
		DEBUG();
		int parr = POINTER_ARRAY.top();
		DEBUG();
		PARAMETER.pop();
		DEBUG();
		TYPES.pop();
		DEBUG();
		OFFSET.pop();
		DEBUG();
		POINTER_ARRAY.pop();
		DEBUG();
		if(btp == tp_int)
		{	
			DEBUG();
			fprintf(fp, "\n\tsubq $4, %%rsp");
			DEBUG();
			fprintf(fp, "\n\tmovl\t%d(%%rbp), %%eax", off);
			DEBUG();
			fprintf(fp, "\n\tmovl\t%%eax, (%%rsp)");
			DEBUG();
			c += 4;
			DEBUG();
		}
		else if(btp == tp_arr && parr == 1)
		{
			DEBUG();
			fprintf(fp, "\n\tsubq $8, %%rsp");
			DEBUG();
			fprintf(fp, "\n\tmovq\t%d(%%rbp), %%rax", off);
			DEBUG();
			fprintf(fp, "\n\tmovq\t%%rax, (%%rsp)");
			DEBUG();
			c += 8;
			DEBUG();
		}
		else if(btp==tp_arr)
		{
			DEBUG();
			fprintf(fp, "\n\tsubq $8, %%rsp");
			DEBUG();
			fprintf(fp, "\n\tleaq\t%d(%%rbp), %%rax", off);
			DEBUG();
			fprintf(fp, "\n\tmovq\t%%rax, (%%rsp)");
			DEBUG();
			c += 8;
			DEBUG();
		}
		else if(btp == tp_char)
		{
			DEBUG();
			fprintf(fp, "\n\tsubq $4, %%rsp");
			DEBUG();
			fprintf(fp, "\n\tmovsbl\t%d(%%rbp), %%eax", off);
			DEBUG();
			fprintf(fp, "\n\tmovl\t%%eax, (%%rsp)");
			DEBUG();
			c += 4;
			DEBUG();
		}
		else
		{
			DEBUG();
			fprintf(fp, "\n\tsubq $8, %%rsp");
			DEBUG();
			fprintf(fp, "\n\tmovq\t%d(%%rbp), %%rax", off);
			DEBUG();
			fprintf(fp, "\n\tmovq\t%%rax, (%%rsp)");
			DEBUG();
			c += 8;
			DEBUG();
		}
		DEBUG();
	}
	DEBUG();
	return c;
	
}

void symtab::gen_internal_code(FILE *fp, int num)
{
	int i;
	DEBUG();	
	for(i = start_quad; i <= end_quad; i++)
	{
		DEBUG();
		opcode &opx = glob_quad.arr[i].op;
		DEBUG();
		string &arg1x = glob_quad.arr[i].arg1;
		DEBUG();
		string &arg2x = glob_quad.arr[i].arg2;
		DEBUG();
		string &resx = glob_quad.arr[i].result;
		DEBUG();
		int offr, off1, off2;
		DEBUG();
		int flag1 = 1;
		DEBUG();
		int flag2 = 1;
		DEBUG();
		int flag3 = 1;
		DEBUG();
		int j;
		DEBUG();
		fprintf(fp, "\n# %d:", i);
		DEBUG();
		if(find(resx))
		{
			DEBUG();
			offr = find(resx)->offset;
			DEBUG();
			fprintf(fp, "res = %s ", find(resx)->name.c_str());
			DEBUG();
		}
		else if(glob_quad.arr[i].result != "" && findg(glob_quad.arr[i].result))
		{
			DEBUG();
			flag3 = 0;
			DEBUG();
		}
		if(find(arg1x))
		{
			DEBUG();
			off1 = find(arg1x)->offset;
			DEBUG();
			fprintf(fp, "arg1 = %s ", find(arg1x)->name.c_str());
			DEBUG();
		}
		else if(glob_quad.arr[i].arg1 != "" && findg(glob_quad.arr[i].arg1))
		{
			DEBUG();
			flag1 = 0;
			DEBUG();		
		}
		if(find(arg2x))
		{
			DEBUG();
			off2 = find(arg2x)->offset;
			DEBUG();
			fprintf(fp, "arg2 = %s ", find(arg2x)->name.c_str());
			DEBUG();
		}
		else if(glob_quad.arr[i].arg2 != "" && findg(glob_quad.arr[i].arg2))
		{
			DEBUG();
			flag2 = 0;
			DEBUG();
		}
		if(flag1 == 0)
		{
			DEBUG();
			if(findg(arg1x) == 2)
			{
				DEBUG();
				fprintf(fp, "\n\tmovzbl\t%s(%%rip), %%eax", arg1x.c_str());
				DEBUG();
			}
			else
			{
				DEBUG();
				fprintf(fp, "\n\tmovl\t%s(%%rip), %%eax", arg1x.c_str());
				DEBUG();
			}
			DEBUG();
		}
		if(flag2 == 0)
		{
			DEBUG();
			if(findg(arg1x) == 2)
			{
				DEBUG();
				fprintf(fp, "\n\tmovzbl\t%s(%%rip), %%edx", arg2x.c_str());
				DEBUG();
			}
			else
			{
				DEBUG();
				fprintf(fp, "\n\tmovl\t%s(%%rip), %%edx", arg2x.c_str());
				DEBUG();
			}
			DEBUG();
		}
		if(S.find(i) != S.end())
		{
			DEBUG();
			fprintf(fp, "\n.L%d:", S[i]);
			DEBUG();
		}
		switch(opx)
		{
			case Q_PLUS:
				if(find(resx) != NULL && find(resx)->tp_n != NULL && find(resx)->tp_n->basetp == tp_char)
				{
					DEBUG();
					if(flag1 != 0)
						fprintf(fp, "\n\tmovzbl\t%d(%%rbp), %%eax", off1);
					DEBUG();
					if(flag2 != 0)
						fprintf(fp, "\n\tmovzbl\t%d(%%rbp), %%edx", off2);
					DEBUG();
					fprintf(fp, "\n\taddl\t%%edx, %%eax");
					DEBUG();
					if(flag3 != 0)
					{
						DEBUG();
						fprintf(fp, "\n\tmovb\t%%al, %d(%%rbp)", offr);
						DEBUG();
					}
					else
					{
						DEBUG();
						fprintf(fp, "\n\tmovb\t%%al, %s(%%rip)", resx.c_str());
						DEBUG();
					}
					DEBUG();
				}
				else 
				{
					DEBUG();
					if(flag1 != 0)
						fprintf(fp, "\n\tmovl\t%d(%%rbp), %%eax", off1);
					DEBUG();
					if(flag2 != 0)
					{
						if(arg2x[0] >='0' && arg2x[0] <= '9')
						{
							DEBUG();
							fprintf(fp, "\n\tmovl\t$%s, %%edx", arg2x.c_str());
							DEBUG();
						}
						else
						{
							DEBUG();
							fprintf(fp, "\n\tmovl\t%d(%%rbp), %%edx", off2);
							DEBUG();
						}
						DEBUG();
					}
					DEBUG();
					fprintf(fp, "\n\taddl\t%%edx, %%eax");
					DEBUG();
					if(flag3 != 0)
					{
						DEBUG();
						fprintf(fp, "\n\tmovl\t%%eax, %d(%%rbp)", offr);
						DEBUG();
					}
					else
					{
						DEBUG();
						fprintf(fp, "\n\tmovl\t%%eax, %s(%%rip)", resx.c_str());
						DEBUG();
					}
					DEBUG();
				}
				DEBUG();
				break;
			case Q_MINUS:
				if(find(resx) != NULL && find(resx)->tp_n != NULL && find(resx)->tp_n->basetp == tp_char)
				{
					DEBUG();
					if(flag1 != 0)
					{
						DEBUG();
						fprintf(fp, "\n\tmovzbl\t%d(%%rbp), %%eax", off1);
						DEBUG();
					}
					DEBUG();
					if(flag2 != 0)
					{
						DEBUG();
						fprintf(fp, "\n\tmovzbl\t%d(%%rbp), %%edx", off2);
						DEBUG();
					}
					DEBUG();
					fprintf(fp, "\n\tsubl\t%%edx, %%eax");
					DEBUG();
					if(flag3 != 0)
					{
						DEBUG();
						fprintf(fp, "\n\tmovb\t%%al, %d(%%rbp)", offr);
						DEBUG();
					}
					else
					{
						DEBUG();
						fprintf(fp, "\n\tmovb\t%%al, %s(%%rip)", resx.c_str());
						DEBUG();
					}
					DEBUG();
				}
				else
				{
					DEBUG();
					if(flag1 != 0)
					{
						DEBUG();
						fprintf(fp, "\n\tmovl\t%d(%%rbp), %%eax", off1);
						DEBUG();
					}
					DEBUG();
					if(flag2 != 0)
					{
						if(arg2x[0] >= '0' && arg2x[0] <= '9')
						{
							DEBUG();
							fprintf(fp, "\n\tmovl\t$%s, %%edx", arg2x.c_str());
							DEBUG();
						}
						else
						{
							DEBUG();
							fprintf(fp, "\n\tmovl\t%d(%%rbp), %%edx", off2);
							DEBUG();
						}
						DEBUG();
					}
					fprintf(fp, "\n\tsubl\t%%edx, %%eax");
					DEBUG();
					if(flag3 != 0)
					{
						DEBUG();
						fprintf(fp, "\n\tmovl\t%%eax, %d(%%rbp)", offr);
						DEBUG();
					}
					else
					{
						DEBUG();
						fprintf(fp, "\n\tmovl\t%%eax, %s(%%rip)", resx.c_str());
						DEBUG();
					}
					DEBUG();
				}
				DEBUG();
				break;
			case Q_MULT:
				if(find(resx) != NULL && find(resx)->tp_n != NULL && find(resx)->tp_n->basetp == tp_char)
				{
					DEBUG();
					if(flag1 != 0)
					{
						DEBUG();
						fprintf(fp, "\n\tmovzbl\t%d(%%rbp), %%eax", off1);
						DEBUG();
					}
					DEBUG();
					if(flag2 != 0)
					{
						DEBUG();
						fprintf(fp, "\n\tmovzbl\t%d(%%rbp), %%edx", off2);
						DEBUG();
					}
					DEBUG();
					fprintf(fp, "\n\timull\t%%edx, %%eax");
					DEBUG();
					if(flag3 != 0)
					{
						DEBUG();
						fprintf(fp, "\n\tmovb\t%%al, %d(%%rbp)", offr);
						DEBUG();
					}
					else
					{
						DEBUG();
						fprintf(fp, "\n\tmovb\t%%al, %s(%%rip)", resx.c_str());
						DEBUG();
					}
					DEBUG();
				}
				else
				{
					DEBUG();
					if(flag1 != 0)
					{
						DEBUG();
						fprintf(fp, "\n\tmovl\t%d(%%rbp), %%eax", off1);
						DEBUG();
					}
					DEBUG();
					if(flag2 != 0)
					{
						DEBUG();
						if(arg2x[0] >= '0' && arg2x[0] <= '9')
						{
							DEBUG();
							fprintf(fp, "\n\tmovl\t$%s, %%ecx", arg2x.c_str());
							DEBUG();
							fprintf(fp, "\n\timull\t%%ecx, %%eax");
							DEBUG();
						}
						else
						{
							DEBUG();
							fprintf(fp, "\n\timull\t%d(%%rbp), %%eax", off2);
							DEBUG();
						}
						DEBUG();
					}
					if(flag3 != 0)
					{
						DEBUG();
						fprintf(fp, "\n\tmovl\t%%eax, %d(%%rbp)", offr);
						DEBUG();
					}
					else
					{
						DEBUG();
						fprintf(fp, "\n\tmovl\t%%eax, %s(%%rip)", resx.c_str());
						DEBUG();
					}
					DEBUG();
				}
				DEBUG();
				break;
			case Q_DIVIDE:
				if(find(resx) != NULL && find(resx)->tp_n != NULL && find(resx)->tp_n->basetp == tp_char)
				{
					DEBUG();
					if(flag1 != 0)
					{
						DEBUG();
						fprintf(fp, "\n\tmovzbl\t%d(%%rbp), %%eax", off1);
						DEBUG();
					}
					DEBUG();
					fprintf(fp, "\n\tcltd");
					DEBUG();
					if(flag2 != 0)
					{
						DEBUG();
						fprintf(fp, "\n\tidivl\t%d(%%rbp), %%eax", off2);
						DEBUG();
					}
					else
					{
						DEBUG();
						fprintf(fp, "\n\tidivl\t%%edx, %%eax");
						DEBUG();
					}
					DEBUG();
					if(flag3 != 0)
					{
						DEBUG();
						fprintf(fp, "\n\tmovb\t%%al, %d(%%rbp)", offr);
						DEBUG();
					}
					else
					{
						DEBUG();
						fprintf(fp, "\n\tmovb\t%%al, %s(%%rip)", resx.c_str());
						DEBUG();
					}
					DEBUG();
				}
				else
				{
					DEBUG();
					if(flag1 != 0)
					{
						DEBUG();
						fprintf(fp, "\n\tmovl\t%d(%%rbp), %%eax", off1);
						DEBUG();
					}
					DEBUG();
					fprintf(fp, "\n\tcltd");
					DEBUG();
					if(flag2 != 0)
					{
						DEBUG();
						fprintf(fp, "\n\tidivl\t%d(%%rbp), %%eax", off2);
						DEBUG();
					}
					else
					{
						DEBUG();
						fprintf(fp, "\n\tidivl\t%%edx, %%eax");
						DEBUG();
					}
					DEBUG();
					if(flag3 != 0)
					{
						DEBUG();
						fprintf(fp, "\n\tmovl\t%%eax, %d(%%rbp)", offr);
						DEBUG();
					}
					else
					{
						DEBUG();
						fprintf(fp, "\n\tmovl\t%%eax, %s(%%rip)", resx.c_str());
						DEBUG();
					}
					DEBUG();
				}	
				DEBUG();
				break;
			case Q_MODULO:
				if(find(resx) != NULL && find(resx)->tp_n != NULL && find(resx)->tp_n->basetp == tp_char)
				{
					DEBUG();
					fprintf(fp, "\n\tmovzbl\t%d(%%rbp), %%eax", off1);
					DEBUG();
					fprintf(fp, "\n\tcltd");
					DEBUG();
					fprintf(fp, "\n\tidivl\t%d(%%rbp), %%eax", off2);
					DEBUG();
					fprintf(fp, "\n\tmovl\t%%edx, %%eax");
					DEBUG();
					fprintf(fp, "\n\tmovb\t%%al, %d(%%rbp)", offr);
					DEBUG();
				}
				else
				{
					DEBUG();
					fprintf(fp, "\n\tmovl\t%d(%%rbp), %%eax", off1);
					DEBUG();
					fprintf(fp, "\n\tcltd");
					DEBUG();
					fprintf(fp, "\n\tidivl\t%d(%%rbp), %%eax", off2);
					DEBUG();
					fprintf(fp, "\n\tmovl\t%%edx, %d(%%rbp)", offr);
					DEBUG();
				}
				DEBUG();
				break;
			case Q_UNARY_MINUS:
				if(find(resx) != NULL && find(resx)->tp_n != NULL && find(resx)->tp_n->basetp == tp_char)
				{
					DEBUG();
					fprintf(fp, "\n\tmovzbl\t%d(%%rbp), %%eax", off1);
					DEBUG();
					fprintf(fp, "\n\tnegl\t%%eax");
					DEBUG();
					fprintf(fp, "\n\tmovb\t%%al, %d(%%rbp)", offr);
					DEBUG();
				}
				else
				{
					DEBUG();
					fprintf(fp, "\n\tmovl\t%d(%%rbp), %%eax", off1);
					DEBUG();
					fprintf(fp, "\n\tnegl\t%%eax");
					DEBUG();
					fprintf(fp, "\n\tmovl\t%%eax, %d(%%rbp)", offr);
					DEBUG();
				}
				DEBUG();
				break;
			case Q_ASSIGN:
				if(arg1x[0] >= '0' && arg1x[0] <= '9')
				{
					DEBUG();
					if(flag1 != 0)
					{
						DEBUG();
						fprintf(fp, "\n\tmovl\t$%s, %d(%%rbp)", arg1x.c_str(), offr);
						DEBUG();
					}
					DEBUG();
				}
				else if(arg1x[0] == '\'')
				{
					DEBUG();
					fprintf(fp, "\n\tmovb\t$%d, %d(%%rbp)", (int)arg1x[1], offr);
					DEBUG();
				}
				else if(flag1 && find(resx) != NULL && find(resx)->tp_n != NULL && find(resx)->tp_n->basetp == tp_char)
				{
					DEBUG();
					fprintf(fp, "\n\tmovzbl\t%d(%%rbp), %%eax", off1);
					DEBUG();
					fprintf(fp, "\n\tmovb\t%%al, %d(%%rbp)", offr);
					DEBUG();
				}
				else if(flag1 && find(resx) != NULL && find(resx)->tp_n != NULL && find(resx)->tp_n->basetp == tp_int)
				{
					DEBUG();
					if(flag1 != 0)
					{
						DEBUG();
						fprintf(fp, "\n\tmovl\t%d(%%rbp), %%eax", off1);
						DEBUG();
					}
					DEBUG();
					fprintf(fp, "\n\tmovl\t%%eax, %d(%%rbp)", offr);
					DEBUG();
				}
				else if(find(resx) != NULL && find(resx)->tp_n != NULL)
				{
					DEBUG();
					fprintf(fp, "\n\tmovq\t%d(%%rbp), %%rax", off1);
					DEBUG();
					fprintf(fp, "\n\tmovq\t%%rax, %d(%%rbp)", offr);
					DEBUG();
				}
				else
				{
					DEBUG();
					if(flag3 != 0)
					{
						DEBUG();
						fprintf(fp, "\n\tmovl\t%d(%%rbp), %%eax", off1);
						DEBUG();
						fprintf(fp, "\n\tmovl\t%%eax, %d(%%rbp)", offr);
						DEBUG();
					}
					else
					{
						DEBUG();
						fprintf(fp, "\n\tmovl\t%%eax, %s(%%rip)", resx.c_str());
						DEBUG();
					}
				}
				DEBUG();
				break;
			case Q_PARAM:
				if(resx[0] == '_')
				{
					DEBUG();
					char* temp = (char*)resx.c_str();
					DEBUG();
					fprintf(fp, "\n\tmovq\t$.STR%d,\t%%rdi", atoi(temp+1));
					DEBUG();
				}
				else
				{
					PARAMETER.push(resx);
					DEBUG();
					TYPES.push(find(resx)->tp_n->basetp);
					DEBUG();
					OFFSET.push(offr);
					DEBUG();
					if(find(resx)->isptrarr == true)
					{
						POINTER_ARRAY.push(1);
						DEBUG();
					}
					else
					{
						POINTER_ARRAY.push(0);
						DEBUG();
					}
				}
				DEBUG();
				break;
			case Q_GOTO:
				if(resx != "-1" && atoi(resx.c_str()) <= end_quad) {
					fprintf(fp,"\n\tjmp .L%d",S[atoi(resx.c_str())]);
				}
				else {
					fprintf(fp,"\n\tjmp\t.LRT%d",num);
				}

				DEBUG();
				break;
			case Q_CALL:
				adding_offset = function_call(fp);
				DEBUG();
				fprintf(fp, "\n\tcall\t%s", arg1x.c_str());
				DEBUG();
				if(resx == "")
				{
					DEBUG();
				}
				else if(find(resx) != NULL && find(resx)->tp_n != NULL && find(resx)->tp_n->basetp == tp_int)
				{
					fprintf(fp, "\n\tmovl\t%%eax, %d(%%rbp)", offr);
					DEBUG();
				}
				else if(find(resx) != NULL && find(resx)->tp_n != NULL && find(resx)->tp_n->basetp == tp_char)
				{
					DEBUG();
					fprintf(fp, "\n\tmovb\t%%al, %d(%%rbp)", offr);
				}
				else if(find(resx) != NULL && find(resx)->tp_n != NULL)
				{
					DEBUG();
					fprintf(fp, "\n\tmovq\t%%rax, %d(%%rbp)", offr);
				}
				else
				{	
					DEBUG();
					fprintf(fp, "\n\tmovl\t%%eax, %d(%%rbp)", offr);
				}
				if(arg1x == "printStr")
				{
					DEBUG();
					fprintf(fp, "\n\taddq $8 , %%rsp");
				}
				else 
				{
					DEBUG();
					fprintf(fp, "\n\taddq $%d , %%rsp", adding_offset);
				}
				DEBUG();
				break;
			case Q_IF_LESS:
				if(find(arg1x) != NULL && find(arg1x)->tp_n != NULL && find(arg1x)->tp_n->basetp == tp_char)
				{
					DEBUG();
					fprintf(fp, "\n\tmovzbl\t%d(%%rbp), %%eax", off1);
					DEBUG();
					fprintf(fp, "\n\tcmpb\t%d(%%rbp), %%al", off2);
					DEBUG();
					fprintf(fp, "\n\tjl .L%d", S[atoi(resx.c_str())]);
					DEBUG();
				}
				else
				{
					fprintf(fp, "\n\tmovl\t%d(%%rbp), %%eax", off1);
					DEBUG();
					fprintf(fp, "\n\tmovl\t%d(%%rbp), %%edx", off2);
					DEBUG();
					fprintf(fp, "\n\tcmpl\t%%edx, %%eax");
					DEBUG();
					fprintf(fp, "\n\tjl .L%d", S[atoi(resx.c_str())]);
					DEBUG();
				}
				break;
			case Q_IF_LESS_OR_EQUAL:
				if(find(arg1x) != NULL && find(arg1x)->tp_n != NULL&&find(arg1x)->tp_n->basetp == tp_char)
				{
					fprintf(fp, "\n\tmovzbl\t%d(%%rbp), %%eax", off1);
					DEBUG();
					fprintf(fp, "\n\tcmpb\t%d(%%rbp), %%al", off2);
					DEBUG();
					fprintf(fp, "\n\tjle .L%d", S[atoi(resx.c_str())]);
					DEBUG();
				}
				else
				{
					fprintf(fp, "\n\tmovl\t%d(%%rbp), %%eax", off1);
					DEBUG();
					fprintf(fp, "\n\tmovl\t%d(%%rbp), %%edx", off2);
					DEBUG();
					fprintf(fp, "\n\tcmpl\t%%edx, %%eax");
					DEBUG();
					fprintf(fp, "\n\tjle .L%d", S[atoi(resx.c_str())]);
					DEBUG();
				}
				DEBUG();
				break;
			case Q_IF_GREATER:
				if(find(arg1x) != NULL && find(arg1x)->tp_n != NULL && find(arg1x)->tp_n->basetp == tp_char)
				{
					fprintf(fp, "\n\tmovzbl\t%d(%%rbp), %%eax", off1);
					DEBUG();
					fprintf(fp, "\n\tcmpb\t%d(%%rbp), %%al", off2);
					DEBUG();
					fprintf(fp, "\n\tjg .L%d", S[atoi(resx.c_str())]);
					DEBUG();
				}
				else
				{
					fprintf(fp, "\n\tmovl\t%d(%%rbp), %%eax", off1);
					DEBUG();
					fprintf(fp, "\n\tmovl\t%d(%%rbp), %%edx", off2);
					DEBUG();
					fprintf(fp, "\n\tcmpl\t%%edx, %%eax");
					DEBUG();
					fprintf(fp, "\n\tjg .L%d", S[atoi(resx.c_str())]);
					DEBUG();
				}
				DEBUG();
				break;
			case Q_IF_GREATER_OR_EQUAL:
				if(find(arg1x) != NULL && find(arg1x)->tp_n != NULL && find(arg1x)->tp_n->basetp == tp_char)
				{
					DEBUG();
					fprintf(fp, "\n\tmovzbl\t%d(%%rbp), %%eax", off1);
					DEBUG();
					fprintf(fp, "\n\tcmpb\t%d(%%rbp), %%al", off2);
					DEBUG();
					fprintf(fp, "\n\tjge .L%d", S[atoi(resx.c_str())]);
					DEBUG();
				}
				else
				{
					DEBUG();
					fprintf(fp, "\n\tmovl\t%d(%%rbp), %%eax", off1);
					DEBUG();
					fprintf(fp, "\n\tmovl\t%d(%%rbp), %%edx", off2);
					DEBUG();
					fprintf(fp, "\n\tcmpl\t%%edx, %%eax");
					DEBUG();
					fprintf(fp, "\n\tjge .L%d", S[atoi(resx.c_str())]);
					DEBUG();
				}
				DEBUG();
				break;
			case Q_IF_EQUAL:
				if(find(arg1x) != NULL && find(arg1x)->tp_n != NULL && find(arg1x)->tp_n->basetp == tp_char)
				{
					DEBUG();
					fprintf(fp, "\n\tmovzbl\t%d(%%rbp), %%eax", off1);
					DEBUG();
					fprintf(fp, "\n\tcmpb\t%d(%%rbp), %%al", off2);
					DEBUG();
					fprintf(fp, "\n\tje .L%d", S[atoi(resx.c_str())]);
					DEBUG();
				}
				else
				{
					DEBUG();
					fprintf(fp, "\n\tmovl\t%d(%%rbp), %%eax", off1);
					DEBUG();
					fprintf(fp, "\n\tmovl\t%d(%%rbp), %%edx", off2);
					DEBUG();
					fprintf(fp, "\n\tcmpl\t%%edx, %%eax");
					DEBUG();
					fprintf(fp, "\n\tje .L%d", S[atoi(resx.c_str())]);
					DEBUG();
				}
				break;
			case Q_IF_NOT_EQUAL:
				if(find(arg1x) != NULL && find(arg1x)->tp_n != NULL && find(arg1x)->tp_n->basetp == tp_char)
				{
					DEBUG();
					fprintf(fp, "\n\tmovzbl\t%d(%%rbp), %%eax", off1);
					DEBUG();
					fprintf(fp, "\n\tcmpb\t%d(%%rbp), %%al", off2);
					DEBUG();
					fprintf(fp, "\n\tjne .L%d", S[atoi(resx.c_str())]);
					DEBUG();
				}
				else
				{
					DEBUG();
					fprintf(fp, "\n\tmovl\t%d(%%rbp), %%eax", off1);
					DEBUG();
					fprintf(fp, "\n\tmovl\t%d(%%rbp), %%edx", off2);
					DEBUG();
					fprintf(fp, "\n\tcmpl\t%%edx, %%eax");
					DEBUG();
					fprintf(fp, "\n\tjne .L%d", S[atoi(resx.c_str())]);
					DEBUG();
				}
				DEBUG();
				break;
			case Q_ADDR:
				DEBUG();
				fprintf(fp, "\n\tleaq\t%d(%%rbp), %%rax", off1);
				DEBUG();
				fprintf(fp, "\n\tmovq\t%%rax, %d(%%rbp)", offr);
				DEBUG();
				break;
			case Q_LDEREF:
				DEBUG();
				fprintf(fp, "\n\tmovq\t%d(%%rbp), %%rax", offr);
				DEBUG();
				fprintf(fp, "\n\tmovl\t%d(%%rbp), %%edx", off1);
				DEBUG();
				fprintf(fp, "\n\tmovl\t%%edx, (%%rax)");
				DEBUG();
				break;
			case Q_RDEREF:
				DEBUG();
				fprintf(fp, "\n\tmovq\t%d(%%rbp), %%rax", off1);
				DEBUG();
				fprintf(fp, "\n\tmovl\t(%%rax), %%eax");
				DEBUG();
				fprintf(fp, "\n\tmovl\t%%eax, %d(%%rbp)", offr);
				DEBUG();
				break;
			case Q_RINDEX:
				if(find(arg1x) && find(arg1x)->isptrarr==true)
				{
					fprintf(fp, "\n\tmovq\t%d(%%rbp), %%rdx", off1);
					DEBUG();
					fprintf(fp, "\n\tmovslq\t%d(%%rbp), %%rax", off2);
					DEBUG();
					fprintf(fp, "\n\taddq\t%%rax, %%rdx");
					DEBUG();
				}
				else
				{
					DEBUG();
					fprintf(fp, "\n\tleaq\t%d(%%rbp), %%rdx", off1);
					DEBUG();
					fprintf(fp, "\n\tmovslq\t%d(%%rbp), %%rax", off2);
					DEBUG();
					fprintf(fp, "\n\taddq\t%%rax, %%rdx");
					DEBUG();
				}
				if(find(resx) != NULL && find(resx)->tp_n != NULL && find(resx)->tp_n->next && find(resx)->tp_n->next->basetp == tp_char)
				{
					DEBUG();
					fprintf(fp, "\n\tmovzbl\t(%%rdx), %%eax");
					DEBUG();
					fprintf(fp, "\n\tmovb\t%%al, %d(%%rbp)", offr);
					DEBUG();
				}
				else
				{
					DEBUG();
					fprintf(fp, "\n\tmovl\t(%%rdx), %%eax");
					DEBUG();
					fprintf(fp, "\n\tmovl\t%%eax, %d(%%rbp)", offr);
					DEBUG();
				}
				break;
			case Q_LINDEX:
				if(find(resx) && find(resx)->isptrarr == true)
				{
					DEBUG();
					fprintf(fp, "\n\tmovq\t%d(%%rbp), %%rdx", offr);
					DEBUG();
					fprintf(fp, "\n\tmovslq\t%d(%%rbp), %%rax", off1);
					DEBUG();
					fprintf(fp, "\n\taddq\t%%rax, %%rdx");
					DEBUG();
				}
				else
				{
					DEBUG();
					fprintf(fp, "\n\tleaq\t%d(%%rbp), %%rdx", offr);
					DEBUG();
					fprintf(fp, "\n\tmovslq\t%d(%%rbp), %%rax", off1);
					DEBUG();
					fprintf(fp,"\n\taddq\t%%rax, %%rdx");
					DEBUG();
				}
				if(find(resx) != NULL && find(resx)->tp_n != NULL && find(resx)->tp_n->next && find(resx)->tp_n->next->basetp == tp_char)
				{
					DEBUG();
					fprintf(fp, "\n\tmovzbl\t%d(%%rbp), %%eax", off2);
					DEBUG();
					fprintf(fp, "\n\tmovb\t%%al, (%%rdx)");
					DEBUG();
				}
				else
				{
					DEBUG();
					fprintf(fp, "\n\tmovl\t%d(%%rbp), %%eax", off2);
					DEBUG();
					fprintf(fp, "\n\tmovl\t%%eax, (%%rdx)");
					DEBUG();
				}
				DEBUG();
				break;
			case Q_RETURN:
				if(resx != "")
				{
					DEBUG();
					if(find(resx) != NULL && find(resx)->tp_n != NULL && find(resx)->tp_n->basetp == tp_char)
					{
						fprintf(fp, "\n\tmovzbl\t%d(%%rbp), %%eax", offr);
						DEBUG();
					}
					else
					{
						fprintf(fp, "\n\tmovl\t%d(%%rbp), %%eax", offr);
						DEBUG();
					}
					DEBUG();
				}
				else
				{
					fprintf(fp, "\n\tmovl\t$0, %%eax");
					DEBUG();
				}
				fprintf(fp, "\n\tjmp\t.LRT%d",num);
				DEBUG();
				break;
			default:
			break;
		}
	}
}

void symtab::function_prologue(FILE *fp, int C)
{
	DEBUG();
	fprintf(fp, "\n\t.globl\t%s", name.c_str());
	DEBUG();
	fprintf(fp, "\n\t.type\t%s, @function", name.c_str());
	DEBUG();
	fprintf(fp, "\n%s:", name.c_str());
	DEBUG();
	fprintf(fp, "\n.LFB%d:", C);
	DEBUG();
	fprintf(fp, "\n\tpushq\t%%rbp");
	DEBUG();
	fprintf(fp, "\n\tmovq\t%%rsp, %%rbp");
	DEBUG();
	int t = -offset;
	DEBUG();
	fprintf(fp, "\n\tsubq\t$%d, %%rsp", t);
	DEBUG();
}

void symtab::function_epilogue(FILE *fp, int C, int num)
{
	DEBUG();
	fprintf(fp, "\n.LRT%d:", num);
	DEBUG();
	fprintf(fp, "\n\taddq\t$%d, %%rsp", offset);
	DEBUG();
	fprintf(fp, "\n\tmovq\t%%rbp, %%rsp");
	DEBUG();
	fprintf(fp, "\n\tpopq\t%%rbp");
	DEBUG();
	fprintf(fp, "\n\tret");
	DEBUG();
	fprintf(fp, "\n.LFE%d:", C);
	DEBUG();
	fprintf(fp, "\n\t.size\t%s, .-%s", name.c_str(), name.c_str());
	DEBUG();
}

