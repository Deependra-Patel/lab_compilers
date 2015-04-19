
void main(){
    pushi(ebp); // Setting dynamic link
    move(esp,ebp); // Setting dynamic link
    addi(-48, esp);
    pushi(edx);
    pushi(ecx);
    pushi(ebx);
    pushi(eax);
    move(0, eax);
    move(-48, ebx);
    addi(ebp,ebx);
    storei(eax, ind(ebx));
    loadi(ind(ebp, -44), ebx);
    move(0, eax);
    move(0, eax);
    move(-44, ecx);
    addi(ebp,ecx);
    storei(eax, ind(ecx));
l18:
    loadi(ind(ebp, -44), ecx);
    move(10, ebx);
    cmpi(ecx, ebx);
    jge(l39);
l23:
    loadi(ind(ebp, -44), ebx);
    move(-40, ecx);
    addi(ebp,ecx);
    loadi(ind(ebp, -44), eax);
    muli(4, eax); 
    addi(ecx, eax); 
    storei(ebx, ind(eax));
    move(-44, eax);
    addi(ebp,eax);
    loadi(ind(eax), edx);
    addi(1, edx);
    storei(edx, ind(eax));
    addi(-1, edx);
    move(edx, eax);
    j(l18);
l39:
    move(2, eax);
    move(-44, ebx);
    addi(ebp,ebx);
    storei(eax, ind(ebx));
    move(-40, ebx);
    addi(ebp,ebx);
    move(-40, eax);
    addi(ebp,eax);
    loadi(ind(ebp, -44), ecx);
    muli(4, ecx); 
    addi(eax, ecx); 
    loadi(ind(ecx), edx);
    addi(1, edx);
    storei(edx, ind(ecx));
    addi(-1, edx);
    move(edx, ecx);
    muli(4, ecx); 
    addi(ebx, ecx); 
    loadi(ind(ecx), edx);
    addi(1, edx);
    storei(edx, ind(ecx));
    addi(-1, edx);
    move(edx, ecx);
    move(-48, ebx);
    addi(ebp,ebx);
    storei(ecx, ind(ebx));
    loadi(ind(ebp, -48), ebx);
    cout << "printing b: ";
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
    popi(12);
    loadi(ind(ebp), ebp);
    popi(1);
    return;
}

