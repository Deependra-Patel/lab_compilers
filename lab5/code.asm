
void f(){
	 pushi(ebp); // Setting dynamic link
	 move(esp,ebp); // Setting dynamic link
}


void main(){
	 pushi(ebp); // Setting dynamic link
	 move(esp,ebp); // Setting dynamic link
	 move(2, eax);
	 move(-48, ebx);
	 addi(ebp,ebx);
	 storei(eax, ind(ebx));
	 move(3, ebx);
	 move(-52, eax);
	 addi(ebp,eax);
	 storei(ebx, ind(eax));
	 move(2, eax);
	 move(-44, ebx);
	 addi(ebp,ebx);
	 storei(eax, ind(ebx));
	 move(3, ebx);
	 move(-40, eax);
	 addi(ebp,eax);
	 move(2, ecx);
	 muli(4, ecx); 
	 addi(eax, ecx); 
	 storei(ebx, ind(ecx));
	 move(5, ecx);
	 move(-40, ebx);
	 addi(ebp,ebx);
	 move(6, eax);
	 muli(4, eax); 
	 addi(ebx, eax); 
	 storei(ecx, ind(eax));
	 loadi(ind(ebp, -48), eax);
	 loadi(ind(ebp, -52), ecx);
	 muli(eax, ecx);
	 loadi(ind(ebp, -48), eax);
	 loadi(ind(ebp, -52), ebx);
	 muli(eax, ebx);
	 addi(ecx, ebx);
	 loadi(ind(ebp, -48), ecx);
	 loadi(ind(ebp, -52), eax);
	 muli(ecx, eax);
	 loadi(ind(ebp, -48), ecx);
	 pushi(ecx);    // pushing temporary storage
	 loadi(ind(ebp, -52), ecx);
	 loadi(ind(esp), edx);    // loading temporary storage
	 muli(edx, ecx);
	 popi(1);
	 addi(eax, ecx);
	 addi(ebx, ecx);
	 loadi(ind(ebp, -48), ebx);
	 loadi(ind(ebp, -52), eax);
	 muli(ebx, eax);
	 loadi(ind(ebp, -48), ebx);
	 pushi(ebx);    // pushing temporary storage
	 loadi(ind(ebp, -52), ebx);
	 loadi(ind(esp), edx);    // loading temporary storage
	 muli(edx, ebx);
	 popi(1);
	 addi(eax, ebx);
	 addi(ecx, ebx);
	 move(-40, ecx);
	 addi(ebp,ecx);
	 move(0, eax);
	 muli(4, eax); 
	 addi(ecx, eax); 
	 storei(ebx, ind(eax));
	 print_int(eax);
	 print_char('\n');
	 print_int(ebx);
	 print_char('\n');
	 print_int(ecx);
	 print_char('\n');
	 print_int(edx);
	 print_char('\n');
}

