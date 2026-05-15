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

Existem várias shells disponíveis no Linux.

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

* RHEL (Red Hat Enterprise Linux) / AlmaLinux
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

```text
/home/utilizador
```

Se for root:

```text
/root
```



# 5. Como aceder a um terminal

Existem várias formas de aceder a um terminal no Linux.



## Método 1: Interface gráfica (GUI)

Em sistemas com ambiente gráfico:

* Menu de aplicações → Terminal
* Pesquisa por “Terminal”
* Atalho comum:

  * Ctrl + Alt + T



## Método 2: Consolas virtuais (TTY)

Em sistemas Linux é possível alternar entre consolas virtuais:

| Atalho          | Descrição                              |
| --------------- | -------------------------------------- |
| Ctrl + Alt + F1 | Interface gráfica (em alguns sistemas) |
| Ctrl + Alt + F2 | tty2                                   |
| Ctrl + Alt + F3 | tty3                                   |
| Ctrl + Alt + F4 | tty4                                   |
| Ctrl + Alt + F5 | tty5                                   |
| Ctrl + Alt + F6 | tty6                                   |

Estas consolas são úteis quando o sistema gráfico não está disponível.



## Método 3: Acesso remoto via SSH

O acesso remoto ao terminal é feito através de SSH.

Exemplo:

```bash
ssh utilizador@ip-do-servidor
```



# 6. Estrutura básica de um comando

A maioria dos comandos Linux segue a estrutura:

```bash
comando [opções] [argumentos]
```



## Exemplo

```bash
ls -l /home
```

| Parte | Significado                   |
| ----- | ----------------------------- |
| ls    | comando para listar ficheiros |
| -l    | opção de formato detalhado    |
| /home | diretório alvo                |



# 7. Comandos básicos no Linux

## Ver diretório atual

```bash
pwd
```

## Listar ficheiros

```bash
ls
```

## Listar ficheiros com detalhes

```bash
ls -l
```

## Mostrar ficheiros ocultos

```bash
ls -la
```

## Mudar de diretório

```bash
cd /etc
```

## Voltar ao diretório anterior

```bash
cd ..
```

## Ir para o diretório home

```bash
cd ~
```



# 8. Ajuda no sistema

## Manual completo

```bash
man ls
```

## Ajuda rápida

```bash
ls --help
```



# 9. Executar comandos como administrador

No Linux, usa-se sudo para executar comandos com privilégios elevados.

Exemplo:

```bash
sudo dnf update
```

O sistema pode pedir a password do utilizador.



# 10. Histórico de comandos

A shell guarda um histórico dos comandos executados.

## Ver histórico

```bash
history
```

## Navegar no histórico

* seta para cima
* seta para baixo



# 11. Boas práticas no terminal

## Usar espaços corretamente

Correto:

```bash
mkdir testes
```

Incorreto:

```bash
mkdirtestes
```



## Atenção a maiúsculas e minúsculas

Linux diferencia letras:

```bash
cd Documentos
```

é diferente de:

```bash
cd documentos
```



## Ver antes de apagar ficheiros

```bash
cat ficheiro.txt
```

Depois:

```bash
rm ficheiro.txt
```



# 12. Encerrar sessão

## Sair do terminal

```bash
exit
```

ou

```bash
logout
```



# Conclusão

O terminal é apenas a interface onde os comandos são escritos, enquanto a shell é o programa que interpreta e executa esses comandos.

Compreender a diferença entre terminal e shell, bem como os símbolos do prompt e a estrutura dos comandos, é essencial para trabalhar com eficiência em sistemas Linux como o Red Hat Enterprise Linux.
