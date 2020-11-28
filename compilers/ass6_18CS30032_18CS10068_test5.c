// Optimisation Problem

int max(int a, int b) 
{ 
	if(a > b)
		return a;
	else
		return b;
} 

int func(int p[], int n) 
{ 
	int dp[100]; 
	dp[0] = 0; 
	int i, j; 
	for(i = 1; i <= n; i++) {
		int cur = 0;   
		for(j = 0; j < i; j++) 
			cur = max(cur, p[j] + dp[i - j - 1]); 
		dp[i] = cur; 
	} 
	return dp[n]; 
} 

int main()
{
	int err = 1;

	int p[100];
	int i, n, ans;

	printStr("_________ Optimisation Problem _________\n");

    printStr("Enter the value of n: ");
    n = readInt(&err);

	printStr("Enter the elements\n"); 
    for(i = 0; i < n; i++) {
        p[i]=readInt(&err);
    }

	ans = func(p, n);

    printStr("Max profit is ");
    printInt(ans);
    printStr("\n_______________________________________________\n");

	return 0;
}