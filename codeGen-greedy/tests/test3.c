int isDivisible(int num, int i)
{
  int fart;
  int j;
  for(j=i; j<=num; j=j+i)
  {
    if(j==num) 
    {
      return 1;
    }
    else
    {
      fart = 1;
    }
  }
  return 0;
}

int isPrime(int num, int i)
{
  if(i==1)
  {
      return 1;
  }
  else
  { 
     if(isDivisible(num, i)==1)
     {
       return 0;
     }
     else
     {
       return isPrime(num,i-1);
     }
  }
}

int main()
{
   int num,prime;

   num = 1001;

   prime = isPrime(num,num/2);

   if(prime==1)
   {
      printf(num, " is a prime number \n");
   }
   else
   {
      printf(num, " is not a prime number \n");
   }
   return 0;
}
  