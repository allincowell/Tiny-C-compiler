#include "ass6_18CS30032_18CS10068_translator.h"
#include "y.tab.h"
#include<sstream>
#include<string>
#include<iostream>

symtab *glob_st = new symtab();
symtab *curr_st = new symtab();
int glob_width;
int temp_count = 0;
int next_instr;
long long int instr_count;
quadArray glob_quad;
vector<string> strings_label;
bool check;
type_n *glob_type;
vector <string> cs;
vector <string> vs;
int size_int = 4;
int size_char = 1;
int size_double = 8;
int size_pointer = 8;
int size_bool = 1;

void PRINT() {
	return;
}

void debug()
{
	PRINT();
	if(check == 1)
		cout << instr_count << endl;
	PRINT();
}

void update_nextinstr()
{
	instr_count++;
	if(check == 1)
	{
		cout << "Current Line Number:" << instr_count << endl;
		PRINT();
		cout<<"Press [ENTER] to continue:";
		PRINT();
		cin.get();
		PRINT();
	}
}

types type_n::getBasetp()
{
	if(this != NULL)
	{
		PRINT();
		return (*this).basetp;
		PRINT();
	}	
	else
	{
		PRINT();
		return tp_void;
		PRINT();
	}	
}

type_n::type_n(types t,int sz,type_n *n)
{
	PRINT();
	basetp = t;
	PRINT();
	size = sz;
	PRINT();
	next = n;
	PRINT();
}

int type_n::getSize()
{
	if(this == NULL)
		return 0;
	PRINT();
	if(((*this).basetp) == tp_arr)
		return (((*this).size)*((*this).next->getSize()));
	PRINT();
	if(((*this).basetp) == tp_void)
		return 0;
	PRINT();
	if(((*this).basetp) == tp_int)
		return size_int;
	PRINT();
	if(((*this).basetp) == tp_double)
		return size_double;
	PRINT();
	if(((*this).basetp) == tp_bool)
		return size_bool;
	PRINT();
	if(((*this).basetp) == tp_char)
		return size_char;
	PRINT();
	if(((*this).basetp) == tp_ptr)
		return size_pointer;
	PRINT();
}

void type_n::printSize()
{
	PRINT();
	printf("%d\n",size);
}

Array::Array(string s,int sz,types t)
{
	(*this).base_arr = s;
	PRINT();
	(*this).tp = t;
	PRINT();
	(*this).bsize = sz;
	PRINT();
	(*this).dimension_size = 1;
	PRINT();
}

void type_n::print()
{
	if(basetp ==  tp_void)
	{
		PRINT();	
		printf("void");
	}

	else if(basetp == tp_bool)
	{
		PRINT();
		printf("bool");

	}	
	else if(basetp == tp_int)	
	{
		PRINT();
		printf("int");
	}

	else if(basetp == tp_char)	
	{
		PRINT();
		printf("char");
		PRINT();
	}
	
	else if(basetp == tp_double)
	{
		PRINT();
		printf("double");
	}

	else if(basetp == tp_ptr)	
	{	
		PRINT();
		printf("ptr(");
		if((*this).next != NULL)
			(*this).next->print();
		printf(")");
		PRINT();
	}
	else if(basetp == tp_arr)
	{	
		printf("Array(%d,", size);
		if((*this).next != NULL)
			(*this).next->print();
			printf(")");
		PRINT();	
	}		
	else if(basetp == tp_func)
	{
		printf("Function()");
		PRINT();
	}	
	else
	{
			PRINT();
			printf("INVALID TYPE\n");
			exit(-1);
	}
}

void Array::addindex(int i)
{
	(*this).dimension_size = (*this).dimension_size+1;
	PRINT();
	(*this).dims.push_back(i);
	PRINT();
}

