%{
    #include "ass6_18CS30032_18CS10068_translator.h"
    void yyerror(const char*);
    extern int yylex(void);
    using namespace std;
%}

%union
{
    int intval;         // value of integer constant
    char charval;       // value of character constant
    idStr idl;          // type for Identifier
    float floatval;     // value of floating constant
    string *strval;     // value of enummeration constant
    decStr decl;        // declarators
    arglistStr argsl;   // argumnets list
    int instr;          // type used by M->(epsilon)
    exp expon;          // structure of expression
    list *nextlist;     // nextlist type for N->(epsilon)
}

%token AUTO BREAK CASE CHAR CONST CONTINUE DEFAULT DO DOUBLE ELSE ENUM EXTERN FLOAT FOR GOTO IF INLINE INT LONG REGISTER RESTRICT RETURN SHORT SIGNED SIZEOF STATIC STRUCT SWITCH TYPEDEF UNION UNSIGNED VOID VOLATILE WHILE _BOOL _COMPLEX _IMAGINARY 
%token POINTER INCREMENT DECREMENT LEFT_SHIFT RIGHT_SHIFT LESS_EQUALS GREATER_EQUALS EQUALS NOT_EQUALS
%token AND OR ELLIPSIS MULTIPLY_ASSIGN DIVIDE_ASSIGN MODULO_ASSIGN ADD_ASSIGN SUBTRACT_ASSIGN
%token LEFT_SHIFT_ASSIGN RIGHT_SHIFT_ASSIGN AND_ASSIGN XOR_ASSIGN OR_ASSIGN SINGLE_LINE_COMMENT MULTI_LINE_COMMENT
%token <idl> IDENTIFIER  
%token <intval> INTEGER_CONSTANT
%token <floatval> FLOATING_CONSTANT
%token <strval> ENUMERATION_CONSTANT
%token <charval> CHAR_CONST
%token <strval> STRING_LITERAL
%type <expon> primary_expression postfix_expression unary_expression cast_expression multiplicative_expression additive_expression shift_expression relational_expression equality_expression AND_expression exclusive_OR_expression inclusive_OR_expression logical_AND_expression logical_OR_expression conditional_expression assignment_expression_opt assignment_expression constant_expression expression expression_statement expression_opt declarator direct_declarator initializer identifier_opt declaration init_declarator_list init_declarator_list_opt init_declarator
%type <nextlist> block_item_list block_item statement labeled_statement compound_statement selection_statement iteration_statement jump_statement block_item_list_opt
%type <argsl> argument_expression_list argument_expression_list_opt
%type <decl> type_specifier declaration_specifiers specifier_qualifier_list type_name pointer pointer_opt
%type <instr>       M
%type <nextlist>    N
%type <charval>     unary_operator

%start translation_unit

%left '+' '-'
%left '*' '/' '%'
%nonassoc UNARY
%nonassoc IF_CONFLICT
%nonassoc ELSE

%%
N:
{
    $$ = makelist(next_instr);
    glob_quad.emit(Q_GOTO, -1);
};

M:
{
    $$ = next_instr;
};

additive_expression :           multiplicative_expression {
                                                                $$ = $1;
                                                          }|
                                additive_expression '+' multiplicative_expression {
                                                                                        typecheck(&$1, &$3);
                                                                                        update_nextinstr();
                                                                                        $$.loc = curr_st->gentemp($1.type);
                                                                                        update_nextinstr();
                                                                                        $$.type = $$.loc->tp_n;
                                                                                        update_nextinstr();
                                                                                        glob_quad.emit(Q_PLUS, $1.loc->name, $3.loc->name, $$.loc->name);
                                                                                        update_nextinstr();
                                                                                  }|
                                additive_expression '-' multiplicative_expression {
                                                                                        typecheck(&$1, &$3);
                                                                                        update_nextinstr();
                                                                                        $$.loc = curr_st->gentemp($1.type);
                                                                                        update_nextinstr();
                                                                                        $$.type = $$.loc->tp_n;
                                                                                        update_nextinstr();
                                                                                        glob_quad.emit(Q_MINUS, $1.loc->name, $3.loc->name, $$.loc->name);
                                                                                        update_nextinstr();
                                                                                  };

multiplicative_expression:      cast_expression {
                                                    $$ = $1;
                                                }|
                                multiplicative_expression '*' cast_expression {
                                                                                    typecheck(&$1, &$3);
                                                                                    update_nextinstr();
                                                                                    $$.loc = curr_st->gentemp($1.type);
                                                                                    update_nextinstr();
                                                                                    $$.type = $$.loc->tp_n;
                                                                                    update_nextinstr();
                                                                                    glob_quad.emit(Q_MULT, $1.loc->name, $3.loc->name, $$.loc->name);
                                                                                    update_nextinstr();
                                                                              }|
                                multiplicative_expression '/' cast_expression {
                                                                                    typecheck(&$1, &$3);
                                                                                    update_nextinstr();
                                                                                    $$.loc = curr_st->gentemp($1.type);
                                                                                    update_nextinstr();
                                                                                    $$.type = $$.loc->tp_n;
                                                                                    update_nextinstr();
                                                                                    glob_quad.emit(Q_DIVIDE, $1.loc->name, $3.loc->name, $$.loc->name);
                                                                                    update_nextinstr();
                                                                              }|
                                multiplicative_expression '%' cast_expression{
                                                                                    typecheck(&$1, &$3);
                                                                                    update_nextinstr();
                                                                                    $$.loc = curr_st->gentemp($1.type);
                                                                                    update_nextinstr();
                                                                                    $$.type = $$.loc->tp_n;
                                                                                    update_nextinstr();
                                                                                    glob_quad.emit(Q_MODULO, $1.loc->name, $3.loc->name, $$.loc->name);
                                                                                    update_nextinstr();
                                                                             };

relational_expression:          shift_expression {
                                                        $$ = $1;
                                                 }|
                                relational_expression '<' shift_expression {
                                                                                typecheck(&$1, &$3);
                                                                                update_nextinstr();
                                                                                $$.type = new type_n(tp_bool);
                                                                                update_nextinstr();
                                                                                $$.truelist = makelist(next_instr);
                                                                                update_nextinstr();
                                                                                $$.falselist = makelist(next_instr + 1);
                                                                                update_nextinstr();
                                                                                glob_quad.emit(Q_IF_LESS, $1.loc->name, $3.loc->name, "-1");
                                                                                update_nextinstr();
                                                                                glob_quad.emit(Q_GOTO, "-1");
                                                                                update_nextinstr();
                                                                           }|
                                relational_expression LESS_EQUALS shift_expression {
                                                                                        typecheck(&$1, &$3);
                                                                                        update_nextinstr();
                                                                                        $$.type = new type_n(tp_bool);
                                                                                        update_nextinstr();
                                                                                        $$.truelist = makelist(next_instr);
                                                                                        update_nextinstr();
                                                                                        $$.falselist = makelist(next_instr + 1);
                                                                                        update_nextinstr();
                                                                                        glob_quad.emit(Q_IF_LESS_OR_EQUAL, $1.loc->name, $3.loc->name, "-1");
                                                                                        update_nextinstr();
                                                                                        glob_quad.emit(Q_GOTO, "-1");
                                                                                        update_nextinstr();
                                                                                    }|
                                relational_expression '>' shift_expression {
                                                                                typecheck(&$1, &$3);
                                                                                update_nextinstr();
                                                                                $$.type = new type_n(tp_bool);
                                                                                update_nextinstr();
                                                                                $$.truelist = makelist(next_instr);
                                                                                update_nextinstr();
                                                                                $$.falselist = makelist(next_instr + 1);
                                                                                update_nextinstr();
                                                                                glob_quad.emit(Q_IF_GREATER, $1.loc->name, $3.loc->name, "-1");
                                                                                update_nextinstr();
                                                                                glob_quad.emit(Q_GOTO, "-1");
                                                                                update_nextinstr();
                                                                           }|
                                
                                relational_expression GREATER_EQUALS shift_expression {
                                                                                            typecheck(&$1, &$3);
                                                                                            update_nextinstr();
                                                                                            $$.type = new type_n(tp_bool);
                                                                                            update_nextinstr();
                                                                                            $$.truelist = makelist(next_instr);
                                                                                            update_nextinstr();
                                                                                            $$.falselist = makelist(next_instr + 1);
                                                                                            update_nextinstr();
                                                                                            glob_quad.emit(Q_IF_GREATER_OR_EQUAL, $1.loc->name, $3.loc->name, "-1");
                                                                                            update_nextinstr();
                                                                                            glob_quad.emit(Q_GOTO, "-1");
                                                                                            update_nextinstr();
                                                                                      };

