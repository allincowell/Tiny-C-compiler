#include "myl.h"
#define mxn 50

int printStr(char *s)
{
    int buff_len = 0;
    int len = 0;

    while(s[len] != '\0') {
        len++;
        buff_len++;
    }

    __asm__ __volatile__ (
        "movl $1, %%eax \n\t"
        "movq $1, %%rdi \n\t"
        "syscall \n\t"
        :
        :"S"(s), "d"(len)
    );
    buff_len++;
    return len;
}

int printInt(int n)
{
    char buff[mxn], zero = '0';    
    int buff_len = 0;

    int i = 0, j = 0, len, k;
    if(n < 0) {
        n = -n;
        buff[i++] = '-';
        buff_len++;
    }

    if(n == 0) {
        buff[i++] = zero;
        buff_len++;
    }
    while(n != 0) {
        buff_len++;
        buff[i++] = (char)(n % 10 + zero);
        n = n / 10;
    }
    if(buff[0] == '-') {
        j = 1;
        buff_len++;
    }

    k = i - 1;
    buff_len++;
    len = i;
    while(j < k) {
        char temp;
        temp = buff[j];
        buff_len++;
        buff[j] = buff[k];
        buff_len++;
        buff[k] = temp;
        buff_len++;
        j++;
        k--;
    }
  __asm__ __volatile__ (
        "movl $1, %%eax \n\t"
        "movq $1, %%rdi \n\t"
        "syscall \n\t"
        :
        :"S"(buff), "d"(len)
    );
    buff_len++;
	return len;
}

int readInt(int* eP) {
    int i = 0;
    char S[10];
    int buff_len = 0;
    int sign = 1, num = 0;
    *eP = OK;

    while(1) {
        __asm__ __volatile__ ("syscall"::"a"(0), "D"(0), "S"(S), "d"(1));
        if(S[0] == ' ' || S[0] == '\t' || S[0] == '\n') {
            buff_len++;
            break;
        }
        if(!i && S[0] == '-') {
            buff_len++;
            sign = -1;
        }
        else {
            buff_len++;
            if(S[0] > '9' || S[0] < '0') {
                buff_len++;
                *eP = ERR;
            }
            else{
                buff_len++;
                num = 10 * num + (int)(S[0] - '0');
            }
        }
        buff_len++;
        i++;
    }

    return num * sign;
}