void funct::print()
{
	printf("Funct(");
	PRINT();
	PRINT();
	for(int i = 0; i < typelist.size(); i++)
	{
		PRINT();
		if(i != 0)
			printf(",");
		PRINT();
		printf("%d ", typelist[i]);
		PRINT();
	}
	printf(")");
	PRINT();
}

symbolData::symbolData(string S)
{
	name = S;
	size = 0;
	tp_n = NULL;
	offset = -1;
	var_type = "";
	isInitialized = false;
	isFunction = false;
	isArray = false;
	ispresent = true;
	arr = NULL;
	fun = NULL;
	nest_tab = NULL;
	isdone = false;
	isptrarr = false;
	isGlobal = false;
}

funct::funct(vector<types> tpls)
{
	typelist = tpls;
	PRINT();
}

void symbolData::createArray()
{
	PRINT();
	arr = new Array((*this).name, (*this).size, tp_arr);
	PRINT();
}

symtab::~symtab()
{
	PRINT();
	for(int i = 0;i < symbol_table.size(); i++)
	{
		PRINT();
		type_n *p1 = (*symbol_table[i]).tp_n;
		PRINT();
		type_n *p2;
		while(true)
		{
			PRINT();
			if(p1 == NULL)
				break;
			PRINT();
			p2 = p1;
			PRINT();
			p1 = (*p1).next;
			PRINT();
			delete p2;
		}
	}
	PRINT();
}

symtab::symtab()
{
	PRINT();
	name = "";
	PRINT();
	offset = 0;
	PRINT();
	no_params = 0;
	PRINT();
}

symbolData* symtab::lookup(string S)
{
	for(int i = 0; i < (int) symbol_table.size(); i++)
	{
		PRINT();
		if((*symbol_table[i]).name == S)
		{
			PRINT();
			return symbol_table[i];
		}
	}
	PRINT();
	symbolData *temp = new symbolData(S);
	PRINT();
	(*temp).i_val.int_val = 0;
	PRINT();
	symbol_table.push_back(temp);
	PRINT();
	return symbol_table[symbol_table.size() - 1];
}

int symtab::findg(string S)
{
	PRINT();
	for(int i = 0; i < vs.size(); i++)
	{
		PRINT();
		if(vs[i] == S)
			return 1;
	}
	PRINT();
	for(int i = 0; i < cs.size(); i++)
	{
		PRINT();
		if(cs[i] == S)
			return 2;
	}
	PRINT();
	return 0;
}

symbolData* symtab::find(string S)
{
	PRINT();
	for(int i = 0; i < (int) symbol_table.size(); i++)
	{
		PRINT();
		if((*symbol_table[i]).name == S && symbol_table[i]->ispresent)
		{
			PRINT();
			return (symbol_table[i]);
		}
	}
	PRINT();
	return NULL;
}

type_n *CopyType(type_n *t)
{
	if(t == NULL) 
		return t;
	PRINT();
	type_n *ret = new type_n((*t).basetp);
	PRINT();
	(*ret).size = (*t).size;
	(*ret).basetp = (*t).basetp;
	PRINT();
	(*ret).next = CopyType((*t).next);
	PRINT();
	return ret;
}

void symtab::update(symbolData *sm, type_n *type, basic_val initval, symtab *next)
{
	(*sm).tp_n = CopyType(type);
	PRINT();
	(*sm).i_val = initval;
	PRINT();
	(*sm).nest_tab = next;
	PRINT();
	int SIZE;
	PRINT();
	if((*sm).tp_n == NULL)
		SIZE = 0;
	else if((((*sm).tp_n)->basetp) == tp_void)
		SIZE = 0;
	else if((((*sm).tp_n)->basetp) == tp_int)
		SIZE = size_int;
	else if((((*sm).tp_n)->basetp) == tp_double)
		SIZE = size_double;
	else if((((*sm).tp_n)->basetp) == tp_bool)
		SIZE = size_bool;
	else if((((*sm).tp_n)->basetp) == tp_char)
		SIZE = size_char;
	else if((((*sm).tp_n)->basetp) == tp_ptr)
		SIZE = size_pointer;
	else
		SIZE = (*sm).tp_n->getSize();
	PRINT();
	(*sm).size = SIZE;
	PRINT();
	(*sm).offset = (*this).offset;
	PRINT();
	(*this).offset = (*this).offset + ((*sm).size);
	PRINT();
	(*sm).isInitialized = false;
	PRINT();
}

