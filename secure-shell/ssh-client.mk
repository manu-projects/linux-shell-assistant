# - podría haber guardado en otra ruta
# (Ej. en un pendrive, en un disco externo dónde no se montó el /home del usuario, ..)
SSH_PAIR_KEY_DIR = ~/.ssh

ASK_SSH_HOST_NAME=read -p "ingrese el NOMBRE del Host: "
ASK_SSH_HOST_USER=read -p "ingrese el NOMBRE DE USUARIO del Host: "
ASK_SSH_HOST_IP=read -p "ingrese el IP del Host: "

ASK_SSH_KEY_NAME=read -p "ingrese el NOMBRE del par de Claves (Pública/Privada): "
ASK_SSH_PRIVATE_KEY_NAME=read -p "ingrese el nombre de la Clave Privada: "
ASK_SSH_KEY_PASSPHRASE=read -p "ingrese la FRASE DE PASO (opcional): "
ASK_SSH_KEY_COMMENTS=read -p "ingrese algún COMENTARIO sobre el par de Claves (opcional): "

# comando `ssh-keygen`
# ====================
#
# opciones
# ---------
# -a		el número de rondas de (KDF), ofrece mayor resistencia al descifrado de la clave
# -t		el tipo de llave (tipo de encriptado, algoritmo de cifrado/firmado ó firma digital)
# -f		ruta y nombre de archivo dónde se generán las claves (pública y privada)
# -N		frase de clave (agrega una capa de seguridad extra, por si tienen acceso a la "Clave Privada")
# -C		comentarios (si fuese para utilizar en github, escribir su email)
# -b		tamaño de la clave en bits (si usamos ed25519 no es necesario, pero si lo sería con rsa)
#
# precauciones
# ------------
# - agregar una FRASE DE PASO (passphrase) como capa de seguridad adicional
# - si alguien tiene acceso al archivo de la "Clave Privada", podría utilizarla para descifrar
# el archivo de la "Clave Pública" que exponemos (con la frase de clave reducimos éste riesgo)
#
# uso de mi macro SSH_KEYGEN
# --------------------------
# 1. utilizar el comando de linux `read` para asignarle valor a las variables (Ej. read -p "nombre: " NOMBRE)
# 2. utilizar `&& $(SSH_KEYGEN)` con las variables de la forma $${} porque no son macros de GNU Make,
# son variables definidas en la Shell de Bash (ó la que definamos en el Makefile)
#
# TODO: definir nombre $${SSH_KEY_NAME} ó $${SSH_KEY_NAME}_$(SIGNATURE_ALGORITHM)
SSH_KEYGEN=ssh-keygen \
		-a $(NUMBER_ROUNDS_KDF) \
		-t $(SIGNATURE_ALGORITHM) \
		-f $${HOME}/.ssh/$${SSH_KEY_NAME} \
		-N "$${SSH_KEY_PASSPHRASE}" \
		-C "$${SSH_KEY_COMMENTS}"

##@ Secure Shell
ssh-install-packages: install-ssh-server

install-ssh-server: ##
	sudo aptitude install openssh-server

sshclient-create-pairkey: ##
	$(ASK_SSH_KEY_NAME) SSH_KEY_NAME \
	&& $(ASK_SSH_KEY_PASSPHRASE) SSH_KEY_PASSPHRASE \
	&& $(ASK_SSH_KEY_COMMENTS) SSH_KEY_COMMENTS \
	&& $(SSH_KEYGEN)

sshclient-list-pairkey:
	@ls $${HOME}/.ssh \
	| grep -E --invert-match --word-regexp "agent-environment|authorized_keys|config|known_hosts"

sshclient-remove-pairkey:
	$(ASK_SSH_KEY_NAME) SSH_KEY_NAME \
	&& rm -vi $${HOME}/.ssh/$${SSH_KEY_NAME} $${HOME}/.ssh/$${SSH_KEY_NAME}.pub

# TODO: crear un archivo servidores-ssh.lst + combinarlo con algún menu con whiptail y elegir desde ahi
# (agregarle un servidor fake como ejemplo)
#
# comando `ssh-copy-id`
# =====================
#
# objetivo
# --------
# - copiar la Clave Pública `~/.ssh/id_rsa.pub` (u otra que elijamos) del "Cliente SSH" en el "Servidor SSH"
# (se copia en el archivo `~/.ssh/authorized_keys`)
#
# opciones
# ---------
# -i		ruta y nombre de la clave pública
sshclient-copy-publickey-to-host: ##
	$(ASK_SSH_KEY_NAME) SSH_KEY_NAME \
	&& $(ASK_SSH_HOST_USER) SSH_HOST_USER \
	&& $(ASK_SSH_HOST_IP) SSH_HOST_IP \
	&& ssh-copy-id \
		-i $${HOME}/.ssh/$${SSH_KEY_NAME}.pub \
		-p $(SSH_PORT) $${SSH_HOST_USER}@$${SSH_HOST_IP}

