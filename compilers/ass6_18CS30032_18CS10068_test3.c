// HCF calculation
int HCF(int a, int b) 
{ 
    if(a == 0) {
        return b;
    }
    else {
        return HCF(b % a, a);
    }
}


int main()
{
    int a, b, ans;
    printStr("_______ HCF Calculation _________\n");

    int err = 1;

    printStr("Enter 1st integer: ");
    a = readInt(&err);

    printStr("Enter 2nd integer: ");
    b = readInt(&err);

    ans = HCF(a, b);
    printStr("HCF is ");
    printInt(ans);
    printStr("\n_____________\n");

    return 0;
}
