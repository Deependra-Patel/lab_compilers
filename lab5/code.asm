
void fact(){
    pushi(ebp); // Setting dynamic link
    move(esp,ebp); // Setting dynamic link
    addi(0, esp);
    pushi(edx);
    pushi(ecx);
    pushi(ebx);
    loadi(ind(ebp, 4), ebx);
    move(0, ecx);
    cmpi(ebx, ecx);
    jne(l16);
l11:
    move(1.0, ecx);
    storef(ecx, ind(ebp, 8));
    j(retfact);
    j(l35);
l16:
    pushf(1); //return
    loadi(ind(ebp, 4), ecx);
    pushi(ecx);    // pushing temporary storage
    move(1, ecx);
    loadi(ind(esp), edx);    // loading temporary storage
    popi(1);
    muli(-1, ecx);
    addi(edx, ecx);
    pushi(ecx);
    fact();
    popi(1);
    loadi(ind(esp), ecx);
    popi(1);
    loadi(ind(ebp, 4), ebx);
    intTofloat(ebx);
    mulf(ebx, ecx);
    storef(ecx, ind(ebp, 8));
    j(retfact);
l35:
retfact:
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


void r(){
    pushi(ebp); // Setting dynamic link
    move(esp,ebp); // Setting dynamic link
    addi(0, esp);
    pushi(edx);
    pushi(ecx);
    pushi(ebx);
    loadi(ind(ebp, 4), ecx);
    cout << "printing a: ";
    print_int(ecx);
    cout << endl;
retr:
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
    move(1, ecx);
    move(-4, ebx);
    addi(ebp,ebx);
    storei(ecx, ind(ebx));
    loadi(ind(ebp, -4), ecx);
    move(0, ebx);
    cmpi(ecx, ebx);
    jne(l18);
l15:
    move(1, ebx);
    j(l20);
l18:
    move(0, ebx);
l20:
    move(-4, ecx);
    addi(ebp,ecx);
    storei(ebx, ind(ecx));
    loadi(ind(ebp, -4), ebx);
    cout << "printing i: ";
    print_int(ebx);
    cout << endl;
retmain:
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