# comando `rsync`
# ========================
#
# opciones interesantes
# ---------------------
# --rsyncpath
#		- comando a ejecutar en el Servidor SSH (remoto) antes de iniciar la transferencia
#		- en este ejemplo utilizamos `sudo rsync` porque necesitamos permisos de superusuario para acceder al directorio /etc
#		- previo a ejecutar, en el Servidor SSH modificamos el sudoers con `sudo visudo`
# 	agregando al final del archivo nombre_usuario_remoto ALL=NOPASSWD:ruta_del_comando_binario_rsync
#
# --rsh
# 	- comando a ejecutar en la Shell del Servidor SSH (remoto)
# 	- por default `rsync` utiliza `ssh`, pero queremos cambiar el puerto 22 que utiliza ssh
#
# opciones comunes
# ------------------
# --human-readable	convierte el tamaño del archivo en una unidad más entendible
# --compress				comprime el archivo durante la transferencia (reduce su tamaño, tardando menos)
# --progress				imprime el progreso durante la transferencia (no es lo mismo que --verbose)
# --partial					mantiene los archivos incompletos en la ruta destino (servidor remoto) en caso de que la transferencia se interrumpa
#
# TODO: evaluar posibilidad de solicitar nombre de la clave + opción -i en el ssh con la ruta de la clave privada
sshclient-copy-config-to-host:
	$(ASK_SSH_HOST_USER) SSH_HOST_USER \
	&& $(ASK_SSH_HOST_IP) SSH_HOST_IP \
	&& rsync \
	--progress --human-readable --partial --compress --verbose \
	--rsync-path="sudo rsync" \
	--rsh "ssh -p $(SSH_PORT)" \
	$(MODULE_SECURE_SHELL_CONFIGS)/custom_sshd_config.cfg \
	$${SSH_HOST_USER}@$${SSH_HOST_IP}:/etc/ssh/sshd_config.d

# TODO: Warning: Permanently added '192.168.0.214' (ECDSA) to the list of known hosts
# TODO: boxes diciendo que la SSH_HOST_IP fue agregada en ~/.ssh/known_hosts
#
# en la primera conexión remota por ssh deberíamos usar la opción (-i)
# para indicar el archivo de la clave privada ó pública (?) <------------------
#
# TODO: agregar un condicional (if), que la primera conexión pregunte key_file+username+ip
sshclient-connect-host: ## solitará nombre de la llave, usuario del host, ip del host
	$(ASK_SSH_KEY_NAME) SSH_KEY_NAME \
	$(ASK_SSH_HOST_USER) SSH_HOST_USER \
	&& $(ASK_SSH_HOST_IP) SSH_HOST_IP \
	-i $${HOME}/.ssh/$${SSH_KEY_NAME} \
	&& ssh -p $(SSH_PORT) $${SSH_HOST_USER}@$${SSH_HOST_IP}

# comando `ssh`
# ============
#
# opciones
# --------
# -X		habilita el X11forwarding (túnel de puerto X11 ó Sistema de Ventanas X)
# -x		deshabilita el X11forwarding
# -C		recomendado si existe mala conexión de internet, comprime los datos enviados por el Servidor SSH (stdin, stdout, stderr, datos del túnel X11, ..)
#
# TODO: utilizar la config que guarda user+host+port+key_file
sshclient-connect-by-hostname: ## solicitará el nombre del host (definido por config)
	$(ASK_SSH_HOST_NAME) SSH_HOST_NAME \
	&& ssh -x $${SSH_HOST_NAME}

sshclient-connect-X11-by-hostname: ## solicitará el nombre del host (definido por config)
	$(ASK_SSH_HOST_NAME) SSH_HOST_NAME \
	&& ssh -X -C $${SSH_HOST_NAME}

# comando `sftp` (secure ftp)
# ===========================
#
# - transfiere de archivos con un prótocolo ftp a través de una conexión segura
#
# TODO: validar si necesitás pasarle el key-file
sshclient-connect-sftp-host:
	$(ASK_SSH_HOST_USER) SSH_HOST_USER \
	&& $(ASK_SSH_HOST_IP) SSH_HOST_IP \
	&& sftp $${SSH_HOST_USER}@$${SSH_HOST_IP}

sshclient-remove-keyhost-by-ip:
	$(SSH_ASK_IP) SSH_IP_HOST \
	&& ssh-keygen -f "$${HOME}/.ssh/known_hosts" -R "$${SSH_IP_HOST}"

# TODO: para pasarlo a un disco, o un pendrive
# ssh-backup-pairkeys:

# comando `ssh-keygen`
# ====================
#
# opciones
# --------
# -l		mostrar el fingerprint de una Clave Pública (.pub)
# -f		ruta y nombre de la Clave Pública (.pub)
sshclient-show-fingerprint-publickey:
	$(ASK_SSH_KEY_NAME) SSH_KEY_NAME \
	&& ssh-keygen -l -f $${HOME}/.ssh/$${SSH_KEY_NAME}.pub
