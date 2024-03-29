#include <string.h>
#include <stdio.h>

#define MAX 1000

struct symbol {
    char nome[30];
    int tamanho;
    int tipo;
};

struct symbol tabela[MAX];

int tam = 0;

int procura(char *nome) {
    for(int i = 0; i < tam; i++){
        if(strcmp(tabela[i].nome, nome) == 0){
            return i;
        }
    }
    return -1;
}

int insere(char *nome) {
    struct symbol aux;
    int pos;
  
    pos = procura(nome);

    if(pos != -1) {
        return pos;
    }

    strcpy(aux.nome, nome);
    tabela[tam] = aux;

    return tam++;
}

char nome[30];

char * obtemNome(int pos) {
    int i;

    if(pos >= 0) {
        strcpy(nome, tabela[pos].nome);
    }

    return nome;
}

void imprime() {
    printf("Tabela de Simbolos\n");
    for(int i = 0; i < tam; i++) {
        printf("%d - %s\n", i, tabela[i].nome);
    }
}
