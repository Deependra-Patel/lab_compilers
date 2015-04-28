
int main()
{
    int str[5];
    int rev[5];
    int i,j;
    i=4;
    j=0;

    str[0]=1;
    str[1]=2;
    str[2]=3;
    str[3]=4;
    str[4]=5;
   
    while(i>=0)
    {
     rev[j++] = str[i];
     i = i-1;
    }
  
    printf(str[0],str[1],str[2],str[3],str[4]);
    printf(rev[0],rev[1],rev[2],rev[3],rev[4]);
  
    return 0;
}