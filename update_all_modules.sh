#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

echo -e "${CYAN}═══════════════════════════════════════════════════════════${NC}"
echo -e "${PURPLE}🚀  UPDATING PROSODY MODULES  🚀${NC}"
echo -e "${CYAN}═══════════════════════════════════════════════════════════${NC}"
echo -e "${YELLOW}📦 Fetching installed modules...${NC}"
echo ""

sudo docker exec -it xmpp-prosody sh -c "prosodyctl list | awk '/^mod_/{system(\"prosodyctl install --server=https://modules.prosody.im/rocks/ \"\$1)}'"

echo ""
echo -e "${CYAN}═══════════════════════════════════════════════════════════${NC}"
echo -e "${GREEN}✅  UPDATE COMPLETED SUCCESSFULLY!  ✅${NC}"
echo -e "${CYAN}═══════════════════════════════════════════════════════════${NC}"
