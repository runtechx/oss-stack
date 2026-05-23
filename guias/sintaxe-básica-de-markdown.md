#  Guia Básico de Markdown

Markdown é uma linguagem leve de marcação usada para formatar texto de forma simples e legível.

Os ficheiros têm a extensão **`.md` (Markdown)**


## Títulos (Headings)

```md
# Título H1
## Título H2
### Título H3
#### Título H4
```

## Ênfase (Negrito e Itálico)

```md
*itálico* ou _itálico_  
**negrito** ou __negrito__  
***negrito e itálico***
```

*itálico* ou _itálico_  
**negrito** ou __negrito__  
***negrito e itálico***


## Listas

### Lista não ordenada

```md
- Item 1
- Item 2
  - Subitem
```
- Item 1
- Item 2
  - Subitem
  - 
### Lista ordenada

```md
1. Primeiro
2. Segundo
3. Terceiro
```
1. Primeiro
2. Segundo
3. Terceiro


## Links

```md
[Runtech](https://www.runtech.ao)
```

[Runtech](https://www.runtech.ao)


## Imagens

```md
![Texto alternativo](https://url-da-imagem.com/imagem.png)
```
![Texto alternativo](https://url-da-imagem.com/imagem.png)



## Código

### Código inline

```md
Use `codigo` dentro da frase
```
Use `codigo` dentro da frase

### Bloco de código

````md
```bash
echo "Olá Mundo"
```
````

```bash
echo "Olá Mundo"
```

## Tabelas

```md
| Nome     | Idade |
|----------|-------|
| João     | 25    |
| Maria    | 30    |
````

| Nome     | Idade |
|----------|-------|
| João     | 25    |
| Maria    | 30    |

**Centralizar os valores**

```md
| Nome     | Idade |
|----------|:-----:|
| João     | 25    |
| Maria    | 30    |
````
| Nome     | Idade |
|----------|:-----:|
| João     | 25    |
| Maria    | 30    |

**Mover para esquerda**
```md
| Nome     | Idade |
|----------|------:|
| João     | 25    |
| Maria    | 30    |
````

| Nome     | Idade |
|----------|------:|
| João     | 25    |
| Maria    | 30    |

## Citações (Blockquote)

```md
> Isto é uma citação
```

> Isto é uma citação


## Linha Horizontal

```md
---
```

---

## Checklist

```md
- [x] Tarefa concluída
- [ ] Tarefa pendente
```
- [x] Tarefa concluída
- [ ] Tarefa pendente

## Escape de caracteres

Para mostrar caracteres especiais:

```md
\* não itálico \*
```

\* não itálico \*


## Admonition / Callout

```md

> [!TIP]
> Dica útil

> [!NOTE]
> Nota importante

> [!WARNING]
> Atenção!

> [!IMPORTANT]
> Informação crítica

>[!CAUTION]
>aviso de cuidado — algo que pode dar problema

```

> [!TIP]
> Dicas em markdown.

> [!NOTE]
> Nota importante

> [!WARNING]
> Atenção!

> [!IMPORTANT]
> Informação crítica

>[!CAUTION]
>aviso de cuidado — algo que pode dar problema

## Dicas

* Markdown é amplamente usado em plataformas como GitHub
* Simples de aprender e muito poderoso
* Ideal para documentação técnica


<div align="right">
Source: https://github.com/runtechx/
</div>
