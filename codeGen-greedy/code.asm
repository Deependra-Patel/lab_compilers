
void isDivisible(){
    pushi(ebp); // Setting dynamic link
    move(esp,ebp); // Setting dynamic link
    addi(-8, esp);
    pushi(edx);
    pushi(ecx);
    pushi(ebx);
    pushi(eax);
    loadi(ind(ebp, 8), eax);
    move(-8, ebx);
    addi(ebp,ebx);
    storei(eax, ind(ebx));
l12:
    loadi(ind(ebp, -8), eax);
    loadi(ind(ebp, 4), ebx);
    cmpi(eax, ebx);
    jg(l40);
l17:
    loadi(ind(ebp, -8), ebx);
    loadi(ind(ebp, 4), eax);
    cmpi(ebx, eax);
    jne(l27);
l22:
    move(1, eax);
    storei(eax, ind(ebp, 12));
    j(retisDivisible);
    j(l32);
l27:
    move(1, eax);
    move(-4, ebx);
    addi(ebp,ebx);
    storei(eax, ind(ebx));
l32:
    loadi(ind(ebp, -8), eax);
    loadi(ind(ebp, 8), ebx);
    addi(eax, ebx);
    move(-8, eax);
    addi(ebp,eax);
    storei(ebx, ind(eax));
    j(l12);
l40:
    move(0, ebx);
    storei(ebx, ind(ebp, 12));
    j(retisDivisible);
retisDivisible:
    loadi(ind(esp), eax);
    popi(1);
    loadi(ind(esp), ebx);
    popi(1);
    loadi(ind(esp), ecx);
    popi(1);
    loadi(ind(esp), edx);
    popi(1);
    popi(2);
    loadi(ind(ebp), ebp);
    popi(1);
    return;
}


void isPrime(){
    pushi(ebp); // Setting dynamic link
    move(esp,ebp); // Setting dynamic link
    addi(0, esp);
    pushi(edx);
    pushi(ecx);
    pushi(ebx);
    pushi(eax);
    loadi(ind(ebp, 8), ebx);
    move(1, eax);
    cmpi(ebx, eax);
    jne(l17);
l12:
    move(1, eax);
    storei(eax, ind(ebp, 12));
    j(retisPrime);
    j(l51);
l17:
    pushi(1); //return
    loadi(ind(ebp, 8), eax);
    pushi(eax);
    loadi(ind(ebp, 4), eax);
    pushi(eax);
    isDivisible();
    popi(2);
    loadi(ind(esp), eax);
    popi(1);
    move(1, ebx);
    cmpi(eax, ebx);
    jne(l35);
l30:
    move(0, ebx);
    storei(ebx, ind(ebp, 12));
    j(retisPrime);
    j(l50);
l35:
    pushi(1); //return
    loadi(ind(ebp, 8), ebx);
    move(1, eax);
    muli(-1, eax);
    addi(ebx, eax);
    pushi(eax);
    loadi(ind(ebp, 4), eax);
    pushi(eax);
    isPrime();
    popi(2);
    loadi(ind(esp), eax);
    popi(1);
    storei(eax, ind(ebp, 12));
    j(retisPrime);
l50:
l51:
retisPrime:
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
    addi(-8, esp);
    pushi(edx);
    pushi(ecx);
    pushi(ebx);
    pushi(eax);
    move(11, eax);
    move(-4, ebx);
    addi(ebp,ebx);
    storei(eax, ind(ebx));
    pushi(1); //return
    loadi(ind(ebp, -4), eax);
    move(2, ebx);
    divi(eax, ebx);
    pushi(ebx);
    loadi(ind(ebp, -4), ebx);
    pushi(ebx);
    isPrime();
    popi(2);
    loadi(ind(esp), ebx);
    popi(1);
    move(-8, eax);
    addi(ebp,eax);
    storei(ebx, ind(eax));
    loadi(ind(ebp, -8), ebx);
    move(1, eax);
    cmpi(ebx, eax);
    jne(l36);
l30:
    loadi(ind(ebp, -8), eax);
    cout << "printing prime: ";
    print_int(eax);
    cout << endl;
    j(l41);
l36:
    loadi(ind(ebp, -8), eax);
    cout << "printing prime: ";
    print_int(eax);
    cout << endl;
l41:
retmain:
    loadi(ind(esp), eax);
    popi(1);
    loadi(ind(esp), ebx);
    popi(1);
    loadi(ind(esp), ecx);
    popi(1);
    loadi(ind(esp), edx);
    popi(1);
    popi(2);
    loadi(ind(ebp), ebp);
    popi(1);
    return;
}

