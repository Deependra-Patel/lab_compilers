float fact(int n)
{
	if(n==0) return 1.0;
	else return n*fact(n-1);
}

void r(int a)
{
	print(a);
}
void main() {
	int i;
	int j;
	int a[5][5];
	i=0;
	while(i!=5)	
	{
		for(j=0;j<5;j++)
		{
			if((i==1 && j==3)||((i==3) && j==2))
			{
				a[i][j]=fact(i+j);
			}
			else{
				a[i][j]=fact(fact(i)/2);
			}
		}
		i=i+1;
	}
	for(i=0;i<5;i++)	
	{
		for(j=0;j<5;j++)
		{
			printf(a[i][j]," ");
		}
		r(j);
	}
}

