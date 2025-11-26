#!/bin/bash

# Define Colors
RED='\033[1;31m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
BLUE='\033[1;34m'
CYAN='\033[1;36m'
MAGENTA='\033[1;35m'
WHITE='\033[1;37m'
PURPLE='\033[1;38;5;129m'
ORANGE='\033[1;38;5;208m'
PINK='\033[1;38;5;198m'
RESET='\033[0m'
NC='\033[0m'
BOLD='\033[1m'

# Config directory (Termux → Kali)
CONFIG_DIR="$HOME/.kali_custom"
mkdir -p "$CONFIG_DIR" || {
    echo -e "${RED}✗ Failed to create config directory!${NC}"
    exit 1
}

# Check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Error handler
handle_error() {
    echo -e "${RED}✗ Error: $1${NC}"
    exit 1
}

# Use apt in Kali
PKG_MANAGER="apt"

# pv check
if ! command_exists pv; then
    echo -e "${YELLOW}✗ pv not found! Installing now...${NC}"
    sudo $PKG_MANAGER update -y && sudo $PKG_MANAGER install -y pv || {
        echo -e "${RED}✗ Failed to install pv${NC}"
    }
fi

clear

# Welcome banner
echo -e "
${GREEN}██████╗  █████╗ ███╗   ██╗██████╗  ██████╗ ███╗   ███╗
██╔══██╗██╔══██╗████╗  ██║██╔══██╗██╔═══██╗████╗ ████║
██████╔╝███████║██╔██╗ ██║██║  ██║██║   ██║██╔████╔██║
${ORANGE}██╔══██╗██╔══██║██║╚██╗██║██║  ██║██║   ██║██║╚██╔╝██║
██║  ██║██║  ██║██║ ╚████║██████╔╝╚██████╔╝██║ ╚═╝ ██║
╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═══╝╚═════╝  ╚═════╝ ╚═╝     ╚═╝
${RED}${BOLD}========>> Created by Sunil [ Prince4you ] <<========= 
${RESET}"
echo -e "${CYAN}[+] Configure your terminal with a custom banner!${RESET}"

# User Input
read -p "$(echo -e "${YELLOW}Enter creator name [default: Sunil]: ${RESET}")" creator_name
creator_name=${creator_name:-Sunil}

read -p "$(echo -e "${YELLOW}Enter creator tagline [default: Prince4You]: ${RESET}")" creator_tag
creator_tag=${creator_tag:-Prince4You}

read -p "$(echo -e "${YELLOW}Enter welcome message [default: Welcome to Your Terminal]: ${RESET}")" welcome_msg
welcome_msg=${welcome_msg:-Welcome to Your Terminal}

default_speed=50

validate_speed() {
    if ! [[ "$1" =~ ^[0-9]+$ ]]; then
        echo -e "${RED}✘ Invalid input! Numbers only.${NC}"
        return 1
    elif [[ "$1" -lt 1 || "$1" -gt 200 ]]; then
        echo -e "${RED}✘ Speed must be between 1 and 200.${NC}"
        return 1
    fi
    return 0
}

while true; do
    read -p "$(echo -e "${YELLOW}Enter animation speed (1-200) [Default: ${default_speed}]: ${RESET}")" speed
    speed=${speed:-$default_speed}

    validate_speed "$speed" && break
done

pv_speed=$speed

echo -e "${CYAN}Previewing speed at ${pv_speed} bytes/sec...${NC}"
echo "      Loading animation test..." | pv -qL "$pv_speed"
sleep 1
echo -e "${GREEN}✓ Animation speed set.${NC}"

# Update
echo -e "${GREEN}[1/6]${NC} ${YELLOW}Updating packages...${NC}"
sudo $PKG_MANAGER update -y && sudo $PKG_MANAGER upgrade -y

# Install required tools
echo -e "${GREEN}[2/6]${NC} ${YELLOW}Installing required packages...${NC}"
sudo $PKG_MANAGER install -y toilet starship fish python3 python3-pip neofetch pv wget git

