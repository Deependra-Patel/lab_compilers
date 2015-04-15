
void f(){
	 pushi(ebp); // Setting dynamic link
	 move(esp,ebp); // Setting dynamic link
}


void main(){
	 pushi(ebp); // Setting dynamic link
	 move(esp,ebp); // Setting dynamic link
	 move(0, eax);
	 move(-52, ebx);
	 addi(ebp,ebx);
	 storei(eax, ind(ebx));
	 move(2, ebx);
	 move(-44, eax);
	 addi(ebp,eax);
	 storei(ebx, ind(eax));
	 move(1, eax);
	 move(-48, ebx);
	 addi(ebp,ebx);
	 storei(eax, ind(ebx));
	 loadi(ind(ebp, -44), ebx);
	 loadi(ind(ebp, -44), eax);
	 addi(ebx, eax);
	 move(-44, ebx);
	 addi(ebp,ebx);
	 storei(eax, ind(ebx));
	 loadi(ind(ebp, -48), ebx);
	 move(1, eax);
	 addi(ebx, eax);
	 move(-48, ebx);
	 addi(ebp,ebx);
	 storei(eax, ind(ebx));
	 loadi(ind(ebp, -44), ebx);
	 move(-52, eax);
	 addi(ebp,eax);
	 storei(ebx, ind(eax));
	 move(0, eax);
	 move(-52, ebx);
	 addi(ebp,ebx);
	 storei(eax, ind(ebx));
	 move(2, ebx);
	 move(-44, eax);
	 addi(ebp,eax);
	 storei(ebx, ind(eax));
	 move(1, eax);
	 move(-48, ebx);
	 addi(ebp,ebx);
	 storei(eax, ind(ebx));
l43:
	 loadi(ind(ebp, -48), ebx);
	 move(10, eax);
	 cmpi(ebx, eax);
	 jl(l49);
	 j(l63);
l49:
	 loadi(ind(ebp, -44), eax);
	 loadi(ind(ebp, -44), ebx);
	 addi(eax, ebx);
	 move(-44, eax);
	 addi(ebp,eax);
	 storei(ebx, ind(eax));
	 loadi(ind(ebp, -48), eax);
	 move(1, ebx);
	 addi(eax, ebx);
	 move(-48, eax);
	 addi(ebp,eax);
	 storei(ebx, ind(eax));
	 j(l43);
l63:
	 loadi(ind(ebp, -44), eax);
	 move(-52, ebx);
	 addi(ebp,ebx);
	 storei(eax, ind(ebx));
	 print_int(eax);
	 print_char('\n');
	 print_int(ebx);
	 print_char('\n');
	 print_int(ecx);
	 print_char('\n');
	 print_int(edx);
	 print_char('\n');
}

