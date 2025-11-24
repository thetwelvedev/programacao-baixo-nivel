#include <stdio.h>

extern int somar_asm(int a, int b);

int main() {
    int x, y;
    
    printf("Digite o primeiro numero: ");
    scanf("%d", &x);

    printf("Digite o segundo numero: ");
    scanf("%d", &y);

    int resultado = somar_asm(x, y);

    printf("Resultado: %d\n", resultado);

    return 0;
}

//int main() {
//    int resultado = somar_asm(20, 20);
//    printf("Resultado: %d\n", resultado);
//    return 0;
//}