shift_expression:               additive_expression {
                                                        $$ = $1;
                                                    }|
                                shift_expression LEFT_SHIFT additive_expression {
                                                                                    $$.loc = curr_st->gentemp($1.type);
                                                                                    update_nextinstr();
                                                                                    $$.type = $$.loc->tp_n;
                                                                                    update_nextinstr();
                                                                                    glob_quad.emit(Q_LEFT_OP, $1.loc->name, $3.loc->name, $$.loc->name);
                                                                                    update_nextinstr();
                                                                                }|
                                shift_expression RIGHT_SHIFT additive_expression{
                                                                                    $$.loc = curr_st->gentemp($1.type);
                                                                                    update_nextinstr();
                                                                                    $$.type = $$.loc->tp_n;
                                                                                    update_nextinstr();
                                                                                    glob_quad.emit(Q_RIGHT_OP, $1.loc->name, $3.loc->name, $$.loc->name);
                                                                                    update_nextinstr();
                                                                                };

exclusive_OR_expression:        AND_expression {
                                                    $$ = $1;
                                               }|
                                exclusive_OR_expression '^' AND_expression {
                                                                                $$.loc = curr_st->gentemp($1.type);
                                                                                update_nextinstr();
                                                                                $$.type = $$.loc->tp_n;
                                                                                update_nextinstr();
                                                                                glob_quad.emit(Q_XOR,$1.loc->name,$3.loc->name,$$.loc->name);
                                                                                update_nextinstr();
                                                                           };

equality_expression:            relational_expression {
                                                            $$ = $1;
                                                      }|
                                equality_expression EQUALS relational_expression {
                                                                                        typecheck(&$1, &$3);
                                                                                        update_nextinstr();
                                                                                        $$.type = new type_n(tp_bool);
                                                                                        update_nextinstr();
                                                                                        $$.truelist = makelist(next_instr);
                                                                                        update_nextinstr();
                                                                                        $$.falselist = makelist(next_instr + 1);
                                                                                        update_nextinstr();
                                                                                        glob_quad.emit(Q_IF_EQUAL, $1.loc->name, $3.loc->name, "-1");
                                                                                        update_nextinstr();
                                                                                        glob_quad.emit(Q_GOTO, "-1");
                                                                                        update_nextinstr();
                                                                                 }|
                                equality_expression NOT_EQUALS relational_expression {
                                                                                            typecheck(&$1, &$3);
                                                                                            update_nextinstr();
                                                                                            $$.type = new type_n(tp_bool);
                                                                                            update_nextinstr();
                                                                                            $$.truelist = makelist(next_instr);
                                                                                            update_nextinstr();
                                                                                            $$.falselist = makelist(next_instr + 1);
                                                                                            update_nextinstr();
                                                                                            glob_quad.emit(Q_IF_NOT_EQUAL, $1.loc->name, $3.loc->name, "-1");
                                                                                            update_nextinstr();
                                                                                            glob_quad.emit(Q_GOTO, "-1");
                                                                                            update_nextinstr();
                                                                                     };

AND_expression :                equality_expression {
                                                        $$ = $1;
                                                    }|
                                AND_expression '&' equality_expression {
                                                                            $$.loc = curr_st->gentemp($1.type);
                                                                            update_nextinstr();
                                                                            $$.type = $$.loc->tp_n;
                                                                            update_nextinstr();
                                                                            glob_quad.emit(Q_LOG_AND, $1.loc->name, $3.loc->name, $$.loc->name);
                                                                            update_nextinstr();
                                                                        };

inclusive_OR_expression:        exclusive_OR_expression {
                                                            $$ = $1;
                                                        }|
                                inclusive_OR_expression '|' exclusive_OR_expression {
                                                                                        $$.loc = curr_st->gentemp($1.type);
                                                                                        update_nextinstr();
                                                                                        $$.type = $$.loc->tp_n;
                                                                                        update_nextinstr();
                                                                                        glob_quad.emit(Q_LOG_OR, $1.loc->name, $3.loc->name, $$.loc->name);
                                                                                        update_nextinstr();
                                                                                    };

logical_OR_expression:          logical_AND_expression {
                                                            $$ = $1;
                                                       }|
                                logical_OR_expression OR M logical_AND_expression   {
                                                                                        if($1.type->basetp != tp_bool)
                                                                                            conv2Bool(&$1);
                                                                                        if($4.type->basetp != tp_bool)
                                                                                            conv2Bool(&$4); 
                                                                                        update_nextinstr();
                                                                                        backpatch($1.falselist,$3);
                                                                                        update_nextinstr();
                                                                                        $$.type = new type_n(tp_bool);
                                                                                        update_nextinstr();
                                                                                        $$.truelist = merge($1.truelist, $4.truelist);
                                                                                        update_nextinstr();
                                                                                        $$.falselist = $4.falselist;
                                                                                        update_nextinstr();
                                                                                    };

logical_AND_expression:         inclusive_OR_expression {
                                                            $$ = $1;
                                                        }|
                                logical_AND_expression AND M inclusive_OR_expression {
                                                                                        if($1.type->basetp != tp_bool)
                                                                                            conv2Bool(&$1);
                                                                                        if($4.type->basetp != tp_bool)
                                                                                            conv2Bool(&$4);
                                                                                        update_nextinstr();
                                                                                        backpatch($1.truelist,$3);
                                                                                        update_nextinstr();
                                                                                        $$.type = new type_n(tp_bool);
                                                                                        update_nextinstr();
                                                                                        $$.falselist = merge($1.falselist, $4.falselist);
                                                                                        update_nextinstr();
                                                                                        $$.truelist = $4.truelist;
                                                                                        update_nextinstr();
                                                                                    };

conditional_expression:         logical_OR_expression {
                                                            $$ = $1;
                                                      }|
                                logical_OR_expression N '?' M expression N ':' M conditional_expression {
                                                                                                            $$.loc = curr_st->gentemp($5.type);
                                                                                                            update_nextinstr();
                                                                                                            $$.type = $$.loc->tp_n;
                                                                                                            update_nextinstr();
                                                                                                            glob_quad.emit(Q_ASSIGN, $9.loc->name, $$.loc->name);
                                                                                                            update_nextinstr();
                                                                                                            list* TEMP_LIST = makelist(next_instr);
                                                                                                            update_nextinstr();
                                                                                                            glob_quad.emit(Q_GOTO, "-1");
                                                                                                            update_nextinstr();
                                                                                                            backpatch($6, next_instr);
                                                                                                            update_nextinstr();
                                                                                                            glob_quad.emit(Q_ASSIGN, $5.loc->name, $$.loc->name);
                                                                                                            update_nextinstr();
                                                                                                            TEMP_LIST = merge(TEMP_LIST, makelist(next_instr));
                                                                                                            update_nextinstr();
                                                                                                            glob_quad.emit(Q_GOTO, "-1");
                                                                                                            update_nextinstr();
                                                                                                            backpatch($2, next_instr);
                                                                                                            update_nextinstr();
                                                                                                            conv2Bool(&$1);
                                                                                                            update_nextinstr();
                                                                                                            backpatch($1.truelist, $4);
                                                                                                            update_nextinstr();
                                                                                                            backpatch($1.falselist, $8);
                                                                                                            update_nextinstr();
                                                                                                            backpatch(TEMP_LIST, next_instr);
                                                                                                            update_nextinstr();
                                                                                                        };

assignment_expression:          conditional_expression  {
                                                            $$ = $1;
                                                        }|
                                unary_expression assignment_operator assignment_expression {
                                                                                                if($1.isPointer)
                                                                                                {
                                                                                                    glob_quad.emit(Q_LDEREF, $3.loc->name, $1.loc->name);
                                                                                                    update_nextinstr();
                                                                                                }
                                                                                                typecheck(&$1,&$3,true);
                                                                                                update_nextinstr();
                                                                                                if($1.arr != NULL)
                                                                                                {
                                                                                                    glob_quad.emit(Q_LINDEX,$1.loc->name, $3.loc->name, $1.arr->name);
                                                                                                    update_nextinstr();
                                                                                                }
                                                                                                else if(!$1.isPointer)
                                                                                                    glob_quad.emit(Q_ASSIGN, $3.loc->name, $1.loc->name);
                                                                                                update_nextinstr();
                                                                                                $$.loc = curr_st->gentemp($3.type);
                                                                                                update_nextinstr();
                                                                                                $$.type = $$.loc->tp_n;
                                                                                                update_nextinstr();
                                                                                                glob_quad.emit(Q_ASSIGN, $3.loc->name, $$.loc->name);
                                                                                                update_nextinstr();
                                                                                            };

