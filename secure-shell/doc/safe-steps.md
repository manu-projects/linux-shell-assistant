# 1. (GPG, GnuPG) GNU Privacy Guard + (pass) The UNIX Password Manager
## 1.1 generar el Par de Claves Primarias (pública/privada) en GnuPG
```shell
make gpg-generate-primary-key
```
- el *algoritmo ed25519* es el más eficiente y seguro
- GPG nos pedirá una *frase de paso* para proteger la *Clave Primaria Privada de GnuPG*
(ésta "frase de paso" agrega una capa de seguridad, en caso de perder o que nos roben la Clave Primaria Privada de GPG)
## 1.2 generar un Par de Claves Secundarias (pública/privada) en GnuPG para [E]ncriptar
```shell
make gpg-generate-subkey
```

- GPG lo utilizaremos para cifrar/encriptar la *Clave Privada de SSH* en el *Password Manager* (llamado pass)
- el *algoritmo cv25519* es el más eficiente y seguro para encriptar (no confundir con ed25519, éste otro no es para encriptar)
- el *Par de Claves Secundarias* debe tener la *capacidad de [E]encriptar* (encrypt capability)
- la *Clave Secundaria Pública* encriptará y la *Clave Secundaria Privada* desencriptará
## 1.3 crear el Almacén de Claves en (pass) el Gestor de Claves estándar de UNIX
```shell
make pass-init
```

- ingresamos el (fpr) *fingerprint* ó *ID* del *Par de Claves Secundarias* que tiene la capacidad de [E]encriptar (encrypt capability)
- `pass` creará un directorio en `~/.password-store` y lo inicializará agregando el ID en `~/.password-store/.gpg-id`
# 2. Par de Claves SSH + Password Manager
## 2.1 crear el Par de Claves de SSH (pública/privada) + la frase de paso (ó passphrase)
```shell
make sshclient-create-pairkey
```

- el *Par de Claves (pública/privada)* persistirá en el en el directorio `~/.ssh/` (cliente SSH)
(NO compartir/publicar la *clave privada* de SSH, sólo divulgaremos la *clave pública* de SSH)
- una alternativa al *Par de Claves SSH* sería crear un *Par de Claves Secundarias de GPG* con la *capacidad de [A]utenticación* (authenticate capability)
## 2.2 importar la Clave Privada de SSH al Password Manager (pass)
```shell
make pass-github-import-ssh-privatekey
```

- evitamos que ocurra el escenario en el que la *Clave Privada de SSH* esté comprometida a causa de la mala seguridad de nuestro sistema
- protegemos la *Clave Privada de SSH* en el *Password Manager (pass)* que necesita el *Par de Claves Secundarias de GPG* para desencriptar
(siendo la Clave Secundaria Privada quien desencripta el archivo que fue cifrado con la Clave Secundaria Pública asociada)
- luego de importar la Clave Privada de SSH, debemos *BORRAR el archivo físico* de `~/.ssh/` (cliente SSH)
(el *par de claves de ssh* tiene el mismo nombre, la *clave pública de ssh* tiene la extensión `.pub`, la *clave privada de ssh* NO tiene extensión)
## 2.3 (opcional) comprobar que la Clave Privada de SSH se importó correctamente
```shell
make pass-list-passwords
```
# 3. Agente SSH ó Agente GPG
## 3.1 agregar en el Agente, la Clave Privada cifrada en el Password Manager
```shell
make sshagent-add-github-privatekey-from-password-manager
```

- la variable de entorno `SSH_AUTH_SOCK` apunta al *archivo del tipo Socket* del Agente que utilicemos (Agente SSH ó Agente GPG)
- el Agente (SSH ó GPG) elegido recordará la *Clave Privada de SSH* y (passphrase) asociada si tuviera, los *Clientes SSH* le preguntarán a él
(ofrece mayor seguridad porque nos evita interactuar con los Clientes SSH, caso contrario nos preguntarían a cada rato por la Clave Privada de SSH)
- usaremos el *Agente GPG (gpg-agent)* porque ya importamos la *Clave Privada de SSH* en el *Password Manager (pass)* que está protegido/encriptado con GPG
- usaríamos el *Agente GPG (ssh-agent)* si protegieramos el archivo de la *Clave Privada de SSH* con una *frase de paso (passphrase)*
(aunque la passphrase ofrece seguridad, evitamos esta manera, porque se recomienda tener el archivo de la Clave Privada en un medio de almacenamiento externo al Sistema)
## 3.2 (opcional) comprobar que la Clave Privada se guardó en el Agente SSH
```shell
make sshagent-list-publickeys
```
- una alternativa sería utilizar el comando `ssh-add`
- con `ssh-add -L` listamos las claves públicas, con `ssh-add -l` para listar los *(fpr) fingerprint*
# 4. Remover el archivo físico la Clave Privada de SSH
```shell
make sshclient-github-remove-privatekey-file
```

- contemplamos el escenario de que esté comprometida la seguridad de nuestra máquina
- el archivo físico del *Par de Claves de SSH (pública/privada)* suelen estar en `~/.ssh`
- guardar una copia, exportando en algún *medio de almacenamiento encriptado* externo al Sistema (Ej. disco duro externo ó pendrive)
## (opcional) copiar en el portapeles la Clave Pública de SSH
```shell
make sshclient-github-copy-publickey-to-clipboard
```

- acceder al navegador web y pegar el contenido en https://github.com/settings/ssh/new
- utilizar el atajo `Ctrl+v` para retirar la *Clave Pública de SSH* del portapapeles
# 5. Iniciar Agente SSH Vs Iniciar Agente GPG
## Archivos de Configuracón dónde ejecutar los Script Shell ó Comandos de Bash
- en el archivo `~/.bashrc` los comandos se ejecutarán cada vez que abramos una Bash Shell
- en el archivo `~/.bash_profile` los comandos se ejecutarán una única vez, al iniciar el sistema
- algunos recomiendan *iniciar el Agente (SSH ó GPG)* sólo cuando se requiere, porque el sistema ya podría estar comprometido al iniciar
## TODO Agente GPG
- considero que es más seguro utilizar el *Agente GPG* que el *Agente SSH* porque
  1. importamos la *Clave Privada de SSH* en el *Password Manager (pass)*
  2. las claves del *Password Manager (pass)* están protegidas/encriptadas con GPG

> en la práctica prefiero arrancar el *Agente GPG* desde `~/.bashrc` porque es tedioso finalizar de manera exitosa el *Agente SSH*
> quien ocupa la variable de entorno *SSH_AUTH_SOCK*

```shell
# en el archivo ~/.bashrc ó ~/.bash_profile
export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
export GPG_TTY="$(tty)"
gpg-connect-agent updatestartuptty /bye
```
## Agente SSH
- revisar la documentación `ssh-agent-autostart` que está más detallada