symbolData* symtab::lookup_global(string S)
{
	PRINT();
	for(int i = 0; i < (int) symbol_table.size(); i++)
	{
		PRINT();
		if(symbol_table[i]->name == S)
		{
			PRINT();
			return symbol_table[i];
		}
	}
	PRINT();
	for(int i = 0; i < (*glob_st).symbol_table.size(); i++)
	{
		PRINT();
		if((*glob_st).symbol_table[i]->name == S)
		{
			PRINT();
			return (*glob_st).symbol_table[i];
		}
	}
	PRINT();
	symbolData *temp_o = new symbolData(S);
	PRINT();
	(*temp_o).i_val.int_val = 0;
	PRINT();
	symbol_table.push_back(temp_o);
	PRINT();
	return symbol_table[(int) symbol_table.size() - 1];
}

symbolData* symtab::gentemp(type_n *type)
{
	char c[10];
	PRINT();
	sprintf(c, "t%03d", temp_count);
	PRINT();
	temp_count++;
	PRINT();
	symbolData *temp = lookup(c);
	PRINT();
	int SIZE;
	PRINT();
	if(type == NULL)
		SIZE = 0;
	else if(((*type).basetp) == tp_void)
		SIZE = 0;
	else if(((*type).basetp) == tp_int)
		SIZE = size_int;
	else if(((*type).basetp) == tp_double)
		SIZE = size_double;
	else if(((*type).basetp) == tp_bool)
		SIZE = size_bool;
	else if(((*type).basetp) == tp_char)
		SIZE = size_char;
	else if(((*type).basetp) == tp_ptr)
		SIZE = size_pointer;
	else
		SIZE = (*type).getSize();
	PRINT();
	(*temp).size = SIZE;
	PRINT();
	(*temp).var_type = "temp";
	PRINT();
	(*temp).tp_n=type;
	PRINT();
	(*temp).offset = (*this).offset;
	PRINT();
	(*this).offset = (*this).offset + ((*temp).size);
	PRINT();
	return temp;
}

list* makelist(int pos)
{
	list *temp = (list*)malloc(sizeof(list));
	PRINT();
	(*temp).index = pos;
	PRINT();
	(*temp).next = NULL;
	PRINT();
	return temp;
}

void symtab::print()
{
	printf("____________________________________________ %s ____________________________________________\n", name.c_str());
	PRINT();
	printf("Offset = %d\nStart Quad Index = %d\nEnd Quad Index =  %d\n", offset, start_quad, end_quad);
	PRINT();
	printf("Name\tValue\tvar_type\tsize\tOffset\tType\n\n");
    PRINT();
    for(int i = 0; i < (symbol_table).size(); i++)
    {
    	PRINT();
        if(symbol_table[i]->ispresent == false)
        	continue;
        PRINT();
        symbolData* t = symbol_table[i];
        PRINT();
        printf("%s\t", symbol_table[i]->name.c_str()); 
        if((*t).isInitialized)
        {
        	PRINT();
        	if(((*t).tp_n)->basetp == tp_char) 
        		printf("%c\t",((*t).i_val).char_val);
        	else if(((*t).tp_n)->basetp == tp_int) 
        		printf("%d\t",((*t).i_val).int_val);
        	else if(((*t).tp_n)->basetp == tp_double) 
        		printf("%.3lf\t",((*t).i_val).double_val);
       	 	else printf("----\t");
       	 	PRINT();
      	}
      	else
      		printf("null\t");
      	PRINT();
        printf("%s",(*t).var_type.c_str());
        PRINT();
        printf("\t\t%d\t%d\t",(*t).size,(*t).offset);
        PRINT();
		if((*t).var_type == "func")
			printf("ptr-to-St( %s )",(*t).nest_tab->name.c_str());
		PRINT();
		if((*t).tp_n != NULL)
			((*t).tp_n)->print();
		printf("\n");
	}
	PRINT();
	printf("\n");
	PRINT();
	printf("x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x\n");
}

