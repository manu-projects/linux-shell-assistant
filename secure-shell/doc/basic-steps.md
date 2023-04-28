# Comandos básicos por linea de comandos (terminal)
comandos que deberíamos ejecutar desde la máquina cliente
1. (ssh-keygen) crear el par claves pública/privada y una "frase de paso" (passphrase)
2. (ssh-copy-id) copiar clave pública en el HOST (servidor remoto) al que nos queremos conectar
3. (ssh) conectarse al HOST (para validar conexión)
# Comandos en un Shell script al iniciar el sistema (login shell)
comandos que se recomiendan agregar en un *archivo de configuración* que se ejecute *al iniciar el sistema*, por ejemplo `~/.bash_profile`
1. (ssh-agent) iniciar el Agente SSH para que éste recuerde las *claves privadas* y las *frase de paso* (passphrase)
2. (ssh-add) agregamos la *clave privada* al Agente SSH (comprobar que se agregó con la opción -L)
