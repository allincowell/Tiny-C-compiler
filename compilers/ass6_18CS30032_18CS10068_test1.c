// Product of three integers
int main()
{
    int a, b, c, prod;
    printStr("_____________ Product of 3 integers _____________\n");

    int err = 1;

    printStr("Enter the 1st integer: ");
    a = readInt(&err);
    printStr("Enter the 2nd integer: ");
    b = readInt(&err);
    printStr("Enter the 3rd integer: ");
    c = readInt(&err);

    prod = a * b * c;

    printStr("Product is ");
    printInt(prod);
    printStr("\n");
    printStr("\n__________________________\n");
    return 0;

}