expression :                    assignment_expression {
                                                            $$ = $1;
                                                            update_nextinstr();
                                                      }|
                                expression ',' assignment_expression {
                                                                        $$ = $3;
                                                                        update_nextinstr();
                                                                     };


primary_expression:             IDENTIFIER {
                                                symbolData * check_func = glob_st->find(*$1.name);
                                                update_nextinstr();
                                                if(check_func == NULL)
                                                {
                                                    $$.loc  =  curr_st->lookup_global(*$1.name);
                                                    update_nextinstr();
                                                    if($$.loc->tp_n != NULL && $$.loc->tp_n->basetp == tp_arr)
                                                    {
                                                        $$.arr = $$.loc;
                                                        update_nextinstr();
                                                        $$.loc = curr_st->gentemp(new type_n(tp_int));
                                                        update_nextinstr();
                                                        $$.loc->i_val.int_val = 0;
                                                        update_nextinstr();
                                                        $$.loc->isInitialized = true;
                                                        update_nextinstr();
                                                        glob_quad.emit(Q_ASSIGN, 0, $$.loc->name);
                                                        update_nextinstr();
                                                        $$.type = $$.arr->tp_n;
                                                        update_nextinstr();
                                                        $$.poss_Array = $$.arr;
                                                        update_nextinstr();
                                                    }
                                                    else
                                                    {
                                                        $$.type = $$.loc->tp_n;
                                                        update_nextinstr();
                                                        $$.arr = NULL;
                                                        update_nextinstr();
                                                        $$.isPointer = false;
                                                        update_nextinstr();
                                                    }
                                                }
                                                else
                                                {
                                                    $$.loc = check_func;
                                                    update_nextinstr();
                                                    $$.type = check_func->tp_n;
                                                    update_nextinstr();
                                                    $$.arr = NULL;
                                                    update_nextinstr();
                                                    $$.isPointer = false;
                                                    update_nextinstr();
                                                }
                                            } |
                                FLOATING_CONSTANT {
                                                    $$.loc  = curr_st->gentemp(new type_n(tp_double));
                                                    update_nextinstr();
                                                    $$.type = $$.loc->tp_n;
                                                    update_nextinstr();
                                                    $$.loc->i_val.double_val = $1;
                                                    update_nextinstr();
                                                    $$.loc->isInitialized = true;
                                                    update_nextinstr();
                                                    $$.arr = NULL;
                                                    update_nextinstr();
                                                    glob_quad.emit(Q_ASSIGN, $1, $$.loc->name);
                                                    update_nextinstr();
                                                  } |
                                INTEGER_CONSTANT {
                                                    $$.loc  = curr_st->gentemp(new type_n(tp_int));
                                                    update_nextinstr();
                                                    $$.type = $$.loc->tp_n;
                                                    update_nextinstr();
                                                    $$.loc->i_val.int_val = $1;
                                                    update_nextinstr();
                                                    $$.loc->isInitialized = true;
                                                    update_nextinstr();
                                                    $$.arr = NULL;
                                                    update_nextinstr();
                                                    glob_quad.emit(Q_ASSIGN, $1, $$.loc->name);
                                                    update_nextinstr();
                                                } |
                                STRING_LITERAL {
                                                    
                                                    strings_label.push_back(*$1);
                                                    update_nextinstr();
                                                    $$.loc = NULL;
                                                    update_nextinstr();
                                                    $$.isString = true;
                                                    update_nextinstr();
                                                    $$.ind_str = strings_label.size()-1;
                                                    update_nextinstr();
                                                    $$.arr = NULL;
                                                    update_nextinstr();
                                                    $$.isPointer = false;
                                                    update_nextinstr();
                                                } |
                                CHAR_CONST {
                                                $$.loc  = curr_st->gentemp(new type_n(tp_char));
                                                update_nextinstr();
                                                $$.type = $$.loc->tp_n;
                                                update_nextinstr();
                                                $$.loc->i_val.char_val = $1;
                                                update_nextinstr();
                                                $$.loc->isInitialized = true;
                                                update_nextinstr();
                                                $$.arr = NULL;
                                                update_nextinstr();
                                                glob_quad.emit(Q_ASSIGN, $1, $$.loc->name);
                                                update_nextinstr();
                                            } |
                                '(' expression ')' {
                                                        $$ = $2;
                                                   };

enumeration_constant:           IDENTIFIER {};

postfix_expression :            primary_expression {
                                                         $$ = $1;
                                                    }|
                                postfix_expression '(' argument_expression_list_opt ')' {
                                                                                            if(!$1.isPointer && !$1.isString && ($1.type) && ($1.type->basetp == tp_void))
                                                                                            {
                                                                                                update_nextinstr();     
                                                                                            }
                                                                                            else
                                                                                                $$.loc = curr_st->gentemp(CopyType($1.type));
                                                                                            char str[10];
                                                                                            update_nextinstr();
                                                                                            if($3.arguments == NULL)
                                                                                            {
                                                                                                sprintf(str,"0");
                                                                                                update_nextinstr();
                                                                                                if($1.type->basetp != tp_void)
                                                                                                    glob_quad.emit(Q_CALL, $1.loc->name, str, $$.loc->name);
                                                                                                else
                                                                                                    glob_quad.emit2(Q_CALL, $1.loc->name, str);
                                                                                                update_nextinstr();
                                                                                            }
                                                                                            else
                                                                                            {
                                                                                                if((*$3.arguments)[0]->isString)
                                                                                                {
                                                                                                    str[0] = '_';
                                                                                                    update_nextinstr();
                                                                                                    sprintf(str + 1, "%d", (*$3.arguments)[0]->ind_str);
                                                                                                    update_nextinstr();
                                                                                                    glob_quad.emit(Q_PARAM,str);
                                                                                                    update_nextinstr();
                                                                                                    glob_quad.emit(Q_CALL, $1.loc->name, "1", $$.loc->name);
                                                                                                    update_nextinstr();
                                                                                                }
                                                                                                else
                                                                                                {
                                                                                                    for(int i = 0; i < $3.arguments->size(); i++)
                                                                                                    {
                                                                                                        if((*$3.arguments)[i]->poss_Array != NULL && $1.loc->name != "printInt")
                                                                                                            glob_quad.emit(Q_PARAM,(*$3.arguments)[i]->poss_Array->name);
                                                                                                        else
                                                                                                            glob_quad.emit(Q_PARAM,(*$3.arguments)[i]->loc->name);
                                                                        
                                                                                                    }
                                                                                                    update_nextinstr();
                                                                                                    sprintf(str, "%ld", $3.arguments->size());
                                                                                                    update_nextinstr();
                                                                                                    if($1.type->basetp != tp_void)
                                                                                                        glob_quad.emit(Q_CALL, $1.loc->name, str, $$.loc->name);
                                                                                                    else
                                                                                                        glob_quad.emit2(Q_CALL ,$1.loc->name, str);
                                                                                                    update_nextinstr();
                                                                                                }
                                                                                            }

                                                                                            $$.arr = NULL;
                                                                                            update_nextinstr();
                                                                                            $$.type = $$.loc->tp_n;
                                                                                            update_nextinstr();
                                                                                         } |

                                postfix_expression '[' expression ']' {
                                                                        $$.loc = curr_st->gentemp(new type_n(tp_int));
                                                                        update_nextinstr();
                                                                        
                                                                        symbolData* temporary = curr_st->gentemp(new type_n(tp_int));
                                                                        update_nextinstr();
                                                                        
                                                                        char temp[10];
                                                                        update_nextinstr();
                                                                        sprintf(temp,"%d",$1.type->next->getSize());
                                                                        update_nextinstr();
                                                                        
                                                                        glob_quad.emit(Q_MULT,$3.loc->name,temp,temporary->name);
                                                                        update_nextinstr();
                                                                        glob_quad.emit(Q_PLUS,$1.loc->name,temporary->name,$$.loc->name);
                                                                        update_nextinstr();
                                                                        
                                                                        $$.arr = $1.arr;
                                                                        update_nextinstr();
                                                                        
                                                                        $$.type = $1.type->next;
                                                                        update_nextinstr();
                                                                        $$.poss_Array = NULL;
                                                                        update_nextinstr();
                                                                     } |
                                
                                postfix_expression '.' IDENTIFIER {/* To be Skipped*/}|
                                postfix_expression POINTER IDENTIFIER {
                                                                      }|
                                postfix_expression DECREMENT {
                                                                $$.loc = curr_st->gentemp(CopyType($1.type));
                                                                update_nextinstr();
                                                                if($1.arr != NULL)
                                                                {
                                                                    symbolData* temp_elem = curr_st->gentemp(CopyType($1.type));
                                                                    update_nextinstr();
                                                                    glob_quad.emit(Q_RINDEX, $1.arr->name, $1.loc->name, $$.loc->name);
                                                                    update_nextinstr();
                                                                    glob_quad.emit(Q_RINDEX, $1.arr->name, $1.loc->name, temp_elem->name);
                                                                    update_nextinstr();
                                                                    glob_quad.emit(Q_MINUS, temp_elem->name, "1", temp_elem->name);
                                                                    update_nextinstr();
                                                                    glob_quad.emit(Q_LINDEX, $1.loc->name, temp_elem->name, $1.arr->name);
                                                                    update_nextinstr();
                                                                    $$.arr = NULL;
                                                                    update_nextinstr();
                                                                }
                                                                else
                                                                {
                                                                    glob_quad.emit(Q_ASSIGN, $1.loc->name, $$.loc->name);
                                                                    update_nextinstr();
                                                                    glob_quad.emit(Q_MINUS, $1.loc->name, "1", $1.loc->name);
                                                                    update_nextinstr();
                                                                }
                                                                $$.type = $$.loc->tp_n;
                                                                update_nextinstr();
                                                              } |
                                postfix_expression INCREMENT {
                                                                $$.loc = curr_st->gentemp(CopyType($1.type));
                                                                update_nextinstr();
                                                                if($1.arr != NULL)
                                                                {
                                                                    symbolData * temp_elem = curr_st->gentemp(CopyType($1.type));
                                                                    update_nextinstr();
                                                                    glob_quad.emit(Q_RINDEX,$1.arr->name, $1.loc->name, $$.loc->name);
                                                                    update_nextinstr();
                                                                    glob_quad.emit(Q_RINDEX, $1.arr->name, $1.loc->name, temp_elem->name);
                                                                    update_nextinstr();
                                                                    glob_quad.emit(Q_PLUS, temp_elem->name, "1", temp_elem->name);
                                                                    update_nextinstr();
                                                                    glob_quad.emit(Q_LINDEX, $1.loc->name, temp_elem->name, $1.arr->name);
                                                                    update_nextinstr();
                                                                    $$.arr = NULL;
                                                                    update_nextinstr();
                                                                }
                                                                else
                                                                {
                                                                    glob_quad.emit(Q_ASSIGN, $1.loc->name, $$.loc->name);
                                                                    update_nextinstr();
                                                                    glob_quad.emit(Q_PLUS, $1.loc->name, "1", $1.loc->name); 
                                                                    update_nextinstr();   
                                                                }
                                                                $$.type = $$.loc->tp_n;                  
                                                                update_nextinstr();               
                                                             } |
                                '(' type_name ')' '{' initializer_list '}' {
                                                                           }|
                                '(' type_name ')' '{' initializer_list ',' '}' {
                                                                               };

