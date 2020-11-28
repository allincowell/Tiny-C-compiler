// Reversing digits of a non -ve integer
int main()
{
    int n;
    printStr("_____________ Reversing digits of a non -ve integer ______________\n");
    printStr("Enter a non -ve integer: ");
    
    int err = 1;
    n = readInt(&err);

    int ans = 0;
    while(n > 0) {
        ans = ans * 10 + n % 10;
        n = n / 10;
    }

    printStr("Reversed integer is: ");
    printInt(ans);
    printStr("\n");
    printStr("\n_______________________________________________\n");
    
    return 0;
}