quad::quad(opcode op, string arg1,string arg2,string res)
{
	(*this).op = op;
	PRINT();
	(*this).arg1 = arg1;
	PRINT();
	(*this).result = res;
	PRINT();
	(*this).arg2 = arg2;
	PRINT();
}

list* merge(list *lt1, list *lt2)
{
	list *temp = (list*)malloc(sizeof(list));
	PRINT();
	list *p1 = temp;
	PRINT();
	int flag = 0;
	PRINT();
	list *l1 = lt1;
	PRINT();
	list *l2 = lt2;
	PRINT();
	while(l1 != NULL)
	{
		flag = 1;
		PRINT();
		(*p1).index = (*l1).index;
		PRINT();
		if((*l1).next != NULL)
		{
			(*p1).next = (list*)malloc(sizeof(list));
			p1=(*p1).next;
		}
		PRINT();
		l1 = (*l1).next;
	}
	while(l2 != NULL)
	{
		PRINT();
		if(flag == 1)
		{
			PRINT();
			(*p1).next = (list*)malloc(sizeof(list));
			PRINT();
			p1 = (*p1).next;
			PRINT();
			flag = 0;
			PRINT();
		}
		(*p1).index = l2->index;
		PRINT();
		if(l2->next != NULL)
		{
			PRINT();
			(*p1).next = (list*)malloc(sizeof(list));
			PRINT();
			p1 = (*p1).next;
			PRINT();
		}
		l2 = l2->next;
		PRINT();
	}
	PRINT();
	(*p1).next = NULL;
	PRINT();
	return temp;
}

void quad::print_arg()
{
	PRINT();
	printf("\t%s\t=\t%s\top\t%s\t", result.c_str(), arg1.c_str(), arg2.c_str());
	PRINT();
}

quadArray::quadArray()
{
	PRINT();
	next_instr = 0;
	PRINT();
}

void quadArray::emit(opcode opc, string arg1, string arg2, string res)
{
	PRINT();
	if(res.size() != 0)
	{
		PRINT();
		quad new_elem(opc, arg1, arg2, res);
		PRINT();
		arr.push_back(new_elem);
		PRINT();
	}
	else if(arg2.size() != 0)
	{
		PRINT();
		quad new_elem(opc, arg1, "", arg2);
		PRINT();
		arr.push_back(new_elem);
		PRINT();
	}
	else if(arg1.size() != 0)
	{
		PRINT();
		quad new_elem(opc, "", "", arg1);
		PRINT();
		arr.push_back(new_elem);
		PRINT();
	}
	else
	{
		PRINT();
		quad new_elem(opc, "", "", "");
		PRINT();
		arr.push_back(new_elem);
		PRINT();
	}
	next_instr++;
	PRINT();
}

void quadArray::emit(opcode opc, int val, string OP)
{
	char S[20];
	PRINT();
	sprintf(S, "%d", val);
	if((int) OP.size() == 0)
	{
		PRINT();
		quad new_quad(opc, "", "", S);
		PRINT();
		arr.push_back(new_quad);
		PRINT();
	}
	else
	{
		PRINT();
		quad new_quad(opc, S, "", OP);
		PRINT();
		arr.push_back(new_quad);
		PRINT();
	}
	PRINT();
	next_instr++;
	PRINT();
}