argument_expression_list_opt:   argument_expression_list {
                                                            $$ = $1;
                                                            update_nextinstr();
                                                          }|
                                            {
                                                $$.arguments = NULL;
                                                update_nextinstr();
                                            };

argument_expression_list:       assignment_expression {
                                                        $$.arguments = new vector<exp*>;
                                                        update_nextinstr();
                                                        exp * tex = new exp($1);
                                                        update_nextinstr();
                                                        $$.arguments->push_back(tex);
                                                        update_nextinstr();
                                                        update_nextinstr();
                                                     }|
                                argument_expression_list ',' assignment_expression {
                                                                                        exp* tex = new exp($3);
                                                                                        update_nextinstr();
                                                                                        $$.arguments->push_back(tex);
                                                                                        update_nextinstr();
                                                                                    };

cast_expression :               unary_expression {
                                                    if($1.arr != NULL && $1.arr->tp_n != NULL && $1.poss_Array == NULL)
                                                    {
                                                        $$.loc = curr_st->gentemp(new type_n($1.type->basetp));
                                                        update_nextinstr();
                                                        glob_quad.emit(Q_RINDEX, $1.arr->name, $1.loc->name, $$.loc->name);
                                                        update_nextinstr();
                                                        $$.arr = NULL;
                                                        update_nextinstr();
                                                        $$.type = $$.loc->tp_n;
                                                        update_nextinstr();
                                                        update_nextinstr();
                                                    }
                                                    else if($1.isPointer == true)
                                                    {
                                                        $$.loc = curr_st->gentemp(CopyType($1.type));
                                                        update_nextinstr();
                                                        $$.isPointer = false;
                                                        update_nextinstr();
                                                        glob_quad.emit(Q_RDEREF,$1.loc->name,$$.loc->name);
                                                        update_nextinstr();
                                                    }
                                                    else
                                                        $$ = $1;
                                                }|
                                '(' type_name ')' cast_expression{
                                                                 };


unary_expression:               postfix_expression {
                                                        $$ = $1;
                                                        update_nextinstr();
                                                   }|

                                DECREMENT unary_expression {
                                                                $$.loc = curr_st->gentemp(CopyType($2.type));
                                                                update_nextinstr();
                                                                if($2.arr != NULL)
                                                                {
                                                                    symbolData * temp_elem = curr_st->gentemp(CopyType($2.type));
                                                                    update_nextinstr();
                                                                    glob_quad.emit(Q_RINDEX, $2.arr->name, $2.loc->name, temp_elem->name);
                                                                    update_nextinstr();
                                                                    glob_quad.emit(Q_MINUS, temp_elem->name, "1", temp_elem->name);
                                                                    update_nextinstr();
                                                                    glob_quad.emit(Q_LINDEX, $2.loc->name, temp_elem->name, $2.arr->name);
                                                                    update_nextinstr();
                                                                    glob_quad.emit(Q_RINDEX, $2.arr->name, $2.loc->name, $$.loc->name);
                                                                    update_nextinstr();
                                                                    $$.arr = NULL;
                                                                    update_nextinstr();
                                                                }
                                                                else
                                                                {
                                                                    glob_quad.emit(Q_MINUS, $2.loc->name,"1", $2.loc->name);
                                                                    update_nextinstr();
                                                                    glob_quad.emit(Q_ASSIGN, $2.loc->name, $$.loc->name);
                                                                    update_nextinstr();
                                                                }
                                                                $$.type = $$.loc->tp_n;
                                                                update_nextinstr();
                                                            }|

                                INCREMENT unary_expression {
                                                                $$.loc = curr_st->gentemp($2.type);
                                                                update_nextinstr();
                                                                if($2.arr != NULL)
                                                                {
                                                                    symbolData * temp_elem = curr_st->gentemp(CopyType($2.type));
                                                                    update_nextinstr();
                                                                    glob_quad.emit(Q_RINDEX,$2.arr->name,$2.loc->name,temp_elem->name);
                                                                    update_nextinstr();
                                                                    glob_quad.emit(Q_PLUS,temp_elem->name,"1",temp_elem->name);
                                                                    update_nextinstr();
                                                                    glob_quad.emit(Q_LINDEX,$2.loc->name,temp_elem->name,$2.arr->name);
                                                                    update_nextinstr();
                                                                    glob_quad.emit(Q_RINDEX,$2.arr->name,$2.loc->name,$$.loc->name);
                                                                    update_nextinstr();
                                                                    $$.arr = NULL;
                                                                    update_nextinstr();
                                                                }
                                                                else
                                                                {
                                                                    glob_quad.emit(Q_PLUS, $2.loc->name, "1", $2.loc->name);
                                                                    update_nextinstr();
                                                                    glob_quad.emit(Q_ASSIGN, $2.loc->name, $$.loc->name);
                                                                    update_nextinstr();
                                                                }
                                                                $$.type = $$.loc->tp_n;
                                                                update_nextinstr();
                                                            }|
                                
                                unary_operator cast_expression
                                                                {
                                                                    type_n* temp_type;
                                                                    update_nextinstr();
                                                                    switch($1)
                                                                    {
                                                                        case '&':
                                                                            temp_type = new type_n(tp_ptr,1,$2.type);
                                                                            update_nextinstr();
                                                                            $$.loc = curr_st->gentemp(CopyType(temp_type));
                                                                            update_nextinstr();
                                                                            $$.type = $$.loc->tp_n;
                                                                            update_nextinstr();
                                                                            glob_quad.emit(Q_ADDR, $2.loc->name, $$.loc->name);
                                                                            update_nextinstr();
                                                                            $$.arr = NULL;
                                                                            update_nextinstr();
                                                                            break;
                                                                        case '*':
                                                                            $$.isPointer = true;
                                                                            update_nextinstr();
                                                                            $$.type = $2.loc->tp_n->next;
                                                                            update_nextinstr();
                                                                            $$.loc = $2.loc;
                                                                            update_nextinstr();
                                                                            $$.arr = NULL;
                                                                            update_nextinstr();
                                                                            break;
                                                                        case '+':
                                                                            $$.loc = curr_st->gentemp(CopyType($2.type));
                                                                            update_nextinstr();
                                                                            $$.type = $$.loc->tp_n;
                                                                            update_nextinstr();
                                                                            glob_quad.emit(Q_ASSIGN, $2.loc->name, $$.loc->name);
                                                                            update_nextinstr();
                                                                            break;
                                                                        case '-':
                                                                            $$.loc = curr_st->gentemp(CopyType($2.type));
                                                                            update_nextinstr();
                                                                            $$.type = $$.loc->tp_n;
                                                                            update_nextinstr();
                                                                            glob_quad.emit(Q_UNARY_MINUS, $2.loc->name, $$.loc->name);
                                                                            update_nextinstr();
                                                                            break;
                                                                        case '~':
                                                                            $$.loc = curr_st->gentemp(CopyType($2.type));
                                                                            update_nextinstr();
                                                                            $$.type = $$.loc->tp_n;
                                                                            update_nextinstr();
                                                                            glob_quad.emit(Q_NOT, $2.loc->name, $$.loc->name);
                                                                            update_nextinstr();
                                                                            break;
                                                                        case '!':
                                                                            $$.loc = curr_st->gentemp(CopyType($2.type));
                                                                            update_nextinstr();
                                                                            $$.type = $$.loc->tp_n;
                                                                            update_nextinstr();
                                                                            $$.truelist = $2.falselist;
                                                                            update_nextinstr();
                                                                            $$.falselist = $2.truelist;
                                                                            update_nextinstr();
                                                                            break;
                                                                        default:
                                                                            update_nextinstr();
                                                                            break;
                                                                    }
                                                                }|
                                SIZEOF unary_expression {}|
                                SIZEOF '(' type_name ')' {};

