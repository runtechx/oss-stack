<div align="right">

[Início](/README.md) |  [OpenFirst](/OPENFIRST.md) |
[Stack](/stack/stack.md) |
[Guias](/guias/guides.md) |
[Labs](/labs/labs.md) |
[Comandos](/stack/auto-installer.md)

&nbsp;
&nbsp;
</div>

# Blocklists

Listas de bloqueio de IPs e domínios para protecção de infraestruturas TIC contra tráfego malicioso, abusivo e indesejado.



## O que são ficheiros de bloqueio

Um ficheiro de bloqueio (`blocklist`) é uma lista de endereços IP ou domínios que devem ser bloqueados ao nível da rede ou do sistema. Cada entrada representa uma fonte identificada como maliciosa, abusiva ou indesejada — com base em denúncias, análise de comportamento ou inteligência de ameaças.

Estes ficheiros são consumidos directamente por ferramentas de segurança como firewalls, proxies, sistemas de detecção de intrusão e fail2ban, que aplicam as regras de bloqueio de forma automática.



## Ficheiros disponíveis

| Ficheiro | Conteúdo | Uso típico |
|---|---|---|
| `ip-bl.txt` | Lista de endereços IPv4 e IPv6 maliciosos ou abusivos | Firewall, fail2ban, iptables, nftables |
| `domain-bl.txt` | Lista de domínios associados a malware, tracking ou publicidade abusiva | DNS sinkhole, proxy, Pi-hole, AdGuard |

### Formato dos ficheiros

Cada linha contém uma entrada:

```
# ip-bl.txt
101.126.138.178
45.227.255.206
185.220.101.47

# domain-bl.txt
tracking.example.com
malware-cdn.net
ads.abusive-network.io
```

Linhas começadas por `#` são comentários e são ignoradas pelas ferramentas.



## Como funciona o bloqueio

```
Tráfego de entrada/saída
        │
        ▼
┌─────────────────────────────┐
│ Fail2ban / Firewall / Proxy │  ◄── carrega ip-bl.txt e domain-bl.txt
└─────────────────────────────┘
        │
  IP ou domínio
  está na lista?
        │
   Sim ─┤─ Não
        │        │
    BLOQUEAR   PERMITIR
```

Quando uma ligação é iniciada — de dentro ou de fora da rede — a ferramenta de segurança verifica se o IP ou domínio de destino/origem consta na blocklist. Se constar, a ligação é bloqueada antes de atingir os serviços internos.

---

## Benefícios

**Redução da superfície de ataque**
Bloqueia proactivamente IPs e domínios com histórico de actividade maliciosa — scanners, botnets, servidores de C2, infraestrutura de malware — antes de qualquer tentativa de exploração.

**Protecção contra tracking e telemetria não autorizada**
A `domain-bl.txt` inclui domínios de rastreamento e telemetria que recolhem dados sem consentimento explícito, úteis em ambientes onde a privacidade é um requisito.

**Automação e baixo custo operacional**
Uma vez integradas, as listas são aplicadas automaticamente. A actualização é feita substituindo o ficheiro — sem necessidade de intervenção manual por cada ameaça.

**Camada de defesa independente**
Funcionam como uma camada de segurança complementar, independente de outros controlos. Mesmo que uma ameaça contorne outras defesas, o bloqueio por IP ou domínio mantém-se activo.

**Auditabilidade**
Ficheiros de texto simples, versionados em Git. Qualquer alteração fica registada com autor, data e motivo — rastreável e auditável.



## Como verificar um IP da lista

Para investigar qualquer IP presente nas blocklists, usa o [AbuseIPDB](https://www.abuseipdb.com/):

- Número de denúncias registadas
- Percentagem de confiança de abuso (*Confidence of Abuse*)
- ISP e operadora responsável
- Tipo de infraestrutura (Datacenter, Hosting, Residencial)
- ASN, domínio associado, país e cidade de origem

**Exemplo:** o IP `101.126.138.178` foi reportado 82 vezes com 75% de confiança de abuso, associado ao ISP `Beijing Volcano Engine Technology Co., Ltd.`, infraestrutura de datacenter, domínio `bytedance.com`, com origem em Pequim, China.



## Nodes

A pasta `nodes/` contém listas segmentadas por tipo de ameaça ou origem, para integração mais granular em ambientes que suportam múltiplas listas simultâneas.



> [!TIP]
> Consulta os [`guias/`](/guias/guides.md) para instruções detalhadas sobre como integrar estas listas com fail2ban, firewalls e outras ferramentas.
>
> Para verificar mais informações sobre um IP encontrado na blocklist da RT, utilize o site [AbuseIPDB](https://www.abuseipdb.com).

&nbsp;

<div align="right">
Source: https://github.com/runtechx/
</div>