void quadArray::emit(opcode opc, char val, string OP)
{
	char S[20];
	PRINT();
	sprintf(S, "'%c'", val);
	PRINT();
	if((int) OP.size() == 0)
	{
		PRINT();
		quad new_quad(opc, "", "", S);
		PRINT();
		arr.push_back(new_quad);
		PRINT();
	}
	else
	{
		PRINT();
		quad new_quad(opc, S, "", OP);
		PRINT();
		arr.push_back(new_quad);
		PRINT();
	}
	PRINT();
	next_instr++;
}

void quadArray::emit(opcode opc, double val, string OP)
{
	char S[20];
	PRINT();
	sprintf(S, "%lf", val);
	PRINT();
	if((int) OP.size() == 0)
	{
		PRINT();
		quad new_quad(opc, "", "", S);
		PRINT();
		arr.push_back(new_quad);
		PRINT();
	}
	else
	{
		PRINT();
		quad new_quad(opc, S, "", OP);
		PRINT();
		arr.push_back(new_quad);
		PRINT();
	}
	PRINT();
	next_instr++;
	PRINT();
}

void quadArray::emit2(opcode opc, string arg1, string arg2, string res)
{
	if((int) res.size() == 0)
	{
		PRINT();
		quad new_elem(opc, arg1, arg2, "");
		PRINT();
		arr.push_back(new_elem);
	}
}