unary_operator  :               '&' {
                                        $$ = '&';
                                    }|
                                '*' {
                                        $$ = '*';
                                    }|
                                '+' {
                                        $$ = '+';
                                    }|
                                '-' {
                                        $$ = '-';
                                    }|
                                '~' {
                                        $$ = '~';
                                    }|
                                '!' {
                                        $$ = '!';
                                    };

function_definition:    declaration_specifiers declarator declaration_list_opt compound_statement {
                                                                                                    symbolData * func = glob_st->lookup($2.loc->name);
                                                                                                    update_nextinstr();
                                                                                                    func->nest_tab->symbol_table[0]->tp_n = CopyType(func->tp_n);
                                                                                                    update_nextinstr();
                                                                                                    func->nest_tab->symbol_table[0]->name = "retVal";
                                                                                                    update_nextinstr();
                                                                                                    func->nest_tab->symbol_table[0]->offset = 0;
                                                                                                    update_nextinstr();
                                                                                                    if(func->nest_tab->symbol_table[0]->tp_n->basetp == tp_ptr)
                                                                                                    {
                                                                                                        int diff = size_pointer - func->nest_tab->symbol_table[0]->size;
                                                                                                        update_nextinstr();
                                                                                                        func->nest_tab->symbol_table[0]->size = size_pointer;
                                                                                                        update_nextinstr();
                                                                                                        for(int i = 1; i < func->nest_tab->symbol_table.size(); i++)
                                                                                                        {
                                                                                                            func->nest_tab->symbol_table[i]->offset += diff;
                                                                                                            update_nextinstr();
                                                                                                        }
                                                                                                    }
                                                                                                    int offset_size = 0;
                                                                                                    update_nextinstr();
                                                                                                    for(int i = 0; i < func->nest_tab->symbol_table.size(); i++)
                                                                                                    {
                                                                                                        offset_size += func->nest_tab->symbol_table[i]->size;
                                                                                                        update_nextinstr();
                                                                                                    }
                                                                                                    func->nest_tab->end_quad = next_instr - 1;
                                                                                                    update_nextinstr();
                                                                                                    curr_st = new symtab();
                                                                                                    update_nextinstr();
                                                                                                };

assignment_operator:            '='                                                     |
                                MULTIPLY_ASSIGN                                         |
                                DIVIDE_ASSIGN                                           |
                                MODULO_ASSIGN                                           |
                                ADD_ASSIGN                                              |
                                SUBTRACT_ASSIGN                                         |
                                LEFT_SHIFT_ASSIGN                                       |
                                RIGHT_SHIFT_ASSIGN                                      |
                                AND_ASSIGN                                              |
                                XOR_ASSIGN                                              |
                                OR_ASSIGN                                               ;

constant_expression:            conditional_expression {
                                                            $$ = $1;
                                                            update_nextinstr();
                                                       };

init_declarator_list_opt:       init_declarator_list {
                                                        if($1.type != NULL && $1.type->basetp == tp_func)
                                                        {
                                                            $$ = $1;
                                                            update_nextinstr();
                                                        }
                                                     }|
                                            {
                                                $$.loc = NULL;
                                                update_nextinstr();
                                            };

declaration:                    declaration_specifiers init_declarator_list_opt ';' {
                                                                                        if($2.loc != NULL && $2.type != NULL && $2.type->basetp == tp_func)
                                                                                        {
                                                                                            curr_st = new symtab();
                                                                                            update_nextinstr();
                                                                                        }
                                                                                    };

declaration_specifiers:         storage_class_specifier declaration_specifiers_opt {}|
                                type_qualifier declaration_specifiers_opt {}         |
                                type_specifier declaration_specifiers_opt            |
                                function_specifier declaration_specifiers_opt {};

type_specifier:                 VOID {
                                        glob_type = new type_n(tp_void);
                                        update_nextinstr();
                                    }|
                                INT {
                                        glob_type = new type_n(tp_int);
                                        update_nextinstr();
                                    }|
                                CHAR {
                                        glob_type = new type_n(tp_char);
                                        update_nextinstr();
                                    }|
                                SHORT {}|
                                FLOAT {}|
                                LONG {}|
                                DOUBLE {
                                            glob_type = new type_n(tp_double);
                                            update_nextinstr();
                                        }|
                                UNSIGNED {}|
                                SIGNED {}|
                                _IMAGINARY {}|
                                _BOOL {}|
                                _COMPLEX {}|
                                enum_specifier {};


declaration_specifiers_opt:     declaration_specifiers                                  |
                                                                                        ;

init_declarator_list:           init_declarator {
                                                    $$ = $1;
                                                    update_nextinstr();
                                                }|
                                init_declarator_list ',' init_declarator                ;

storage_class_specifier:        EXTERN {}|
                                AUTO {}  |
                                STATIC {}|
                                REGISTER {};


init_declarator:                declarator {
                                                if($1.type != NULL && $1.type->basetp == tp_func)
                                                {
                                                    $$ = $1;
                                                    update_nextinstr();
                                                }
                                            }|
                                declarator '=' initializer {
                                                                if($3.type!=NULL)
                                                                {
                                                                    if($3.type->basetp == tp_int)
                                                                    {
                                                                        $1.loc->i_val.int_val = $3.loc->i_val.int_val;
                                                                        update_nextinstr();
                                                                        $1.loc->isInitialized = true;
                                                                        update_nextinstr();
                                                                        symbolData *temp_ver = curr_st->find($1.loc->name);
                                                                        update_nextinstr();
                                                                        if(temp_ver != NULL)
                                                                        {
                                                                            temp_ver->i_val.int_val= $3.loc->i_val.int_val;
                                                                            update_nextinstr();
                                                                            temp_ver->isInitialized = true;
                                                                            update_nextinstr();
                                                                        }
                                                                    }
                                                                    else if($3.type->basetp == tp_char)
                                                                    {
                                                                        $1.loc->i_val.char_val= $3.loc->i_val.char_val;
                                                                        update_nextinstr();
                                                                        $1.loc->isInitialized = true;
                                                                        update_nextinstr();
                                                                        symbolData *temp_ver = curr_st->find($1.loc->name);
                                                                        update_nextinstr();
                                                                        if(temp_ver != NULL)
                                                                        {
                                                                            temp_ver->i_val.char_val = $3.loc->i_val.char_val;
                                                                            update_nextinstr();
                                                                            temp_ver->isInitialized = true;
                                                                            update_nextinstr();
                                                                        }
                                                                    }
                                                                }
                                                                glob_quad.emit(Q_ASSIGN,$3.loc->name, $1.loc->name);
                                                                update_nextinstr();
                                                            };

enumerator_list:                enumerator {}|
                                enumerator_list ',' enumerator {};

specifier_qualifier_list:       type_specifier specifier_qualifier_list_opt {
                                                                            }|
                                type_qualifier specifier_qualifier_list_opt {}; 

