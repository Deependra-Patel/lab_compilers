
void main(){
    pushi(ebp); // Setting dynamic link
    move(esp,ebp); // Setting dynamic link
    addi(-12, esp);
    pushi(edx);
    pushi(ecx);
    pushi(ebx);
    move(1, ebx);
    move(-12, ecx);
    addi(ebp,ecx);
    storei(ebx, ind(ecx));
    loadi(ind(ebp, -12), ebx);
    loadi(ind(ebp, -12), ecx);
    cmpi(ebx, ecx);
    jne(l18);
l15:
    move(1, ecx);
    j(l20);
l18:
    move(0, ecx);
l20:
    loadi(ind(ebp, -12), ebx);
    cmpi(ecx, ebx);
    jg(l27);
l24:
    move(1, ebx);
    j(l29);
l27:
    move(0, ebx);
l29:
    move(-12, ecx);
    addi(ebp,ecx);
    storei(ebx, ind(ecx));
    loadi(ind(ebp, -12), ebx);
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
    popi(3);
    loadi(ind(ebp), ebp);
    popi(1);
    return;
}

