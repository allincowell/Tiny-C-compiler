// Factorial Calculation
int fact(int n) 
{ 
  int i, dp[80];
  dp[0] = 1;
  for(i = 1; i <= n; i++) {
    dp[i] = dp[i - 1] * i;
  } 
  return dp[n];
} 
  
int main () 
{ 
  int n, ans; 
  printStr("_____________  Factorial Calculation _____________\n");

  int err = 1;

  printStr("Enter the value of n: ");
  n = readInt(&err);

  ans = fact(n);
  printStr("Factorial of n is: ");
  printInt(ans);

  printStr("\n_________________________\n");
  return 0; 
} 