enumerator:                     enumeration_constant {}|
                                enumeration_constant '=' constant_expression {};

specifier_qualifier_list_opt:   specifier_qualifier_list {}|
                                                         {};

enum_specifier:                 ENUM identifier_opt '{' enumerator_list '}' {}|
                                ENUM identifier_opt '{' enumerator_list ',' '}' {}|
                                ENUM IDENTIFIER {};

identifier_opt:                 IDENTIFIER {
                                                $$.loc  = curr_st->lookup(*$1.name);
                                                update_nextinstr();
                                                update_nextinstr();
                                                $$.type = new type_n(glob_type->basetp);
                                                update_nextinstr();
                                            }|
                                            {};

function_specifier:             INLINE {};

pointer_opt:                    pointer {
                                            $$ = $1;
                                            update_nextinstr();
                                        }|
                                        {
                                            $$.type = NULL;
                                            update_nextinstr();
                                        };


type_qualifier:                 CONST {}|
                                RESTRICT {}|
                                VOLATILE {};

expression_statement:           expression_opt ';'{
                                                        $$ = $1;
                                                        update_nextinstr();
                                                  };

selection_statement:            IF '(' expression N ')' M statement N ELSE M statement {
                                                                                            $7 = merge($7,$8);
                                                                                            update_nextinstr();
                                                                                            $11 = merge($11,makelist(next_instr));
                                                                                            update_nextinstr();
                                                                                            glob_quad.emit(Q_GOTO,"-1");
                                                                                            update_nextinstr();
                                                                                            backpatch($4,next_instr);
                                                                                            update_nextinstr();

                                                                                            conv2Bool(&$3);
                                                                                            update_nextinstr();

                                                                                            backpatch($3.truelist,$6);
                                                                                            update_nextinstr();
                                                                                            backpatch($3.falselist,$10);
                                                                                            update_nextinstr();
                                                                                            $$ = merge($7,$11);
                                                                                            update_nextinstr();
                                                                                        }|
                                IF '(' expression N ')' M statement %prec IF_CONFLICT{
                                                                        $7 = merge($7,makelist(next_instr));
                                                                        update_nextinstr();
                                                                        glob_quad.emit(Q_GOTO, "-1");
                                                                        update_nextinstr();
                                                                        backpatch($4,next_instr);
                                                                        update_nextinstr();
                                                                        conv2Bool(&$3);
                                                                        update_nextinstr();
                                                                        backpatch($3.truelist,$6);
                                                                        update_nextinstr();
                                                                        $$ = merge($7,$3.falselist);
                                                                        update_nextinstr();
                                                                    }|
                                SWITCH '(' expression ')' statement {};

jump_statement:                 GOTO IDENTIFIER ';' {}|
                                CONTINUE ';' {}|
                                BREAK ';' {}|
                                RETURN expression_opt ';' {
                                                                if($2.loc == NULL)
                                                                    glob_quad.emit(Q_RETURN);
                                                                else
                                                                {
                                                                    exp * dummy = new exp();
                                                                    update_nextinstr();
                                                                    dummy->loc = curr_st->symbol_table[0];
                                                                    update_nextinstr();
                                                                    dummy->type = dummy->loc->tp_n;
                                                                    update_nextinstr();
                                                                    typecheck(dummy, &$2,true);
                                                                    update_nextinstr();
                                                                    delete dummy;
                                                                    update_nextinstr();
                                                                    glob_quad.emit(Q_RETURN, $2.loc->name);
                                                                    update_nextinstr();
                                                                }
                                                                $$ = NULL;
                                                                update_nextinstr();
                                                          };

iteration_statement:            WHILE '(' M expression N ')' M statement {
                                                                            glob_quad.emit(Q_GOTO,$3);
                                                                            update_nextinstr();
                                                                            backpatch($8,$3);
                                                                            backpatch($5,next_instr);
                                                                            conv2Bool(&$4);
                                                                            update_nextinstr();
                                                                            backpatch($4.truelist,$7);
                                                                            update_nextinstr();
                                                                            $$ = $4.falselist;
                                                                            update_nextinstr();
                                                                        }|
                                FOR '(' expression_opt ';' M expression_opt N ';' M expression_opt N ')' M statement {
                                                                                                                        backpatch($11,$5);
                                                                                                                        update_nextinstr();
                                                                                                                        backpatch($14,$9);
                                                                                                                        update_nextinstr();
                                                                                                                        glob_quad.emit(Q_GOTO,$9);
                                                                                                                        update_nextinstr();
                                                                                                                        backpatch($7, next_instr);
                                                                                                                        update_nextinstr();
                                                                                                                        conv2Bool(&$6);
                                                                                                                        update_nextinstr();
                                                                                                                        backpatch($6.truelist, $13);
                                                                                                                        update_nextinstr();
                                                                                                                        $$ = $6.falselist;
                                                                                                                        update_nextinstr();
                                                                                                                    }|
                                DO M statement  WHILE '(' M expression N ')' ';' {  
                                                                                    backpatch($8,next_instr);
                                                                                    update_nextinstr();
                                                                                    backpatch($3,$6);
                                                                                    update_nextinstr();
                                                                                    conv2Bool(&$7);
                                                                                    update_nextinstr();
                                                                                    backpatch($7.truelist,$2);
                                                                                    update_nextinstr();
                                                                                    $$ = $7.falselist;
                                                                                    update_nextinstr();
                                                                                }|
                                FOR '(' declaration expression_opt ';' expression_opt ')' statement {};

translation_unit:               external_declaration                                    |
                                translation_unit external_declaration                   ;

external_declaration:           function_definition                                     |
                                declaration      {

                                                                                        for(int i = 0;i < curr_st->symbol_table.size(); i++)
                                                                                        {
                                                                                            if(curr_st->symbol_table[i]->nest_tab == NULL)
                                                                                                {
                                                                                                    if(curr_st->symbol_table[i]->var_type == "local" || curr_st->symbol_table[i]->var_type == "temp")
                                                                                                    {
                                                                                                        symbolData *glob_var = glob_st->find(curr_st->symbol_table[i]->name);
                                                                                                        update_nextinstr();
                                                                                                        if(glob_var == NULL)
                                                                                                        {
                                                                                                            glob_var = glob_st->lookup(curr_st->symbol_table[i]->name);
                                                                                                            update_nextinstr();
                                                                                                            update_nextinstr();
                                                                                                            int t_size = curr_st->symbol_table[i]->tp_n->getSize();
                                                                                                            update_nextinstr();
                                                                                                            glob_var->offset = glob_st->offset;
                                                                                                            update_nextinstr();
                                                                                                            glob_var->size = t_size;
                                                                                                            update_nextinstr();
                                                                                                            glob_st->offset += t_size;
                                                                                                            update_nextinstr();
                                                                                                            glob_var->nest_tab = glob_st;
                                                                                                            update_nextinstr();
                                                                                                            glob_var->var_type = curr_st->symbol_table[i]->var_type;
                                                                                                            update_nextinstr();
                                                                                                            glob_var->tp_n = curr_st->symbol_table[i]->tp_n;
                                                                                                            update_nextinstr();
                                                                                                            if(curr_st->symbol_table[i]->isInitialized)
                                                                                                            {
                                                                                                                glob_var->isInitialized = curr_st->symbol_table[i]->isInitialized;
                                                                                                                update_nextinstr();
                                                                                                                glob_var->i_val = curr_st->symbol_table[i]->i_val;
                                                                                                                update_nextinstr();
                                                                                                            }
                                                                                                        }
                                                                                                    }
                                                                                                }
                                                                                        }
                                                                                        
                                                    };


declarator :                    pointer_opt direct_declarator {
                                                                if($1.type == NULL)
                                                                {
                                                                    update_nextinstr();
                                                                }
                                                                else
                                                                {
                                                                    if($2.loc->tp_n->basetp != tp_ptr)
                                                                    {
                                                                        type_n * test = $1.type;
                                                                        update_nextinstr();
                                                                        while(test->next != NULL)
                                                                        {
                                                                            test = test->next;
                                                                            update_nextinstr();
                                                                        }
                                                                        test->next = $2.loc->tp_n;
                                                                        update_nextinstr();
                                                                        $2.loc->tp_n = $1.type;
                                                                        update_nextinstr();
                                                                    }
                                                                }

                                                                if($2.type != NULL && $2.type->basetp == tp_func)
                                                                {
                                                                    $$ = $2;
                                                                    update_nextinstr();
                                                                }
                                                                else
                                                                {
                                                                    $2.loc->size = $2.loc->tp_n->getSize();
                                                                    update_nextinstr();
                                                                    $2.loc->offset = curr_st->offset;
                                                                    update_nextinstr();
                                                                    curr_st->offset += $2.loc->size;
                                                                    update_nextinstr();
                                                                    $$ = $2;
                                                                    update_nextinstr();
                                                                    $$.type = $$.loc->tp_n;
                                                                    update_nextinstr();
                                                                }
                                                            };

