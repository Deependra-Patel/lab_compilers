
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
    pushi(eax);    // pushing temporary storage
    loadi(ind(ebp, 4), eax);
    loadi(ind(esp), edx);    // loading temporary storage
    popi(1);
    cmpi(edx, eax);
    jg(l46);
l20:
    loadi(ind(ebp, -8), eax);
    pushi(eax);    // pushing temporary storage
    loadi(ind(ebp, 4), eax);
    loadi(ind(esp), edx);    // loading temporary storage
    popi(1);
    cmpi(edx, eax);
    jne(l33);
l28:
    move(1, eax);
    storei(eax, ind(ebp, 12));
    j(retisDivisible);
    j(l38);
l33:
    move(1, eax);
    move(-4, ebx);
    addi(ebp,ebx);
    storei(eax, ind(ebx));
l38:
    loadi(ind(ebp, -8), eax);
    loadi(ind(ebp, 8), ebx);
    addi(eax, ebx);
    move(-8, eax);
    addi(ebp,eax);
    storei(ebx, ind(eax));
    j(l12);
l46:
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
    j(l54);
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
    j(l53);
l35:
    pushi(1); //return
    loadi(ind(ebp, 8), ebx);
    pushi(ebx);    // pushing temporary storage
    move(1, ebx);
    loadi(ind(esp), edx);    // loading temporary storage
    popi(1);
    muli(-1, ebx);
    addi(edx, ebx);
    pushi(ebx);
    loadi(ind(ebp, 4), ebx);
    pushi(ebx);
    isPrime();
    popi(2);
    loadi(ind(esp), ebx);
    popi(1);
    storei(ebx, ind(ebp, 12));
    j(retisPrime);
l53:
l54:
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
    move(11, ebx);
    move(-4, eax);
    addi(ebp,eax);
    storei(ebx, ind(eax));
    pushi(1); //return
    loadi(ind(ebp, -4), ebx);
    pushi(ebx);    // pushing temporary storage
    move(2, ebx);
    loadi(ind(esp), edx);    // loading temporary storage
    popi(1);
    divi(edx, ebx);
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
    jne(l39);
l33:
    loadi(ind(ebp, -8), eax);
    cout << "printing prime: ";
    print_int(eax);
    cout << endl;
    j(l44);
l39:
    loadi(ind(ebp, -8), eax);
    cout << "printing prime: ";
    print_int(eax);
    cout << endl;
l44:
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

