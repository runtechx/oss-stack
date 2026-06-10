<div align="right">

[OpenFirst](/OPENFIRST.md) |
[Stack](/stack/stack.md) |
[Guias](/guias/guides.md) |
[Labs](/labs/labs.md) |
[Comandos](/stack/auto-installer.md)

</div>

# OpenFirst

**Standard de Adopção Tecnológica para infraestruturas TIC.**

O OpenFirst é um standard de decisão tecnológica que estabelece critérios estruturados para avaliação e adopção de tecnologias, com preferência por soluções open source e padrões abertos.

> Princípio central: **open source é a opção por defeito. Soluções proprietárias são a excepção documentada.**



## O que encontras neste repositório

Este repositório não é apenas documentação — é um kit operacional completo que acompanha o ciclo de decisão, aprendizagem e implementação de tecnologias open source.

Está organizado em três camadas que se complementam:

```
Decidir → Aprender → Implementar
```

| Camada | O que resolve | Onde |
|---|---|---|
| **Decidir** | Critérios e modelo estruturado para escolher tecnologias | [`OPENFIRST.md`](/OPENFIRST.md) |
| **Aprender** | Guias práticos e laboratórios para validar e ganhar competência | [`guias/`](/guias/guides.md) · [`labs/`](/labs/) |
| **Implementar** | Stack de referência, scripts e automações prontos a usar | [`stack/`](/stack/stack.md) · [`stack/auto-installer.md`](/stack/auto-installer.md) |

E ainda:

| Recurso | O que é | Onde |
|---|---|---|
| **Blocklists** | Listas de bloqueio de IPs e domínios para segurança de rede | [`blocklists/`](/blocklists/) |



## Como usar este repositório

**Se precisas de tomar uma decisão tecnológica →**
Começa pelo [`OPENFIRST.md`](/OPENFIRST.md). Encontras o modelo de decisão em 4 etapas, critérios de maturidade e um scorecard para avaliar alternativas open source.

**Se precisas de aprender a usar uma tecnologia →**
Consulta os [`guias/`](/guias/guides.md) para procedimentos operacionais documentados, ou usa os [`labs/`](/labs/) para experimentar em ambiente controlado antes de ir para produção.

**Se precisas de instalar ou configurar um ambiente →**
Vai directamente ao [`stack/auto-installer.md`](/stack/auto-installer.md) para comandos e automações prontas, ou ao [`stack/stack.md`](/stack/stack.md) para perceber o racional de cada tecnologia adoptada.

**Se precisas de proteger a rede →**
As [`blocklists/`](/blocklists/) contêm listas de IPs e domínios prontas a integrar com fail2ban, firewalls ou proxies.



## Organização do Repositório

Listagem do repositório
```
OpenFirst/
├── blocklists/          # Listas de bloqueio de IPs e domínios
│   ├── nodes/
│   ├── domain-bl.txt
│   ├── ip-bl.txt
│   └── README.md
│
├── guias/               # Documentação técnica e procedimentos operacionais
│   ├── img/
│   ├── como-usar-ip-bl-txt-com-fail2b....md
│   ├── como-usar-os-labs-locais.md
│   ├── preparar-maq-hyperv-para-labs....md
│   ├── preparar-maq-virtualbox-para-l....md
│   ├── sintaxe-basica-de-markdown.md
│   └── guides.md
│
├── labs/                # Laboratórios e ambientes de teste
│
├── stack/               # Stack tecnológica e automações
│   ├── pesquisas/
│   ├── scripts/
│   ├── auto-installer.md
│   └── stack.md
│
├── LICENSE
├── OPENFIRST.md         # Standard de Adopção Tecnológica (documento principal)
└── README.md            # Este ficheiro
```

### `blocklists`
Listas de bloqueio de IPs e domínios associados a publicidade abusiva, malware e tracking. Utilizáveis directamente em firewalls, proxies e ferramentas como fail2ban.

### `guias`
Documentação técnica e procedimentos operacionais. Inclui guias de preparação de ambientes (Hyper-V, VirtualBox), uso das blocklists e referências de sintaxe.

### `labs`
Laboratórios e ambientes de teste para validação de tecnologias antes da adopção em produção.

### `stack`
Stack tecnológica de referência e automações para ambientes open source em AlmaLinux 10+. Inclui scripts de instalação automática e pesquisas de suporte à decisão tecnológica.



## Documentos Principais

| Documento | Descrição |
|---|---|
| [`OPENFIRST.md`](/OPENFIRST.md) | Standard de Adopção Tecnológica — modelo de decisão, critérios e princípios |
| [`stack/stack.md`](/stack/stack.md) | Stack tecnológica de referência |
| [`stack/auto-installer.md`](/stack/auto-installer.md) | Automações e comandos de instalação |
| [`guias/guides.md`](/guias/guides.md) | Índice de guias técnicos |



## Contribuições

O ecossistema OpenFirst evolui através da colaboração e partilha de conhecimento técnico.

São valorizadas contribuições que:

- proponham alternativas open source viáveis e maduras com fundamentação técnica
- melhorem os critérios de avaliação ou o modelo de decisão
- contribuam para automação, segurança, eficiência ou escalabilidade
- reportem casos de uso reais e lições aprendidas

Se este projecto for útil:

- ⭐ estrela o repositório
- segue a organização para acompanhar novas stacks e automações
- partilha com equipas e comunidades técnicas

## Perguntas Frequentes (FAQ)

Discussões e respostas técnicas na secção de [FAQ do repositório](https://github.com/runtechx/OpenFirst/discussions?discussions_q=is%3Aclosed).

&nbsp;

<div align="right">
Source: https://github.com/runtechx/
</div>