direct_declarator:              IDENTIFIER {
                                                    $$.loc = curr_st->lookup(*$1.name);
                                                    update_nextinstr();
                                                    if($$.loc->var_type == "")
                                                    {
                                                        $$.loc->var_type = "local";
                                                        update_nextinstr();
                                                        $$.loc->tp_n = new type_n(glob_type->basetp);
                                                        update_nextinstr();
                                                    }
                                                    $$.type = $$.loc->tp_n;
                                                    update_nextinstr();
                                            }|
                                direct_declarator '[' type_qualifier_list_opt assignment_expression_opt ']' {
                                                                                                                if($1.type->basetp == tp_arr)
                                                                                                                {
                                                                                                                    type_n * typ1 = $1.type,*typ = $1.type;
                                                                                                                    update_nextinstr();
                                                                                                                    typ1 = typ1->next;
                                                                                                                    update_nextinstr();
                                                                                                                    while(typ1->next != NULL)
                                                                                                                    {
                                                                                                                        typ1 = typ1->next;
                                                                                                                        update_nextinstr();
                                                                                                                        typ = typ->next;
                                                                                                                        update_nextinstr();
                                                                                                                    }
                                                                                                                    typ->next = new type_n(tp_arr,$4.loc->i_val.int_val,typ1);
                                                                                                                    update_nextinstr();
                                                                                                                }
                                                                                                                else
                                                                                                                {
                                                                                                                    if($4.loc == NULL)
                                                                                                                        $1.type = new type_n(tp_arr, -1, $1.type);
                                                                                                                    else
                                                                                                                        $1.type = new type_n(tp_arr, $4.loc->i_val.int_val, $1.type);
                                                                                                                    update_nextinstr();
                                                                                                                }
                                                                                                                $$ = $1;
                                                                                                                update_nextinstr();
                                                                                                                $$.loc->tp_n = $$.type;
                                                                                                                update_nextinstr();
                                                                                                            }|
                                direct_declarator '[' STATIC type_qualifier_list_opt assignment_expression ']' {}|
                                direct_declarator '[' type_qualifier_list STATIC assignment_expression ']' {}|
                                direct_declarator '[' type_qualifier_list_opt '*' ']' {/* We don't have to implement this*/}|
                                direct_declarator '(' parameter_type_list ')' {
                                                                                   int params_no = curr_st->no_params;
                                                                                    update_nextinstr();
                                                                                    update_nextinstr();
                                                                                   curr_st->no_params = 0;
                                                                                    update_nextinstr();
                                                                                   int dec_params = 0;
                                                                                    update_nextinstr();
                                                                                   int over_params = params_no;
                                                                                    update_nextinstr();
                                                                                   for(int i = curr_st->symbol_table.size() - 1; i >= 0; i--)
                                                                                   {
                                                                                        update_nextinstr();
                                                                                    }
                                                                                   for(int i = curr_st->symbol_table.size() - 1; i >= 0; i--)
                                                                                   {
                                                                                        string detect=curr_st->symbol_table[i]->name;
                                                                                        update_nextinstr();
                                                                                        if(over_params == 0)
                                                                                        {
                                                                                            break;
                                                                                            update_nextinstr();
                                                                                        }
                                                                                        if(detect.size() == 4)
                                                                                        {
                                                                                            if(detect[0] == 't')
                                                                                            {
                                                                                                if('0' <= detect[1]&&detect[1] <= '9')
                                                                                                {
                                                                                                    if('0' <= detect[2] && detect[2] <= '9')
                                                                                                    {
                                                                                                        if('0' <= detect[3] && detect[3] <= '9')
                                                                                                            dec_params++;
                                                                                                        update_nextinstr();
                                                                                                    }
                                                                                                    update_nextinstr();
                                                                                                }
                                                                                                update_nextinstr();
                                                                                            }
                                                                                            update_nextinstr();
                                                                                        }
                                                                                        else
                                                                                            over_params--;
                                                                                        update_nextinstr();

                                                                                   }
                                                                                   params_no += dec_params;
                                                                                    update_nextinstr();
                                                                                   int temp_i = curr_st->symbol_table.size() - params_no;
                                                                                    update_nextinstr();
                                                                                   symbolData * new_func = glob_st->find(curr_st->symbol_table[temp_i - 1]->name);
                                                                                    update_nextinstr();
                                                                                    if(new_func == NULL)
                                                                                    {
                                                                                        new_func = glob_st->lookup(curr_st->symbol_table[temp_i - 1]->name);
                                                                                        update_nextinstr();
                                                                                        $$.loc = curr_st->symbol_table[temp_i - 1];
                                                                                        update_nextinstr();
                                                                                        for(int i = 0; i < (temp_i - 1);i++)
                                                                                        {
                                                                                            curr_st->symbol_table[i]->ispresent = false;
                                                                                            update_nextinstr();
                                                                                            if(curr_st->symbol_table[i]->var_type == "local" || curr_st->symbol_table[i]->var_type == "temp")
                                                                                            {
                                                                                                symbolData *glob_var = glob_st->find(curr_st->symbol_table[i]->name);
                                                                                                update_nextinstr();
                                                                                                if(glob_var == NULL)
                                                                                                {
                                                                                                    update_nextinstr();
                                                                                                    glob_var = glob_st->lookup(curr_st->symbol_table[i]->name);
                                                                                                    update_nextinstr();
                                                                                                    int t_size = curr_st->symbol_table[i]->tp_n->getSize();
                                                                                                    update_nextinstr();
                                                                                                    glob_var->offset = glob_st->offset;
                                                                                                    update_nextinstr();
                                                                                                    glob_var->size = t_size;
                                                                                                    update_nextinstr();
                                                                                                    glob_st->offset += t_size;
                                                                                                    update_nextinstr();
                                                                                                    glob_var->nest_tab = glob_st;
                                                                                                    update_nextinstr();
                                                                                                    glob_var->var_type = curr_st->symbol_table[i]->var_type;
                                                                                                    update_nextinstr();
                                                                                                    glob_var->tp_n = curr_st->symbol_table[i]->tp_n;
                                                                                                    update_nextinstr();
                                                                                                    if(curr_st->symbol_table[i]->isInitialized)
                                                                                                    {
                                                                                                        glob_var->isInitialized = curr_st->symbol_table[i]->isInitialized;
                                                                                                        update_nextinstr();
                                                                                                        glob_var->i_val = curr_st->symbol_table[i]->i_val;
                                                                                                        update_nextinstr();
                                                                                                    }

                                                                                                }
                                                                                            }
                                                                                        }
                                                                                        if(new_func->var_type == "")
                                                                                        {
                                                                                            new_func->tp_n = CopyType(curr_st->symbol_table[temp_i - 1]->tp_n);
                                                                                            update_nextinstr();
                                                                                            new_func->var_type = "func";
                                                                                            update_nextinstr();
                                                                                            new_func->isInitialized = false;
                                                                                            update_nextinstr();
                                                                                            new_func->nest_tab = curr_st;
                                                                                            update_nextinstr();
                                                                                            curr_st->name = curr_st->symbol_table[temp_i - 1]->name;
                                                                                            update_nextinstr();
                                                                                            update_nextinstr();
                                                                                            curr_st->symbol_table[temp_i - 1]->name = "retVal";
                                                                                            update_nextinstr();
                                                                                            curr_st->symbol_table[temp_i - 1]->var_type = "return";
                                                                                            update_nextinstr();
                                                                                            curr_st->symbol_table[temp_i - 1]->size = curr_st->symbol_table[temp_i - 1]->tp_n->getSize();
                                                                                            update_nextinstr();
                                                                                            curr_st->symbol_table[temp_i - 1]->offset = 0;
                                                                                            update_nextinstr();
                                                                                            curr_st->offset = 16;
                                                                                            update_nextinstr();
                                                                                            int count = 0;
                                                                                            update_nextinstr();
                                                                                            for(int i = (curr_st->symbol_table.size()) - params_no; i < curr_st->symbol_table.size(); i++)
                                                                                            {
                                                                                                update_nextinstr();
                                                                                                curr_st->symbol_table[i]->var_type = "param";
                                                                                                update_nextinstr();
                                                                                                curr_st->symbol_table[i]->offset = count - curr_st->symbol_table[i]->size;
                                                                                                update_nextinstr();
                                                                                                count = count-curr_st->symbol_table[i]->size;
                                                                                                update_nextinstr();
                                                                                            }
                                                                                        }
                                                                                    }
                                                                                    else
                                                                                    {
                                                                                        curr_st = new_func->nest_tab;
                                                                                        update_nextinstr();
                                                                                    }
                                                                                    curr_st->start_quad = next_instr;
                                                                                    update_nextinstr();
                                                                                    $$.loc = new_func;
                                                                                    update_nextinstr();
                                                                                    $$.type = new type_n(tp_func);
                                                                                    update_nextinstr();
                                                                                }|
                                '(' declarator ')' {
                                                        $$ = $2;
                                                        update_nextinstr();
                                                    }|
                                
                                direct_declarator '(' identifier_list_opt ')' {
                                                                                int temp_i = curr_st->symbol_table.size();
                                                                                update_nextinstr();
                                                                                symbolData* new_func = glob_st->find(curr_st->symbol_table[temp_i - 1]->name);
                                                                                update_nextinstr();
                                                                                if(new_func == NULL)
                                                                                {
                                                                                    new_func = glob_st->lookup(curr_st->symbol_table[temp_i - 1]->name);
                                                                                    update_nextinstr();
                                                                                    $$.loc = curr_st->symbol_table[temp_i - 1];
                                                                                    update_nextinstr();
                                                                                    for(int i = 0; i < temp_i - 1; i++)
                                                                                    {
                                                                                        curr_st->symbol_table[i]->ispresent = false;
                                                                                        update_nextinstr();
                                                                                        if(curr_st->symbol_table[i]->var_type == "local" || curr_st->symbol_table[i]->var_type == "temp")
                                                                                        {
                                                                                            symbolData *glob_var = glob_st->find(curr_st->symbol_table[i]->name);
                                                                                            update_nextinstr();
                                                                                            if(glob_var == NULL)
                                                                                            {
                                                                                                update_nextinstr();
                                                                                                glob_var = glob_st->lookup(curr_st->symbol_table[i]->name);
                                                                                                update_nextinstr();
                                                                                                int t_size = curr_st->symbol_table[i]->tp_n->getSize();
                                                                                                update_nextinstr();
                                                                                                glob_var->offset = glob_st->offset;
                                                                                                update_nextinstr();
                                                                                                glob_var->size = t_size;
                                                                                                update_nextinstr();
                                                                                                glob_st->offset += t_size;
                                                                                                update_nextinstr();
                                                                                                glob_var->nest_tab = glob_st;
                                                                                                update_nextinstr();
                                                                                                glob_var->var_type = curr_st->symbol_table[i]->var_type;
                                                                                                update_nextinstr();
                                                                                                glob_var->tp_n = curr_st->symbol_table[i]->tp_n;
                                                                                                update_nextinstr();
                                                                                                if(curr_st->symbol_table[i]->isInitialized)
                                                                                                {
                                                                                                    glob_var->isInitialized = curr_st->symbol_table[i]->isInitialized;
                                                                                                    update_nextinstr();
                                                                                                    glob_var->i_val = curr_st->symbol_table[i]->i_val;
                                                                                                    update_nextinstr();
                                                                                                }
                                                                                            }
                                                                                        }
                                                                                    }
                                                                                    if(new_func->var_type == "")
                                                                                    {
                                                                                        new_func->tp_n = CopyType(curr_st->symbol_table[temp_i-1]->tp_n);
                                                                                        update_nextinstr();
                                                                                        new_func->var_type = "func";
                                                                                        update_nextinstr();
                                                                                        new_func->isInitialized = false;
                                                                                        update_nextinstr();
                                                                                        new_func->nest_tab = curr_st;
                                                                                        update_nextinstr();
                                                                                        curr_st->name = curr_st->symbol_table[temp_i-1]->name;
                                                                                        update_nextinstr();
                                                                                        curr_st->symbol_table[temp_i-1]->name = "retVal";
                                                                                        update_nextinstr();
                                                                                        curr_st->symbol_table[temp_i-1]->var_type = "return";
                                                                                        update_nextinstr();
                                                                                        curr_st->symbol_table[temp_i-1]->size = curr_st->symbol_table[0]->tp_n->getSize();
                                                                                        update_nextinstr();
                                                                                        curr_st->symbol_table[temp_i-1]->offset = 0;
                                                                                        update_nextinstr();
                                                                                        curr_st->offset = 16;
                                                                                        update_nextinstr();
                                                                                    }
                                                                                }
                                                                                else
                                                                                {
                                                                                    curr_st = new_func->nest_tab;
                                                                                    update_nextinstr();
                                                                                }
                                                                                curr_st->start_quad = next_instr;
                                                                                update_nextinstr();
                                                                                $$.loc = new_func;
                                                                                update_nextinstr();
                                                                                $$.type = new type_n(tp_func);
                                                                                update_nextinstr();
                                                                            };

