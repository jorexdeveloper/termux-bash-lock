# BASH LOCK

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

|  |  |
|--|--|
|![img](./Screenshots/1.png)|![img](./Screenshots/2.png)|

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
