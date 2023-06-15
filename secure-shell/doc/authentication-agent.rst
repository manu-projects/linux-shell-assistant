Agentes de Autenticación (ssh-agent, gpg-agent)
===============================================

Evitar su uso en maquinas NO confiables
---------------------------------------
- las **Claves privadas** podrían ser descargadas
- la **Frase de paso** (passphrase) puede ser capturada al momento de escribirla
- implementaciones falsas de SSH, ó programas falsos de inición de sesión, ó shells que roban la **Frase de paso**
- el **espacio de memoria dónde ejecutamos el Agente de Autenticación** puede ser accedido, descargando las **Claves Privadas**

Usabilidad
----------
- evita que el usuario escriba la **frase de paso** (passphrase) al establecer una conexión remota
- guarda en memoria las **Claves PRIVADAS** y las **Frases de paso** asociadas (passphrase) y las recuerda

  1. mientras que la ejecucion del proceso no finalice
  2. mientras que la sesión de la **Interactive Login Shell** no finalice (se crea cuando iniciamos el sistema)

Seguridad
---------
- no exponen las *Claves Privadas* porque éste las guarda y sólo responden a las solicitudes de los Clientes SSH
- evita el usuario deba manipular las claves privadas

Agregar/Remover claves privadas en el Agente SSH (ssh-add)
==========================================================
- el comando ``ssh-add`` requiere la previa ejecución del Agente SSH (ssh-agent)
- según la opción que le pasemos, agrega/remueve **Claves Privadas** del Agente SSH

Clientes SSH
============

Seguridad
---------
- consultan automáticamente al **Agente de Autenticación** por cualquier operación con las **Claves Privadas**
- NO ven la **Clave Privada** del **Agente de Autenticación**, éste desencripta y responde las peticiones (es más seguro)

Comunicación con el Agente SSH
------------------------------
- la comunicación es a **través de un archivo temporal del tipo Socket** asignado a la **variable de entorno** ``SSH_AUTH_SOCK``
- (Ej. cuando iniciamos el Agente SSH, éste devuelve comandos Shell que crean variables de entorno para que la Shell pueda conectarse a éste)
- un **archivo temporal** por defecto se crea dentro de ``/tmp`` y es eliminando al finalizar el sistema
- un **archivo del tipo socket** (Socket de Dominio Unix)
  - hace de *canal de comunicación* para la *transferencia de datos entre procesos*
  - comprobamos que NO es un *archivo regular* ejecutando en la linea de comandos

    1. ``echo ${SSH_AUTH_SOCK} | xargs file``
    2. ó ``echo ${SSH_AUTH_SOCK} | xargs ls -l``

CLI (Linea de comandos)
=======================
- **Interfáz basada en texto** que permite al Usuario interactuar con el Sistema Operativo
- la **Shell hace de intérprete** (ssh, bash, zsh, ..) entre el Usuario (lo que escriba en la linea de comandos) y el Sistema Operativo