void quadArray::print()
{
	opcode op;
	PRINT();
	string arg1;
	PRINT();
	string arg2;
	PRINT();
	string res;
	PRINT();
	for(int i = 0;i < next_instr; i++)
	{

		op = arr[i].op;
		PRINT();
		arg1 = arr[i].arg1;
		PRINT();
		arg2 = arr[i].arg2;
		PRINT();
		res = arr[i].result;
		PRINT();
		printf("%3d : ", i);
		PRINT();
		if(Q_PLUS <= op && op <= Q_NOT_EQUAL)
	    {
	        printf("%s", res.c_str());
	        PRINT();
	        printf("\t=\t");
	        PRINT();
	        printf("%s", arg1.c_str());
	        PRINT();
	        printf(" ");
	        PRINT();
            if( Q_PLUS == op) 
            	printf("+"); 
            else if( Q_MINUS == op) 
            	printf("-"); 
            else if (Q_MULT == op) 
            	printf("*"); 
            else if(op == Q_DIVIDE) 
            	printf("/");
            else if( Q_MODULO == op) 
            	printf("%%"); 
            else if( Q_LEFT_OP == op) 
            	printf("<<"); 
            else if (op == Q_RIGHT_OP) 
            	printf(">>"); 
            else if(op == Q_XOR) 
            	printf("^"); 
            else if (op== Q_AND) 
            	printf("&"); 
            else if( Q_OR == op) 
            	printf("|"); 
            else if (Q_LOG_AND == op) 
            	printf("&&"); 
            else if(op == Q_LOG_OR) 
            	printf("||"); 
            else if( Q_LESS == op) 
            	printf("<"); 
            else if( Q_LESS_OR_EQUAL == op) 
            	printf("<="); 
            else if(Q_GREATER_OR_EQUAL == op) 
            	printf(">="); 
            else if (Q_GREATER == op) 
            	printf(">"); 
            else if (Q_EQUAL == op) 
            	printf("=="); 
            else if(Q_NOT_EQUAL == op) 
            		printf("!=");
        
	        printf(" ");
	        PRINT();
	       	printf("%s\n", arg2.c_str());
	       	PRINT();
	    }
	    else if(Q_UNARY_MINUS <= op && op <= Q_ASSIGN)
	    {
	        printf("%s", res.c_str());
	        PRINT();
	        printf("\t=\t");
	        PRINT();    
            if( Q_UNARY_MINUS == op) 
            	printf("-"); 
            else if (op == Q_UNARY_PLUS)  
            	printf("+"); 
            else if(op == Q_COMPLEMENT) 
            	printf("~"); 
            else if(op == Q_NOT)  
            	printf("!"); 
        	PRINT();
	        printf("%s\n", arg1.c_str());
	        PRINT();
	    }
	    else if(op == Q_GOTO)
	    {
	    	printf("goto ");
	    	PRINT();
	    	printf("%s\n", res.c_str());
	    	PRINT();
	    }
	    else if(Q_IF_EQUAL <= op && op <= Q_IF_GREATER_OR_EQUAL)
	    {
	        printf("if  ");
	        printf("%s", arg1.c_str());
	        printf(" ");
	        PRINT();
            if(Q_IF_LESS == op) 
            	printf("<"); 
            else if( Q_IF_GREATER == op) 
            	printf(">"); 
            else if(op == Q_IF_LESS_OR_EQUAL ) 
            	printf("<="); 
            else if(op == Q_IF_GREATER_OR_EQUAL ) 
            	printf(">="); 
            else if (op == Q_IF_EQUAL ) 
            	printf("=="); 
            else if(op == Q_IF_NOT_EQUAL )
            	printf("!="); 
            else if (op == Q_IF_EXPRESSION ) 
            	printf("!= 0"); 
            else if (op == Q_IF_NOT_EXPRESSION)  
            	printf("== 0"); 
	        printf("%s", arg2.c_str());
	        PRINT();
	        printf("\tgoto ");
	        PRINT();
	        printf("%s\n",res.c_str()); 
	        PRINT();           
	    }
	    else if(Q_CHAR2INT <= op && op <= Q_DOUBLE2INT)
	    {
	        printf("%s", res.c_str());
	        printf("\t=\t");
	        PRINT();
            if(op == Q_CHAR2INT) 
            { 
            	printf(" Char2Int(");
            	PRINT();
            	printf("%s",arg1.c_str());
            	printf(")\n"); 
            }
            else if(op == Q_CHAR2DOUBLE) 
            {
            	printf(" Char2Double(");
            	PRINT();
            	printf("%s",arg1.c_str());
            	printf(")\n"); 
            }
            else if(op == Q_INT2CHAR) 
            {
            	printf(" Int2Char(");
            	PRINT();
            	printf("%s",arg1.c_str());
            	PRINT();
            	printf(")\n"); 
        	}
            else if(op == Q_DOUBLE2CHAR ) 
            {
            	printf(" Double2Char(");
            	PRINT();
            	printf("%s",arg1.c_str());
            	PRINT();
            	printf(")\n");
            }
            else if(op == Q_INT2DOUBLE)
            { 
            	printf(" Int2Double(");
            	PRINT();
            	printf("%s",arg1.c_str());
            	PRINT();
            	printf(")\n"); 
            }
            else if(op == Q_DOUBLE2INT)
            { 
            	printf(" Double2Int(");
            	PRINT();
            	printf("%s",arg1.c_str());
            	PRINT();
            	printf(")\n"); 
            }	
            PRINT();
	                    
	    }
	    else if(op == Q_PARAM)
	    {
	    	PRINT();
	        printf("param\t");
	        printf("%s\n",res.c_str());
	        PRINT();
	    }
	    else if(op == Q_CALL)
	    {
	    	PRINT();
	        if(!res.c_str())
					printf("call %s, %s\n", arg1.c_str(), arg2.c_str());
			else if(res.size()==0)
			{
				PRINT();
				printf("call %s, %s\n", arg1.c_str(), arg2.c_str());
			}
			else
			{
				PRINT();
				printf("%s\t=\tcall %s, %s\n", res.c_str(), arg1.c_str(), arg2.c_str());
			}	    
	    }
	    else if(op == Q_RETURN)
	    {
	        printf("return\t");
	        PRINT();
	        printf("%s\n",res.c_str());
	        PRINT();
	    }
	    else if( op == Q_RINDEX)
	    {
	    	PRINT();
	        printf("%s\t=\t%s[%s]\n", res.c_str(), arg1.c_str(), arg2.c_str());
	        PRINT();
	    }
	    else if(op == Q_LINDEX)
	    {
	    	PRINT();
	        printf("%s[%s]\t=\t%s\n", res.c_str(), arg1.c_str(), arg2.c_str());
	        PRINT();
	    }
	    else if(op == Q_LDEREF)
	    {
	    	PRINT();
	        printf("*%s\t=\t%s\n", res.c_str(), arg1.c_str());
	    }
	    else if(op == Q_RDEREF)
	    {
	    	PRINT();
	    	printf("%s\t=\t* %s\n", res.c_str(), arg1.c_str());
	    }
	    else if(op == Q_ADDR)
	    {
	    	PRINT();
	    	printf("%s\t=\t& %s\n", res.c_str(), arg1.c_str());
	    }
	}
}

