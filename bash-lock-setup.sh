#!/data/data/com.termux/files/usr/bin/bash

################################################################################
#                           BASH LOCK SET UP SCRIPT                            #
#                                 author Jore                                  #
#                                 version 1.0                                  #
#                                                                              #
################################################################################

################################################################################
#                                FUNCTIONS                                     #
################################################################################

# Asks Y/N question and returns response as 0/1
# ARG1 (question to be asked) ARG2 (default value. (Y/N))
# Asks 3 times, then returns default value or
# Continues to ask if no default supplied.
_ask() {
	# Set prompt depending on default value
	if [ "${2:-}" = "Y" ]; then
		local prompt="Y/n"
		local default="Y"
	elif [ "${2:-}" = "N" ]; then
		local prompt="y/N"
		local default="N"
	else
		local prompt="y/n"
		local default=""
	fi
	printf "\n"
	# Ask
	local retries=3
	while true; do
		if [ ${retries} -eq 3 ]; then
			_reset_line && printf "${CYAN}[${YELLOW}?${CYAN}] ${1} ${prompt}: ${RESET}"
		else
			_reset_line && printf "${RED}[${YELLOW}${retries}${RED}] ${1} ${prompt}: ${RESET}"
		fi
		read -n 1 reply
		# Set default value?
		if [ -z "${reply}" ]; then
			reply=${default}
		fi
		case "${reply}" in
			Y | y) unset reply && return 0 ;;
			N | n) unset reply && return 1 ;;
		esac
		# Ask return 3rd time if default value is set
		((retries--))
		if [ ! -z "${default}" ] && [ ${retries} -eq 0 ]; then # && [[ ${default} =~ ^(Y|N|y|n)$ ]]; then
			case "${default}" in
				Y | y) unset reply && return 0 ;;
				N | n) unset reply && return 1 ;;
			esac
		fi
	done
}

_reset_line() {
	printf "\r                                            \r"
}

