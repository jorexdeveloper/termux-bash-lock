<h1 align="center" style="color:#C9D1D9;">TERMUX BASH LOCH</h1>

<p align="center">
	<a href="https://github.com/jorexdeveloper/termux-bash-lock/stargazers">
		<img
			src="https://img.shields.io/github/stars/jorexdeveloper/termux-bash-lock?colorA=0D1117&colorB=58A6FF&style=for-the-badge">
	</a>
	<a href="https://github.com/jorexdeveloper/termux-bash-lock/issues">
		<img
			src="https://img.shields.io/github/issues/jorexdeveloper/termux-bash-lock?colorA=0D1117&colorB=F85149&style=for-the-badge">
	</a>
	<a href="https://github.com/jorexdeveloper/termux-bash-lock/contributors">
		<img
			src="https://img.shields.io/github/contributors/jorexdeveloper/termux-bash-lock?colorA=0D1117&colorB=2EA043&style=for-the-badge">
	</a>
</p>

Set a login password for Bash.

**NOTE:** This script was made for **Termux** and may not work properly for other systems, use with caution.

## INSTALLATION

Download and execute the setup script (`bash-lock-setup.sh`) or copy and paste below commands in Termux.

```
apt update -y && apt upgrade -y && apt install wget -y && wget https://raw.githubusercontent.com/jorexdeveloper/bash-lock/main/bash-lock-setup.sh && bash bash-lock-setup.sh --help
```

The program displays help information to guide you further.

```
Usage: bash-lock-setup.sh OPTION
Set up a login password for Bash. (for Termux)

Options:
  -s, --set
          Set new password.
  -c, --clear
          Clear saved password.
  -h, --help
          Print this message and exit.
  -v. --version
          Print version and exit

After setting a password, use lock command to lock the shell any time.
```

## SCREENSHOTS

<div style="overflow-x: auto; white-space: nowrap; text-align: center;">
  <img src="./Screenshots/2.png" width="300" height="600" style="margin: 5px;">
  <img src="./Screenshots/1.png" width="300" height="600" style="margin: 5px;">
</div>

### LICENSE

```
```
    Copyright (C) 2023  Jore

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <https://www.gnu.org/licenses/>.
    
```
