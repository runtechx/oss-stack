# Aceder a um terminal shell e executar comandos com a sintaxe correta

O shell é a interface de linha de comandos do sistema operativo Linux. No RHEL, o shell padrão é o Bash (Bourne-Again SHell).

Através do shell, os utilizadores podem interagir diretamente com o sistema operativo, executar comandos, administrar ficheiros, configurar serviços e automatizar tarefas.

O terminal é uma das ferramentas mais importantes para administradores de sistemas Linux, permitindo um controlo rápido, eficiente e avançado sobre o sistema.


# Estrutura básica de um comando

A maioria dos comandos Linux segue a seguinte estrutura:

```bash
comando [opções] [argumentos]
```

## Exemplo

```bash
ls -l /home
```

### Explicação

| Elemento | Descrição |
|----------|------------|
| `ls` | Comando utilizado para listar ficheiros e diretórios |
| `-l` | Opção que apresenta a listagem detalhada |
| `/home` | Argumento que indica o diretório alvo |



# Abrir um terminal

Em ambientes gráficos, o terminal pode ser aberto através de:

- Menu de aplicações → Terminal
- Atalho:
  - `Ctrl + Alt + T` (em muitos ambientes Linux)

Em servidores sem interface gráfica, o acesso é normalmente feito através de:

- Consola local
- SSH



# Executar comandos básicos

## Ver o diretório atual

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

## Ir para a pasta pessoal do utilizador

```bash
cd ~
```


# Obter ajuda sobre comandos

## Manual de um comando

```bash
man ls
```

## Ajuda rápida

```bash
ls --help
```


# Executar comandos como administrador

No RHEL e noutras distribuições Linux, utiliza-se o `sudo` para executar comandos com privilégios administrativos.

## Exemplo

```bash
sudo dnf update
```

O sistema poderá solicitar a password do utilizador.



# Sintaxe correta e boas práticas

## Utilizar espaços corretamente

✔ Correto:

```bash
mkdir testes
```

✘ Incorreto:

```bash
mkdirtestes
```



## Atenção às maiúsculas e minúsculas

Linux diferencia letras maiúsculas de minúsculas.

```bash
cd Documentos
```

é diferente de:

```bash
cd documentos
```



## Evitar apagar ficheiros sem verificar

Antes de remover ficheiros:

```bash
rm ficheiro.txt
```

verifique sempre o conteúdo com:

```bash
cat ficheiro.txt
```



# Histórico de comandos

O Bash guarda o histórico dos comandos executados.

## Ver histórico

```bash
history
```

## Reutilizar comandos anteriores

- Seta para cima (`↑`)
- Seta para baixo (`↓`)



# Encerrar sessão

## Terminar o terminal

```bash
exit
```

ou

```bash
logout
```



# Conclusão

Dominar o terminal Linux e a sintaxe correta dos comandos é essencial para qualquer utilizador ou administrador de sistemas Linux.

O Bash fornece uma interface poderosa para gestão do sistema, automação de tarefas e administração avançada, sendo uma competência fundamental em ambientes RHEL e Linux em geral.