_set_passwd() {
	# Ask before overwriting lock script
	if [ -f ${LOCK_SCRIPT} ]; then
		_ask "Overwrite current password." "N" || {
			_reset_line && printf "${CYAN}[${YELLOW}=${CYAN}] Password NOT changed.${RESET}\n"
			return 1
		}
	else
		printf "\n"
	fi
	# Confirm execution code in login script
	# DON'T REMOVE OR CHANGE THE COMMENT (it is used here and in _del_passwd)
	grep -q "# EXECUTE BASH LOCK BY JORE" ${LOGIN_SCRIPT} || cp "${LOGIN_SCRIPT}" "${LOGIN_SCRIPT}~" && sed -i "2i\# EXECUTE BASH LOCK BY JORE\nif [ -f \"${LOCK_SCRIPT}\" ]; then\n\tbash \"${LOCK_SCRIPT}\" || exit 1\nfi" ${LOGIN_SCRIPT} || {
		printf "${RED}[${YELLOW}!${RED}] Failed to set password.${RESET}\n"
		return 1
	}
	# Set the password
	local retries=3
	while true; do
		if [ ${retries} -eq 3 ]; then
			_reset_line && printf "${CYAN}[${YELLOW}*${CYAN}] Enter new password: ${RESET}" && read -sn ${PASSWD_LENGTH} passwd
		else
			printf "${RED} Try again: ${RESET}" && read -sn ${PASSWD_LENGTH} passwd
		fi
		_reset_line && printf "${CYAN}[${YELLOW}*${CYAN}] Verify new password: ${RESET}" && read -sn ${PASSWD_LENGTH} passwd1
		_reset_line && printf "${CYAN}[${YELLOW}*${CYAN}] Checking password...${RESET}"
		if [ "${passwd}" == "${passwd1}" ]; then
			# Create lock script
			{
				PASSWD_LENGTH=${#passwd}
				mkdir -p $(dirname "${LOCK_SCRIPT}")
				passwd=$(echo "${passwd1}" | shasum --algorithm=${ALGORITHM})
			} && {
				cat > ${LOCK_SCRIPT} <<- EOF
					#!/data/data/com.termux/files/usr/bin/bash

					################################################################################
					#                               BASH LOCK SCRIPT                               #
					#                                 author Jore                                  #
					#                                 version 1.0                                  #
					#                                                                              #
					################################################################################

					################################################################################
					#                                FUNCTIONS                                     #
					################################################################################

					_banner() {
						clear
						# Center banner vertically
						local height=\$(expr \$(stty size | cut --delimiter=" " --fields=1) / 2)
						for ((i = 0; i < height; i++)); do
							printf "\n"
						done
						# Maximize banner line
						local line=""
						local width=\$(expr \$(stty size | cut --delimiter=" " --fields=2) - 2)
						for ((i = 0; i < width; i++)); do
							line+="─"
						done
						# Calculate space before text
						local space=""
						local width1=\$(expr \( \${width} - 5 \) / 2)
						for ((i = 0; i < width1; i++)); do
							space+=" "
						done
						# Calculate space after text
						local space1=""
						local width2=\$(expr \${width} - \${width1} - 5)
						for ((i = 0; i < width2; i++)); do
							space1+=" "
						done
						unset i
						# Print banner
						printf "\${CYAN}┌\${line}┐\${RESET}\n"
						printf "\${CYAN}│\${space}LOGIN\${space1}│\${RESET}\n"
						printf "\${CYAN}└\${line}┘\${RESET}\n"
					}

					_reset_line() {
						printf "\r                                            \r"
					}

					_check_pass() {
						local retries=3
						while true; do
							if [ \${retries} -eq 3 ]; then
								printf "\n\${CYAN}[\${YELLOW}*\${CYAN}] Enter password: \${RESET}" && read -sn \${PASSWD_LENGTH} passwd
							else
								printf "\${RED} Try again: \${RESET}" && read -sn \${PASSWD_LENGTH} passwd
							fi
							_reset_line && printf "\${CYAN}[\${YELLOW}*\${CYAN}] Checking password...\${RESET}"
							if [ "\$(echo "\${passwd}" | shasum --algorithm=\${ALGORITHM})" == "\${PASSWD_SHA}" ]; then
								unset passwd
								_reset_line && printf "\${GREEN}[\${YELLOW}=\${GREEN}] Login success.\${RESET}\n"
								return 0
							else
								((retries--))
								_reset_line && printf "\${RED}[\${YELLOW}\${retries}\${RED}] Incorrect password.\${RESET}"
								if [ \${retries} -eq 0 ]; then
									printf "\n"
									return 1
								fi
							fi
						done
					}

					################################################################################
					#                                ENTRY POINT                                   #
					################################################################################

					ALGORITHM=${ALGORITHM}
					PASSWD_LENGTH=${PASSWD_LENGTH}
					PASSWD_SHA="${passwd}"
					RED="${RED}"
					GREEN="${GREEN}"
					YELLOW="${YELLOW}"
					CYAN="${CYAN}"
					RESET="${RESET}"

					_banner
					_check_pass || exit 1
					unset ALGORITHM PASSWD_LENGTH PASSWD_SHA RED GREEN YELLOW CYAN RESET
				EOF
			} && chmod 700 ${LOCK_SCRIPT} && _reset_line && printf "${GREEN}[${YELLOW}=${GREEN}] Password set succesfully.${RESET}\n"
			break
		else
			((retries--))
			_reset_line && printf "${RED}[${YELLOW}${retries}${RED}] Passwords do not match.${RESET}"
			if [ ${retries} -eq 0 ]; then
				printf "\n"
				return 1
			fi
		fi
	done
	unset passwd passwd1
	return 0
}

_del_passwd() {
	if [ -f ${LOCK_SCRIPT} ]; then
		if _ask "Clear current password." "N"; then
			rm -f ${LOCK_SCRIPT} && {
				# Remove execution code if it exists
				grep -q "# EXECUTE BASH LOCK BY JORE" ${LOGIN_SCRIPT} && sed -i '/# EXECUTE BASH LOCK BY JORE/{N;N;N;d;}' ${LOGIN_SCRIPT}
			} && {
				_reset_line && printf "${GREEN}[${YELLOW}=${GREEN}] Password cleared succesfully.${RESET}\n"
				return 0
			} || {
				_reset_line && printf "${RED}[${YELLOW}!${RED}] Failed clear password.${RESET}\n"
			}
		else
			_reset_line && printf "${CYAN}[${YELLOW}=${CYAN}] Password NOT cleared.${RESET}\n"
		fi
	else
		_reset_line && printf "\n${CYAN}[${YELLOW}!${CYAN}] No password to clear.${RESET}\n"
	fi
	return 1
}

_print_help() {
	printf "${CYAN}Usage: ${YELLOW}$(basename $0) OPTION${RESET}\n"
	printf "${CYAN}Set up a password for bash login.${CYAN}${RESET}\n"
	printf "${CYAN}${RESET}\n"
	printf "${CYAN}Options:${RESET}\n"
	printf "${CYAN}  -s, --set${RESET}\n"
	printf "${CYAN}          Set new password.${RESET}\n"
	printf "${CYAN}  -c, --clear${RESET}\n"
	printf "${CYAN}          Clear saved password.${RESET}\n"
	printf "${CYAN}  -h, --help${RESET}\n"
	printf "${CYAN}          Print this message and exit.${RESET}\n"
	printf "${CYAN}  -v. --version${RESET}\n"
	printf "${CYAN}          Print version and exit${RESET}\n"
}

_print_version() {
	printf "${YELLOW}Bash Lock Script${CYAN} by Jore, version ${VERSION}${RESET}\n"
	printf "${CYAN}Copyright (C) 2022 Free Software Foundation, Inc.${RESET}\n"
	printf "${CYAN}License GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>${RESET}\n"
	printf "\n"
	printf "${CYAN}This is free software; you are free to change and redistribute it.${RESET}\n"
	printf "${CYAN}There is NO WARRANTY, to the extent permitted by law.${RESET}\n"
}

################################################################################
#                                ENTRY POINT                                   #
################################################################################

VERSION="1.0"
RED="\e[1;31m"
GREEN="\e[1;32m"
YELLOW="\e[1;33m"
CYAN="\e[1;36m"
RESET="\e[0m"
ALGORITHM=512
PASSWD_LENGTH=1
LOGIN_SCRIPT="${PREFIX}/bin/login"
LOCK_SCRIPT="${PREFIX}/bin/applets/bash-lock.sh"

if [ -n "$1" ]; then
	case "$1" in
		"-s" | "--set")
			_set_passwd
			;;
		"-c" | "--clear")
			_del_passwd
			;;
		"-h" | "--help")
			_print_help
			;;
		"-v" | "--version")
			_print_version
			;;
		*)
			printf "${RED}[${YELLOW}!${RED}] Unknown option '${1}'${RESET}\n"
			_print_help
			;;
	esac
else
	_print_help
fi
unset RED GREEN YELLOW CYAN RESET ALGORITHM PASSWD_LENGTH LOCK_SCRIPT VERSION
