# Agente de Autenticación OpenSSH (ssh-agent)
## Evitar su uso en maquinas NO confiables
- las *Claves privadas* podrían ser descargadas
- la *Frase de paso* (passphrase) puede ser capturada al momento de escribirla
- implementaciones falsas de SSH, ó programas falsos de inición de sesión, ó shells que roban la *Frase de paso*
- el *espacio de memoria dónde ejecutamos el agente SSH* puede ser accedido, descargando las *Claves privadas*
## Usabilidad
- guarda en memoria las **Claves PRIVADAS** y las **Frases de paso** (passphrase) y las recuerda
  - la ejecucion del proceso no finalice
  - la sesión de la **Interactive Login Shell** no finalice (se crea cuando iniciamos el sistema)
- evita que el usuario escriba la **frase de paso** (passphrase) al establecer una conexión remota
## Seguridad
- no exponen las *Claves privadas* porque éste las guarda y sólo responden a las solicitudes de los Clientes SSH
- evita el usuario deba manipular las claves privadas
# Agregar/Remover claves del Agente SSH (ssh-add)
- el comando `ssh-add` requiere la previa ejecución del Agente SSH (ssh-agent)
- agrega/remueve claves privadas en el Agente SSH
# Clientes SSH
## Seguridad
- consultan automáticamente al *Agente de Autenticación SSH* por cualquier operación con las claves
- NO ven la *clave privada* del *Agente SSH*, éste desencripta y responde las peticiones (es más seguro)
## Comunicación con el Agente SSH
- la comunicación es a *través de un archivo temporal del tipo Socket* asignado a la *variable de entorno* `SSH_AUTH_SOCK`
(recordemos que al iniciar el Agente SSH, éste devuelve comandos Shell que crean variables de entorno para que la Shell pueda conectarse a éste)
- un *archivo temporal* por defecto se crea dentro de `/tmp` y es eliminando al finalizar el sistema
- un *archivo del tipo socket* (Socket de Dominio Unix)
  - hace de *canal de comunicación* para la *transferencia de datos entre procesos*
  - comprobar que no es un *archivo regular* ejecutando en la linea de comandos `echo ${SSH_AUTH_SOCK} | xargs file` ó `echo ${SSH_AUTH_SOCK} | xargs ls -l`
# CLI (Linea de comandos)
- *Interfáz basada en texto* que permite al Usuario interactuar con el Sistema Operativo
- la *Shell hace de intérprete* (ssh, bash, zsh, ..) entre el Usuario (lo que escriba en la linea de comandos) y el Sistema Operativo
