
void sum(){
    pushi(ebp); // Setting dynamic link
    move(esp,ebp); // Setting dynamic link
    addi(-4, esp);
    pushi(edx);
    pushi(ecx);
    pushi(ebx);
    pushi(eax);
    move(3, eax);
    move(4, ebx);
    muli(eax, ebx);
    move(-4, eax);
    addi(ebp,eax);
    storei(ebx, ind(eax));
    loadf(ind(ebp, 4), eax);
    loadf(ind(ebp, 8), ebx);
    addf(eax, ebx);
    storef(ebx, ind(ebp, 12));
    j(retsum);
retsum:
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


void factorial(){
    pushi(ebp); // Setting dynamic link
    move(esp,ebp); // Setting dynamic link
    addi(0, esp);
    pushi(edx);
    pushi(ecx);
    pushi(ebx);
    pushi(eax);
    loadi(ind(ebp, 4), ebx);
    move(0, eax);
    cmpi(ebx, eax);
    jg(l17);
l12:
    move(1, eax);
    storei(eax, ind(ebp, 8));
    j(retfactorial);
    j(l32);
l17:
    loadi(ind(ebp, 4), eax);
    pushi(1); //return
    loadi(ind(ebp, 4), ebx);
    move(1, ecx);
    muli(-1, ecx);
    addi(ebx, ecx);
    pushi(ecx);
    factorial();
    popi(1);
    loadi(ind(esp), ecx);
    popi(1);
    muli(eax, ecx);
    storei(ecx, ind(ebp, 8));
    j(retfactorial);
l32:
retfactorial:
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
    addi(-220, esp);
    pushi(edx);
    pushi(ecx);
    pushi(ebx);
    pushi(eax);
    move(1, ecx);
    move(-216, eax);
    addi(ebp,eax);
    move(1, ebx);
    muli(20, ebx); 
    addi(eax, ebx); 
    move(0, eax);
    muli(4, eax); 
    addi(ebx, eax); 
    storei(ecx, ind(eax));
    pushf(1); //return
    move(-216, eax);
    addi(ebp,eax);
    move(1, ecx);
    muli(20, ecx); 
    addi(eax, ecx); 
    move(0, eax);
    muli(4, eax); 
    addi(ecx, eax); 
    loadi(ind(eax), eax); 
    intTofloat(eax);
    pushf(eax);
    move(3.0, eax);
    pushf(eax);
    sum();
    popi(2);
    loadi(ind(esp), eax);
    popi(1);
    move(-220, ecx);
    addi(ebp,ecx);
    storef(eax, ind(ecx));
    loadf(ind(ebp, -220), ecx);
    cout << "printing f: ";
    print_float(ecx);
    cout << endl;
    move(-216, ecx);
    addi(ebp,ecx);
    move(-216, eax);
    addi(ebp,eax);
    move(1, ebx);
    muli(20, ebx); 
    addi(eax, ebx); 
    move(0, eax);
    muli(4, eax); 
    addi(ebx, eax); 
    loadi(ind(eax), eax); 
    muli(20, eax); 
    addi(ecx, eax); 
    move(0, ecx);
    muli(4, ecx); 
    addi(eax, ecx); 
    loadi(ind(ecx), ecx); 
    move(-16, eax);
    addi(ebp,eax);
    storei(ecx, ind(eax));
    loadi(ind(ebp, -16), eax);
    cout << "printing l: ";
    print_int(eax);
    cout << endl;
    loadi(ind(ebp, -16), eax);
    intTofloat(eax);
    loadf(ind(ebp, -220), ecx);
    addf(eax, ecx);
    move(-220, eax);
    addi(ebp,eax);
    storef(ecx, ind(eax));
    loadf(ind(ebp, -220), eax);
    cout << "printing f: ";
    print_float(eax);
    cout << endl;
    pushi(1); //return
    move(6, eax);
    pushi(eax);
    factorial();
    popi(1);
    loadi(ind(esp), eax);
    popi(1);
    move(-4, ecx);
    addi(ebp,ecx);
    storei(eax, ind(ecx));
    loadi(ind(ebp, -4), ecx);
    cout << "printing i: ";
    print_int(ecx);
    cout << endl;
    move(8, ecx);
    move(-16, eax);
    addi(ebp,eax);
    storei(ecx, ind(eax));
    move(4, eax);
    move(-4, ecx);
    addi(ebp,ecx);
    storei(eax, ind(ecx));
    move(23, ecx);
    move(-8, eax);
    addi(ebp,eax);
    storei(ecx, ind(eax));
    loadi(ind(ebp, -4), eax);
    loadi(ind(ebp, -16), ecx);
    muli(eax, ecx);
    loadi(ind(ebp, -8), eax);
    loadi(ind(ebp, -16), ebx);
    muli(eax, ebx);
    move(5, eax);
    divi(ebx, eax);
    addi(ecx, eax);
    loadi(ind(ebp, -16), ecx);
    muli(-1, ecx);
    addi(eax, ecx);
    move(-12, eax);
    addi(ebp,eax);
    storei(ecx, ind(eax));
    loadi(ind(ebp, -4), eax);
    loadi(ind(ebp, -4), ecx);
    addi(eax, ecx);
    loadi(ind(ebp, -16), eax);
    addi(ecx, eax);
    loadi(ind(ebp, -8), ecx);
    addi(eax, ecx);
    loadi(ind(ebp, -12), eax);
    addi(ecx, eax);
    loadi(ind(ebp, -12), ecx);
    loadi(ind(ebp, -8), ebx);
    muli(ecx, ebx);
    loadi(ind(ebp, -16), ecx);
    addi(ebx, ecx);
    addi(eax, ecx);
    move(-16, eax);
    addi(ebp,eax);
    storei(ecx, ind(eax));
    loadi(ind(ebp, -16), eax);
    cout << "printing l: ";
    print_int(eax);
    cout << endl;
    move(0, eax);
    move(-4, ecx);
    addi(ebp,ecx);
    storei(eax, ind(ecx));
    move(0, ecx);
    move(-16, eax);
    addi(ebp,eax);
    storei(ecx, ind(eax));
l149:
    loadi(ind(ebp, -16), eax);
    move(4, ecx);
    cmpi(eax, ecx);
    jge(l223);
l154:
    loadi(ind(ebp, -16), ecx);
    cout << "printing l: ";
    print_int(ecx);
    cout << endl;
    loadi(ind(ebp, -8), ecx);
    move(0, eax);
    move(0, eax);
    move(-8, ebx);
    addi(ebp,ebx);
    storei(eax, ind(ebx));
l165:
    loadi(ind(ebp, -8), ebx);
    move(10, ecx);
    cmpi(ebx, ecx);
    jge(l215);
l170:
    loadi(ind(ebp, -8), ecx);
    move(5, ebx);
    cmpi(ecx, ebx);
    je(l199);
l175:
    loadi(ind(ebp, -16), ebx);
    move(0, ecx);
    cmpi(ebx, ecx);
    jne(l199);
l180:
    loadi(ind(ebp, -4), ecx);
    move(10, ebx);
    cmpi(ecx, ebx);
    jle(l199);
l185:
    loadi(ind(ebp, -8), ebx);
    cout << "printing k: ";
    print_int(ebx);
    cout << endl;
    loadi(ind(ebp, -16), ebx);
    cout << "printing l: ";
    print_int(ebx);
    cout << endl;
    loadi(ind(ebp, -4), ebx);
    cout << "printing i: ";
    print_int(ebx);
    cout << endl;
    j(l206);
l199:
    loadi(ind(ebp, -4), ebx);
    loadi(ind(ebp, -8), ecx);
    addi(ebx, ecx);
    move(-4, ebx);
    addi(ebp,ebx);
    storei(ecx, ind(ebx));
l206:
    move(-8, ebx);
    addi(ebp,ebx);
    loadi(ind(ebx), edx);
    addi(1, edx);
    storei(edx, ind(ebx));
    addi(-1, edx);
    move(edx, ebx);
    j(l165);
l215:
    loadi(ind(ebp, -16), ebx);
    move(1, ecx);
    addi(ebx, ecx);
    move(-16, ebx);
    addi(ebp,ebx);
    storei(ecx, ind(ebx));
    j(l149);
l223:
    loadi(ind(ebp, -4), ebx);
    cout << "printing i: ";
    print_int(ebx);
    cout << endl;
    move(0, ebx);
    move(-4, ecx);
    addi(ebp,ecx);
    storei(ebx, ind(ecx));
    loadi(ind(ebp, -4), ecx);
    cout << "printing i: ";
    print_int(ecx);
    cout << endl;
    move(-4, ecx);
    addi(ebp,ecx);
    loadi(ind(ecx), edx);
    addi(1, edx);
    storei(edx, ind(ecx));
    addi(-1, edx);
    move(edx, ecx);
    loadi(ind(ebp, -4), ecx);
    cout << "printing i: ";
    print_int(ecx);
    cout << endl;
    loadi(ind(ebp, -16), ecx);
    move(4, ebx);
    cmpi(ecx, ebx);
    jne(l259);
l251:
    loadi(ind(ebp, -4), ebx);
    move(0, ecx);
    cmpi(ebx, ecx);
    jle(l259);
l256:
    move(1, ecx);
    j(l261);
l259:
    move(0, ecx);
l261:
    move(-4, ebx);
    addi(ebp,ebx);
    storei(ecx, ind(ebx));
    loadi(ind(ebp, -4), ebx);
    move(0, ecx);
    cmpi(ebx, ecx);
    je(l275);
l269:
    loadi(ind(ebp, -4), ecx);
    cout << "printing i: ";
    print_int(ecx);
    cout << endl;
    j(l280);
l275:
    loadi(ind(ebp, -4), ecx);
    move(-4, ebx);
    addi(ebp,ebx);
    storei(ecx, ind(ebx));
l280:
    move(2, ebx);
    intTofloat(ebx);
    move(3, ecx);
    intTofloat(ecx);
    move(5.0, eax);
    mulf(ecx, eax);
    addf(ebx, eax);
    floatToint(eax);
    move(-4, ebx);
    addi(ebp,ebx);
    storei(eax, ind(ebx));
    loadi(ind(ebp, -4), ebx);
    cout << "printing i: ";
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
    popi(55);
    loadi(ind(ebp), ebp);
    popi(1);
    return;
}

