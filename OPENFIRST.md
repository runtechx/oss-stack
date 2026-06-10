# OpenFirst — Standard de Adopção Tecnológica

## O que é o OpenFirst

O **OpenFirst** é um standard de adopção tecnológica que estabelece um modelo estruturado para avaliação e adopção de tecnologias em ambientes empresariais, com preferência por soluções open source e padrões abertos.

O OpenFirst prioriza **transparência, auditabilidade, interoperabilidade e independência tecnológica de longo prazo**, reduzindo a dependência de fornecedores específicos (vendor lock-in) e aumentando o controlo sobre sistemas, dados e infraestrutura crítica.

## Princípio Central

> **Open source é a opção por defeito. Soluções proprietárias são a excepção documentada.**


## Modelo de Decisão

Toda a adopção de nova tecnologia segue este processo sequencial. Cada etapa deve ser respondida antes de avançar para a seguinte.

### Etapa 1 — Existe alternativa open source viável?

Uma alternativa é considerada viável quando cumpre **todos** os seguintes critérios de maturidade:

| Critério | Indicadores mínimos |
|---|---|
| **Maturidade** | Projecto com ≥ 2 anos de histórico activo; versão estável disponível |
| **Comunidade** | Actividade regular no repositório; issues respondidos; releases frequentes |
| **Suporte** | Documentação completa; opção de suporte comercial disponível (se necessário) |
| **Licença** | Licença OSI-aprovada compatível com o contexto de uso (MIT, Apache 2.0, GPL, etc.) |

Se não existir alternativa viável → avançar para [Etapa 3](#etapa-3).

### Etapa 2 — Cumpre os requisitos funcionais e técnicos?

A solução open source identificada deve satisfazer:

- **Requisitos funcionais:** as capacidades necessárias estão disponíveis ou são extensíveis
- **Performance:** métricas de desempenho dentro dos limites aceitáveis para o caso de uso
- **Segurança:** histórico de resposta a CVEs; processo de disclosure activo; sem vulnerabilidades críticas abertas
- **Integração:** compatibilidade com APIs, protocolos e sistemas existentes
- **Operação:** capacidade interna ou acessível para instalar, configurar e manter

Se não cumprir → avançar para [Etapa 3](#etapa-3).

### Etapa 3 — O risco operacional é aceitável?

Aplicável tanto a soluções open source (risco de manutenção) como proprietárias (risco de dependência):

- **Risco de abandono:** qual a probabilidade de o projecto/produto ser descontinuado?
- **Risco de licença:** a licença pode mudar de forma prejudicial (ex: BSL, SSPL)?
- **Risco de dados:** os dados ficam sob controlo da organização?
- **Risco de saída:** existe estratégia de migração documentada?

### Etapa 4 — Avaliação de solução proprietária ou SaaS

Quando não existe alternativa open source viável, a adopção de solução proprietária requer documentação obrigatória dos seguintes pontos:

| Critério | Requisito |
|---|---|
| **Justificação** | Registo explícito de porquê não foi possível usar open source |
| **Interoperabilidade** | Suporte a APIs abertas e formatos de dados padrão |
| **Exit strategy** | Plano de migração documentado; dados exportáveis em formatos abertos |
| **Privacidade e segurança** | Clareza sobre onde os dados são processados e armazenados |
| **Revisão periódica** | Data de reavaliação agendada (máximo 12 meses) |


## Princípios Operacionais

A implementação do OpenFirst é suportada pelos seguintes princípios de engenharia:

### OpenFirst by Design
O open source é o ponto de partida por defeito em todas as decisões tecnológicas. A pergunta nunca é "porquê open source?" — é "porquê não open source?"

### Infrastructure as Code e Automação
Toda a infraestrutura e configuração de serviços é versionada e automatizada. Configurações manuais são excepções documentadas, não a norma.

### Security by Design
Segurança é incorporada desde a fase de concepção. Não é uma camada adicionada posteriormente. Inclui gestão de segredos, controlo de acesso por defeito restritivo e auditoria de dependências.

### Portabilidade e Independência
Arquitecturas desenhadas para evitar coupling com plataformas específicas. Dados e configurações devem ser exportáveis e migráveis.

### Observabilidade e Controlo Operacional
Visibilidade total sobre os sistemas em produção através de métricas, logs estruturados e distributed tracing. Sem caixas-negras operacionais.

### Escalabilidade e Resiliência
Sistemas desenhados para crescer horizontalmente e tolerar falhas parciais. Alta disponibilidade como requisito, não como opção.

## Critérios de Maturidade Open Source — Referência Rápida

Para avaliações rápidas, use este scorecard (pontuação mínima recomendada: 12/20):

| Dimensão | Peso | Como avaliar |
|---|---|---|
| Actividade do projecto | /5 | Commits recentes, issues respondidos, PRs merged |
| Qualidade da documentação | /4 | Docs completas, exemplos, guias operacionais |
| Ecossistema e integrações | /4 | Plugins, conectores, comunidade de contribuidores |
| Modelo de suporte | /4 | Suporte comercial disponível, SLAs possíveis |
| Historial de segurança | /3 | CVEs resolvidos, disclosure process, auditorias |


## Casos de Excepção

O OpenFirst reconhece contextos onde a aplicação estrita pode não ser adequada:

| Situação | Abordagem |
|---|---|
| **Requisito regulatório específico** | Documentar o requisito; reavaliação quando o contexto regulatório mudar |
| **Tecnologia sem alternativa open source matura** | Adoptar proprietária com exit strategy; monitorizar alternativas activamente |
| **Prazo crítico de negócio** | Adopção temporária com prazo de reavaliação definido (máximo 6 meses) |
| **Solução proprietária já existente e consolidada** | Avaliar custo/risco de migração vs. manutenção; definir roadmap gradual |


## Valor para o Negócio

O OpenFirst não é uma ideologia — é um instrumento de gestão de risco tecnológico e de redução de custos de longo prazo.

A sua adopção permite às organizações:

- **Reduzir vendor lock-in** — dependência controlada de fornecedores específicos
- **Diminuir custos** — licenciamento, suporte e operação a longo prazo
- **Aumentar a segurança** — transparência do código e auditabilidade
- **Acelerar integrações** — padrões abertos facilitam interoperabilidade entre sistemas e equipas
- **Construir stacks portáveis** — tecnologias substituíveis sem refactoring total
- **Melhorar a autonomia operacional** — equipas com controlo real sobre os sistemas que operam


## Métricas de Adopção

Para avaliar se o OpenFirst está a funcionar, monitorizar regularmente:

- **% de componentes de stack com solução open source** (meta: ≥ 70%)
- **Nº de soluções proprietárias com exit strategy documentada** (meta: 100%)
- **Nº de decisões de adopção proprietária sem justificação registada** (meta: 0)
- **Tempo médio para reavaliação de soluções proprietárias** (meta: ≤ 12 meses)