void typecheck(exp *e1, exp *e2, bool isAssign)
{
	types type1, type2;
	PRINT();
	if(e1->type == NULL)
	{
		PRINT();
		e1->type = CopyType((*e2).type);
	}
	else if((*e2).type == NULL)
	{
		PRINT();
		(*e2).type = CopyType(e1->type);
	}
	PRINT();
	type1 = ((*e1).type)->basetp;
	PRINT();
	type2 = ((*e2).type)->basetp;
	PRINT();
	if(type1 == type2)
	{
		PRINT();
		return;
	}
	if(!isAssign)
	{
		if(type1 > type2)
		{
			PRINT();
			symbolData *temp = (*curr_st).gentemp((*e1).type);
			PRINT();
			if(type1 == tp_int && type2 == tp_char)
				glob_quad.emit(Q_CHAR2INT, (*e2).loc->name, (*temp).name);
			else if(type1 == tp_double && type2 == tp_int)
				glob_quad.emit(Q_INT2DOUBLE,(*e2).loc->name, (*temp).name);
			(*e2).loc = temp;
			PRINT();
			(*e2).type = (*temp).tp_n;
			PRINT();
		}
		else
		{
			PRINT();
			symbolData *temp = (*curr_st).gentemp((*e2).type);
			PRINT();
			if(type2 == tp_int && type1 == tp_char)
				glob_quad.emit(Q_CHAR2INT, e1->loc->name, (*temp).name);
			else if(type2 == tp_double && type1 == tp_int)
				glob_quad.emit(Q_INT2DOUBLE, e1->loc->name, (*temp).name);	
			PRINT();
			e1->loc = temp;
			PRINT();
			e1->type = (*temp).tp_n;
		}		
	}
	else
	{
		PRINT();
		symbolData *temp = (*curr_st).gentemp(e1->type);
		if(type1 == tp_int && type2 == tp_double)
			glob_quad.emit(Q_DOUBLE2INT, (*e2).loc->name, (*temp).name);
		else if(type1 == tp_double && type2 == tp_int)
			glob_quad.emit(Q_INT2DOUBLE, (*e2).loc->name, (*temp).name);
		else if(type1 == tp_char && type2 == tp_int)
			glob_quad.emit(Q_INT2CHAR, (*e2).loc->name, (*temp).name);
		else if(type1 == tp_int && type2 == tp_char)
			glob_quad.emit(Q_CHAR2INT, (*e2).loc->name, (*temp).name);
		else
		{
			PRINT();
			printf("%s %s Types compatibility not defined\n",e1->loc->name.c_str(),(*e2).loc->name.c_str());
			PRINT();
			exit(-1);
		}
		(*e2).loc = temp;
		PRINT();
		(*e2).type = (*temp).tp_n;
		PRINT();
	}
}

