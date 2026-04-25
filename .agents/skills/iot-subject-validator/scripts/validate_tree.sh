#!/bin/bash

# Cores para facilitar a leitura no terminal do agente
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # Sem Cor
ERRORS=0

echo -e "${YELLOW}Iniciando a auditoria estrutural do projeto Inception-of-Things...${NC}\n"

# Função para checar a existência de arquivos/diretórios
check_exists() {
    if [ ! -e "$1" ]; then
        echo -e "${RED}[ERRO] Obrigatório ausente: '$1'${NC}"
        ERRORS=$((ERRORS+1))
    else
        echo -e "${GREEN}[OK] Encontrado: '$1'${NC}"
    fi
}

# Verificações da Parte 1
echo -e "\n${YELLOW}--- Validando p1 ---${NC}"
check_exists "p1"
check_exists "p1/scripts"
check_exists "p1/confs"
check_exists "p1/Vagrantfile"

# Verificações da Parte 2
echo -e "\n${YELLOW}--- Validando p2 ---${NC}"
check_exists "p2"
check_exists "p2/scripts"
check_exists "p2/confs"
check_exists "p2/Vagrantfile"

# Verificações da Parte 3 (Não usa Vagrant)
echo -e "\n${YELLOW}--- Validando p3 ---${NC}"
check_exists "p3"
check_exists "p3/scripts"
check_exists "p3/confs"

echo -e "\n------------------------------------------------"

# Retorno padrão para ferramentas de automação (Exit Codes)
if [ $ERRORS -eq 0 ]; then
    echo -e "${GREEN}SUCESSO! A árvore de diretórios base atende ao subject.${NC}"
    exit 0
else
    echo -e "${RED}FALHA! Foram encontrados $ERRORS erro(s) estrutural(is). Corrija antes de enviar para correção.${NC}"
    exit 1
fi