type_qualifier_list_opt:        type_qualifier_list {}|
                                                    {};

pointer:                        '*' type_qualifier_list_opt {
                                                                $$.type = new type_n(tp_ptr);
                                                                update_nextinstr();
                                                            }|
                                '*' type_qualifier_list_opt pointer {
                                                                        $$.type = new type_n(tp_ptr, 1, $3.type);
                                                                        update_nextinstr();
                                                                    };

assignment_expression_opt:      assignment_expression {
                                                            $$ = $1;
                                                            update_nextinstr();
                                                        }|
                                            {
                                                $$.loc = NULL;
                                                update_nextinstr();
                                            };

identifier_list_opt:            identifier_list                                         |
                                                                                        ;

parameter_list:                 parameter_declaration   {
                                                            (curr_st->no_params)++;
                                                            update_nextinstr();
                                                        }|
                                parameter_list ',' parameter_declaration {
                                                                            (curr_st->no_params)++;
                                                                            update_nextinstr();
                                                                         };

type_qualifier_list:            type_qualifier {}|
                                type_qualifier_list type_qualifier {};

parameter_type_list:            parameter_list {
                                               }|
                                parameter_list ',' ELLIPSIS {};

parameter_declaration:          declaration_specifiers declarator {
                                                                      update_nextinstr();
                                                                  }|
                                declaration_specifiers {};

identifier_list :               IDENTIFIER                                              |
                                identifier_list ',' IDENTIFIER                          ;

type_name:                      specifier_qualifier_list                                ;

initializer_list:               designation_opt initializer                             |
                                initializer_list ',' designation_opt initializer        ; 

initializer:                    assignment_expression {
                                    $$ = $1;
                                }|
                                '{' initializer_list '}' {}|
                                '{' initializer_list ',' '}' {};

designation_opt:                designation                                             |

designator_list:                designator                                              |
                                designator_list designator                              ;

designator:                     '[' constant_expression ']'                             |
                                '.' IDENTIFIER {};                                                                                        ;

designation:                    designator_list '='                                     ;

compound_statement:             '{' block_item_list_opt '}' {
                                                                $$ = $2;
                                                                update_nextinstr();
                                                            };

statement:                      labeled_statement {}|
                                compound_statement {
                                                        $$ = $1;
                                                        update_nextinstr();
                                                    }|
                                expression_statement {
                                                        $$ = NULL;
                                                        update_nextinstr();
                                                    }|
                                selection_statement {
                                                        $$ = $1;
                                                        update_nextinstr();
                                                    }|
                                iteration_statement {
                                                        $$ = $1;
                                                        update_nextinstr();
                                                    }|
                                jump_statement  {
                                                    $$ = $1;
                                                    update_nextinstr();
                                                };

labeled_statement:              IDENTIFIER ':' statement {}|
                                CASE constant_expression ':' statement {}|
                                DEFAULT ':' statement {};

block_item:                     declaration {
                                                $$ = NULL;
                                                update_nextinstr();
                                            }|
                                statement {
                                                $$ = $1;
                                                update_nextinstr();
                                          };


block_item_list:                block_item {
                                                $$ = $1;
                                                update_nextinstr();
                                            }|
                                block_item_list M block_item {
                                                                    backpatch($1,$2);
                                                                    update_nextinstr();
                                                                    $$ = $3;
                                                                    update_nextinstr();
                                                             };

block_item_list_opt:            block_item_list {
                                                    $$ = $1;
                                                    update_nextinstr();
                                                }|  
                                            {
                                                $$ = NULL;
                                                update_nextinstr();
                                            };

expression_opt:                 expression {
                                                $$ = $1;
                                                update_nextinstr();
                                           }|
                                            {
                                                $$.loc = NULL;
                                                update_nextinstr();
                                            };

declaration_list:               declaration                                             |
                                declaration_list declaration                            ;


declaration_list_opt:           declaration_list                                        |
                                                                                        ;

%%
void yyerror(const char*s)
{
    printf("%s",s);
}