# lolcat
echo -e "${GREEN}[3/6]${NC} ${YELLOW}Installing lolcat...${NC}"
pip3 install lolcat

# Change shell to fish
echo -e "${GREEN}[4/6]${NC} ${YELLOW}Changing default shell to fish...${NC}"
chsh -s /usr/bin/fish

mkdir -p ~/.config/fish

# Social Media Setup
echo -e "${GREEN}[5/6]${NC} ${YELLOW}Social Media Setup${NC}"
SOCIAL_FILE="$CONFIG_DIR/social_media.txt"
> "$SOCIAL_FILE"

platforms=("YouTube" "Instagram" "Facebook" "Telegram" "WhatsApp" 
"Twitter/X" "GitHub" "LinkedIn" "Discord" "Reddit" "Mastodon")

for platform in "${platforms[@]}"; do
    read -p "$(echo -e "${YELLOW}$platform: ${NC}")" url
    if [ -n "$url" ]; then
        echo "$platform:$url" >> "$SOCIAL_FILE"
    fi
done

# Banner Script
echo -e "${GREEN}[6/6]${NC} ${YELLOW}Creating banner script...${NC}"

cat > "$CONFIG_DIR/kali_banner.sh" << EOF
#!/bin/bash
RESET="\033[0m"
BOLD="\033[1m"

random_color() {
    colors=(
        "\033[1;31m" "\033[1;32m" "\033[1;33m" "\033[1;34m"
        "\033[1;36m" "\033[1;35m" "\033[1;37m"
        "\033[1;38;5;129m" "\033[1;38;5;208m" "\033[1;38;5;198m"
    )
    echo "\${colors[\$RANDOM % \${#colors[@]}]}"
}

distros=( "kali" "ubuntu" "parrot" "debian" "blackarch" "arch" )

declare -A messages
messages["kali"]="Kali Linux: Unleash your inner hacker!"
messages["ubuntu"]="Ubuntu: User friendly Linux."
messages["parrot"]="Parrot OS: Security & privacy."
messages["debian"]="Debian: Rock solid base."
messages["arch"]="Arch Linux: Build it your way."
messages["blackarch"]="BlackArch: For pentesters."

random_distro=\${distros[\$RANDOM % \${#distros[@]}]}

declare -A social
if [ -f "$SOCIAL_FILE" ]; then
    while IFS=':' read -r p l; do
        social["\$p"]="\$l"
    done < "$SOCIAL_FILE"
fi

clear
echo -e "\$(random_color)Loading Your Awesome Terminal...\$RESET" | pv -qL $pv_speed
sleep 0.5

if command -v neofetch >/dev/null; then
    neofetch --ascii_distro "\$random_distro" --color_blocks off
fi

echo -e "\n\$(random_color)${BOLD}$welcome_msg\$RESET" | pv -qL $pv_speed
echo -e "\$(random_color)Current Distro: \$random_distro\$RESET" | pv -qL $pv_speed
echo -e "\$(random_color)\${messages[\$random_distro]}\$RESET" | pv -qL $pv_speed

if [ \${#social[@]} -gt 0 ]; then
    echo -e "\n\$(random_color)Follow me:\$RESET" | pv -qL $pv_speed
    for p in "\${!social[@]}"; do
        echo -e "\$(random_color)[+] \$p: \$RESET\${social[\$p]}" | pv -qL $pv_speed
    done
fi

echo -e "\n\$(random_color)Created By $creator_name [$creator_tag]\$RESET" | pv -qL $pv_speed
EOF

chmod +x "$CONFIG_DIR/kali_banner.sh"

# Auto-load in fish
echo "$CONFIG_DIR/kali_banner.sh" >> ~/.config/fish/config.fish

echo -e "${GREEN}✓ Setup complete! Restart terminal or run: fish${NC}"
