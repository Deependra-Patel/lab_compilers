
void main(){
    pushi(ebp); // Setting dynamic link
    move(esp,ebp); // Setting dynamic link
    addi(-4, esp);
    pushi(edx);
    pushi(ecx);
    pushi(ebx);
    pushi(eax);
    move(1, eax);
    move(-4, ebx);
    addi(ebp,ebx);
    storei(eax, ind(ebx));
    move(1, eax);
    move(0, ebx);
    cmpi(eax, ebx);
    jne(l19);
l16:
    move(1, ebx);
    j(l21);
l19:
    move(0, ebx);
l21:
    move(-4, eax);
    addi(ebp,eax);
    storei(ebx, ind(eax));
    loadi(ind(ebp, -4), ebx);
    cout << "printing a: ";
    print_int(ebx);
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

