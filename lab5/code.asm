
void fact(){
    pushi(ebp); // Setting dynamic link
    move(esp,ebp); // Setting dynamic link
    addi(-4, esp);
    pushi(edx);
    pushi(ecx);
    pushi(ebx);
    pushi(eax);
    loadi(ind(ebp, 4), eax);
    move(0, ebx);
    cmpi(eax, ebx);
    jne(l21);
l12:
    move(5, ebx);
    move(4, eax);
    addi(ebp,eax);
    storei(ebx, ind(eax));
    move(1, eax);
    storei(eax, ind(ebp, 8));
    j(retfact);
    j(l40);
l21:
    pushi(1); //return
    loadi(ind(ebp, 4), eax);
    move(1, ebx);
    muli(-1, ebx);
    addi(eax, ebx);
    pushi(ebx);
    fact();
    popi(1);
    loadi(ind(esp), ebx);
    popi(1);
    move(-4, eax);
    addi(ebp,eax);
    storei(ebx, ind(eax));
    loadi(ind(ebp, -4), eax);
    loadi(ind(ebp, 4), ebx);
    muli(eax, ebx);
    storei(ebx, ind(ebp, 8));
    j(retfact);
l40:
retfact:
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


void fib(){
    pushi(ebp); // Setting dynamic link
    move(esp,ebp); // Setting dynamic link
    addi(0, esp);
    pushi(edx);
    pushi(ecx);
    pushi(ebx);
    pushi(eax);
    loadi(ind(ebp, 4), ebx);
    move(2, eax);
    cmpi(ebx, eax);
    jge(l17);
l12:
    loadi(ind(ebp, 4), eax);
    storei(eax, ind(ebp, 8));
    j(retfib);
    j(l41);
l17:
    pushi(1); //return
    loadi(ind(ebp, 4), eax);
    move(1, ebx);
    muli(-1, ebx);
    addi(eax, ebx);
    pushi(ebx);
    fib();
    popi(1);
    loadi(ind(esp), ebx);
    popi(1);
    pushi(1); //return
    loadi(ind(ebp, 4), eax);
    move(2, ecx);
    muli(-1, ecx);
    addi(eax, ecx);
    pushi(ecx);
    fib();
    popi(1);
    loadi(ind(esp), ecx);
    popi(1);
    addi(ebx, ecx);
    storei(ecx, ind(ebp, 8));
    j(retfib);
l41:
retfib:
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
    move(9, ecx);
    move(-4, ebx);
    addi(ebp,ebx);
    storei(ecx, ind(ebx));
    loadi(ind(ebp, -4), ebx);
    move(10, ecx);
    cmpi(ebx, ecx);
    jle(l21);
l16:
    loadi(ind(ebp, -4), ecx);
    move(10, ebx);
    cmpi(ecx, ebx);
    jl(l27);
l21:
    move(1, ebx);
    move(-4, ecx);
    addi(ebp,ecx);
    storei(ebx, ind(ecx));
    j(l32);
l27:
    move(2, ecx);
    move(-4, ebx);
    addi(ebp,ebx);
    storei(ecx, ind(ebx));
l32:
    loadi(ind(ebp, -4), ebx);
    cout << "printing a: ";
    print_int(ebx);
    cout << endl;
    move(3, ebx);
    j(retmain);
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

