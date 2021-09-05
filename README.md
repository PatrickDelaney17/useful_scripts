
# useful_scripts
basic script storage for common use cases.

# Color options for print output
> [from overflow](https://stackoverflow.com/questions/5947742/how-to-change-the-output-color-of-echo-in-linux)
```
Black        0;30     Dark Gray     1;30
Red          0;31     Light Red     1;31
Green        0;32     Light Green   1;32
Brown/Orange 0;33     Yellow        1;33
Blue         0;34     Light Blue    1;34
Purple       0;35     Light Purple  1;35
Cyan         0;36     Light Cyan    1;36
Light Gray   0;37     White         1;37
```

```console
foo@bar:~$ LightBlue='\033[1;34m'
foo@bar:~$ NC='\033[0m' # No Color
foo@bar:~$ printf "${LightBlue}some colored text${NC}..\n"
I love Stack Overflow
```

# Links
---
## Keep for later usage
* [Basic Steps](https://pimylifeup.com/mongodb-raspberry-pi/#:~:text=For%20those%20who%20do%20not%20know%2C%20MongoDB%20is,tutorial%20on%20installing%20MongoDB%20on%20your%20Raspberry%20Pi.)

## Learning

## Tooling / Installment
* [Git Install steps](https://projects.raspberrypi.org/en/projects/getting-started-with-git/3)
* [install jq](https://wilsonmar.github.io/jq/) for working with `JSON`

## Other Refs
> used with `updateCheck.sh` script
```shell
#REF - https://codereview.stackexchange.com/questions/146896/simple-linux-upgrade-script-in-bash
#REF - https://www.raspberrypi.org/documentation/raspbian/updating.md
#REF - assumes jq is installed https://wilsonmar.github.io/jq/
```
