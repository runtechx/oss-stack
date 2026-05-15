
# Terminal e Shell no Linux

No Linux, o trabalho com linha de comandos é uma das formas mais poderosas de interação com o sistema. Para isso, existem dois conceitos fundamentais que muitas vezes são confundidos: terminal e shell.



# 1. O que é um Terminal

O terminal é uma interface (gráfica ou de texto) que permite ao utilizador interagir com o sistema operativo através de comandos.

Ele não interpreta comandos. Apenas:
- recebe o que o utilizador escreve
- envia para a shell
- mostra o resultado na tela

## Exemplos de terminais

- GNOME Terminal
- Konsole
- xterm
- Windows Terminal
- PuTTY (acesso remoto via SSH)



## Terminal vs Shell

| Elemento | Função |
|----------|--------|
| Terminal | Interface de entrada e saída |
| Shell | Interpretador de comandos |



## Fluxo de funcionamento

```text
Utilizador
   ↓
Terminal (interface)
   ↓
Shell (interpreta comandos)
   ↓
Kernel Linux
   ↓
Hardware
````



# 2. O que é uma Shell

Uma shell é um programa que funciona como interpretador de comandos e também como linguagem de scripting.

No Linux, a shell:

* interpreta comandos digitados no terminal
* executa programas
* permite automação através de scripts
* controla o sistema através de comandos



## Funções da Shell

* Execução de comandos
* Gestão de ficheiros e diretórios
* Automação (scripts)
* Gestão de processos
* Administração do sistema



# 3. Tipos de Shell no Linux

## Tabela de shells

| Shell                             | Descrição                                            | Utilização                                |
| --------------------------------- | ---------------------------------------------------- | ----------------------------------------- |
| Bash (Bourne Again SHell)         | Shell padrão na maioria das distribuições Linux      | Mais usada em servidores e sistemas Linux |
| Zsh (Z Shell)                     | Shell moderna com funcionalidades avançadas          | Popular entre developers                  |
| Fish (Friendly Interactive Shell) | Shell com interface amigável e sugestões automáticas | Ideal para iniciantes                     |
| sh (Bourne Shell)                 | Shell clássica e simples                             | Compatibilidade e scripts básicos         |
| ksh (Korn Shell)                  | Shell tradicional Unix                               | Ambientes empresariais antigos            |

## Nota importante

A Bash é a shell mais utilizada no Linux, especialmente em sistemas como:

* RHEL (Red Hat Enterprise Linux)
* Ubuntu
* Debian



# 4. Símbolos no prompt da Shell

Quando abres um terminal, vês algo como:

```text
user@linux:~$
```

ou

```text
root@linux:~#
```



## Símbolo $

O símbolo `$` indica que estás logado como utilizador normal.

Exemplo:

```text
mario@server:~$
```

Características:

* utilizador sem privilégios administrativos
* não pode modificar ficheiros críticos do sistema
* uso seguro para tarefas comuns



## Símbolo

O símbolo `#` indica que estás como root (administrador).

Exemplo:

```text
root@server:~#
```

Características:

* acesso total ao sistema
* pode instalar/remover software
* pode alterar ficheiros críticos
* uso deve ser cuidadoso



## Símbolo ~

O símbolo `~` representa o diretório home do utilizador atual.

Exemplo:

```bash
cd ~
```

Equivale a:

```
/home/utilizador
```

Se for root:

```
/root
```



# 5. Como aceder a um terminal

## Método 1: Interface gráfica (GUI)

* Menu de aplicações → Terminal
* Pesquisa por “Terminal”
* Atalho:

  * Ctrl + Alt + T



## Método 2: Consolas virtuais (TTY)

| Atalho          | Descrição                                 |
| --------------- | ----------------------------------------- |
| Ctrl + Alt + F1 | Interface gráfica (dependendo do sistema) |
| Ctrl + Alt + F2 | tty2                                      |
| Ctrl + Alt + F3 | tty3                                      |
| Ctrl + Alt + F4 | tty4                                      |
| Ctrl + Alt + F5 | tty5                                      |
| Ctrl + Alt + F6 | tty6                                      |



## Método 3: SSH

```bash
ssh utilizador@ip-do-servidor
```



# 6. Estrutura básica de um comando

```bash
comando [opções] [argumentos]
```

Exemplo:

```bash
ls -l /home
```

| Parte | Significado |
| ----- | ----------- |
| ls    | comando     |
| -l    | opção       |
| /home | argumento   |



# 7. Formatos de opções

No Linux, os comandos podem usar diferentes formatos de opções.



## 7.1 Forma curta (short options)

Usa um hífen (`-`) seguido de uma letra.

Exemplo:

```bash
ls -l
```

Várias opções curtas podem ser combinadas:

```bash
ls -la
```

Isto equivale a:

```bash
ls -l -a
```



## 7.2 Forma longa (long options)

Usa dois hífens (`--`) seguido de uma palavra completa.

Exemplo:

```bash
ls --all
```

Outro exemplo:

```bash
ls --human-readable
```



## 7.3 Forma combinada de opções curtas

Várias opções curtas podem ser agrupadas num único hífen:

```bash
tar -xvf arquivo.tar
```

Equivale a:

```bash
tar -x -v -f arquivo.tar
```

| Opção | Significado  |
| ----- | ------------ |
| -x    | extrair      |
| -v    | modo verbose |
| -f    | ficheiro     |



# 8. Comandos básicos no Linux

## Diretório atual

```bash
pwd
```

## Listar ficheiros

```bash
ls
```

## Lista detalhada

```bash
ls -l
```

## Ficheiros ocultos

```bash
ls -la
```

## Mudar diretório

```bash
cd /etc
```

## Voltar atrás

```bash
cd ..
```

## Home

```bash
cd ~
```



# 9. Ajuda no sistema

## Manual

```bash
man ls
```

## Ajuda rápida

```bash
ls --help
```



# 10. Executar como administrador

```bash
sudo dnf update
```



# 11. Histórico de comandos

```bash
history
```



# 12. Encerrar sessão

```bash
exit
```



# Conclusão

O terminal é apenas a interface onde os comandos são inseridos, enquanto a shell é o interpretador que os executa.

Compreender terminal, shell e os formatos de opções é essencial para trabalhar eficientemente em sistemas Linux.


