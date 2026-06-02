
|Projecto                                                       | SO Suportado                         | Correio | Suporte Pago |
|---------------------------------------------------------------|--------------------------------------|---------|--------------|
|[CWP](https://control-webpanel.com/)                           | AlmaLinux 8 & 9                      |         |              |
|





| Projeto        | Código aberto? | Suporta AlmaLinux 10? | Interface moderna? | Suporte pago disponível? | Suporta Mailserver? | Suporta Multitenancy? | Observações                                                                 |
|----------------|----------------|------------------------|---------------------|---------------------------|----------------------|------------------------|-----------------------------------------------------------------------------|
| BlueOnyx       | ✓              | ✗                      | △                   | ✓                         | ✓                    | ✗                      | Interface funcional, mas visualmente mais tradicional. E-mail integrado.    |
| aaPanel        | ✓              | ✓                      | ✓                   | ✓                         | △                    | △                      | Interface moderna e fácil; mailserver via plugins; multitenancy limitado.   |
| CyberPanel     | ✓              | ✗                      | ✓                   | ✓                         | ✓                    | ✗                      | Interface moderna (OpenLiteSpeed); mailserver incluído; AlmaLinux 10 não consolidado. |
| Kloxo          | ✓              | ✗                      | ✗                   | ✗                         | ✗                    | ✗                      | Projeto antigo, descontinuado; não recomendado para produção.               |
| Froxlor        | ✓              | ✓                      | ✓                   | ✗                         | ✓                    | ✗                      | Open source, moderno; suporta Linux recente; mailserver integrado.          |
| ApisCP         | ✗              | ✓                      | ✓                   | ✓                         | ✓                    | ✓                    | Comercial, focado em profissionais; mailserver completo; multitenancy sim.  |
| CWP            | ✗              | ✓                      | △                   | ✓                         | ✓                    | △                    | Versão gratuita + Pro; mailserver incluso; multitenancy parcial na Pro.     |
| ISPConfig      | ✓              | ✓                      | △                   | ✓                         | ✓                    | ✓                    | BSD license; suporta múltiplos servidores/clusters; mailserver completo; interface funcional mas tradicional. |
| Virtualmin     | ✓              | △                      | △                   | ✓                         | ✓                    | ✓                    | Baseado no Webmin; mailserver robusto; multitenancy via virtual domains; suporte AlmaLinux parcial. |
| HestiaCP       | ✓              | ✗                      | ✓                   | ✗                         | ✓                    | △                    | Fork do VestaCP; interface moderna; mailserver (Exim/Dovecot); multitenancy limitado; Ubuntu/Debian apenas. |
| CloudPanel     | ✓              | ✗                      | ✓                   | ✗                         | ✗                    | ✗                      | Interface moderna, alta performance; Ubuntu/Debian apenas; sem mailserver nativo; focado em web apps. |

**Legenda:**  
✓ = Sim  
✗ = Não  
△ = Parcialmente / Limitado

**Observações:**
* BlueOnyx possui uma interface funcional, mas visualmente mais tradicional.
* aaPanel destaca-se pela interface moderna e facilidade de utilização.
* CyberPanel oferece uma interface moderna baseada em OpenLiteSpeed, mas o suporte ao AlmaLinux 10 ainda não é oficialmente consolidado.
* Kloxo é um projeto antigo e praticamente descontinuado.
* Froxlor é open source, moderno e suporta distribuições Linux recentes.
* ApisCP é comercial (não open source), focado em ambientes profissionais.
* CWP (Control Web Panel) possui versão gratuita e versão Pro com suporte pago. O visual é razoavelmente moderno, mas menos intuitivo que aaPanel ou CyberPanel.