void backpatch(list *l,int i)
{
	list *temp = l;
	PRINT();
	list *temp2;
	PRINT();
	char S[10];
	PRINT();
	sprintf(S, "%d", i);
	PRINT();
	while(temp != NULL)
	{
		PRINT();
		glob_quad.arr[(*temp).index].result = S;
		PRINT();
		temp2 = temp;
		PRINT();
		temp = (*temp).next;
		PRINT();
		free(temp2);
	}
}

void conv2Bool(exp *e)
{
	if(((*e).type)->basetp != tp_bool)
	{
		((*e).type) = new type_n(tp_bool);
		PRINT();
		(*e).falselist = makelist(next_instr);
		PRINT();
		glob_quad.emit(Q_IF_EQUAL, (*e).loc->name, "0", "-1");
		PRINT();
		(*e).truelist = makelist(next_instr);
		PRINT();
		glob_quad.emit(Q_GOTO, -1);
		PRINT();
	}
}

void print_list(list *root)
{
	int flag = 0;
	PRINT();
	while(root != NULL)
	{
		printf("%d ", root->index);
		PRINT();
		flag = 1;
		PRINT();
		root = root->next;
	}
	if(flag == 0)
	{
		PRINT();
		printf("Empty List\n");
	}
	else
	{
		PRINT();
		printf("\n");
	}
}

int main()
{
	instr_count = 0;
	check = 0;

	symbolData *temp_printi = new symbolData("printInt");
	(*temp_printi).tp_n = new type_n(tp_int);
	(*temp_printi).var_type = "func";
	(*temp_printi).nest_tab = glob_st;
	(*glob_st).symbol_table.push_back(temp_printi);
	
	symbolData *temp_readi = new symbolData("readInt");
	temp_readi->tp_n = new type_n(tp_int);
	temp_readi->var_type = "func";
	temp_readi->nest_tab = glob_st;
	(*glob_st).symbol_table.push_back(temp_readi);
	
	symbolData *temp_prints = new symbolData("printStr");
	(*temp_prints).tp_n = new type_n(tp_int);
	(*temp_prints).var_type = "func";
	(*temp_prints).nest_tab = glob_st;
	(*glob_st).symbol_table.push_back(temp_prints);

	yyparse();

	(*glob_st).name = "Global";
	printf("_________________________________________________________________________________");
	printf("\nGenerated Quads for the program\n");
	glob_quad.print();
	printf("_________________________________________________________________________________\n");
	printf("Symbol table for the Program\n");
	(*glob_st).print();
	set<string> S;
	S.insert("Global");
	printf("_________________________________________________________________________________\n");

	FILE *fp;
	fp = fopen("output.s", "w");
	fprintf(fp,"\t.file\t\"output.s\"\n");

	for (int i = 0; i < strings_label.size(); ++i)
	{
		fprintf(fp,"\n.STR%d:\t.string %s",i,strings_label[i].c_str());	
	}

	set<string> OTHER;
	(*glob_st).mark_labels();
	(*glob_st).global_variables(fp);
	OTHER.insert("Global");

	int C = 0;
	for (int i = 0; i < (*glob_st).symbol_table.size(); ++i)
	{
		if((((*glob_st).symbol_table[i])->nest_tab) != NULL)
		{
			if(OTHER.find((((*glob_st).symbol_table[i])->nest_tab)->name) == OTHER.end())
			{
				(*glob_st).symbol_table[i]->nest_tab->assign_offset();
				(*glob_st).symbol_table[i]->nest_tab->print();
				(*glob_st).symbol_table[i]->nest_tab->function_prologue(fp, C);
				(*glob_st).symbol_table[i]->nest_tab->function_restore(fp);
				(*glob_st).symbol_table[i]->nest_tab->gen_internal_code(fp, C);
				OTHER.insert((((*glob_st).symbol_table[i])->nest_tab)->name);
				(*glob_st).symbol_table[i]->nest_tab->function_epilogue(fp, C, C);
				C++;
			}
		}
	}

	fprintf(fp, "\n");

	return 0;
}
