# Métodos para iniciar el Agente SSH
## Ejecutar en segundo plano (background) en una Unica Shell
- Es útil si tuvieramos sólo una Shell
  (no es el caso en un *Sistema de Ventanas X* dónde solemos utilizar varias Shell)
- Si iniciamos el Agente SSH mediante un Shell script
  1. lo ejecutamos con `eval $(ssh-agent -s)` ejecutandose automáticamente en segundo plano (background)
  2. la opción `-s` es necesaria, para que devuelva los comandos con un estilo Bourne-shell (sh)
- Si iniciamos el Agente SSH mediante una terminal
  1. lo ejecutamos con `eval $(ssh-agent)` ejecutandose automáticamente en segundo plano (background)
  2. la opción `-s` NO es necesaria, porque el agente SSH detecta el tipo de Login Shell
- Crea las variables de entorno sólo para esa Shell
  (Ej. si creamos desde un Emulador de Terminal otra PTY Slave, ésta tendrá asociada otra Shell pero sin las variables de entorno del Agente SSH)
## Ejecutar en primer plano (foreground) en una Subshell
- Iniciamos el Agente SSH con un script Shell en un archivo de configuración que se ejecute al iniciar el Sistema (Ej. `~/.bash_profile`)
- Si falla el Agente SSH, "podría" provocar que *Login Shell* con la que iniciamos el sistema finalice
- se recomienda ejecutar al final del archivo porque..
  1. si suspendimos otro proceso (Ej. vim)
  2. al iniciar el agente SSH éste crea una subshell en primer plano (foreground)
  3. no podemos reanudar el proceso suspendido hasta finalizar la nueva subshell del Agente SSH
# Shell script para auto-iniciar el Agente SSH
## Shell script en el archivo .bash_profile (recomendado)
- se recomienda copiar el Shell script de iniciar el "Agente SSH" en `~/.bash_profile`
para que se ejecute una sola vez (cuando iniciamos sesión en el sistema)
- un Shell script en `~/.bash_profile` se ejecuta automáticamente en una "Interactive Login Shell"
es decir una "Shell Interactiva de Inicio de Sesión"
## Shell script en el archivo .bashrc
- NO se recomienda copiar el Shell script iniciar el "Agente SSH" en `~/.bashrc`
porque se ejecutaría cada vez que creemos una "terminal" en un "emulador de terminal" (Ej. xterm, konsole, ..),
- un Shell script en `~/.bashrc` se ejecuta automáticamente al iniciar una "Interactive Non-Login Shell"
es decir una "Shell interactiva sin inicio de sesión"
# Ejemplos Tipos de Shell
## Ejemplos de una "interactive login shell"
1. cuando nos conectamos por SSH a un servidor remoto
2. cuando nos logeamos en nuestra maquina local
## Ejemplos de una "interactive non-login shell"
1. cuando creamos terminales desde un Emulador de terminal, éstas no requieren iniciar sesión
porque ya lo hicimos al principio al logearnos en nuestra maquina local
## Ejemplos de una "non-interactive non-login shell"
1. cuando ejecutamos un script de bash ó sh (se ejecuta una subshell de éste tipo)
