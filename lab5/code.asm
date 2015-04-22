
void f(){
    pushi(ebp); // Setting dynamic link
    move(esp,ebp); // Setting dynamic link
    addi(0, esp);
    pushi(edx);
    pushi(ecx);
    pushi(ebx);
    pushi(eax);
    move(0, eax);
    storei(eax, ind(ebp, 4));
    j(retf);
retf:
    loadi(ind(esp), eax);
    popi(1);
    loadi(ind(esp), ebx);
    popi(1);
    loadi(ind(esp), ecx);
    popi(1);
    loadi(ind(esp), edx);
    popi(1);
    popi(0);
    loadi(ind(ebp), ebp);
    popi(1);
    return;
}


void main(){
    pushi(ebp); // Setting dynamic link
    move(esp,ebp); // Setting dynamic link
    addi(-4, esp);
    pushi(edx);
    pushi(ecx);
    pushi(ebx);
    pushi(eax);
    move(0, eax);
    move(-4, ebx);
    addi(ebp,ebx);
    storei(eax, ind(ebx));
    pushi(1); //return
    f();
    popi(0);
    loadi(ind(esp), ebx);
    popi(1);
    move(0, eax);
    cmpi(ebx, eax);
    je(l26);
l20:
    move(1, eax);
    move(-4, ebx);
    addi(ebp,ebx);
    storei(eax, ind(ebx));
    j(l31);
l26:
    move(2, ebx);
    move(-4, eax);
    addi(ebp,eax);
    storei(ebx, ind(eax));
l31:
    loadi(ind(ebp, -4), eax);
    cout << "printing a: ";
    print_int(eax);
    cout << endl;
retmain:
    loadi(ind(esp), eax);
    popi(1);
    loadi(ind(esp), ebx);
    popi(1);
    loadi(ind(esp), ecx);
    popi(1);
    loadi(ind(esp), edx);
    popi(1);
    popi(1);
    loadi(ind(ebp), ebp);
    popi(1);
    return;
}

